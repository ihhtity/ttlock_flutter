import 'package:flutter/material.dart';
import '../../../theme.dart';

/// 设备转移页面
class DeviceTransferPage extends StatefulWidget {
  const DeviceTransferPage({Key? key}) : super(key: key);

  @override
  _DeviceTransferPageState createState() => _DeviceTransferPageState();
}

class _DeviceTransferPageState extends State<DeviceTransferPage> {
  String _selectedDevice = '';
  String _transferType = 'account'; // account, room
  
  // 模拟设备列表
  final List<Map<String, dynamic>> _devices = [
    {
      'id': 'D001',
      'name': '智能门锁 S300',
      'model': 'S300',
      'room': '主卧',
      'icon': Icons.lock_rounded,
    },
    {
      'id': 'D002',
      'name': '网关设备 G100',
      'model': 'G100',
      'room': '客厅',
      'icon': Icons.router_rounded,
    },
    {
      'id': 'D003',
      'name': '门磁传感器 D200',
      'model': 'D200',
      'room': '大门',
      'icon': Icons.sensors_rounded,
    },
  ];

  // 模拟账号列表
  final List<Map<String, dynamic>> _accounts = [
    {'id': 'A001', 'name': '张三', 'phone': '138****1234'},
    {'id': 'A002', 'name': '李四', 'phone': '139****5678'},
  ];

  // 模拟房间列表
  final List<Map<String, dynamic>> _rooms = [
    {'id': 'R001', 'name': '主卧'},
    {'id': 'R002', 'name': '次卧'},
    {'id': 'R003', 'name': '客厅'},
    {'id': 'R004', 'name': '厨房'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('设备转移'),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.5,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 提示信息
          _buildTipCard(),
          
          const SizedBox(height: 24),
          
          // 选择设备
          _buildSection(
            title: '1. 选择要转移的设备',
            child: Column(
              children: _devices.map((device) {
                final isSelected = _selectedDevice == device['id'];
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedDevice = device['id'];
                    });
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? AppTheme.primaryColor : Colors.grey.shade200,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            device['icon'] as IconData,
                            color: AppTheme.primaryColor,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                device['name'] as String,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected ? AppTheme.primaryColor : const Color(0xFF333333),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${device['model']} · ${device['room']}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF999999),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle_rounded,
                            color: AppTheme.primaryColor,
                            size: 24,
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // 选择转移类型
          _buildSection(
            title: '2. 选择转移方式',
            child: Column(
              children: [
                _buildTransferTypeOption(
                  '转移到其他账号',
                  'account',
                  Icons.person_outline_rounded,
                  '将设备所有权转移给其他用户',
                ),
                const SizedBox(height: 12),
                _buildTransferTypeOption(
                  '转移到其他房间',
                  'room',
                  Icons.meeting_room_rounded,
                  '将设备移动到当前账号的其他房间',
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // 选择目标
          _buildSection(
            title: '3. 选择目标',
            child: _transferType == 'account'
                ? Column(
                    children: _accounts.map((account) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFF2196F3).withOpacity(0.1),
                          child: Text(
                            (account['name'] as String).substring(0, 1),
                            style: const TextStyle(
                              color: Color(0xFF2196F3),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(account['name'] as String),
                        subtitle: Text(account['phone'] as String),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () {
                          _showTransferConfirmDialog(account['name'], null);
                        },
                      );
                    }).toList(),
                  )
                : Column(
                    children: _rooms.map((room) {
                      return ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF9800).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.meeting_room_rounded,
                            color: Color(0xFFFF9800),
                            size: 22,
                          ),
                        ),
                        title: Text(room['name'] as String),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () {
                          _showTransferConfirmDialog(null, room['name']);
                        },
                      );
                    }).toList(),
                  ),
          ),
          
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  /// 构建提示卡片
  Widget _buildTipCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF2196F3).withOpacity(0.1),
            const Color(0xFF2196F3).withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF2196F3).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: Color(0xFF2196F3),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '设备转移后，原账号将无法继续使用该设备。请谨慎操作！',
              style: TextStyle(
                fontSize: 13,
                color: const Color(0xFF2196F3).withOpacity(0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建分组
  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  /// 构建转移类型选项
  Widget _buildTransferTypeOption(String title, String value, IconData icon, String desc) {
    final isSelected = _transferType == value;
    return InkWell(
      onTap: () {
        setState(() {
          _transferType = value;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.primaryColor : const Color(0xFF666666),
              size: 28,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppTheme.primaryColor : const Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF999999),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.radio_button_checked_rounded,
                color: AppTheme.primaryColor,
                size: 24,
              )
            else
              const Icon(
                Icons.radio_button_unchecked_rounded,
                color: Color(0xFFCCCCCC),
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  /// 显示转移确认对话框
  void _showTransferConfirmDialog(String? accountName, String? roomName) {
    if (_selectedDevice.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请先选择要转移的设备'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final device = _devices.firstWhere((d) => d['id'] == _selectedDevice);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('确认转移'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('设备：${device['name']}'),
            const SizedBox(height: 8),
            if (accountName != null)
              Text('转移到账号：$accountName')
            else
              Text('转移到房间：$roomName'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '此操作不可撤销，确定要继续吗？',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('设备已转移到${accountName ?? roomName}'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
              setState(() {
                _selectedDevice = '';
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
            ),
            child: const Text('确认转移'),
          ),
        ],
      ),
    );
  }
}
