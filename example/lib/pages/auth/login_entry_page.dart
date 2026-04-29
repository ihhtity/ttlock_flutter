import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../theme.dart';
import '../../utils/auth_service.dart';
import 'login_page.dart';

/// 登录入口选择页面
class LoginEntryPage extends StatelessWidget {
  const LoginEntryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingXLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo和标题
              Icon(
                Icons.lock_outline_rounded,
                size: 100,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(height: AppTheme.spacingMedium),
              Text(
                l10n.appName,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacingSmall),
              Text(
                '欢迎使用宝士力得设备管理系统',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 60),
              
              // 管理端入口
              _LoginEntryCard(
                icon: Icons.admin_panel_settings_rounded,
                title: '管理端登录',
                subtitle: '管理员、运维人员使用',
                color: AppTheme.primaryColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(
                        loginType: LoginType.admin,
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: AppTheme.spacingLarge),
              
              // 用户端入口
              _LoginEntryCard(
                icon: Icons.person_outline_rounded,
                title: '用户端登录',
                subtitle: '普通用户使用',
                color: AppTheme.successColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(
                        loginType: LoginType.client,
                      ),
                    ),
                  );
                },
              ),
              
              const Spacer(),
              
              // 底部版权信息
              Text(
                '© 2026 宝士力得. All rights reserved.',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textHint,
                ),
              ),
              const SizedBox(height: AppTheme.spacingSmall),
            ],
          ),
        ),
      ),
    );
  }
}

/// 登录入口卡片
class _LoginEntryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _LoginEntryCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingXLarge),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingMedium),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
              ),
              child: Icon(
                icon,
                size: 40,
                color: color,
              ),
            ),
            const SizedBox(width: AppTheme.spacingLarge),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 20,
              color: color,
            ),
          ],
        ),
      ),
    );
  }
}
