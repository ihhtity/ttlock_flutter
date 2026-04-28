import 'package:flutter/material.dart';
import '../../../theme.dart';

/// 我的消费页面
class MyConsumptionPage extends StatefulWidget {
  const MyConsumptionPage({Key? key}) : super(key: key);

  @override
  _MyConsumptionPageState createState() => _MyConsumptionPageState();
}

class _MyConsumptionPageState extends State<MyConsumptionPage> {
  String _selectedPeriod = 'month'; // month, quarter, year
  
  // 模拟消费记录数据
  final List<Map<String, dynamic>> _records = [
    {
      'id': 'C001',
      'title': '智能门锁 S300',
      'category': '设备购买',
      'amount': -1299.00,
      'date': '2024-01-15',
      'icon': Icons.lock_rounded,
    },
    {
      'id': 'C002',
      'title': '年度云服务套餐',
      'category': '服务订阅',
      'amount': -199.00,
      'date': '2024-01-20',
      'icon': Icons.cloud_rounded,
    },
    {
      'id': 'C003',
      'title': '网关设备 G100',
      'category': '设备购买',
      'amount': -399.00,
      'date': '2024-01-22',
      'icon': Icons.router_rounded,
    },
    {
      'id': 'C004',
      'title': '门磁传感器 D200 x2',
      'category': '配件购买',
      'amount': -178.00,
      'date': '2024-01-25',
      'icon': Icons.sensors_rounded,
    },
  ];

  double get _totalConsumption {
    return _records.fold(0, (sum, item) => sum + (item['amount'] as double).abs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('我的消费'),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.5,
      ),
      body: Column(
        children: [
          // 统计卡片
          _buildStatisticsCard(),
          
          // 时间筛选
          _buildPeriodFilter(),
          
          // 消费记录列表
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _records.length,
              itemBuilder: (context, index) {
                return _buildRecordCard(_records[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 构建统计卡片
  Widget _buildStatisticsCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFF9800),
            const Color(0xFFFFB74D),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF9800).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            '本月消费总额',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '¥${_totalConsumption.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '共 ${_records.length} 笔交易',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建时间筛选
  Widget _buildPeriodFilter() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
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
      child: Row(
        children: [
          _buildPeriodTab('本月', 'month'),
          _buildPeriodTab('本季度', 'quarter'),
          _buildPeriodTab('本年', 'year'),
        ],
      ),
    );
  }

  Widget _buildPeriodTab(String label, String value) {
    final isSelected = _selectedPeriod == value;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedPeriod = value),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFF9800) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? Colors.white : const Color(0xFF666666),
            ),
          ),
        ),
      ),
    );
  }

  /// 构建消费记录卡片
  Widget _buildRecordCard(Map<String, dynamic> record) {
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
            // 图标
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFFF9800).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                record['icon'] as IconData,
                color: const Color(0xFFFF9800),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            
            // 信息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record['title'] as String,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        record['category'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF999999),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '•',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        record['date'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF999999),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // 金额
            Text(
              '¥${(record['amount'] as double).abs().toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF5722),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
