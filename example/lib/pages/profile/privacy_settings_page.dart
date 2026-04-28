import 'package:flutter/material.dart';
import '../../theme.dart';

/// 隐私设置页面
class PrivacySettingsPage extends StatefulWidget {
  const PrivacySettingsPage({Key? key}) : super(key: key);

  @override
  _PrivacySettingsPageState createState() => _PrivacySettingsPageState();
}

class _PrivacySettingsPageState extends State<PrivacySettingsPage> {
  bool _allowLocation = true;
  bool _allowNotifications = true;
  bool _allowDataCollection = false;
  bool _showOnlineStatus = true;
  bool _allowFriendRequests = true;
  String _dataRetentionPeriod = '30天';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('隐私设置'),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.5,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 数据隐私
          _buildSection(
            title: '数据隐私',
            icon: Icons.security_rounded,
            children: [
              _buildSwitchItem(
                title: '允许位置服务',
                subtitle: '允许应用访问您的位置信息',
                value: _allowLocation,
                onChanged: (value) {
                  setState(() => _allowLocation = value);
                },
              ),
              _buildDivider(),
              _buildSwitchItem(
                title: '允许数据收集',
                subtitle: '帮助我们改进产品和服务',
                value: _allowDataCollection,
                onChanged: (value) {
                  setState(() => _allowDataCollection = value);
                },
              ),
              _buildDivider(),
              _buildSelectItem(
                title: '数据保留期限',
                subtitle: '自动删除旧数据的时间',
                value: _dataRetentionPeriod,
                onTap: _showDataRetentionDialog,
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 通知隐私
          _buildSection(
            title: '通知隐私',
            icon: Icons.notifications_rounded,
            children: [
              _buildSwitchItem(
                title: '允许推送通知',
                subtitle: '接收消息和活动通知',
                value: _allowNotifications,
                onChanged: (value) {
                  setState(() => _allowNotifications = value);
                },
              ),
              _buildDivider(),
              _buildSwitchItem(
                title: '显示在线状态',
                subtitle: '其他用户可以看到您的在线状态',
                value: _showOnlineStatus,
                onChanged: (value) {
                  setState(() => _showOnlineStatus = value);
                },
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 社交隐私
          _buildSection(
            title: '社交隐私',
            icon: Icons.group_rounded,
            children: [
              _buildSwitchItem(
                title: '允许好友请求',
                subtitle: '接收其他用户的好友申请',
                value: _allowFriendRequests,
                onChanged: (value) {
                  setState(() => _allowFriendRequests = value);
                },
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 数据安全
          _buildSection(
            title: '数据安全',
            icon: Icons.lock_rounded,
            children: [
              _buildActionItem(
                title: '修改密码',
                subtitle: '定期修改密码以提高安全性',
                icon: Icons.vpn_key_rounded,
                onTap: _showChangePasswordDialog,
              ),
              _buildDivider(),
              _buildActionItem(
                title: '双重验证',
                subtitle: '开启双重验证保护账户安全',
                icon: Icons.shield_rounded,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('双重验证功能开发中'),
                      backgroundColor: AppTheme.primaryColor,
                    ),
                  );
                },
              ),
              _buildDivider(),
              _buildActionItem(
                title: '导出个人数据',
                subtitle: '下载您的个人数据副本',
                icon: Icons.download_rounded,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('数据导出功能开发中'),
                      backgroundColor: AppTheme.primaryColor,
                    ),
                  );
                },
              ),
              _buildDivider(),
              _buildActionItem(
                title: '删除账户',
                subtitle: '永久删除您的账户和所有数据',
                icon: Icons.delete_forever_rounded,
                iconColor: AppTheme.errorColor,
                titleColor: AppTheme.errorColor,
                onTap: _showDeleteAccountDialog,
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // 隐私政策
          Center(
            child: TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('隐私政策页面开发中'),
                    backgroundColor: AppTheme.primaryColor,
                  ),
                );
              },
              child: const Text(
                '查看隐私政策',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建分组
  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    size: 18,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }

  /// 构建开关项
  Widget _buildSwitchItem({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          color: Color(0xFF333333),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF999999),
        ),
      ),
      trailing: Switch(
        value: value,
        activeColor: AppTheme.primaryColor,
        onChanged: onChanged,
      ),
    );
  }

  /// 构建选择项
  Widget _buildSelectItem({
    required String title,
    required String subtitle,
    required String value,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          color: Color(0xFF333333),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF999999),
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.chevron_right_rounded,
            color: Color(0xFFCCCCCC),
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  /// 构建操作项
  Widget _buildActionItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    Color? iconColor,
    Color? titleColor,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Icon(
        icon,
        color: iconColor ?? AppTheme.primaryColor,
        size: 22,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          color: titleColor ?? const Color(0xFF333333),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF999999),
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: Color(0xFFCCCCCC),
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, indent: 16, endIndent: 16);
  }

  /// 显示数据保留期限对话框
  void _showDataRetentionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('选择数据保留期限'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['7天', '30天', '90天', '180天', '永久保留']
              .map((period) => ListTile(
                    title: Text(period),
                    selected: _dataRetentionPeriod == period,
                    onTap: () {
                      setState(() => _dataRetentionPeriod = period);
                      Navigator.pop(context);
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }

  /// 显示修改密码对话框
  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('修改密码'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: '当前密码',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: '新密码',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: '确认新密码',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('密码修改成功'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            child: const Text('确认'),
          ),
        ],
      ),
    );
  }

  /// 显示删除账户对话框
  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.warning_rounded,
              color: AppTheme.errorColor,
              size: 24,
            ),
            const SizedBox(width: 8),
            const Text('确认删除账户'),
          ],
        ),
        content: const Text(
          '删除账户后，您的所有数据将被永久删除且无法恢复。此操作不可逆，请谨慎操作。',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF666666),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('账户删除功能开发中'),
                  backgroundColor: AppTheme.errorColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('确认删除'),
          ),
        ],
      ),
    );
  }
}
