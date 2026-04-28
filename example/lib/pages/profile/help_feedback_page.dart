import 'package:flutter/material.dart';
import '../../theme.dart';

/// 帮助与反馈页面
class HelpFeedbackPage extends StatefulWidget {
  const HelpFeedbackPage({Key? key}) : super(key: key);

  @override
  _HelpFeedbackPageState createState() => _HelpFeedbackPageState();
}

class _HelpFeedbackPageState extends State<HelpFeedbackPage> {
  final TextEditingController _feedbackController = TextEditingController();
  String _selectedCategory = '功能建议';
  
  // 常见问题分类
  final List<Map<String, dynamic>> _faqCategories = [
    {
      'title': '设备使用',
      'icon': Icons.devices_rounded,
      'questions': [
        '如何添加新设备？',
        '设备连接失败怎么办？',
        '如何修改设备名称？',
        '设备离线如何处理？',
      ],
    },
    {
      'title': '账号管理',
      'icon': Icons.person_rounded,
      'questions': [
        '如何修改密码？',
        '如何绑定手机号？',
        '如何注销账号？',
        '忘记密码怎么办？',
      ],
    },
    {
      'title': '支付问题',
      'icon': Icons.payment_rounded,
      'questions': [
        '如何充值余额？',
        '退款流程是什么？',
        '支持哪些支付方式？',
        '发票如何开具？',
      ],
    },
    {
      'title': '其他问题',
      'icon': Icons.help_outline_rounded,
      'questions': [
        '应用闪退怎么办？',
        '如何清除缓存？',
        '如何更新到最新版本？',
        '数据会丢失吗？',
      ],
    },
  ];

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('帮助与反馈'),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.5,
      ),
      body: ListView(
        children: [
          // 搜索框
          _buildSearchBar(),
          
          // 常用问题
          _buildSection(
            title: '常见问题',
            icon: Icons.question_answer_rounded,
            child: _buildFaqList(),
          ),
          
          const SizedBox(height: 16),
          
          // 在线客服
          _buildSection(
            title: '联系客服',
            icon: Icons.headset_mic_rounded,
            child: _buildCustomerServiceOptions(),
          ),
          
          const SizedBox(height: 16),
          
          // 意见反馈
          _buildSection(
            title: '意见反馈',
            icon: Icons.feedback_rounded,
            child: _buildFeedbackForm(),
          ),
          
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  /// 构建搜索框
  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
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
      child: TextField(
        decoration: InputDecoration(
          hintText: '搜索常见问题',
          hintStyle: const TextStyle(color: Color(0xFF999999)),
          prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF999999)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onSubmitted: (value) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('搜索：$value'),
              backgroundColor: AppTheme.primaryColor,
            ),
          );
        },
      ),
    );
  }

  /// 构建分组
  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
                Icon(icon, color: AppTheme.primaryColor, size: 24),
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
          ),
          child,
        ],
      ),
    );
  }

  /// 构建FAQ列表
  Widget _buildFaqList() {
    return Column(
      children: _faqCategories.map((category) {
        return ExpansionTile(
          title: Row(
            children: [
              Icon(
                category['icon'] as IconData,
                color: AppTheme.primaryColor,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                category['title'] as String,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          children: (category['questions'] as List<String>).map((question) {
            return ListTile(
              title: Text(
                question,
                style: const TextStyle(fontSize: 14),
              ),
              trailing: const Icon(Icons.chevron_right_rounded, size: 20),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: Text(question),
                    content: const Text(
                      '这里是问题的详细解答内容。在实际应用中，这里会从后端获取详细的解答信息。',
                      style: TextStyle(fontSize: 14, height: 1.6),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('关闭'),
                      ),
                    ],
                  ),
                );
              },
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  /// 构建客服选项
  Widget _buildCustomerServiceOptions() {
    return Column(
      children: [
        _buildServiceOption(
          icon: Icons.chat_rounded,
          title: '在线客服',
          subtitle: '工作日 9:00-18:00',
          color: const Color(0xFF2196F3),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('在线客服功能开发中'),
                backgroundColor: AppTheme.primaryColor,
              ),
            );
          },
        ),
        const Divider(height: 1),
        _buildServiceOption(
          icon: Icons.phone_rounded,
          title: '电话客服',
          subtitle: '400-123-4567',
          color: const Color(0xFF4CAF50),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('拨打客服电话：400-123-4567'),
                backgroundColor: AppTheme.primaryColor,
              ),
            );
          },
        ),
        const Divider(height: 1),
        _buildServiceOption(
          icon: Icons.email_rounded,
          title: '邮件支持',
          subtitle: 'support@example.com',
          color: const Color(0xFFFF9800),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('发送邮件至：support@example.com'),
                backgroundColor: AppTheme.primaryColor,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildServiceOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF999999),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFFCCCCCC)),
          ],
        ),
      ),
    );
  }

  /// 构建反馈表单
  Widget _buildFeedbackForm() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 反馈类型选择
          const Text(
            '反馈类型',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              '功能建议',
              'Bug反馈',
              '体验优化',
              '其他',
            ].map((type) {
              final isSelected = _selectedCategory == type;
              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedCategory = type;
                  });
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primaryColor : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    type,
                    style: TextStyle(
                      fontSize: 13,
                      color: isSelected ? Colors.white : const Color(0xFF666666),
                      fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 16),
          
          // 反馈内容输入
          const Text(
            '反馈内容',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _feedbackController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: '请详细描述您的问题或建议...',
              hintStyle: const TextStyle(color: Color(0xFFCCCCCC)),
              filled: true,
              fillColor: Colors.grey.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 提交按钮
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_feedbackController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('请输入反馈内容'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('感谢您的反馈！'),
                    backgroundColor: AppTheme.successColor,
                  ),
                );
                _feedbackController.clear();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                '提交反馈',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
