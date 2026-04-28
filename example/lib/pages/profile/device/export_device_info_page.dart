import 'package:flutter/material.dart';
import '../../../theme.dart';

/// 导出设备信息页面
class ExportDeviceInfoPage extends StatefulWidget {
  const ExportDeviceInfoPage({Key? key}) : super(key: key);

  @override
  _ExportDeviceInfoPageState createState() => _ExportDeviceInfoPageState();
}

class _ExportDeviceInfoPageState extends State<ExportDeviceInfoPage> {
  String _selectedFormat = 'excel'; // excel, csv, pdf
  bool _includeAllFields = true;
  
  // 模拟设备数据
  final List<Map<String, dynamic>> _devices = [
    {
      'id': 'D001',
      'name': '智能门锁 S300',
      'model': 'S300',
      'room': '主卧',
      'status': '在线',
      'lastUpdate': '2024-01-25 14:30',
    },
    {
      'id': 'D002',
      'name': '网关设备 G100',
      'model': 'G100',
      'room': '客厅',
      'status': '在线',
      'lastUpdate': '2024-01-25 14:28',
    },
    {
      'id': 'D003',
      'name': '门磁传感器 D200',
      'model': 'D200',
      'room': '大门',
      'status': '离线',
      'lastUpdate': '2024-01-24 18:20',
    },
    {
      'id': 'D004',
      'name': '智能猫眼 C100',
      'model': 'C100',
      'room': '大门',
      'status': '在线',
      'lastUpdate': '2024-01-25 14:25',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('导出设备信息'),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.5,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 统计信息
          _buildStatistics(),
          
          const SizedBox(height: 24),
          
          // 导出设置
          _buildSection(
            title: '导出设置',
            child: Column(
              children: [
                // 文件格式选择
                const Text(
                  '文件格式',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF666666),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildFormatOption('Excel', 'excel', Icons.table_chart_rounded, Color(0xFF4CAF50)),
                    _buildFormatOption('CSV', 'csv', Icons.text_snippet_rounded, Color(0xFF2196F3)),
                    _buildFormatOption('PDF', 'pdf', Icons.picture_as_pdf_rounded, Color(0xFFF44336)),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // 字段选项
                SwitchListTile(
                  title: const Text(
                    '包含所有字段',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: const Text(
                    '导出设备的完整信息，包括名称、型号、房间、状态等',
                    style: TextStyle(fontSize: 12),
                  ),
                  value: _includeAllFields,
                  activeColor: AppTheme.primaryColor,
                  onChanged: (value) {
                    setState(() {
                      _includeAllFields = value;
                    });
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // 设备预览
          _buildSection(
            title: '设备预览',
            subtitle: '共 ${_devices.length} 个设备',
            child: Column(
              children: _devices.map((device) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              device['name'] as String,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${device['model']} · ${device['room']}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF999999),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: (device['status'] == '在线' 
                              ? AppTheme.successColor 
                              : Colors.grey).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          device['status'] as String,
                          style: TextStyle(
                            fontSize: 11,
                            color: device['status'] == '在线' 
                                ? AppTheme.successColor 
                                : Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          
          const SizedBox(height: 32),
          
          // 导出按钮
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _exportDevices,
              icon: const Icon(Icons.download_rounded, size: 20),
              label: const Text(
                '导出设备信息',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 提示信息
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded, color: Colors.blue.shade700, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '导出的文件将保存到手机下载目录',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue.shade700,
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

  /// 构建统计信息
  Widget _buildStatistics() {
    final onlineCount = _devices.where((d) => d['status'] == '在线').length;
    final offlineCount = _devices.where((d) => d['status'] == '离线').length;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor,
            AppTheme.primaryColor.withOpacity(0.8),
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
            child: _buildStatItem('总设备', '${_devices.length}', Icons.devices_rounded),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.white.withOpacity(0.3),
          ),
          Expanded(
            child: _buildStatItem('在线', '$onlineCount', Icons.wifi_rounded),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.white.withOpacity(0.3),
          ),
          Expanded(
            child: _buildStatItem('离线', '$offlineCount', Icons.wifi_off_rounded),
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

  /// 构建分组
  Widget _buildSection({
    required String title,
    String? subtitle,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(width: 8),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF999999),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  /// 构建格式选项
  Widget _buildFormatOption(String label, String value, IconData icon, Color color) {
    final isSelected = _selectedFormat == value;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedFormat = value;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? color : const Color(0xFF666666),
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? color : const Color(0xFF666666),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 导出设备信息
  void _exportDevices() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('正在导出'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text('正在生成${_selectedFormat.toUpperCase()}文件...'),
          ],
        ),
      ),
    );

    // 模拟导出过程
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('导出成功！文件已保存到下载目录'),
          backgroundColor: AppTheme.successColor,
          action: SnackBarAction(
            label: '查看',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('打开文件管理器功能开发中'),
                  backgroundColor: AppTheme.primaryColor,
                ),
              );
            },
          ),
        ),
      );
    });
  }
}
