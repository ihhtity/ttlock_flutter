import 'package:flutter/material.dart';
import '../../theme.dart';

/// 收款账号管理页面
class PaymentAccountPage extends StatefulWidget {
  const PaymentAccountPage({Key? key}) : super(key: key);

  @override
  _PaymentAccountPageState createState() => _PaymentAccountPageState();
}

class _PaymentAccountPageState extends State<PaymentAccountPage> {
  // 模拟收款账号数据
  final List<Map<String, dynamic>> _accounts = [
    {
      'id': '1',
      'type': 'wechat',
      'name': '微信支付',
      'account': '138****1234',
      'isDefault': true,
      'icon': Icons.wechat_rounded,
      'color': Color(0xFF07C160),
    },
    {
      'id': '2',
      'type': 'alipay',
      'name': '支付宝',
      'account': 'zhang***@example.com',
      'isDefault': false,
      'icon': Icons.payment_rounded,
      'color': Color(0xFF1677FF),
    },
    {
      'id': '3',
      'type': 'bank',
      'name': '工商银行',
      'account': '6222 **** **** 8888',
      'isDefault': false,
      'icon': Icons.account_balance_rounded,
      'color': Color(0xFFE60012),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          '收款账号',
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
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFF9800),
                  Color(0xFFFFB74D),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: const Icon(Icons.add_rounded, color: Colors.white),
              onPressed: _showAddAccountDialog,
              tooltip: '添加账号',
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 提示信息
          _buildTipCard(),
          
          // 账号列表
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _accounts.length,
              itemBuilder: (context, index) {
                return _buildAccountCard(_accounts[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 构建提示卡片
  Widget _buildTipCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFF9800).withOpacity(0.12),
            const Color(0xFFFFB74D).withOpacity(0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFF9800).withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF9800).withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFF9800).withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              color: Color(0xFFFF9800),
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              '请确保收款账号信息准确无误，以便正常接收款项',
              style: TextStyle(
                fontSize: 13,
                color: const Color(0xFFFF9800).withOpacity(0.95),
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建账号卡片
  Widget _buildAccountCard(Map<String, dynamic> account) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            // 图标
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    (account['color'] as Color).withOpacity(0.15),
                    (account['color'] as Color).withOpacity(0.08),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                account['icon'] as IconData,
                color: account['color'] as Color,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            
            // 账号信息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        account['name'] as String,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                        ),
                      ),
                      if (account['isDefault'] as bool) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.successColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '默认',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppTheme.successColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    account['account'] as String,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF999999),
                    ),
                  ),
                ],
              ),
            ),
            
            // 操作按钮
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert_rounded),
              onSelected: (value) {
                if (value == 'set_default') {
                  _setDefaultAccount(account['id']);
                } else if (value == 'edit') {
                  _showEditAccountDialog(account);
                } else if (value == 'delete') {
                  _showDeleteConfirmDialog(account);
                }
              },
              itemBuilder: (context) => [
                if (!(account['isDefault'] as bool))
                  const PopupMenuItem(
                    value: 'set_default',
                    child: Row(
                      children: [
                        Icon(Icons.check_circle_outline_rounded, size: 20),
                        SizedBox(width: 8),
                        Text('设为默认'),
                      ],
                    ),
                  ),
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit_rounded, size: 20),
                      SizedBox(width: 8),
                      Text('编辑'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline_rounded, size: 20, color: Colors.red),
                      SizedBox(width: 8),
                      Text('删除', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 设置默认账号
  void _setDefaultAccount(String id) {
    setState(() {
      for (var account in _accounts) {
        account['isDefault'] = account['id'] == id;
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('已设置为默认收款账号'),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// 显示添加账号对话框
  void _showAddAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('添加收款账号'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAccountTypeOption('wechat', '微信支付', Icons.wechat_rounded, Color(0xFF07C160)),
            const SizedBox(height: 12),
            _buildAccountTypeOption('alipay', '支付宝', Icons.payment_rounded, Color(0xFF1677FF)),
            const SizedBox(height: 12),
            _buildAccountTypeOption('bank', '银行卡', Icons.account_balance_rounded, Color(0xFFE60012)),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountTypeOption(String type, String name, IconData icon, Color color) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('添加$name功能开发中'),
            backgroundColor: AppTheme.primaryColor,
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: 16),
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 显示编辑账号对话框
  void _showEditAccountDialog(Map<String, dynamic> account) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('编辑功能开发中'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  /// 显示删除确认对话框
  void _showDeleteConfirmDialog(Map<String, dynamic> account) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('确认删除'),
        content: Text('确定要删除${account['name']}吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _accounts.removeWhere((a) => a['id'] == account['id']);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('已删除'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }
}
