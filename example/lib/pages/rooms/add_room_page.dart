import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../utils/device_room_service.dart';

/// 添加房间页面
class AddRoomPage extends StatefulWidget {
  const AddRoomPage({Key? key}) : super(key: key);

  @override
  _AddRoomPageState createState() => _AddRoomPageState();
}

class _AddRoomPageState extends State<AddRoomPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _floorController = TextEditingController();
  String _selectedType = '标准间';
  String _selectedBuilding = 'A栋';
  
  // 默认选项（不可删除和修改）
  final List<String> _defaultRoomTypes = ['标准间', '大床房', '双床房', '套房', '豪华套房'];
  final List<String> _defaultBuildings = ['A栋', 'B栋'];
  
  // 自定义选项（可以删除和修改）
  final List<String> _customRoomTypes = [];
  final List<String> _customBuildings = [];
  
  // 获取完整选项列表
  List<String> get _roomTypes => [..._defaultRoomTypes, ..._customRoomTypes];
  List<String> get _buildings => [..._defaultBuildings, ..._customBuildings];

  @override
  void dispose() {
    _nameController.dispose();
    _floorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('添加房间'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 房间名称
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: '房间名称',
                  hintText: '例如：101',
                  prefixIcon: Icon(Icons.meeting_room_rounded),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入房间名称';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // 房间类型
              _buildManagedDropdown(
                label: '房间类型',
                icon: Icons.hotel_rounded,
                value: _selectedType,
                defaultOptions: _defaultRoomTypes,
                customOptions: _customRoomTypes,
                onChanged: (value) => setState(() => _selectedType = value!),
                onAddCustom: _addCustomRoomType,
                onEditCustom: _editCustomRoomType,
                onDeleteCustom: _deleteCustomRoomType,
              ),
              const SizedBox(height: 16),
              
              // 所属楼栋
              _buildManagedDropdown(
                label: '所属楼栋',
                icon: Icons.apartment_rounded,
                value: _selectedBuilding,
                defaultOptions: _defaultBuildings,
                customOptions: _customBuildings,
                onChanged: (value) => setState(() => _selectedBuilding = value!),
                onAddCustom: _addCustomBuilding,
                onEditCustom: _editCustomBuilding,
                onDeleteCustom: _deleteCustomBuilding,
              ),
              const SizedBox(height: 16),
              
              // 所属楼层（手动输入）
              TextFormField(
                controller: _floorController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '所属楼层',
                  hintText: '例如：1',
                  prefixIcon: Icon(Icons.layers_rounded),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入楼层';
                  }
                  final floor = int.tryParse(value);
                  if (floor == null || floor < 1) {
                    return '请输入有效楼层';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              
              // 提交按钮
              ElevatedButton.icon(
                onPressed: _submitForm,
                icon: const Icon(Icons.check_rounded),
                label: const Text('保存'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    // 显示加载指示器
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // 调用后端 API 创建房间
      final response = await RoomService.createRoom(
        name: _nameController.text.trim(),
        type: _selectedType,
        building: _selectedBuilding,
        floor: int.tryParse(_floorController.text.trim()),
      );

      if (!mounted) return;
      Navigator.pop(context); // 关闭加载指示器

      if (response.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('房间添加成功'),
            backgroundColor: AppTheme.successColor,
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // 关闭加载指示器
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('添加失败: $e'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  /// 构建可管理的下拉框
  Widget _buildManagedDropdown({
    required String label,
    required IconData icon,
    required String value,
    required List<String> defaultOptions,
    required List<String> customOptions,
    required ValueChanged<String?> onChanged,
    required VoidCallback onAddCustom,
    required Function(int) onEditCustom,
    required Function(int) onDeleteCustom,
  }) {
    final allOptions = [...defaultOptions, ...customOptions];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 下拉框
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon),
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: const Icon(Icons.add_circle_outline_rounded),
              onPressed: onAddCustom,
              tooltip: '添加自定义选项',
            ),
          ),
          items: allOptions.map((option) {
            final isDefault = defaultOptions.contains(option);
            return DropdownMenuItem(
              value: option,
              child: Row(
                children: [
                  Text(option),
                  if (!isDefault)
                    const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(
                        Icons.star_rounded,
                        size: 12,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
        
        // 自定义选项管理
        if (customOptions.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: customOptions.asMap().entries.map<Widget>((entry) {
              final index = entry.key;
              final option = entry.value;
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Chip(
                    label: Text(option),
                    deleteIcon: const Icon(Icons.delete_rounded, size: 16),
                    onDeleted: () => onDeleteCustom(index),
                    backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                    labelStyle: const TextStyle(fontSize: 12),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_rounded, size: 16),
                    onPressed: () => onEditCustom(index),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  /// 添加自定义房间类型
  void _addCustomRoomType() {
    _showAddCustomOptionDialog(
      title: '添加房间类型',
      label: '房间类型',
      onConfirm: (value) {
        setState(() {
          _customRoomTypes.add(value);
        });
      },
    );
  }

  /// 添加自定义楼栋
  void _addCustomBuilding() {
    _showAddCustomOptionDialog(
      title: '添加楼栋',
      label: '楼栋名称',
      onConfirm: (value) {
        setState(() {
          _customBuildings.add(value);
        });
      },
    );
  }

  /// 编辑自定义房间类型
  void _editCustomRoomType(int index) {
    _showEditCustomOptionDialog(
      title: '编辑房间类型',
      label: '房间类型',
      initialValue: _customRoomTypes[index],
      onConfirm: (value) {
        setState(() {
          _customRoomTypes[index] = value;
        });
      },
    );
  }

  /// 编辑自定义楼栋
  void _editCustomBuilding(int index) {
    _showEditCustomOptionDialog(
      title: '编辑楼栋',
      label: '楼栋名称',
      initialValue: _customBuildings[index],
      onConfirm: (value) {
        setState(() {
          _customBuildings[index] = value;
        });
      },
    );
  }

  /// 删除自定义房间类型
  void _deleteCustomRoomType(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除"${_customRoomTypes[index]}"吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                final deletedOption = _customRoomTypes[index];
                _customRoomTypes.removeAt(index);
                // 如果删除的是当前选中的，重置为默认选项
                if (_selectedType == deletedOption) {
                  _selectedType = _defaultRoomTypes.first;
                }
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorColor),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  /// 删除自定义楼栋
  void _deleteCustomBuilding(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除"${_customBuildings[index]}"吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                final deletedOption = _customBuildings[index];
                _customBuildings.removeAt(index);
                // 如果删除的是当前选中的，重置为默认选项
                if (_selectedBuilding == deletedOption) {
                  _selectedBuilding = _defaultBuildings.first;
                }
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorColor),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  /// 显示添加自定义选项对话框
  void _showAddCustomOptionDialog({
    required String title,
    required String label,
    required Function(String) onConfirm,
  }) {
    final controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            hintText: '请输入自定义选项',
          ),
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              onConfirm(value.trim());
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                onConfirm(controller.text.trim());
                Navigator.pop(context);
              }
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  /// 显示编辑自定义选项对话框
  void _showEditCustomOptionDialog({
    required String title,
    required String label,
    required String initialValue,
    required Function(String) onConfirm,
  }) {
    final controller = TextEditingController(text: initialValue);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              onConfirm(value.trim());
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                onConfirm(controller.text.trim());
                Navigator.pop(context);
              }
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}

