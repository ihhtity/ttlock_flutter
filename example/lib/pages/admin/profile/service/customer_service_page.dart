import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:android_intent_plus/android_intent.dart';
import '../../../../theme.dart';

/// 客服页面
class CustomerServicePage extends StatelessWidget {
  const CustomerServicePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '客服',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.5,
        shadowColor: Colors.black12,
      ),
      backgroundColor: const Color(0xFFF7F8FA),
      body: ListView(
        padding: const EdgeInsets.only(top: 12, bottom: 20),
        children: [
          // 客服电话 - 重点突出
          _buildContactItem(
            context,
            icon: Icons.phone_outlined,
            label: '客服电话',
            value: '400-888-8888',
            type: ContactType.phone,
            isHighlight: true,
          ),
          const SizedBox(height: 12),
          
          // 邮箱
          _buildContactItem(
            context,
            icon: Icons.email_outlined,
            label: '邮箱',
            value: 'service@ttlock.com',
            type: ContactType.email,
          ),
          const SizedBox(height: 1),
          
          // 商务合作
          _buildContactItem(
            context,
            icon: Icons.business_outlined,
            label: '商务合作',
            value: 'sales@ttlock.com',
            type: ContactType.email,
          ),
          const SizedBox(height: 12),
          
          // 官网
          _buildContactItem(
            context,
            icon: Icons.language_outlined,
            label: '官网',
            value: 'www.ttlock.com',
            type: ContactType.url,
            url: 'https://www.ttlock.com',
          ),
          const SizedBox(height: 1),
          
          // 电脑网页版
          _buildContactItem(
            context,
            icon: Icons.computer_outlined,
            label: '电脑网页版',
            value: 'lock.ttlock.com',
            type: ContactType.url,
            url: 'https://lock.ttlock.com',
          ),
          const SizedBox(height: 1),
          
          // 酒店系统
          _buildContactItem(
            context,
            icon: Icons.hotel_outlined,
            label: '酒店系统',
            value: 'hotel.ttlock.com',
            type: ContactType.url,
            url: 'https://hotel.ttlock.com',
          ),
          const SizedBox(height: 12),
          
          // 公寓系统
          _buildContactItem(
            context,
            icon: Icons.apartment_outlined,
            label: '公寓系统',
            value: 'ttrenting.ttlock.com',
            type: ContactType.url,
            url: 'https://ttrenting.ttlock.com',
          ),
          const SizedBox(height: 1),
          
          // 说明书网页版
          _buildContactItem(
            context,
            icon: Icons.description_outlined,
            label: '说明书网页版',
            value: 'https://ttlockdoc.ttlock.com',
            type: ContactType.url,
            url: 'https://ttlockdoc.ttlock.com',
          ),
        ],
      ),
    );
  }

  /// 构建联系项
  Widget _buildContactItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required ContactType type,
    String? url,
    bool isHighlight = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: isHighlight 
          ? [
              BoxShadow(
                color: AppTheme.primaryColor.withValues(alpha: 0.15),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ]
          : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleContact(context, type, value, url),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // 图标容器
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isHighlight 
                      ? AppTheme.primaryColor.withValues(alpha: 0.1)
                      : const Color(0xFFF5F6F8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    size: 22,
                    color: isHighlight 
                      ? AppTheme.primaryColor
                      : const Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(width: 14),
                
                // 标签和内容
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: isHighlight ? FontWeight.w600 : FontWeight.w500,
                          color: isHighlight 
                            ? const Color(0xFF1F2937)
                            : const Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        value,
                        style: TextStyle(
                          fontSize: 13,
                          color: isHighlight 
                            ? AppTheme.primaryColor
                            : const Color(0xFF9CA3AF),
                          fontWeight: isHighlight ? FontWeight.w500 : FontWeight.normal,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 8),
                
                // 操作图标
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isHighlight 
                      ? AppTheme.primaryColor.withValues(alpha: 0.1)
                      : const Color(0xFFF5F6F8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getActionIcon(type),
                    size: 18,
                    color: isHighlight 
                      ? AppTheme.primaryColor
                      : const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 获取操作图标
  IconData _getActionIcon(ContactType type) {
    switch (type) {
      case ContactType.phone:
        return Icons.call_rounded;  // 电话图标
      case ContactType.email:
        return Icons.copy_all_rounded;  // 复制图标
      case ContactType.url:
        return Icons.link_rounded;  // 链接图标
    }
  }

  /// 处理联系操作
  Future<void> _handleContact(
    BuildContext context,
    ContactType type,
    String value,
    String? url,
  ) async {
    try {
      switch (type) {
        case ContactType.phone:
          // 在Android上直接拨打电话
          final AndroidIntent intent = AndroidIntent(
            action: 'action_call',
            data: 'tel:$value',
          );
          await intent.launch();
          break;
        case ContactType.email:
        case ContactType.url:
          // 复制内容到剪贴板
          await Clipboard.setData(ClipboardData(text: value));
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('已复制 $value 到剪贴板'),
                backgroundColor: AppTheme.successColor,
                duration: const Duration(seconds: 2),
              ),
            );
          }
          break;
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('操作失败: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }
}

/// 联系类型
enum ContactType {
  phone,  // 电话
  email,  // 邮箱
  url,    // 网址
}
