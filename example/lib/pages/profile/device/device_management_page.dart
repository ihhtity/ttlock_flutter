import 'package:flutter/material.dart';
import '../../../theme.dart';
import '../../../utils/device_room_service.dart';
import 'device_add_page.dart';

/// 设备管理页面（使用真实API）
class DeviceManagementPage extends StatefulWidget {
  const DeviceManagementPage({Key? key}) : super(key: key);

  @override
  _DeviceManagementPageState createState() => _DeviceManagementPageState();
}

class _DeviceManagementPageState extends State<DeviceManagementPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedType = 'all'; // all, lock, gateway, power
  int? _selectedStatus; // null-全部, 1-在线, 0-离线
  bool _isSearching = false; // 是否正在搜索
  
  List<DeviceModel> _devices = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  
  int _currentPage = 1;
  int _totalCount = 0;

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// 加载设备列表
  Future<void> _loadDevices({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
    }

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      String? typeFilter;
      if (_selectedType != 'all') {
        typeFilter = _selectedType;
      }

      String? keyword;
      if (_searchController.text.isNotEmpty) {
        keyword = _searchController.text;
      }

      final response = await DeviceService.getDevices(
        page: _currentPage,
        pageSize: 20,
        type: typeFilter,
        status: _selectedStatus,
        keyword: keyword,
      );

      if (!mounted) return;

      setState(() {
        _isLoading = false;
        
        if (response.isSuccess && response.data != null) {
          _devices = response.data!.list;
          _totalCount = response.data!.total;
          _hasError = false;
        } else {
          _hasError = true;
          _errorMessage = response.message;
        }
      });
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = '加载失败: $e';
      });
    }
  }

  /// 下拉刷新
  Future<void> _onRefresh() async {
    await _loadDevices(refresh: true);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('设备列表已刷新'),
          backgroundColor: AppTheme.successColor,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  /// 搜索设备
  void _onSearch() {
    _loadDevices(refresh: true);
  }

  /// 清空搜索
  void _clearSearch() {
    _searchController.clear();
    _loadDevices(refresh: true);
  }

  /// 切换类型筛选
  void _changeTypeFilter(String type) {
    setState(() {
      _selectedType = type;
    });
    _loadDevices(refresh: true);
  }

  /// 切换状态筛选
  void _changeStatusFilter(int? status) {
    setState(() {
      _selectedStatus = status;
    });
    _loadDevices(refresh: true);
  }

  /// 跳转到添加设备页面
  void _navigateToAddDevice() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddDevicePage(),
      ),
    ).then((result) {
      if (result == true) {
        _loadDevices(refresh: true);
      }
    });
  }

  /// 获取设备类型图标
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

  /// 获取设备类型文本
  String _getTypeText(String type) {
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

  /// 获取设备类型颜色
  Color _getTypeColor(String type) {
    switch (type) {
      case 'lock':
        return AppTheme.primaryColor;
      case 'gateway':
        return Colors.orange;
      case 'power':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: '搜索设备...',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _onSearch(),
              )
            : const Text('设备管理'),
        actions: [
          if (_isSearching)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _isSearching = false;
                });
                _clearSearch();
              },
            )
          else
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _isSearching = true;
                });
              },
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _onRefresh,
          ),
        ],
      ),
      body: Column(
        children: [
          // 筛选器
          _buildFilters(),
          
          // 设备列表
          Expanded(
            child: _buildDeviceList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAddDevice,
        icon: const Icon(Icons.add),
        label: const Text('添加设备'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  /// 构建筛选器
  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 类型筛选
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('全部', 'all', _selectedType == 'all'),
                const SizedBox(width: 8),
                _buildFilterChip('智能锁', 'lock', _selectedType == 'lock'),
                const SizedBox(width: 8),
                _buildFilterChip('网关', 'gateway', _selectedType == 'gateway'),
                const SizedBox(width: 8),
                _buildFilterChip('电源', 'power', _selectedType == 'power'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // 状态筛选
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildStatusChip('全部', null, _selectedStatus == null),
                const SizedBox(width: 8),
                _buildStatusChip('在线', 1, _selectedStatus == 1),
                const SizedBox(width: 8),
                _buildStatusChip('离线', 0, _selectedStatus == 0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建类型筛选标签
  Widget _buildFilterChip(String label, String value, bool isSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => _changeTypeFilter(value),
      backgroundColor: Colors.grey[200],
      selectedColor: AppTheme.primaryColor.withOpacity(0.2),
      checkmarkColor: AppTheme.primaryColor,
      labelStyle: TextStyle(
        color: isSelected ? AppTheme.primaryColor : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  /// 构建状态筛选标签
  Widget _buildStatusChip(String label, int? value, bool isSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => _changeStatusFilter(value),
      backgroundColor: Colors.grey[200],
      selectedColor: AppTheme.successColor.withOpacity(0.2),
      checkmarkColor: AppTheme.successColor,
      labelStyle: TextStyle(
        color: isSelected ? AppTheme.successColor : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  /// 构建设备列表
  Widget _buildDeviceList() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppTheme.errorColor,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage,
              style: const TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _loadDevices(refresh: true),
              child: const Text('重试'),
            ),
          ],
        ),
      );
    }

    if (_devices.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.devices_other_rounded,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              '暂无设备数据',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _navigateToAddDevice,
              icon: const Icon(Icons.add),
              label: const Text('添加设备'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _devices.length,
        itemBuilder: (context, index) {
          final device = _devices[index];
          return _buildDeviceCard(device);
        },
      ),
    );
  }

  /// 构建设备卡片
  Widget _buildDeviceCard(DeviceModel device) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // 设备类型图标
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: _getTypeColor(device.type).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getTypeIcon(device.type),
                color: _getTypeColor(device.type),
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            
            // 设备信息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        device.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _getTypeColor(device.type).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _getTypeText(device.type),
                          style: TextStyle(
                            fontSize: 11,
                            color: _getTypeColor(device.type),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'MAC: ${device.mac}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  if (device.model != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      '型号: ${device.model}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            // 状态指示
            Column(
              children: [
                Icon(
                  device.isOnline 
                      ? Icons.wifi_rounded 
                      : Icons.wifi_off_rounded,
                  color: device.isOnline 
                      ? AppTheme.successColor 
                      : AppTheme.errorColor,
                  size: 20,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.battery_full,
                      color: device.battery > 50 
                          ? AppTheme.successColor 
                          : AppTheme.warningColor,
                      size: 16,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${device.battery}%',
                      style: TextStyle(
                        fontSize: 12,
                        color: device.battery > 50 
                            ? AppTheme.successColor 
                            : AppTheme.warningColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
