import 'package:flutter/material.dart';
import '../../theme.dart';
import '../devices/add_device_page.dart';

/// 设备管理页面
class DeviceManagementPage extends StatefulWidget {
  const DeviceManagementPage({Key? key}) : super(key: key);

  @override
  _DeviceManagementPageState createState() => _DeviceManagementPageState();
}

class _DeviceManagementPageState extends State<DeviceManagementPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedType = 'all'; // all, lock, gateway, power
  String _selectedStatus = 'all'; // all, online, offline
  bool _isSearching = false; // 是否显示搜索框
  final List<Map<String, dynamic>> _devices = [
    // 智能锁设备
    {
      'id': 1,
      'name': '大门智能锁',
      'model': 'TTLock Pro',
      'type': 'lock', // lock智能锁、gateway网关、power电源
      'battery': 85,
      'hasBattery': true, // 有电/无电
      'gatewayBound': true, // 是否绑定网关
      'gatewayOnline': true, // 网关在线状态
      'lastUsed': '2026-04-25 10:30',
      'location': '前门',
    },
    {
      'id': 2,
      'name': '卧室门锁',
      'model': 'TTLock Lite',
      'type': 'lock',
      'battery': 72,
      'hasBattery': true,
      'gatewayBound': true,
      'gatewayOnline': true,
      'lastUsed': '2026-04-25 08:15',
      'location': '主卧',
    },
    {
      'id': 3,
      'name': '办公室门禁',
      'model': 'TTLock Business',
      'type': 'lock',
      'battery': 90,
      'hasBattery': true,
      'gatewayBound': false,
      'gatewayOnline': false,
      'lastUsed': '2026-04-25 09:00',
      'location': '办公室',
    },
    {
      'id': 4,
      'name': '书房门锁',
      'model': 'TTLock Standard',
      'type': 'lock',
      'battery': 5,
      'hasBattery': false, // 无电
      'gatewayBound': true,
      'gatewayOnline': false,
      'lastUsed': '2026-04-24 16:20',
      'location': '书房',
    },
    {
      'id': 5,
      'name': '儿童房门锁',
      'model': 'TTLock Mini',
      'type': 'lock',
      'battery': 88,
      'hasBattery': true,
      'gatewayBound': true,
      'gatewayOnline': true,
      'lastUsed': '2026-04-25 11:45',
      'location': '儿童房',
    },
    {
      'id': 6,
      'name': '厨房门锁',
      'model': 'TTLock Pro',
      'type': 'lock',
      'battery': 92,
      'hasBattery': true,
      'gatewayBound': true,
      'gatewayOnline': true,
      'lastUsed': '2026-04-25 12:00',
      'location': '厨房',
    },
    {
      'id': 7,
      'name': '卫生间门锁',
      'model': 'TTLock Lite',
      'type': 'lock',
      'battery': 3,
      'hasBattery': false, // 无电
      'gatewayBound': false,
      'gatewayOnline': false,
      'lastUsed': '2026-04-23 09:30',
      'location': '卫生间',
    },

    // 网关设备
    {
      'id': 8,
      'name': '客厅网关',
      'model': 'TTLock Gateway',
      'type': 'gateway',
      'status': 'online', // 在线/离线
      'battery': 100,
      'lockCount': 3, // 绑定的智能锁数量
      'lastUsed': '2026-04-25 12:10',
      'location': '客厅',
    },
    {
      'id': 9,
      'name': '走廊网关',
      'model': 'TTLock Gateway Mini',
      'type': 'gateway',
      'status': 'online',
      'battery': 95,
      'lockCount': 2,
      'lastUsed': '2026-04-25 10:45',
      'location': '走廊',
    },
    {
      'id': 10,
      'name': '车库网关',
      'model': 'TTLock Gateway Pro',
      'type': 'gateway',
      'status': 'offline', // 离线
      'battery': 45,
      'lockCount': 1,
      'lastUsed': '2026-04-24 18:20',
      'location': '车库',
    },
    {
      'id': 11,
      'name': '地下室网关',
      'model': 'TTLock Gateway',
      'type': 'gateway',
      'status': 'online',
      'battery': 87,
      'lockCount': 4,
      'lastUsed': '2026-04-25 09:15',
      'location': '地下室',
    },

    // 电源设备
    {
      'id': 12,
      'name': '客厅电源控制器',
      'model': 'TTLock Power',
      'type': 'power',
      'powerStatus': 'on', // on开电、off关电、offline离线
      'battery': 88,
      'doorOpen': false,
      'lastUsed': '2026-04-25 11:00',
      'location': '客厅',
    },
    {
      'id': 13,
      'name': '卧室电源开关',
      'model': 'TTLock Power Lite',
      'type': 'power',
      'powerStatus': 'on',
      'battery': 76,
      'doorOpen': true,
      'lastUsed': '2026-04-25 07:30',
      'location': '主卧',
    },
    {
      'id': 14,
      'name': '餐厅电源控制',
      'model': 'TTLock Power Pro',
      'type': 'power',
      'powerStatus': 'offline', // 离线
      'battery': 22,
      'doorOpen': false,
      'lastUsed': '2026-04-24 20:15',
      'location': '餐厅',
    },
    {
      'id': 15,
      'name': '阳台电源开关',
      'model': 'TTLock Power',
      'type': 'power',
      'powerStatus': 'off', // 关电
      'battery': 91,
      'doorOpen': false,
      'lastUsed': '2026-04-25 06:00',
      'location': '阳台',
    },
    {
      'id': 16,
      'name': '书房电源控制',
      'model': 'TTLock Power Mini',
      'type': 'power',
      'powerStatus': 'on',
      'battery': 83,
      'doorOpen': true,
      'lastUsed': '2026-04-25 10:20',
      'location': '书房',
    },
  ];

  List<Map<String, dynamic>> get _filteredDevices {
    var filtered = _devices;

    // 按类型筛选
    if (_selectedType != 'all') {
      filtered =
          filtered.where((device) => device['type'] == _selectedType).toList();
    }

    // 按状态筛选
    if (_selectedStatus != 'all') {
      filtered = filtered
          .where((device) => device['status'] == _selectedStatus)
          .toList();
    }

    // 按设备名字模糊查询
    if (_searchController.text.isNotEmpty) {
      filtered = filtered.where((device) {
        return device['name'].toString().toLowerCase().contains(
                  _searchController.text.toLowerCase(),
                ) ||
            device['location'].toString().toLowerCase().contains(
                  _searchController.text.toLowerCase(),
                );
      }).toList();
    }

    return filtered;
  }

  /// 获取指定类型的设备列表
  List<Map<String, dynamic>> _getDevicesByType(String type) {
    return _filteredDevices.where((device) => device['type'] == type).toList();
  }

  /// 获取类型名称
  String _getTypeName(String type) {
    switch (type) {
      case 'lock':
        return '智能锁';
      case 'gateway':
        return '网关';
      case 'power':
        return '电源';
      default:
        return type;
    }
  }

  /// 获取类型图标
  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'lock':
        return Icons.lock_rounded;
      case 'gateway':
        return Icons.router_rounded;
      case 'power':
        return Icons.power_rounded;
      default:
        return Icons.devices_rounded;
    }
  }

  /// 获取类型颜色
  Color _getTypeColor(String type) {
    switch (type) {
      case 'lock':
        return const Color(0xFF2196F3); // 蓝色
      case 'gateway':
        return const Color(0xFF9C27B0); // 紫色
      case 'power':
        return const Color(0xFFFF9800); // 橙色
      default:
        return AppTheme.primaryColor;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// 刷新设备列表
  Future<void> _refreshDevices() async {
    // TODO: 实际刷新逻辑 - 从服务器获取最新数据
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _selectedType = 'all'; // 自动跳回全部
        _selectedStatus = 'all'; // 自动跳回全部
        _searchController.clear(); // 清空搜索
        _isSearching = false; // 退出搜索模式
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('设备列表已刷新'),
          backgroundColor: AppTheme.successColor,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final lockCount = _devices.where((d) => d['type'] == 'lock').length;
    final gatewayCount = _devices.where((d) => d['type'] == 'gateway').length;
    final powerCount = _devices.where((d) => d['type'] == 'power').length;

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
                      hintText: '搜索设备...',
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
                '设备管理',
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
            onPressed: _refreshDevices,
          ),
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: _addDevice,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // 统计卡片 - 一横排4个（全部、智能锁、网关、电源）
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
                  _devices.length.toString(),
                  Icons.devices_rounded,
                  Colors.white,
                  _selectedType == 'all',
                  () => setState(() => _selectedType = 'all'),
                ),
                Container(
                  width: 1,
                  height: 50,
                  color: Colors.white.withOpacity(0.2),
                ),
                _buildStatItem(
                  '智能锁',
                  lockCount.toString(),
                  Icons.lock_rounded,
                  _getTypeColor('lock'),
                  _selectedType == 'lock',
                  () => setState(() => _selectedType = 'lock'),
                ),
                Container(
                  width: 1,
                  height: 50,
                  color: Colors.white.withOpacity(0.2),
                ),
                _buildStatItem(
                  '网关',
                  gatewayCount.toString(),
                  Icons.router_rounded,
                  _getTypeColor('gateway'),
                  _selectedType == 'gateway',
                  () => setState(() => _selectedType = 'gateway'),
                ),
                Container(
                  width: 1,
                  height: 50,
                  color: Colors.white.withOpacity(0.2),
                ),
                _buildStatItem(
                  '电源',
                  powerCount.toString(),
                  Icons.power_rounded,
                  _getTypeColor('power'),
                  _selectedType == 'power',
                  () => setState(() => _selectedType = 'power'),
                ),
              ],
            ),
          ),

          // 设备类型分类卡片列表
          Expanded(
            child: _filteredDevices.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.devices_other_rounded,
                          size: 80,
                          color: AppTheme.textHint.withOpacity(0.3),
                        ),
                        const SizedBox(height: AppTheme.spacingMedium),
                        Text(
                          _searchController.text.isEmpty ? '暂无设备' : '未找到匹配的设备',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.textHint,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingSmall),
                        ElevatedButton.icon(
                          onPressed: _addDevice,
                          icon: const Icon(Icons.add_rounded),
                          label: const Text('添加设备'),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _refreshDevices,
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      children: [
                        // 智能锁卡片
                        if (_getDevicesByType('lock').isNotEmpty)
                          _buildTypeCard('lock', _getDevicesByType('lock')),

                        // 网关卡片
                        if (_getDevicesByType('gateway').isNotEmpty)
                          _buildTypeCard(
                              'gateway', _getDevicesByType('gateway')),

                        // 电源卡片
                        if (_getDevicesByType('power').isNotEmpty)
                          _buildTypeCard('power', _getDevicesByType('power')),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  /// 构建类型状态信息（右边）
  Widget _buildTypeStatusInfo(String type, List<Map<String, dynamic>> devices) {
    if (type == 'lock') {
      // 智能锁：有电(绿色),无电(红色)
      final hasPowerCount =
          devices.where((d) => d['hasBattery'] == true).length;
      final noPowerCount =
          devices.where((d) => d['hasBattery'] == false).length;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.battery_full_rounded,
                  size: 14, color: AppTheme.successColor),
              const SizedBox(width: 4),
              Text(
                '有电: $hasPowerCount',
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.battery_alert_rounded,
                  size: 14, color: AppTheme.errorColor),
              const SizedBox(width: 4),
              Text(
                '无电: $noPowerCount',
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      );
    } else if (type == 'gateway') {
      // 网关：在线(绿色),离线(红色)
      final onlineCount = devices.where((d) => d['status'] == 'online').length;
      final offlineCount =
          devices.where((d) => d['status'] == 'offline').length;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.wifi_rounded, size: 14, color: AppTheme.successColor),
              const SizedBox(width: 4),
              Text(
                '在线: $onlineCount',
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.wifi_off_rounded,
                  size: 14, color: AppTheme.errorColor),
              const SizedBox(width: 4),
              Text(
                '离线: $offlineCount',
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      // 电源：开电(绿色),关电(蓝色),离线(红色)
      final onCount = devices.where((d) => d['powerStatus'] == 'on').length;
      final offCount = devices.where((d) => d['powerStatus'] == 'off').length;
      final offlineCount =
          devices.where((d) => d['powerStatus'] == 'offline').length;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.power_rounded, size: 14, color: AppTheme.successColor),
              const SizedBox(width: 4),
              Text(
                '开电: $onCount',
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.power_rounded,
                  size: 14, color: const Color(0xFF2196F3)),
              const SizedBox(width: 4),
              Text(
                '关电: $offCount',
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          if (offlineCount > 0) ...[
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.power_off_rounded,
                    size: 14, color: AppTheme.errorColor),
                const SizedBox(width: 4),
                Text(
                  '离线: $offlineCount',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      );
    }
  }

  /// 构建设备类型卡片
  Widget _buildTypeCard(String type, List<Map<String, dynamic>> devices) {
    final typeName = _getTypeName(type);
    final typeIcon = _getTypeIcon(type);
    final typeColor = _getTypeColor(type); // 使用类型固定颜色，与顶部统计卡片一致

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: typeColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 卡片头部 - 使用类型颜色，与顶部统计卡片一致
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  typeColor,
                  typeColor.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppTheme.borderRadiusLarge),
                topRight: Radius.circular(AppTheme.borderRadiusLarge),
              ),
            ),
            child: Row(
              children: [
                // 左边：图标和名称（保持不变）
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    typeIcon,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        typeName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '共 ${devices.length} 个设备',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),

                // 右边：设备状态说明
                _buildTypeStatusInfo(type, devices),
              ],
            ),
          ),

          // 设备网格
          Padding(
            padding: const EdgeInsets.all(12),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // 一行4个
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
                childAspectRatio: 0.75, // 卡片宽高比，增加高度
              ),
              itemCount: devices.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => _showDeviceOptions(devices[index]),
                  child: _buildDeviceGridItem(devices[index]),
                );
              },
            ),
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

  /// 构建设备网格项（小卡片）
  Widget _buildDeviceGridItem(Map<String, dynamic> device) {
    final deviceType = device['type'];

    // 根据设备类型获取状态颜色
    Color statusColor;
    if (deviceType == 'lock') {
      // 智能锁：有电绿色，无电红色
      statusColor = device['hasBattery'] == true
          ? AppTheme.successColor
          : AppTheme.errorColor;
    } else if (deviceType == 'gateway') {
      // 网关：在线绿色，离线红色
      statusColor = device['status'] == 'online'
          ? AppTheme.successColor
          : AppTheme.errorColor;
    } else {
      // 电源：开电绿色，关电蓝灰色，离线红色
      final powerStatus = device['powerStatus'];
      if (powerStatus == 'on') {
        statusColor = AppTheme.successColor;
      } else if (powerStatus == 'off') {
        statusColor = const Color(0xFF607D8B); // 蓝灰色
      } else {
        statusColor = AppTheme.errorColor;
      }
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        side: BorderSide(
          color: statusColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 设备名称
            Text(
              device['name'],
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: statusColor,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),

            // 根据设备类型显示不同信息
            if (deviceType == 'lock')
              _buildLockInfo(device, statusColor)
            else if (deviceType == 'gateway')
              _buildGatewayInfo(device, statusColor)
            else if (deviceType == 'power')
              _buildPowerInfo(device, statusColor),
          ],
        ),
      ),
    );
  }

  /// 构建智能锁信息
  Widget _buildLockInfo(Map<String, dynamic> device, Color statusColor) {
    return Column(
      children: [
        // 电量显示
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getBatteryIcon(device['battery']),
              size: 12,
              color: _getBatteryColor(device['battery']),
            ),
            const SizedBox(width: 3),
            Text(
              '${device['battery']}%',
              style: TextStyle(
                fontSize: 10,
                color: _getBatteryColor(device['battery']),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        // 网关绑定状态（如果有绑定才显示）
        if (device['gatewayBound'] == true)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                device['gatewayOnline'] == true
                    ? Icons.wifi_rounded
                    : Icons.wifi_off_rounded,
                size: 12,
                color: device['gatewayOnline'] == true
                    ? AppTheme.successColor
                    : AppTheme.errorColor,
              ),
              const SizedBox(width: 3),
              Text(
                device['gatewayOnline'] == true ? '在线' : '离线',
                style: TextStyle(
                  fontSize: 9,
                  color: device['gatewayOnline'] == true
                      ? AppTheme.successColor
                      : AppTheme.errorColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
      ],
    );
  }

  /// 构建网关信息
  Widget _buildGatewayInfo(Map<String, dynamic> device, Color statusColor) {
    return Column(
      children: [
        // 在线/离线图标
        Icon(
          device['status'] == 'online'
              ? Icons.wifi_rounded
              : Icons.wifi_off_rounded,
          size: 16,
          color: statusColor,
        ),
        const SizedBox(height: 3),
        // 绑定的智能锁数量
        Text(
          '锁: ${device['lockCount'] ?? 0}',
          style: const TextStyle(
            fontSize: 9,
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// 构建电源信息（垂直排列：名称 + 状态图标）
  Widget _buildPowerInfo(Map<String, dynamic> device, Color statusColor) {
    final powerStatus = device['powerStatus'];
    final isOnline = device['status'] == 'online';

    // 根据电源状态确定图标和颜色
    IconData powerIcon;
    Color powerColor;

    if (powerStatus == 'on') {
      // 开电：绿色电源图标
      powerIcon = Icons.power_rounded;
      powerColor = AppTheme.successColor;
    } else if (powerStatus == 'off') {
      // 关电：蓝色电源图标
      powerIcon = Icons.power_rounded;
      powerColor = const Color(0xFF2196F3); // 蓝色
    } else {
      // 离线：红色电源图标（带划线）
      powerIcon = Icons.power_off_rounded;
      powerColor = AppTheme.errorColor;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 状态图标（居中显示）
        Icon(
          powerIcon,
          size: 20,
          color: powerColor,
        ),
      ],
    );
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

  /// 显示设备选项
  void _showDeviceOptions(Map<String, dynamic> device) {
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
                title: const Text('编辑设备'),
                onTap: () {
                  Navigator.pop(context);
                  _editDevice(device);
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_rounded,
                    color: AppTheme.primaryColor),
                title: const Text('设备详情'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: 查看设备详情
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings_rounded,
                    color: AppTheme.primaryColor),
                title: const Text('设备设置'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: 设备设置
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.delete_rounded,
                    color: AppTheme.errorColor),
                title: const Text('删除设备',
                    style: TextStyle(color: AppTheme.errorColor)),
                onTap: () {
                  Navigator.pop(context);
                  _deleteDevice(device);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// 添加设备
  void _addDevice() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddDevicePage(),
      ),
    );
  }

  /// 编辑设备
  void _editDevice(Map<String, dynamic> device) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('编辑设备：${device['name']}'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  /// 删除设备
  void _deleteDevice(Map<String, dynamic> device) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除设备"${device['name']}"吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _devices.removeWhere((d) => d['id'] == device['id']);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('设备已删除'),
                  backgroundColor: Color(0xFF4CAF50),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF44336),
            ),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }
}
