import 'package:flutter/material.dart';
import '../../theme.dart';

/// 厂商账号管理页面
class VendorAccountPage extends StatefulWidget {
  const VendorAccountPage({Key? key}) : super(key: key);

  @override
  _VendorAccountPageState createState() => _VendorAccountPageState();
}

class _VendorAccountPageState extends State<VendorAccountPage> {
  // 当前选中的厂商
  String _selectedVendor = '宝士力得';
  
  // 厂商列表
  final List<String> _vendors = [
    '宝士力得',
    '阔道',
    '通通锁',
    '维来',
    '耀安',
    '凯迪仕',
    '德施曼',
    '小米智能',
    '华为智选',
    '鹿客',
    '萤石',
  ];

  // 模拟厂商账号数据
  final Map<String, List<Map<String, dynamic>>> _vendorAccounts = {
    '宝士力得': [
      {
        'id': 'V001',
        'accountName': '宝士力得主账号',
        'username': 'bsld_admin',
        'status': 'active',
        'deviceCount': 25,
        'roomCount': 8,
        'groupCount': 3,
        'ruleCount': 5,
        'createTime': '2024-01-15',
      },
    ],
    '阔道': [],
    '通通锁': [],
    '维来': [],
    '耀安': [],
    '凯迪仕': [],
    '德施曼': [],
    '小米智能': [],
    '华为智选': [],
    '鹿客': [],
    '萤石': [],
  };

