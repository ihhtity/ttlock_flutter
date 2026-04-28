import 'package:flutter/material.dart';
import '../../../theme.dart';

/// 添加设备页面
class AddDevicePage extends StatelessWidget {
  const AddDevicePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '添加设备',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black87),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(
            color: Colors.grey.shade200,
            height: 0.5,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 12, bottom: 20),
        children: [
          // 智能锁分类
          _buildSection(
            title: '智能锁',
            items: [
              {'name': '所有锁', 'icon': Icons.lock_rounded, 'hasImage': true},
              {
                'name': '门锁',
                'icon': Icons.door_front_door_rounded,
                'hasImage': true
              },
              {
                'name': '挂锁',
                'icon': Icons.lock_outline_rounded,
                'hasImage': true
              },
              {
                'name': '保险箱锁',
                'icon': Icons.security_rounded,
                'hasImage': true
              },
              {'name': '智能锁芯', 'icon': Icons.tune_rounded, 'hasImage': true},
              {
                'name': '车位锁',
                'icon': Icons.local_parking_rounded,
                'hasImage': true
              },
              {'name': '柜锁', 'icon': Icons.chair_rounded, 'hasImage': true},
              {
                'name': '自行车锁',
                'icon': Icons.pedal_bike_rounded,
                'hasImage': true
              },
              {
                'name': '遥控设备',
                'icon': Icons.gamepad_rounded,
                'hasImage': false
              },
            ],
          ),

          const SizedBox(height: 20),

          // 网关分类
          _buildSection(
            title: '网关',
            items: [
              {
                'name': 'G1 (Wi-Fi)',
                'subtitle': '2.4G',
                'icon': Icons.router_rounded,
                'hasImage': true
              },
              {
                'name': 'G2 (Wi-Fi)',
                'subtitle': '2.4G',
                'icon': Icons.wifi_rounded,
                'hasImage': true
              },
              {'name': 'G3 (有线)', 'icon': Icons.lan_rounded, 'hasImage': true},
              {
                'name': 'G4 (4G)',
                'icon': Icons.signal_cellular_alt_rounded,
                'hasImage': true
              },
              {
                'name': 'G5 (Wi-Fi)',
                'subtitle': '2.4G&5G',
                'icon': Icons.wifi_tethering_rounded,
                'hasImage': true
              },
              {
                'name': 'G6 (Matter)',
                'icon': Icons.device_hub_rounded,
                'hasImage': true
              },
            ],
          ),

          const SizedBox(height: 20),

          // 摄像头分类
          _buildSection(
            title: '摄像头',
            items: [
              {'name': 'TC2', 'icon': Icons.videocam_rounded, 'hasImage': true},
              {
                'name': 'DB2',
                'icon': Icons.camera_alt_rounded,
                'hasImage': true
              },
            ],
          ),

          const SizedBox(height: 20),

          // 门磁分类
          _buildSection(
            title: '门磁',
            items: [
              {
                'name': '门磁传感器',
                'icon': Icons.sensors_rounded,
                'hasImage': true
              },
            ],
          ),

          const SizedBox(height: 20),

          // 电源分类
          _buildSection(
            title: '电源',
            items: [
              {'name': '智能插座', 'icon': Icons.power_rounded, 'hasImage': true},
              {'name': '电表', 'icon': Icons.bolt_rounded, 'hasImage': true},
            ],
          ),
        ],
      ),
    );
  }

  /// 构建分类区块
  Widget _buildSection({
    required String title,
    required List<Map<String, dynamic>> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 分类标题（在白色卡片外面）
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF666666),
            ),
          ),
        ),

        // 白色大卡片容器
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 2.8,
            children: items.map((item) {
              return _buildDeviceCard(
                name: item['name'] as String,
                subtitle: item['subtitle'] as String?,
                icon: item['icon'] as IconData,
                hasImage: item['hasImage'] as bool? ?? false,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  /// 构建设备卡片
  Widget _buildDeviceCard({
    required String name,
    String? subtitle,
    required IconData icon,
    required bool hasImage,
  }) {
    return Material(
      color: const Color(0xFFF5F7FA),
      borderRadius: BorderRadius.circular(8),
      elevation: 0,
      child: InkWell(
        onTap: () {
          // TODO: 跳转到设备配对页面
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              // 设备图标/图片（白色背景小方块）
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: const Color(0xFF333333),
                ),
              ),

              const SizedBox(width: 10),

              // 设备名称和副标题
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF333333),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF999999),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
