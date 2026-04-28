import 'package:flutter/material.dart';
import '../../../theme.dart';

/// 家庭成员管理页面
class FamilyMembersPage extends StatefulWidget {
  const FamilyMembersPage({Key? key}) : super(key: key);

  @override
  _FamilyMembersPageState createState() => _FamilyMembersPageState();
}

class _FamilyMembersPageState extends State<FamilyMembersPage> {
  // 模拟家庭成员数据
  final List<Map<String, dynamic>> _members = [
    {
      'id': 'F001',
      'name': '我',
      'relation': '户主',
      'phone': '138****1234',
      'avatar': null,
      'isOwner': true,
      'devices': ['智能门锁 S300', '网关 G100'],
      'joinTime': '2024-01-01',
    },
    {
      'id': 'F002',
      'name': '妻子',
      'relation': '配偶',
      'phone': '139****5678',
      'avatar': null,
      'isOwner': false,
      'devices': ['智能门锁 S300'],
      'joinTime': '2024-01-05',
    },
    {
      'id': 'F003',
      'name': '父亲',
      'relation': '父母',
      'phone': '137****9012',
      'avatar': null,
      'isOwner': false,
      'devices': ['智能门锁 S300'],
      'joinTime': '2024-01-10',
    },
    {
      'id': 'F004',
      'name': '母亲',
      'relation': '父母',
      'phone': '136****3456',
      'avatar': null,
      'isOwner': false,
      'devices': ['智能门锁 S300'],
      'joinTime': '2024-01-10',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('家庭成员'),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_rounded),
            onPressed: _showAddMemberDialog,
            tooltip: '添加成员',
          ),
        ],
      ),
      body: Column(
        children: [
          // 家庭信息卡片
          _buildFamilyInfoCard(),
          
          // 成员列表
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _members.length,
              itemBuilder: (context, index) {
                return _buildMemberCard(_members[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 构建家庭信息卡片
  Widget _buildFamilyInfoCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF66BB6A),
            const Color(0xFF4CAF50),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4CAF50).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.family_restroom_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '我的家庭',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_members.length} 位成员',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '家庭成员可以共享设备，方便家人一起使用',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.95),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建成员卡片
  Widget _buildMemberCard(Map<String, dynamic> member) {
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
        child: Row(
          children: [
            // 头像
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: member['isOwner'] as bool
                      ? const Color(0xFF66BB6A).withOpacity(0.2)
                      : Colors.grey.shade200,
                  child: member['avatar'] != null
                      ? ClipOval(
                          child: Image.network(
                            member['avatar'],
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Text(
                          (member['name'] as String).substring(0, 1),
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: member['isOwner'] as bool
                                ? const Color(0xFF66BB6A)
                                : Colors.grey.shade600,
                          ),
                        ),
                ),
                if (member['isOwner'] as bool)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Color(0xFF66BB6A),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.verified_rounded,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            
            const SizedBox(width: 16),
            
            // 成员信息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        member['name'] as String,
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
                          color: const Color(0xFF66BB6A).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          member['relation'] as String,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF66BB6A),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    member['phone'] as String,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF999999),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '可访问：${(member['devices'] as List<String>).join('、')}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ),
            
            // 操作菜单
            if (!(member['isOwner'] as bool))
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert_rounded),
                onSelected: (value) {
                  if (value == 'edit') {
                    _showEditMemberDialog(member);
                  } else if (value == 'remove') {
                    _showRemoveConfirmDialog(member);
                  }
                },
                itemBuilder: (context) => [
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
                    value: 'remove',
                    child: Row(
                      children: [
                        Icon(Icons.person_remove_rounded, size: 20, color: Colors.red),
                        SizedBox(width: 8),
                        Text('移除', style: TextStyle(color: Colors.red)),
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

  /// 显示添加成员对话框
  void _showAddMemberDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('添加家庭成员'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '请输入家庭成员的手机号',
              style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: '请输入手机号',
                prefixIcon: const Icon(Icons.phone_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: '选择关系',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: ['配偶', '父母', '子女', '其他'].map((relation) {
                return DropdownMenuItem(
                  value: relation,
                  child: Text(relation),
                );
              }).toList(),
              onChanged: (value) {},
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
                  content: Text('邀请已发送'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            child: const Text('发送邀请'),
          ),
        ],
      ),
    );
  }

  /// 显示编辑成员对话框
  void _showEditMemberDialog(Map<String, dynamic> member) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('编辑功能开发中'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  /// 显示移除确认对话框
  void _showRemoveConfirmDialog(Map<String, dynamic> member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('确认移除'),
        content: Text('确定要将「${member['name']}」从家庭中移除吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _members.removeWhere((m) => m['id'] == member['id']);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('已移除${member['name']}'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('确认移除'),
          ),
        ],
      ),
    );
  }
}
