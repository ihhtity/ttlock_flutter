import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../theme.dart';
import '../profile/profile_page.dart';
import 'add_room_page.dart';
import 'room_detail_page.dart';

/// 房间管理页面
class RoomManagementPage extends StatefulWidget {
  const RoomManagementPage({Key? key}) : super(key: key);

  @override
  _RoomManagementPageState createState() => _RoomManagementPageState();
}

class _RoomManagementPageState extends State<RoomManagementPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = 'all'; // all, vacant, rented, maintenance
  bool _isSearching = false; // 是否显示搜索框

  // 模拟房间数据
  final List<Map<String, dynamic>> _allRooms = [
    {
      'id': '1',
      'name': '101',
      'type': '标准间',
      'status': 'vacant', // vacant空闲、rented租用、maintenance维修
      'battery': 85,
      'devices': ['lock', 'light'],
      'icon': Icons.hotel_rounded,
      'color': AppTheme.successColor, // 空闲-绿色
      'building': 'A栋',
      'floor': 1,
    },
    {
      'id': '2',
      'name': '102',
      'type': '大床房',
      'status': 'rented',
      'battery': 72,
      'devices': ['lock', 'light', 'ac'],
      'icon': Icons.bed_rounded,
      'color': AppTheme.primaryColor, // 租用-蓝色
      'building': 'A栋',
      'floor': 1,
    },
    {
      'id': '3',
      'name': '103',
      'type': '双床房',
      'status': 'maintenance',
      'battery': 45,
      'devices': ['lock'],
      'icon': Icons.hotel_rounded,
      'color': AppTheme.errorColor, // 维修-红色
      'building': 'A栋',
      'floor': 1,
    },
    {
      'id': '4',
      'name': '201',
      'type': '标准间',
      'status': 'vacant',
      'battery': 90,
      'devices': ['lock', 'light'],
      'icon': Icons.hotel_rounded,
      'color': AppTheme.successColor,
      'building': 'A栋',
      'floor': 2,
    },
    {
      'id': '5',
      'name': '202',
      'type': '套房',
      'status': 'rented',
      'battery': 100,
      'devices': ['lock', 'light', 'ac', 'tv'],
      'icon': Icons.star_rounded,
      'color': AppTheme.primaryColor,
      'building': 'A栋',
      'floor': 2,
    },
    {
      'id': '6',
      'name': '203',
      'type': '大床房',
      'status': 'vacant',
      'battery': 95,
      'devices': ['lock', 'light'],
      'icon': Icons.bed_rounded,
      'color': AppTheme.successColor,
      'building': 'A栋',
      'floor': 2,
    },
    {
      'id': '7',
      'name': '301',
      'type': '豪华套房',
      'status': 'rented',
      'battery': 88,
      'devices': ['lock', 'light', 'ac', 'tv'],
      'icon': Icons.diamond_rounded,
      'color': AppTheme.primaryColor,
      'building': 'B栋',
      'floor': 3,
    },
    {
      'id': '8',
      'name': '302',
      'type': '标准间',
      'status': 'maintenance',
      'battery': 30,
      'devices': ['lock'],
      'icon': Icons.hotel_rounded,
      'color': AppTheme.errorColor,
      'building': 'B栋',
      'floor': 3,
    },
  ];

  List<Map<String, dynamic>> get _rooms {
    var filtered = _allRooms;

    // 按房态筛选
    if (_selectedStatus != 'all') {
      filtered =
          filtered.where((room) => room['status'] == _selectedStatus).toList();
    }

    // 按房间名字模糊查询
    if (_searchController.text.isNotEmpty) {
      filtered = filtered.where((room) {
        return room['name'].toString().toLowerCase().contains(
              _searchController.text.toLowerCase(),
            );
      }).toList();
    }

    return filtered;
  }

  int _selectedIndex = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// 刷新房间列表
  Future<void> _refreshRooms() async {
    // TODO: 实际刷新逻辑 - 从服务器获取最新数据
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _selectedStatus = 'all'; // 自动跳回全部
        _searchController.clear(); // 清空搜索
        _isSearching = false; // 退出搜索模式
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('房间列表已刷新'),
          backgroundColor: AppTheme.successColor,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  /// 跳转到添加房间页面
  void _navigateToAddRoom() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddRoomPage(),
      ),
    ).then((result) {
      if (result == true) {
        setState(() {});
      }
    });
  }

  /// 跳转到房间编辑页面
  void _navigateToRoomDetail(Map<String, dynamic> room) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RoomDetailPage(room: room),
      ),
    ).then((result) {
      if (result == true) {
        setState(() {});
      }
    });
  }

  /// 获取状态文本
  String _getStatusText(String status) {
    switch (status) {
      case 'vacant':
        return '空闲';
      case 'rented':
        return '租用';
      case 'maintenance':
        return '维修';
      default:
        return status;
    }
  }

  /// 获取状态颜色
  Color _getStatusColor(String status) {
    switch (status) {
      case 'vacant':
        return AppTheme.successColor; // 绿色
      case 'rented':
        return AppTheme.primaryColor; // 蓝色
      case 'maintenance':
        return AppTheme.errorColor; // 红色
      default:
        return AppTheme.textHint;
    }
  }

  /// 获取设备图标
  IconData _getDeviceIcon(String deviceType) {
    switch (deviceType) {
      case 'lock':
        return Icons.lock_rounded;
      case 'light':
        return Icons.lightbulb_rounded;
      case 'ac':
        return Icons.ac_unit_rounded;
      case 'tv':
        return Icons.tv_rounded;
      case 'minibar':
        return Icons.local_bar_rounded;
      default:
        return Icons.devices_rounded;
    }
  }

  /// 获取电池图标
  IconData _getBatteryIcon(int battery) {
    if (battery >= 80) return Icons.battery_full_rounded;
    if (battery >= 50) return Icons.battery_5_bar_rounded;
    if (battery >= 20) return Icons.battery_2_bar_rounded;
    return Icons.battery_alert_rounded;
  }

  /// 获取电池颜色
  Color _getBatteryColor(int battery) {
    if (battery >= 50) return AppTheme.successColor;
    if (battery >= 20) return const Color(0xFFFFA500);
    return AppTheme.errorColor;
  }

  /// 显示房间选项
  void _showRoomOptions(Map<String, dynamic> room) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.borderRadiusLarge),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit_rounded,
                    color: AppTheme.primaryColor),
                title: const Text('编辑房间'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: 编辑房间
                },
              ),
              ListTile(
                leading: const Icon(Icons.devices_rounded,
                    color: AppTheme.primaryColor),
                title: const Text('查看设备'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: 查看房间设备
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings_rounded,
                    color: AppTheme.primaryColor),
                title: const Text('房间设置'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: 房间设置
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.delete_rounded,
                    color: AppTheme.errorColor),
                title: const Text('删除房间',
                    style: TextStyle(color: AppTheme.errorColor)),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDeleteRoom(room);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// 确认删除房间
  void _confirmDeleteRoom(Map<String, dynamic> room) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
        ),
        title: const Text('确认删除'),
        content: Text('确定要删除 "${room['name']}" 吗？此操作不可恢复。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _allRooms.removeWhere((r) => r['id'] == room['id']);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('房间已删除'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final vacantCount = _allRooms.where((r) => r['status'] == 'vacant').length;
    final rentedCount = _allRooms.where((r) => r['status'] == 'rented').length;
    final maintenanceCount =
        _allRooms.where((r) => r['status'] == 'maintenance').length;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: _isSearching
            ? Container(
                constraints: const BoxConstraints(maxWidth: 300),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    inputDecorationTheme: const InputDecorationTheme(
                      filled: false,
                      border: InputBorder.none,
                    ),
                  ),
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      hintText: '搜索房间...',
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
              )
            : const Text(
                '房间管理',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppTheme.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (_isSearching)
            IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: () {
                setState(() {
                  _isSearching = false;
                  _searchController.clear();
                });
              },
            )
          else
            IconButton(
              icon: const Icon(Icons.search_rounded),
              onPressed: () {
                setState(() {
                  _isSearching = true;
                });
              },
            ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _refreshRooms,
          ),
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: _navigateToAddRoom,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // 统计卡片 - 一横排4个
          Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF667EEA),
                  const Color(0xFF764BA2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF667EEA).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  '全部',
                  _allRooms.length.toString(),
                  Icons.home_rounded,
                  Colors.white,
                  _selectedStatus == 'all',
                  () => setState(() => _selectedStatus = 'all'),
                ),
                Container(
                  width: 1,
                  height: 50,
                  color: Colors.white.withOpacity(0.2),
                ),
                _buildStatItem(
                  '空闲',
                  vacantCount.toString(),
                  Icons.check_circle_rounded,
                  AppTheme.successColor,
                  _selectedStatus == 'vacant',
                  () => setState(() => _selectedStatus = 'vacant'),
                ),
                Container(
                  width: 1,
                  height: 50,
                  color: Colors.white.withOpacity(0.2),
                ),
                _buildStatItem(
                  '租用',
                  rentedCount.toString(),
                  Icons.person_rounded,
                  AppTheme.primaryColor,
                  _selectedStatus == 'rented',
                  () => setState(() => _selectedStatus = 'rented'),
                ),
                Container(
                  width: 1,
                  height: 50,
                  color: Colors.white.withOpacity(0.2),
                ),
                _buildStatItem(
                  '维修',
                  maintenanceCount.toString(),
                  Icons.build_rounded,
                  AppTheme.errorColor,
                  _selectedStatus == 'maintenance',
                  () => setState(() => _selectedStatus = 'maintenance'),
                ),
              ],
            ),
          ),

          // 房间网格列表 - 一行4个，可上下滑动
          Expanded(
            child: _rooms.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home_work_rounded,
                          size: 80,
                          color: AppTheme.textHint.withOpacity(0.3),
                        ),
                        const SizedBox(height: AppTheme.spacingMedium),
                        Text(
                          _searchController.text.isEmpty ? '暂无房间' : '未找到匹配的房间',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.textHint,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingSmall),
                        ElevatedButton.icon(
                          onPressed: _showAddRoomDialog,
                          icon: const Icon(Icons.add_rounded),
                          label: const Text('添加房间'),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _refreshRooms,
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4, // 一行4个
                        crossAxisSpacing: 6,
                        mainAxisSpacing: 6,
                        childAspectRatio: 0.80, // 卡片宽高比
                      ),
                      itemCount: _rooms.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () => _navigateToRoomDetail(_rooms[index]),
                          child: _buildRoomGridItem(_rooms[index]),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          if (index == 1) {
            // 切换到个人中心
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfilePage(),
              ),
            ).then((_) {
              setState(() {
                _selectedIndex = 0;
              });
            });
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: AppTheme.textHint,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: '房间',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: '我的',
          ),
        ],
      ),
    );
  }

  /// 构建房间网格项（小卡片）
  Widget _buildRoomGridItem(Map<String, dynamic> room) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        side: BorderSide(
          color: room['color'].withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 房间名字
            Text(
              room['name'],
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: room['color'],
                height: 1.2,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),

            // 房间类型
            Text(
              room['type'],
              style: const TextStyle(
                fontSize: 10,
                color: AppTheme.textSecondary,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),

            // 电量显示
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getBatteryIcon(room['battery']),
                  size: 13,
                  color: _getBatteryColor(room['battery']),
                ),
                const SizedBox(width: 3),
                Text(
                  '${room['battery']}%',
                  style: TextStyle(
                    fontSize: 11,
                    color: _getBatteryColor(room['battery']),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),

            // 设备图标列表
            SizedBox(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 2,
                runSpacing: 2,
                children: (room['devices'] as List<String>).map((device) {
                  return Icon(
                    _getDeviceIcon(device),
                    size: 11,
                    color: AppTheme.textHint,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 显示添加房间对话框
  void _showAddRoomDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
        ),
        title: const Text('添加房间'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('请选择房间类型：'),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.hotel_rounded, color: AppTheme.primaryColor),
              title: Text('标准间'),
              dense: true,
            ),
            ListTile(
              leading: Icon(Icons.bed_rounded, color: AppTheme.primaryColor),
              title: Text('大床房'),
              dense: true,
            ),
            ListTile(
              leading: Icon(Icons.star_rounded, color: AppTheme.primaryColor),
              title: Text('套房'),
              dense: true,
            ),
            ListTile(
              leading:
                  Icon(Icons.diamond_rounded, color: AppTheme.primaryColor),
              title: Text('豪华套房'),
              dense: true,
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
                const SnackBar(
                  content: Text('开始添加房间...'),
                  backgroundColor: AppTheme.primaryColor,
                ),
              );
            },
            child: const Text('下一步'),
          ),
        ],
      ),
    );
  }

  /// 构建统计项
  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 12 : 8,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.25),
                    Colors.white.withOpacity(0.15),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.2)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : color,
                size: isSelected ? 22 : 20,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: isSelected ? 20 : 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color:
                    isSelected ? Colors.white : Colors.white.withOpacity(0.7),
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
