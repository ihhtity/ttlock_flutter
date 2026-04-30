import 'package:flutter/material.dart';
import '../../../theme.dart';
import '../../../utils/auth_service.dart';
import '../../../utils/local_cache.dart';
import '../../../utils/api_client.dart';
import '../../auth/login_entry_page.dart';
import '../service/self_service_page.dart';
import 'user_personal_info_page.dart';

/// 菜单项数据模型
class MenuItemData {
  final IconData icon;
  final String label;
  final Color color;

  const MenuItemData({
    required this.icon,
    required this.label,
    required this.color,
  });
}

/// 用户端个人中心页面
class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  int _selectedIndex = 1;
  
  // 用户数据（从缓存加载）
  Map<String, dynamic> _userData = {
    'nickname': '用户',
    'phone': null,
    'email': null,
    'phoneBound': false,
    'emailBound': false,
    'avatar': null,
  };
  
  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }
  
  /// 加载用户信息
  void _loadUserInfo() {
    final userInfo = LocalCache.getUserInfo();
    if (userInfo != null) {
      setState(() {
        _userData = {
          'nickname': userInfo['nickname'] ?? '用户',
          'phone': userInfo['phone'],
          'email': userInfo['email'],
          'phoneBound': userInfo['phone'] != null && userInfo['phone'].toString().isNotEmpty,
          'emailBound': userInfo['email'] != null && userInfo['email'].toString().isNotEmpty,
          'avatar': userInfo['avatar'],
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
          if (index == _selectedIndex) return; // 如果点击当前页面，不执行任何操作
          
          setState(() {
            _selectedIndex = index;
          });
          
          if (index == 0) {
            // 切换到自助服务
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const SelfServicePage(),
              ),
              (route) => false,
            );
          }
          // index == 1 是当前页面（我的），不需要跳转
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
                    _userData['nickname'] ?? '用户',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // 只显示已绑定的手机号
                  if (_userData['phoneBound'] ?? false)
                    Text(
                      _userData['phone'] ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  // 如果手机号和邮箱都已绑定，添加间距
                  if ((_userData['emailBound'] ?? false) && (_userData['phoneBound'] ?? false))
                    const SizedBox(height: 4),
                  // 只显示已绑定的邮箱
                  if (_userData['emailBound'] ?? false)
                    Text(
                      _userData['email'] ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  // 如果都没有绑定，显示提示
                  if (!(_userData['phoneBound'] ?? false) && !(_userData['emailBound'] ?? false))
                    Text(
                      '点击完善个人信息',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.7),
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

  /// 功能菜单区域
  Widget _buildMenuSection() {
    return Column(
      children: [
        // 账号管理卡片
        _buildFunctionCard(
          title: '账号管理',
          items: [
            {'icon': Icons.security_rounded, 'label': '账号安全', 'color': AppTheme.successColor},
            {'icon': Icons.notifications_outlined, 'label': '消息通知', 'color': AppTheme.warningColor},
          ],
        ),

        const SizedBox(height: AppTheme.spacingMedium),

        // 服务支持卡片
        _buildFunctionCard(
          title: '服务支持',
          items: [
            {'icon': Icons.help_outline_rounded, 'label': '帮助中心', 'color': AppTheme.infoColor},
            {'icon': Icons.chat_bubble_outline_rounded, 'label': '在线客服', 'color': AppTheme.primaryColor},
            {'icon': Icons.info_outline_rounded, 'label': '关于我们', 'color': AppTheme.textSecondary},
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
    switch (label) {
      case '账号安全':
        _navigateToPersonalInfo();
        break;
      case '消息通知':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('消息通知功能开发中')),
        );
        break;
      case '帮助中心':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('帮助中心功能开发中')),
        );
        break;
      case '在线客服':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('在线客服功能开发中')),
        );
        break;
      case '关于我们':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('关于我们功能开发中')),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label功能开发中')),
        );
    }
  }

  /// 退出登录按钮
  Widget _buildLogoutButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _showLogoutDialog,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.logout_rounded,
                  color: AppTheme.errorColor,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Text(
                  '退出登录',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.errorColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 跳转到个人信息页面
  void _navigateToPersonalInfo() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const UserPersonalInfoPage(),
      ),
    );
  }

  /// 显示退出登录确认对话框
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认退出'),
        content: const Text('确定要退出登录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _logout();
            },
            child: const Text(
              '确定',
              style: TextStyle(color: AppTheme.errorColor),
            ),
          ),
        ],
      ),
    );
  }

  /// 退出登录
  Future<void> _logout() async {
    // 清除登录状态和用户信息
    await LocalCache.saveLoginStatus(false);
    await LocalCache.clearUserInfo();
    HttpClient.setToken('');
    
    // 返回到登录选择页面
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginEntryPage(),
      ),
      (route) => false,
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('已退出登录'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }
}
