import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../theme.dart';

/// 关于页面
class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('关于'),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: const Color(0xFFE5E5E5),
            height: 1,
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 顶部品牌区域
            _buildHeaderSection(),
            
            const SizedBox(height: 24),
            
            // 公司介绍（可折叠）
            _buildExpandableCard(
              '公司介绍',
              '宝士力得（BSLD）是TTLock Technology Co., Ltd.旗下的智能门锁品牌...',
              Icons.business_rounded,
              false,
              [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '宝士力得（BSLD）是TTLock Technology Co., Ltd.旗下的智能门锁品牌，专注于为用户提供安全、便捷、智能的门禁解决方案。我们致力于通过创新技术和优质服务，让智能家居生活更加美好。\n\n' +
                    '公司成立于2015年，总部位于中国深圳，业务遍及全球50多个国家和地区。我们拥有专业的研发团队和完善的售后服务体系，为用户提供7x24小时的技术支持。',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF666666),
                      height: 1.8,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // 公司信息卡片
            _buildInfoCard(),
            
            const SizedBox(height: 12),
            
            // 应用权限收集说明（可折叠）
            _buildExpandableCard(
              '应用权限收集说明',
              '查看应用所需的权限及用途说明',
              Icons.security_rounded,
              true,
              [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildPermissionItem(
                        '蓝牙权限',
                        '用于搜索和连接智能门锁、网关等设备',
                        Icons.bluetooth_rounded,
                      ),
                      const SizedBox(height: 16),
                      _buildPermissionItem(
                        '位置权限',
                        'Android系统要求使用蓝牙功能必须获取位置权限',
                        Icons.location_on_rounded,
                      ),
                      const SizedBox(height: 16),
                      _buildPermissionItem(
                        '网络权限',
                        '用于设备数据同步、远程控制和固件更新',
                        Icons.wifi_rounded,
                      ),
                      const SizedBox(height: 16),
                      _buildPermissionItem(
                        '相机权限',
                        '用于扫描设备二维码和条形码',
                        Icons.camera_alt_rounded,
                      ),
                      const SizedBox(height: 16),
                      _buildPermissionItem(
                        '存储权限',
                        '用于保存设备配置和本地数据',
                        Icons.storage_rounded,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // 版权信息
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                children: [
                  Text(
                    '© 2026 TTLock. All rights reserved.',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF999999),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Version 1.0.0',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFFCCCCCC),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// 构建顶部品牌区域
  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          // Logo
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor,
                  AppTheme.primaryColor.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.lock_outline_rounded,
              size: 48,
              color: Colors.white,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // 应用名称
          const Text(
            '宝士力得',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
              letterSpacing: 1,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // 版本号标签
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'v1.0.0',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  /// 构建信息卡片
  Widget _buildInfoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildCopyableItem('公司名称', 'TTLock Technology Co., Ltd.', Icons.business_rounded),
          _buildDivider(),
          _buildCopyableItem('官方网站', 'www.ttlock.com', Icons.language_rounded),
          _buildDivider(),
          _buildCallItem('客服电话', '400-888-8888', Icons.phone_rounded),
          _buildDivider(),
          _buildCopyableItem('客服邮箱', 'service@ttlock.com', Icons.email_rounded),
          _buildDivider(),
          _buildCopyableItem('商务合作', 'sales@ttlock.com', Icons.handshake_rounded),
          _buildDivider(),
          _buildExpandableListItem('隐私政策', '查看隐私政策详细内容', Icons.privacy_tip_rounded, false),
          _buildDivider(),
          _buildExpandableListItem('用户协议', '查看用户协议详细内容', Icons.description_rounded, false),
          _buildDivider(),
          _buildExpandableListItem('开源许可', '查看开源许可详细内容', Icons.code_rounded, false),
        ],
      ),
    );
  }
  
  /// 构建分隔线
  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 56),
      child: Divider(
        height: 1,
        thickness: 0.5,
        color: const Color(0xFFE5E5E5),
      ),
    );
  }

  /// 构建信息项
  Widget _buildInfoItem(String label, String value) {
    return Container(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          // TODO: 根据不同项跳转到对应页面
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              // 标签
              Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF333333),
                ),
              ),
              
              const Spacer(),
              
              // 值
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF999999),
                ),
              ),
              
              const SizedBox(width: 8),
              
              // 箭头图标
              const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: Color(0xFFCCCCCC),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// 构建可复制信息项
  Widget _buildCopyableItem(String label, String value, IconData icon) {
    return InkWell(
      onTap: () async {
        await Clipboard.setData(ClipboardData(text: value));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text('$label 已复制'),
                ],
              ),
              duration: const Duration(seconds: 1),
              backgroundColor: const Color(0xFF4CAF50),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // 图标
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
            // 标签
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF999999),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF1A1A1A),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // 复制图标
            Icon(
              Icons.copy_rounded,
              size: 18,
              color: const Color(0xFFCCCCCC),
            ),
          ],
        ),
      ),
    );
  }
  
  /// 构建可拨打的电话项
  Widget _buildCallItem(String label, String phoneNumber, IconData icon) {
    return InkWell(
      onTap: () async {
        final Uri launchUri = Uri(
          scheme: 'tel',
          path: phoneNumber,
        );
        if (await canLaunchUrl(launchUri)) {
          await launchUrl(launchUri);
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('无法拨打电话'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // 图标
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
            // 标签
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF999999),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    phoneNumber,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF1A1A1A),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // 电话图标
            Icon(
              Icons.phone_rounded,
              size: 18,
              color: AppTheme.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
  
  /// 构建可折叠列表项
  Widget _buildExpandableListItem(String title, String subtitle, IconData icon, bool isAlwaysExpanded) {
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 16),
      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      iconColor: AppTheme.primaryColor,
      collapsedIconColor: const Color(0xFFCCCCCC),
      initiallyExpanded: isAlwaysExpanded,
      leading: Container(
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
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          color: Color(0xFF1A1A1A),
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: !isAlwaysExpanded ? Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF999999),
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ) : null,
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            _getContentText(title),
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
              height: 1.8,
            ),
          ),
        ),
      ],
    );
  }
  
  /// 构建可折叠卡片
  Widget _buildExpandableCard(String title, String subtitle, IconData icon, bool isAlwaysExpanded, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: EdgeInsets.zero,
        iconColor: AppTheme.primaryColor,
        collapsedIconColor: const Color(0xFFCCCCCC),
        initiallyExpanded: isAlwaysExpanded,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryColor,
                AppTheme.primaryColor.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 22,
            color: Colors.white,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: !isAlwaysExpanded ? Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF999999),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ) : null,
        children: children,
      ),
    );
  }
  
  /// 获取内容文本
  String _getContentText(String title) {
    switch (title) {
      case '隐私政策':
        return '我们非常重视您的隐私保护。本隐私政策详细说明了我们如何收集、使用、存储和保护您的个人信息。\n\n1. 信息收集：我们会收集您在使用服务过程中产生的必要信息\n2. 信息使用：我们仅将信息用于提供和改进服务\n3. 信息安全：我们采取严格的安全措施保护您的信息';
      case '用户协议':
        return '欢迎使用宝士力得智能门锁应用。本协议是您与我们之间就使用本应用达成的法律协议。\n\n1. 服务条款：您同意按照本协议使用我们的服务\n2. 用户责任：您需要妥善保管账户信息\n3. 免责声明：在法律规定范围内，我们不对某些情况承担责任';
      case '开源许可':
        return '本项目使用了以下开源软件：\n\n1. Flutter - Apache License 2.0\n2. url_launcher - BSD License\n3. shared_preferences - BSD License\n\n感谢所有开源贡献者！';
      default:
        return '';
    }
  }
  
  /// 构建章节标题
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
        ],
      ),
    );
  }
  
  /// 构建权限项
  Widget _buildPermissionItem(String title, String description, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 图标
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(width: 12),
          // 文本
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF999999),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
