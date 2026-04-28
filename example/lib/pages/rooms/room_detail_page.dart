import 'package:flutter/material.dart';
import '../../theme.dart';

/// 房间详情/编辑页面
class RoomDetailPage extends StatefulWidget {
  final Map<String, dynamic> room;

  const RoomDetailPage({Key? key, required this.room}) : super(key: key);

  @override
  _RoomDetailPageState createState() => _RoomDetailPageState();
}

class _RoomDetailPageState extends State<RoomDetailPage> {
  @override
  Widget build(BuildContext context) {
    final room = widget.room;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('${room['name']} - 房间详情'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 房间基本信息卡片
            _buildRoomInfoCard(room),
            
            // 操作按钮区域
            _buildActionButtons(room),
          ],
        ),
      ),
    );
  }

  /// 房间基本信息卡片
  Widget _buildRoomInfoCard(Map<String, dynamic> room) {
    return Container(
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            room['color'],
            room['color'].withOpacity(0.9),
            room['color'].withOpacity(0.75),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: room['color'].withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // 顶部房间信息区域
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 左侧：房间号大图标
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.meeting_room_rounded,
                    color: room['color'],
                    size: 40,
                  ),
                ),
                const SizedBox(width: 16),
                
                // 中间：房间名称和类型
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        room['name'],
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.5,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.hotel_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              room['type'],
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // 右侧：房态标签
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: room['color'],
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _getRoomStatusText(room['status']),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: room['color'],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // 底部信息统计条
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildInfoStatItem('楼栋', room['building'] ?? '未设置', Icons.apartment_rounded),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white.withOpacity(0.2),
                ),
                _buildInfoStatItem('楼层', '${room['floor'] ?? 0}层', Icons.layers_rounded),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white.withOpacity(0.2),
                ),
                _buildInfoStatItem('电量', '${room['battery']}%', Icons.battery_full_rounded),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 信息统计项
  Widget _buildInfoStatItem(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white.withOpacity(0.9),
            size: 20,
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _getRoomStatusText(String status) {
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

  /// 操作按钮区域
  Widget _buildActionButtons(Map<String, dynamic> room) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 房间设置
          _buildButtonGroup(
            '房间设置',
            [
              {'icon': Icons.settings_rounded, 'label': '设置'},
              {'icon': Icons.link_rounded, 'label': '设备绑定'},
              {'icon': Icons.history_rounded, 'label': '操作记录'},
              {'icon': Icons.delete_rounded, 'label': '删除房间'},
            ],
          ),
          const SizedBox(height: 16),
          
          // 智能锁控制
          if (room['devices'].contains('lock'))
            _buildButtonGroup(
              '智能锁控制',
              [
                {'icon': Icons.bluetooth_rounded, 'label': '蓝牙开锁'},
                {'icon': Icons.router_rounded, 'label': '网关开锁'},
                {'icon': Icons.key_rounded, 'label': '电子钥匙'},
                {'icon': Icons.password_rounded, 'label': '密码管理'},
                {'icon': Icons.credit_card_rounded, 'label': '发卡管理'},
                {'icon': Icons.manage_accounts_rounded, 'label': '钥匙管理'},
                {'icon': Icons.history_rounded, 'label': '开锁记录'},
                {'icon': Icons.lock_open_rounded, 'label': '常开模式'},
                {'icon': Icons.router_rounded, 'label': '网关管理'},
                {'icon': Icons.link_off_rounded, 'label': '解除绑定'},
              ],
            ),
          const SizedBox(height: 16),
          
          // 电源设备控制
          if (room['devices'].contains('light'))
            _buildButtonGroup(
              '电源设备控制',
              [
                {'icon': Icons.power_rounded, 'label': '开锁通电'},
                {'icon': Icons.toggle_on_rounded, 'label': '常开电源'},
                {'icon': Icons.power_off_rounded, 'label': '关闭电源'},
                {'icon': Icons.timer_rounded, 'label': '按时开电'},
                {'icon': Icons.volume_up_rounded, 'label': '语言播报'},
                {'icon': Icons.query_stats_rounded, 'label': '查询状态'},
                {'icon': Icons.history_rounded, 'label': '操作记录'},
                {'icon': Icons.settings_rounded, 'label': '设备设置'},
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildButtonGroup(String title, List<Map<String, dynamic>> buttons) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
        ),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 0.85,
          children: buttons.map((btn) {
            return _buildActionButton(btn['icon']!, btn['label']!);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('点击了 $label'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 24,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppTheme.textPrimary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
