import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../theme.dart';
import '../../utils/device_room_service.dart';
import '../profile/profile_page.dart';
import 'add_room_page.dart';
import 'room_detail_page.dart';

/// 房间管理页面（使用真实API）
class RoomManagementPage extends StatefulWidget {
  const RoomManagementPage({Key? key}) : super(key: key);

  @override
  _RoomManagementPageState createState() => _RoomManagementPageState();
}

class _RoomManagementPageState extends State<RoomManagementPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = 'all'; // all, vacant, rented
  bool _isSearching = false; // 是否正在搜索
  
  List<RoomModel> _rooms = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalCount = 0;
  
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// 加载房间列表
  Future<void> _loadRooms({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
    }

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      String? statusFilter;
      if (_selectedStatus != 'all') {
        statusFilter = _selectedStatus;
      }

      String? keyword;
      if (_searchController.text.isNotEmpty) {
        keyword = _searchController.text;
      }

      final response = await RoomService.getRooms(
        page: _currentPage,
        pageSize: 20,
        status: statusFilter,
        keyword: keyword,
      );

      if (!mounted) return;

      setState(() {
        _isLoading = false;
        
        if (response.isSuccess && response.data != null) {
          _rooms = response.data!.list;
          _totalCount = response.data!.total;
          _totalPages = (_totalCount / 20).ceil();
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
    await _loadRooms(refresh: true);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('房间列表已刷新'),
          backgroundColor: AppTheme.successColor,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  /// 搜索房间
  void _onSearch() {
    _loadRooms(refresh: true);
  }

  /// 清空搜索
  void _clearSearch() {
    _searchController.clear();
    _loadRooms(refresh: true);
  }

  /// 切换状态筛选
  void _changeStatusFilter(String status) {
    setState(() {
      _selectedStatus = status;
    });
    _loadRooms(refresh: true);
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
        _loadRooms(refresh: true);
      }
    });
  }

  /// 跳转到房间详情页面
  void _navigateToRoomDetail(RoomModel room) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RoomDetailPage.fromModel(room: room),
      ),
    ).then((result) {
      if (result == true) {
        _loadRooms(refresh: true);
      }
    });
  }

  /// 获取状态文本
  String _getStatusText(String status) {
    switch (status) {
      case 'vacant':
        return '空置';
      case 'rented':
        return '已租';
      default:
        return status;
    }
  }

  /// 获取状态颜色
  Color _getStatusColor(String status) {
    switch (status) {
      case 'vacant':
        return AppTheme.successColor;
      case 'rented':
        return AppTheme.primaryColor;
      default:
        return Colors.grey;
    }
  }

  /// 获取状态图标
  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'vacant':
        return Icons.check_circle_outline;
      case 'rented':
        return Icons.home_rounded;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: '搜索房间...',
                  hintStyle: const TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _onSearch(),
              )
            : Text(l10n.roomManagement),
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
          // 状态筛选标签
          _buildStatusFilter(),
          
          // 房间列表
          Expanded(
            child: _buildRoomList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAddRoom,
        icon: const Icon(Icons.add),
        label: const Text('添加房间'),
        backgroundColor: AppTheme.primaryColor,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          
          if (index == 1) {
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

  /// 构建状态筛选器
  Widget _buildStatusFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          _buildFilterChip('全部', 'all'),
          const SizedBox(width: 8),
          _buildFilterChip('空置', 'vacant'),
          const SizedBox(width: 8),
          _buildFilterChip('已租', 'rented'),
        ],
      ),
    );
  }

  /// 构建筛选标签
  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedStatus == value;
    
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => _changeStatusFilter(value),
      backgroundColor: Colors.grey[200],
      selectedColor: AppTheme.primaryColor.withOpacity(0.2),
      checkmarkColor: AppTheme.primaryColor,
      labelStyle: TextStyle(
        color: isSelected ? AppTheme.primaryColor : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  /// 构建房间列表
  Widget _buildRoomList() {
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
              onPressed: () => _loadRooms(refresh: true),
              child: const Text('重试'),
            ),
          ],
        ),
      );
    }

    if (_rooms.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              '暂无房间数据',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _navigateToAddRoom,
              icon: const Icon(Icons.add),
              label: const Text('添加房间'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _rooms.length,
        itemBuilder: (context, index) {
          final room = _rooms[index];
          return _buildRoomCard(room);
        },
      ),
    );
  }

  /// 构建房间卡片
  Widget _buildRoomCard(RoomModel room) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _navigateToRoomDetail(room),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // 状态图标
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _getStatusColor(room.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getStatusIcon(room.status),
                  color: _getStatusColor(room.status),
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              
              // 房间信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          room.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(room.status).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _getStatusText(room.status),
                            style: TextStyle(
                              fontSize: 12,
                              color: _getStatusColor(room.status),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${room.type ?? '标准间'} · ${room.building ?? ''}${room.floor != null ? '${room.floor}层' : ''}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              
              // 电量指示
              Column(
                children: [
                  Icon(
                    Icons.battery_full,
                    color: room.battery > 50 
                        ? AppTheme.successColor 
                        : AppTheme.warningColor,
                    size: 20,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${room.battery}%',
                    style: TextStyle(
                      fontSize: 12,
                      color: room.battery > 50 
                          ? AppTheme.successColor 
                          : AppTheme.warningColor,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right,
                color: AppTheme.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
