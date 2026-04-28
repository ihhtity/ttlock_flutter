/// 厂商类型枚举
enum VendorType {
  ttlock,    // TTLock 厂商
  bsld,      // BSLD 厂商（待实现）
  other,     // 其他厂商（待实现）
}

/// 厂商信息模型
class VendorInfo {
  final VendorType type;
  final String name;        // 厂商名称
  final String displayName; // 显示名称
  final String logo;        // Logo 路径
  final bool isAvailable;   // 是否可用

  const VendorInfo({
    required this.type,
    required this.name,
    required this.displayName,
    required this.logo,
    this.isAvailable = false,
  });

  /// 获取所有可用厂商列表
  static List<VendorInfo> get availableVendors => [
        const VendorInfo(
          type: VendorType.ttlock,
          name: 'ttlock',
          displayName: 'TTLock',
          logo: 'assets/vendors/ttlock_logo.png',
          isAvailable: true,
        ),
        const VendorInfo(
          type: VendorType.bsld,
          name: 'bsld',
          displayName: '宝士力得',
          logo: 'assets/vendors/bsld_logo.png',
          isAvailable: false, // 待实现
        ),
      ];

  /// 根据类型获取厂商信息
  static VendorInfo? getByType(VendorType type) {
    return availableVendors.firstWhere(
      (vendor) => vendor.type == type,
      orElse: () => throw Exception('Unknown vendor type: $type'),
    );
  }
}
