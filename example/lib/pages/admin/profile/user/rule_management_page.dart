import 'package:flutter/material.dart';
import '../../../../theme.dart';

/// 规则管理页面
class RuleManagementPage extends StatefulWidget {
  const RuleManagementPage({Key? key}) : super(key: key);

  @override
  _RuleManagementPageState createState() => _RuleManagementPageState();
}

class _RuleManagementPageState extends State<RuleManagementPage> {
  // 模拟规则数据
  final List<Map<String, dynamic>> _rules = [
    {
      'id': 'R001',
      'name': '回家自动开灯',
      'description': '当门锁被打开时，自动开启客厅灯光',
      'trigger': '门锁开锁',
      'action': '开启灯光',
      'status': 'active',
      'icon': Icons.lightbulb_rounded,
      'color': Color(0xFFFF9800),
    },
    {
      'id': 'R002',
      'name': '离家布防模式',
      'description': '当所有人员离开后，自动启动安防系统',
      'trigger': '所有人离家',
      'action': '启动安防',
      'status': 'active',
      'icon': Icons.security_rounded,
      'color': Color(0xFF4CAF50),
    },
    {
      'id': 'R003',
      'name': '夜间自动锁门',
      'description': '每晚23:00自动检查门锁状态并上锁',
      'trigger': '定时任务',
      'action': '门锁上锁',
      'status': 'inactive',
      'icon': Icons.lock_clock_rounded,
      'color': Color(0xFF2196F3),
    },
    {
      'id': 'R004',
      'name': '异常报警通知',
      'description': '检测到异常开锁时发送通知到手机',
      'trigger': '异常检测',
      'action': '发送通知',
      'status': 'active',
      'icon': Icons.notifications_active_rounded,
      'color': Color(0xFFF44336),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('规则管理'),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: _showAddRuleDialog,
            tooltip: '添加规则',
          ),
        ],
      ),
      body: Column(
        children: [
          // 提示信息
          _buildTipCard(),
          
          // 规则列表
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _rules.length,
              itemBuilder: (context, index) {
                return _buildRuleCard(_rules[index]);
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF9C27B0).withOpacity(0.1),
            const Color(0xFF9C27B0).withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF9C27B0).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.auto_awesome_rounded,
            color: Color(0xFF9C27B0),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '创建自动化规则，让设备智能联动，提升生活便利性',
              style: TextStyle(
                fontSize: 13,
                color: const Color(0xFF9C27B0).withOpacity(0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建规则卡片
  Widget _buildRuleCard(Map<String, dynamic> rule) {
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
            // 头部
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: (rule['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    rule['icon'] as IconData,
                    color: rule['color'] as Color,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rule['name'] as String,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        rule['description'] as String,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF999999),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // 状态开关
                Switch(
                  value: rule['status'] == 'active',
                  activeColor: AppTheme.successColor,
                  onChanged: (value) {
                    setState(() {
                      rule['status'] = value ? 'active' : 'inactive';
                    });
                  },
                ),
              ],
            ),
            
            const Divider(height: 24),
            
            // 触发条件和执行动作
            Row(
              children: [
                Expanded(
                  child: _buildConditionItem(
                    '触发条件',
                    rule['trigger'] as String,
                    Icons.auto_awesome_rounded,
                    const Color(0xFF2196F3),
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(
                  Icons.arrow_forward_rounded,
                  color: Color(0xFFCCCCCC),
                  size: 24,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildConditionItem(
                    '执行动作',
                    rule['action'] as String,
                    Icons.play_circle_rounded,
                    const Color(0xFF4CAF50),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // 操作按钮
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _showEditRuleDialog(rule);
                    },
                    icon: const Icon(Icons.edit_rounded, size: 18),
                    label: const Text('编辑'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                      side: const BorderSide(color: AppTheme.primaryColor),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _showRuleDetailDialog(rule);
                    },
                    icon: const Icon(Icons.visibility_rounded, size: 18),
                    label: const Text('详情'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: rule['color'] as Color,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConditionItem(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333),
            ),
          ),
        ],
      ),
    );
  }

  /// 显示添加规则对话框
  void _showAddRuleDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('添加自动化规则'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: '规则名称',
                  hintText: '请输入规则名称',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.rule_rounded),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: '触发条件',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: [
                  '门锁开锁',
                  '门锁关锁',
                  '定时任务',
                  '异常检测',
                  '所有人离家',
                ].map((trigger) {
                  return DropdownMenuItem(value: trigger, child: Text(trigger));
                }).toList(),
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: '执行动作',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: [
                  '开启灯光',
                  '关闭灯光',
                  '门锁上锁',
                  '门锁开锁',
                  '启动安防',
                  '发送通知',
                ].map((action) {
                  return DropdownMenuItem(value: action, child: Text(action));
                }).toList(),
                onChanged: (value) {},
              ),
            ],
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
                  content: Text('规则创建成功'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            child: const Text('创建'),
          ),
        ],
      ),
    );
  }

  /// 显示编辑规则对话框
  void _showEditRuleDialog(Map<String, dynamic> rule) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('编辑功能开发中'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  /// 显示规则详情对话框
  void _showRuleDetailDialog(Map<String, dynamic> rule) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(rule['name'] as String),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                rule['description'] as String,
                style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
              ),
              const SizedBox(height: 16),
              _buildDetailItem('触发条件', rule['trigger']),
              _buildDetailItem('执行动作', rule['action']),
              _buildDetailItem(
                '状态',
                rule['status'] == 'active' ? '已启用' : '已禁用',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
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
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
