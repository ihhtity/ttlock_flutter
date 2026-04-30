import 'package:flutter/material.dart';
import '../../../theme.dart';
import '../profile/profile_page.dart';

/// 用户端自助服务页面
class SelfServicePage extends StatefulWidget {
  const SelfServicePage({Key? key}) : super(key: key);

  @override
  _SelfServicePageState createState() => _SelfServicePageState();
}

class _SelfServicePageState extends State<SelfServicePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          '自助服务',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppTheme.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {
              // TODO: 消息通知
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 欢迎卡片
            _buildWelcomeCard(),
            
            const SizedBox(height: AppTheme.spacingMedium),
            
            // 快捷功能
            _buildQuickActions(),
            
            const SizedBox(height: AppTheme.spacingMedium),
            
            // 常用服务
            _buildCommonServices(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == _selectedIndex) return; // 如果点击当前页面，不执行任何操作
          
          setState(() {
            _selectedIndex = index;
          });
          
          if (index == 1) {
            // 切换到个人中心
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const UserProfilePage(),
              ),
              (route) => false,
            );
          }
          // index == 0 是当前页面（服务），不需要跳转
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: AppTheme.textHint,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: '服务',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: '我的',
          ),
        ],
      ),
    );
  }

  /// 欢迎卡片
  Widget _buildWelcomeCard() {
    return Container(
      margin: const EdgeInsets.all(AppTheme.spacingLarge),
      padding: const EdgeInsets.all(AppTheme.spacingLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor,
            AppTheme.primaryColor.withOpacity(0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.waving_hand_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '欢迎使用',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '自助服务平台',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 快捷功能
  Widget _buildQuickActions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLarge),
      padding: const EdgeInsets.all(AppTheme.spacingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '快捷功能',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: AppTheme.spacingMedium),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildQuickActionItem(
                icon: Icons.key_rounded,
                label: '开门',
                color: AppTheme.primaryColor,
              ),
              _buildQuickActionItem(
                icon: Icons.history_rounded,
                label: '记录',
                color: AppTheme.successColor,
              ),
              _buildQuickActionItem(
                icon: Icons.qr_code_rounded,
                label: '二维码',
                color: AppTheme.warningColor,
              ),
              _buildQuickActionItem(
                icon: Icons.help_outline_rounded,
                label: '帮助',
                color: AppTheme.infoColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 快捷功能项
  Widget _buildQuickActionItem({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return InkWell(
      onTap: () {
        // TODO: 实现具体功能
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$label 功能开发中'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// 常用服务
  Widget _buildCommonServices() {
    final services = [
      {'icon': Icons.lock_open_rounded, 'label': '门锁管理', 'color': AppTheme.primaryColor},
      {'icon': Icons.family_restroom_rounded, 'label': '家庭成员', 'color': AppTheme.successColor},
      {'icon': Icons.schedule_rounded, 'label': '密码管理', 'color': AppTheme.warningColor},
      {'icon': Icons.devices_rounded, 'label': '设备管理', 'color': AppTheme.infoColor},
      {'icon': Icons.report_problem_rounded, 'label': '报修服务', 'color': AppTheme.errorColor},
      {'icon': Icons.chat_bubble_outline_rounded, 'label': '在线客服', 'color': AppTheme.primaryColor},
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLarge),
      padding: const EdgeInsets.all(AppTheme.spacingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '常用服务',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: AppTheme.spacingMedium),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.0,
            ),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return _buildServiceItem(
                icon: service['icon'] as IconData,
                label: service['label'] as String,
                color: service['color'] as Color,
              );
            },
          ),
        ],
      ),
    );
  }

  /// 服务项
  Widget _buildServiceItem({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return InkWell(
      onTap: () {
        // TODO: 实现具体功能
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$label 功能开发中'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