  List<Map<String, dynamic>> get _currentAccounts {
    return _vendorAccounts[_selectedVendor] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          '厂商账号管理',
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
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: const Color(0xFFE5E5E5),
            height: 1,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor,
                  AppTheme.primaryColor.withOpacity(0.85),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
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
          // 厂商选择器
          _buildVendorSelector(),
          
          const SizedBox(height: 12),
          
          // 统计信息
          _buildStatistics(),
          
          const SizedBox(height: 12),
          
          // 账号列表标题
          if (_currentAccounts.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                    '账号列表 (${_currentAccounts.length})',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                ],
              ),
            ),
          
          // 账号列表
          Expanded(
            child: _currentAccounts.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _currentAccounts.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildAccountCard(_currentAccounts[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  /// 构建厂商选择器
  Widget _buildVendorSelector() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryColor,
                      AppTheme.primaryColor.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.business_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '选择厂商',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _vendors.map((vendor) {
              final isSelected = vendor == _selectedVendor;
              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedVendor = vendor;
                  });
                },
                borderRadius: BorderRadius.circular(20),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                            colors: [
                              AppTheme.primaryColor,
                              AppTheme.primaryColor.withOpacity(0.85),
                            ],
                          )
                        : null,
                    color: isSelected ? null : const Color(0xFFF5F7FA),
                    borderRadius: BorderRadius.circular(20),
                    border: isSelected
                        ? null
                        : Border.all(color: const Color(0xFFE0E0E0), width: 1.5),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppTheme.primaryColor.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    vendor,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? Colors.white : const Color(0xFF666666),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// 构建统计信息
  Widget _buildStatistics() {
    final totalDevices = _currentAccounts.fold<int>(
      0,
      (sum, account) => sum + (account['deviceCount'] as int),
    );
    final totalRooms = _currentAccounts.fold<int>(
      0,
      (sum, account) => sum + (account['roomCount'] as int),
    );
    final totalGroups = _currentAccounts.fold<int>(
      0,
      (sum, account) => sum + (account['groupCount'] as int),
    );
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor,
            AppTheme.primaryColor.withOpacity(0.85),
            AppTheme.primaryColor.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem('设备数', totalDevices.toString(), Icons.devices_rounded),
          ),
          Container(
            width: 1,
            height: 50,
            color: Colors.white.withOpacity(0.2),
          ),
          Expanded(
            child: _buildStatItem('房间数', totalRooms.toString(), Icons.meeting_room_rounded),
          ),
          Container(
            width: 1,
            height: 50,
            color: Colors.white.withOpacity(0.2),
          ),
          Expanded(
            child: _buildStatItem('分组数', totalGroups.toString(), Icons.group_work_rounded),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        const SizedBox(height: 10),
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 账号名称和状态
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryColor,
                        AppTheme.primaryColor.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.business_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account['accountName'] as String,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '用户名：${account['username']}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: account['status'] == 'active'
                        ? AppTheme.successColor.withOpacity(0.1)
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    account['status'] == 'active' ? '正常' : '禁用',
                    style: TextStyle(
                      fontSize: 12,
                      color: account['status'] == 'active'
                          ? AppTheme.successColor
                          : Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // 数据统计
            Row(
              children: [
                _buildMiniStat('设备', account['deviceCount'], Icons.devices_rounded),
                const SizedBox(width: 12),
                _buildMiniStat('房间', account['roomCount'], Icons.meeting_room_rounded),
                const SizedBox(width: 12),
                _buildMiniStat('分组', account['groupCount'], Icons.group_work_rounded),
                const SizedBox(width: 12),
                _buildMiniStat('规则', account['ruleCount'], Icons.settings_rounded),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // 操作按钮
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showEditAccountDialog(account),
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
                    onPressed: () => _viewVendorData(account),
                    icon: const Icon(Icons.visibility_rounded, size: 18),
                    label: const Text('查看数据'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      elevation: 0,
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

  Widget _buildMiniStat(String label, int count, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F7FA),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: AppTheme.primaryColor),
            const SizedBox(height: 4),
            Text(
              count.toString(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 查看厂商数据
  void _viewVendorData(Map<String, dynamic> account) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.info_outline_rounded, color: AppTheme.primaryColor),
            const SizedBox(width: 8),
            const Text('厂商数据说明'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '当前厂商：$_selectedVendor',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '选择该厂商账号后，系统将显示：',
              style: TextStyle(fontSize: 13, color: Color(0xFF666666)),
            ),
            const SizedBox(height: 8),
            _buildDataFeature('设备管理', '显示该厂商的所有设备信息'),
            _buildDataFeature('房间管理', '显示该厂商的设备房间分配'),
            _buildDataFeature('分组管理', '显示该厂商的设备分组情况'),
            _buildDataFeature('规则管理', '显示该厂商的自动化规则'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('知道了'),
          ),
        ],
      ),
    );
  }

  Widget _buildDataFeature(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_rounded, size: 16, color: AppTheme.primaryColor),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 显示添加账号对话框
  void _showAddAccountDialog() {
    String selectedVendor = _vendors.first;
    final accountNameController = TextEditingController();
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('添加厂商账号'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 厂商选择
                DropdownButtonFormField<String>(
                  value: selectedVendor,
                  decoration: const InputDecoration(
                    labelText: '选择厂商',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.business_rounded),
                  ),
                  items: _vendors.map((vendor) {
                    return DropdownMenuItem(
                      value: vendor,
                      child: Text(vendor),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedVendor = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                // 账号名称
                TextField(
                  controller: accountNameController,
                  decoration: const InputDecoration(
                    labelText: '账号名称',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.badge_rounded),
                  ),
                ),
                const SizedBox(height: 16),
                // 用户名
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: '用户名',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_rounded),
                  ),
                ),
                const SizedBox(height: 16),
                // 密码
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: '密码',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock_rounded),
                  ),
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
                if (accountNameController.text.isEmpty ||
                    usernameController.text.isEmpty ||
                    passwordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('请填写完整信息'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }

                // 添加新账号
                setState(() {
                  _vendorAccounts[selectedVendor]?.add({
                    'id': 'V${DateTime.now().millisecondsSinceEpoch}',
                    'accountName': accountNameController.text,
                    'username': usernameController.text,
                    'status': 'active',
                    'deviceCount': 0,
                    'roomCount': 0,
                    'groupCount': 0,
                    'ruleCount': 0,
                    'createTime': DateTime.now().toString().split(' ')[0],
                  });
                });

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('账号添加成功'),
                    backgroundColor: AppTheme.successColor,
                  ),
                );
              },
              child: const Text('添加'),
            ),
          ],
        ),
      ),
    );
  }

  /// 显示编辑账号对话框
  void _showEditAccountDialog(Map<String, dynamic> account) {
    final accountNameController = TextEditingController(text: account['accountName']);
    final usernameController = TextEditingController(text: account['username']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('编辑厂商账号'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: accountNameController,
              decoration: const InputDecoration(
                labelText: '账号名称',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.badge_rounded),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: '用户名',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_rounded),
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
              setState(() {
                account['accountName'] = accountNameController.text;
                account['username'] = usernameController.text;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('账号修改成功'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  /// 构建空状态
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.business_rounded,
              size: 64,
              color: AppTheme.primaryColor.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '$_selectedVendor 暂无账号',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '点击右上角按钮添加厂商账号',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _showAddAccountDialog,
            icon: const Icon(Icons.add_rounded),
            label: const Text('添加账号'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
