import 'package:flutter/material.dart';
import '../../../../theme.dart';

/// 订单管理页面
class OrderManagementPage extends StatefulWidget {
  const OrderManagementPage({Key? key}) : super(key: key);

  @override
  _OrderManagementPageState createState() => _OrderManagementPageState();
}

class _OrderManagementPageState extends State<OrderManagementPage> {
  String _selectedFilter = 'all'; // all, pending, completed, cancelled

  // 模拟订单数据
  final List<Map<String, dynamic>> _orders = [
    {
      'id': 'ORD20240101001',
      'title': '智能门锁 S300',
      'amount': 1299.00,
      'status': 'completed',
      'date': '2024-01-15',
      'icon': Icons.lock_rounded,
    },
    {
      'id': 'ORD20240102002',
      'title': '网关设备 G100',
      'amount': 399.00,
      'status': 'pending',
      'date': '2024-01-18',
      'icon': Icons.router_rounded,
    },
    {
      'id': 'ORD20240103003',
      'title': '门磁传感器 D200',
      'amount': 89.00,
      'status': 'completed',
      'date': '2024-01-20',
      'icon': Icons.sensors_rounded,
    },
    {
      'id': 'ORD20240104004',
      'title': '年度云服务套餐',
      'amount': 199.00,
      'status': 'completed',
      'date': '2024-01-22',
      'icon': Icons.cloud_rounded,
    },
    {
      'id': 'ORD20240105005',
      'title': '智能猫眼 C100',
      'amount': 599.00,
      'status': 'cancelled',
      'date': '2024-01-25',
      'icon': Icons.camera_alt_rounded,
    },
  ];

  List<Map<String, dynamic>> get _filteredOrders {
    if (_selectedFilter == 'all') return _orders;
    return _orders.where((order) => order['status'] == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          '订单管理',
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
      ),
      body: Column(
        children: [
          // 筛选标签
          _buildFilterTabs(),
          
          // 订单列表
          Expanded(
            child: _filteredOrders.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredOrders.length,
                    itemBuilder: (context, index) {
                      return _buildOrderCard(_filteredOrders[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  /// 构建筛选标签
  Widget _buildFilterTabs() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterTab('全部', 'all'),
            const SizedBox(width: 10),
            _buildFilterTab('待支付', 'pending'),
            const SizedBox(width: 10),
            _buildFilterTab('已完成', 'completed'),
            const SizedBox(width: 10),
            _buildFilterTab('已取消', 'cancelled'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTab(String label, String value) {
    final isSelected = _selectedFilter == value;
    return InkWell(
      onTap: () => setState(() => _selectedFilter = value),
      borderRadius: BorderRadius.circular(24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 20 : 16,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    AppTheme.primaryColor,
                    AppTheme.primaryColor.withOpacity(0.85),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : const Color(0xFFF5F7FA),
          borderRadius: BorderRadius.circular(24),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF666666),
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }

  /// 构建订单卡片
  Widget _buildOrderCard(Map<String, dynamic> order) {
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
            // 订单头部
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryColor.withOpacity(0.15),
                        AppTheme.primaryColor.withOpacity(0.08),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    order['icon'] as IconData,
                    color: AppTheme.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order['title'] as String,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C3E50),
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '订单号：${order['id']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(order['status'] as String),
              ],
            ),
            
            Container(
              height: 1,
              margin: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.grey.shade300,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            
            // 订单信息
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today_rounded, size: 14, color: Colors.grey.shade500),
                    const SizedBox(width: 6),
                    Text(
                      '购买日期',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                Text(
                  order['date'] as String,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF666666),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.account_balance_wallet_rounded, size: 14, color: Colors.grey.shade500),
                    const SizedBox(width: 6),
                    Text(
                      '订单金额',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                Text(
                  '¥${(order['amount'] as double).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF6B6B),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 构建状态标签
  Widget _buildStatusBadge(String status) {
    String text;
    Color color;
    
    switch (status) {
      case 'completed':
        text = '已完成';
        color = AppTheme.successColor;
        break;
      case 'pending':
        text = '待支付';
        color = const Color(0xFFFF9800);
        break;
      case 'cancelled':
        text = '已取消';
        color = AppTheme.textHint;
        break;
      default:
        text = '未知';
        color = Colors.grey;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// 构建空状态
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_rounded,
            size: 80,
            color: AppTheme.textHint.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            '暂无订单',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.textHint,
            ),
          ),
        ],
      ),
    );
  }
}
