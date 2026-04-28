import 'package:flutter/material.dart';
import '../../../theme.dart';

/// 增值功能页面
class PremiumFeaturesPage extends StatefulWidget {
  const PremiumFeaturesPage({Key? key}) : super(key: key);

  @override
  _PremiumFeaturesPageState createState() => _PremiumFeaturesPageState();
}

class _PremiumFeaturesPageState extends State<PremiumFeaturesPage> {
  // 模拟增值服务数据
  final List<Map<String, dynamic>> _features = [
    {
      'id': '1',
      'title': '云存储服务',
      'description': '云端存储开锁记录、设备状态等数据',
      'price': '¥9.9/月',
      'originalPrice': '¥19.9/月',
      'icon': Icons.cloud_upload_rounded,
      'color': Color(0xFF2196F3),
      'purchased': true,
      'popular': false,
    },
    {
      'id': '2',
      'title': '高级数据分析',
      'description': '详细的设备使用统计和分析报告',
      'price': '¥29.9/月',
      'originalPrice': '¥49.9/月',
      'icon': Icons.analytics_rounded,
      'color': Color(0xFF9C27B0),
      'purchased': false,
      'popular': true,
    },
    {
      'id': '3',
      'title': '远程视频查看',
      'description': '随时随地查看门锁摄像头实时画面',
      'price': '¥19.9/月',
      'originalPrice': '¥39.9/月',
      'icon': Icons.videocam_rounded,
      'color': Color(0xFFF44336),
      'purchased': false,
      'popular': false,
    },
    {
      'id': '4',
      'title': '智能场景联动',
      'description': '创建自动化场景，多设备智能联动',
      'price': '¥15.9/月',
      'originalPrice': '¥29.9/月',
      'icon': Icons.auto_awesome_rounded,
      'color': Color(0xFFFF9800),
      'purchased': false,
      'popular': false,
    },
    {
      'id': '5',
      'title': '优先技术支持',
      'description': '享受专属客服和技术支持服务',
      'price': '¥49.9/月',
      'originalPrice': '¥99.9/月',
      'icon': Icons.support_agent_rounded,
      'color': Color(0xFF4CAF50),
      'purchased': false,
      'popular': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('增值功能'),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.5,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // VIP会员卡片
          _buildVipCard(),
          
          const SizedBox(height: 16),
          
          // 功能列表标题
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Row(
              children: [
                const Text(
                  '全部功能',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const Spacer(),
                Text(
                  '${_features.length}项服务',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          
          // 功能列表
          ..._features.map((feature) => _buildFeatureCard(feature)).toList(),
        ],
      ),
    );
  }

  /// 构建VIP会员卡片
  Widget _buildVipCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFFD700),
            const Color(0xFFFFA500),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD700).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.workspace_premium_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'VIP会员',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '解锁所有高级功能，享受专属权益',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('VIP开通功能开发中'),
                  backgroundColor: AppTheme.primaryColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFFFFA500),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              '立即开通 ¥99.9/年',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建功能卡片
  Widget _buildFeatureCard(Map<String, dynamic> feature) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // 图标
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: (feature['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    feature['icon'] as IconData,
                    color: feature['color'] as Color,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                
                // 信息
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        feature['title'] as String,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        feature['description'] as String,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF999999),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            feature['price'] as String,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFF5722),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            feature['originalPrice'] as String,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFFCCCCCC),
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // 操作按钮
                if (feature['purchased'] as bool)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.successColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '已开通',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.successColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                else
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('购买${feature['title']}功能开发中'),
                          backgroundColor: AppTheme.primaryColor,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: feature['color'] as Color,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      '购买',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
              ],
            ),
          ),
          
          // 热门标签
          if (feature['popular'] as bool)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF5722),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                child: const Text(
                  '热门',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
