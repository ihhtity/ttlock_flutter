import 'package:flutter/material.dart';
import '../../../../theme.dart';

/// 子账号管理页面
class SubAccountPage extends StatefulWidget {
  const SubAccountPage({Key? key}) : super(key: key);

  @override
  _SubAccountPageState createState() => _SubAccountPageState();
}

class _SubAccountPageState extends State<SubAccountPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  // 模拟子账号数据
  final List<Map<String, dynamic>> _subAccounts = [
    {
      'id': 'SA001',
      'name': '李小明',
      'phone': '138****5678',
      'role': '管理员',
      'permissions': ['开锁', '添加用户', '查看记录'],
      'status': 'active',
      'createTime': '2024-01-10',
      'lastLogin': '2024-01-25 14:30',
    },
    {
      'id': 'SA002',
      'name': '王小红',
      'phone': '139****9012',
      'role': '普通用户',
      'permissions': ['开锁', '查看记录'],
      'status': 'active',
      'createTime': '2024-01-15',
      'lastLogin': '2024-01-24 09:15',
    },
    {
      'id': 'SA003',
      'name': '张小刚',
      'phone': '137****3456',
      'role': '访客',
      'permissions': ['开锁'],
      'status': 'inactive',
      'createTime': '2024-01-20',
      'lastLogin': '2024-01-22 16:45',
    },
  ];

  List<Map<String, dynamic>> get _filteredAccounts {
    if (_searchText.isEmpty) return _subAccounts;
    return _subAccounts.where((account) {
      return account['name'].toString().contains(_searchText) ||
          account['phone'].toString().contains(_searchText);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('子账号管理'),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_rounded),
            onPressed: _showAddAccountDialog,
            tooltip: '添加子账号',
          ),
        ],
      ),
      body: Column(
        children: [
          // 搜索框
          _buildSearchBar(),
          
          // 统计信息
          _buildStatistics(),
          
          // 账号列表
          Expanded(
            child: _filteredAccounts.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredAccounts.length,
                    itemBuilder: (context, index) {
                      return _buildAccountCard(_filteredAccounts[index]);
                    },
                  ),
          ),
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
        controller: _searchController,
        decoration: InputDecoration(
          hintText: '搜索账号名称或手机号',
          hintStyle: const TextStyle(color: Color(0xFF999999)),
          prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF999999)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onChanged: (value) {
          setState(() {
            _searchText = value;
          });
        },
      ),
    );
  }

  /// 构建统计信息
  Widget _buildStatistics() {
    final activeCount = _subAccounts.where((a) => a['status'] == 'active').length;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF2196F3),
            const Color(0xFF2196F3).withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem('总账号', _subAccounts.length.toString(), Icons.people_rounded),
          ),
          Expanded(
            child: _buildStatItem('活跃', activeCount.toString(), Icons.check_circle_rounded),
          ),
          Expanded(
            child: _buildStatItem('未激活', (_subAccounts.length - activeCount).toString(), Icons.cancel_rounded),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ],
    );
  }

  /// 构建账号卡片
  Widget _buildAccountCard(Map<String, dynamic> account) {
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 头部信息
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: const Color(0xFF2196F3).withOpacity(0.1),
                  child: Text(
                    (account['name'] as String).substring(0, 1),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2196F3),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
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
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _getRoleColor(account['role']).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              account['role'] as String,
                              style: TextStyle(
                                fontSize: 11,
                                color: _getRoleColor(account['role']),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        account['phone'] as String,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF999999),
                        ),
                      ),
                    ],
                  ),
                ),
                // 状态开关
                Switch(
                  value: account['status'] == 'active',
                  activeColor: AppTheme.successColor,
                  onChanged: (value) {
                    setState(() {
                      account['status'] = value ? 'active' : 'inactive';
                    });
                  },
                ),
              ],
            ),
            
            const Divider(height: 24),
            
            // 权限标签
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: (account['permissions'] as List<String>).map((perm) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    perm,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF666666),
                    ),
                  ),
                );
              }).toList(),
            ),
            
            const SizedBox(height: 12),
            
            // 底部信息
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '创建于 ${account['createTime']}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFFCCCCCC),
                  ),
                ),
                TextButton(
                  onPressed: () => _showAccountDetail(account),
                  child: const Text(
                    '查看详情',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case '管理员':
        return const Color(0xFFF44336);
      case '普通用户':
        return const Color(0xFF2196F3);
      case '访客':
        return const Color(0xFF9E9E9E);
      default:
        return Colors.grey;
    }
  }

  /// 显示空状态
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline_rounded,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            '暂无子账号',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '点击右上角添加子账号',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade400,
            ),
          ),
        ],
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
        title: const Text('添加子账号'),
        content: const Text('添加子账号功能开发中'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  /// 显示账号详情
  void _showAccountDetail(Map<String, dynamic> account) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text('${account['name']} - 详情'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailItem('角色', account['role']),
              _buildDetailItem('手机号', account['phone']),
              _buildDetailItem('状态', account['status'] == 'active' ? '已激活' : '未激活'),
              _buildDetailItem('创建时间', account['createTime']),
              _buildDetailItem('最后登录', account['lastLogin']),
              const SizedBox(height: 8),
              const Text(
                '权限列表：',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (account['permissions'] as List<String>).map((perm) {
                  return Chip(
                    label: Text(perm, style: const TextStyle(fontSize: 12)),
                    backgroundColor: Colors.grey.shade100,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('编辑功能开发中'),
                  backgroundColor: AppTheme.primaryColor,
                ),
              );
            },
            child: const Text('编辑'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label：',
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF999999),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF333333),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
