import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme.dart';
import '../../../utils/auth_service.dart';
import '../rooms/room_management_page.dart';
import '../../auth/login_entry_page.dart';
import 'account/personal_info_page.dart';
import 'service/customer_service_page.dart';
import 'service/about_page.dart';
import 'notification/message_notification_page.dart';
import 'device/device_management_page.dart';
import 'generic_feature_page.dart';
import 'finance/order_management_page.dart';
import 'user/user_management_page.dart';
import 'account/vendor_account_page.dart';
import 'account/privacy_settings_page.dart';
import 'account/payment_account_page.dart';
import 'finance/my_consumption_page.dart';
import 'finance/premium_features_page.dart';
import 'service/help_feedback_page.dart';
import 'account/sub_account_page.dart';
import 'user/family_members_page.dart';
import 'device/device_transfer_page.dart';
import 'user/group_management_page.dart';
import 'user/rule_management_page.dart';
import 'device/export_device_info_page.dart';

/// 个人中心页面
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // 模拟用户数据
  final Map<String, dynamic> _userData = {
    'nickname': '19874947494', // 默认为注册手机号或邮箱
    'phone': '19874947494',
    'email': 'zhangsan@example.com',
    'phoneBound': true,
    'emailBound': true,
    'avatar': null,
    'country': '中国',
    'countryCode': '+86',
  };

  // 模拟未读消息数量
  int _unreadMessageCount = 3;

  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false, // 完全禁用自动添加的返回按钮
        leading: null, // 删除返回按钮
        title: const Text(
          '个人中心',
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
          // 接收消息
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MessageNotificationPage(),
                    ),
                  ).then((_) {
                    // 从消息页面返回后，刷新未读数量
                    setState(() {
                      // TODO: 实际应该从后端获取最新的未读数量
                      _unreadMessageCount = 0; // 这里假设用户已查看所有消息
                    });
                  });
                },
                tooltip: '消息通知',
              ),
              // 未读消息角标
              if (_unreadMessageCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF44336),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      _unreadMessageCount > 99
                          ? '99+'
                          : _unreadMessageCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          // 联系客服
          IconButton(
            icon: const Icon(Icons.headset_mic_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CustomerServicePage(),
                ),
              );
            },
            tooltip: '联系客服',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 个人基本信息卡片
            _buildProfileCard(),

            const SizedBox(height: AppTheme.spacingMedium),

            // 功能菜单
            _buildMenuSection(),

            const SizedBox(height: AppTheme.spacingMedium),

            // 退出登录按钮
            _buildLogoutButton(),

            const SizedBox(height: AppTheme.spacingMedium),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          if (index == 0) {
            // 切换到房间管理
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const RoomManagementPage(),
              ),
              (route) => false,
            );
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

  /// 个人基本信息卡片
  Widget _buildProfileCard() {
    return InkWell(
      onTap: _navigateToPersonalInfo,
      child: Container(
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
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            // 头像
            CircleAvatar(
              radius: 35,
              backgroundColor: Colors.white,
              child: _userData['avatar'] != null
                  ? ClipOval(
                      child: Image.network(
                        _userData['avatar'],
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Icon(
                      Icons.person_rounded,
                      size: 40,
                      color: AppTheme.primaryColor,
                    ),
            ),
            const SizedBox(width: AppTheme.spacingLarge),

            // 用户信息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _userData['nickname'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (_userData['phoneBound'])
                    Text(
                      _userData['phone'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  if (_userData['emailBound'] && _userData['phoneBound'])
                    const SizedBox(height: 4),
                  if (_userData['emailBound'])
                    Text(
                      _userData['email'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                ],
              ),
            ),

            // 右箭头
            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.white,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }

  /// 跳转到个人信息页面
  void _navigateToPersonalInfo() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonalInfoPage(userData: _userData),
      ),
    ).then((updatedData) {
      if (updatedData != null && updatedData is Map<String, dynamic>) {
        setState(() {
          _userData.addAll(updatedData);
        });
      }
    });
  }

  /// 退出登录按钮
  Widget _buildLogoutButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLarge),
      child: InkWell(
        onTap: () {
          _showLogoutDialog();
        },
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFFF6B6B),
                const Color(0xFFEE5A6F),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF6B6B).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.logout_rounded,
                color: Colors.white,
                size: 22,
              ),
              const SizedBox(width: 12),
              const Text(
                '退出登录',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 显示退出登录确认对话框
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B6B).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: Color(0xFFFF6B6B),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              '确认退出',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: const Text(
          '确定要退出登录吗？退出后需要重新输入账号密码。',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF666666),
            height: 1.5,
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        actions: [
          // 取消按钮
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: const BorderSide(color: Color(0xFFE0E0E0)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                '取消',
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF666666),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // 确定按钮
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // 清除登录状态，跳转到登录选择页面
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const LoginEntryPage(),
                  ),
                  (route) => false, // 清除所有路由栈
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: const Color(0xFFFF6B6B),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                '确定',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 功能菜单区域
  Widget _buildMenuSection() {
    return Column(
      children: [
        // 设备管理卡片
        _buildFunctionCard(
          title: '设备管理',
          items: [
            {
              'icon': Icons.devices_rounded,
              'label': '设备管理',
              'color': AppTheme.primaryColor
            },
            {
              'icon': Icons.transfer_within_a_station_rounded,
              'label': '设备转移',
              'color': AppTheme.primaryColor
            },
            {
              'icon': Icons.group_work_rounded,
              'label': '分组管理',
              'color': AppTheme.primaryColor
            },
            {
              'icon': Icons.settings_rounded,
              'label': '规则管理',
              'color': AppTheme.primaryColor
            },
            {
              'icon': Icons.file_download_rounded,
              'label': '导出设备信息',
              'color': AppTheme.primaryColor
            },
          ],
        ),

        const SizedBox(height: AppTheme.spacingMedium),

        // 用户管理卡片
        _buildFunctionCard(
          title: '用户管理',
          items: [
            {
              'icon': Icons.people_rounded,
              'label': '用户管理',
              'color': const Color(0xFF2196F3)
            },
            {
              'icon': Icons.business_rounded,
              'label': '厂商账号',
              'color': const Color(0xFF2196F3)
            },
            {
              'icon': Icons.supervised_user_circle_rounded,
              'label': '子账号管理',
              'color': const Color(0xFF2196F3)
            },
            {
              'icon': Icons.family_restroom_rounded,
              'label': '家庭成员',
              'color': const Color(0xFF2196F3)
            },
          ],
        ),

        const SizedBox(height: AppTheme.spacingMedium),

        // 财务管理卡片
        _buildFunctionCard(
          title: '财务管理',
          items: [
            {
              'icon': Icons.account_balance_wallet_rounded,
              'label': '收款账号',
              'color': const Color(0xFFFF9800)
            },
            {
              'icon': Icons.receipt_long_rounded,
              'label': '订单管理',
              'color': const Color(0xFFFF9800)
            },
            {
              'icon': Icons.shopping_bag_rounded,
              'label': '我的消费',
              'color': const Color(0xFFFF9800)
            },
            {
              'icon': Icons.card_giftcard_rounded,
              'label': '增值功能',
              'color': const Color(0xFFFF9800)
            },
          ],
        ),

        const SizedBox(height: AppTheme.spacingMedium),

        // 系统设置卡片
        _buildFunctionCard(
          title: '系统设置',
          items: [
            {
              'icon': Icons.help_outline_rounded,
              'label': '帮助与反馈',
              'color': const Color(0xFF9C27B0)
            },
            {
              'icon': Icons.info_outline_rounded,
              'label': '关于我们',
              'color': const Color(0xFF9C27B0)
            },
            {
              'icon': Icons.security_rounded,
              'label': '隐私设置',
              'color': const Color(0xFF9C27B0)
            },
          ],
        ),
      ],
    );
  }

  /// 构建功能卡片
  Widget _buildFunctionCard({
    required String title,
    required List<Map<String, dynamic>> items,
  }) {
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
          // 卡片标题
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 12),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),
          ),

          // 功能按钮网格
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.85,
            children: items
                .map((item) => _buildFunctionButton(
                      icon: item['icon'] as IconData,
                      label: item['label'] as String,
                      color: item['color'] as Color,
                      badge: item['badge'] as int?,
                      onTap: () => _handleFunctionTap(item['label'] as String),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  /// 构建功能按钮
  Widget _buildFunctionButton({
    required IconData icon,
    required String label,
    required Color color,
    int? badge,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 图标容器
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 24,
                  ),
                ),
                // 角标
                if (badge != null && badge > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 1),
                      decoration: const BoxDecoration(
                        color: AppTheme.errorColor,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        badge.toString(),
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            // 文字
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF666666),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  /// 处理功能点击
  void _handleFunctionTap(String label) {
    Widget? page;

    switch (label) {
      case '消息通知':
        page = const MessageNotificationPage();
        break;
      case '关于我们':
        page = const AboutPage();
        break;
      case '设备管理':
        page = const DeviceManagementPage();
        break;
      case '设备转移':
        page = const DeviceTransferPage();
        break;
      case '分组管理':
        page = const GroupManagementPage();
        break;
      case '规则管理':
        page = const RuleManagementPage();
        break;
      case '导出设备信息':
        page = const ExportDeviceInfoPage();
        break;
      case '用户管理':
        page = const UserManagementPage();
        break;
      case '厂商账号':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const VendorAccountPage(),
          ),
        );
        return;
      case '子账号管理':
        page = const SubAccountPage();
        break;
      case '家庭成员':
        page = const FamilyMembersPage();
        break;
      case '收款账号':
        page = const PaymentAccountPage();
        break;
      case '订单管理':
        page = const OrderManagementPage();
        break;
      case '我的消费':
        page = const MyConsumptionPage();
        break;
      case '增值功能':
        page = const PremiumFeaturesPage();
        break;
      case '帮助与反馈':
        page = const HelpFeedbackPage();
        break;
      case '隐私设置':
        page = const PrivacySettingsPage();
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label功能开发中')),
        );
        return;
    }

    if (page != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => page!),
      );
    }
  }
}
