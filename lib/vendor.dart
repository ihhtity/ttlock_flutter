/// 厂商插件系统 - 统一导出
/// 
/// 使用示例：
/// ```dart
/// import 'package:ttlock_flutter/vendor.dart';
/// 
/// // 初始化默认厂商（TTLock）
/// await VendorManager().initializeDefault();
/// 
/// // 扫描设备
/// await VendorManager().startScan(
///   timeout: Duration(seconds: 10),
///   onDeviceFound: (device) {
///     print('发现设备: ${device.deviceName}');
///   },
/// );
/// 
/// // 切换到 BSLD 厂商（当实现后）
/// await VendorManager().switchVendor(VendorType.bsld);
/// ```

library vendor;

// 核心接口和模型
export 'vendor/ivendor_plugin.dart';
export 'vendor/vendor_info.dart';
export 'vendor/vendor_manager.dart';

// 厂商插件实现
export 'vendor/ttlock_plugin.dart';
export 'vendor/bsld_plugin.dart';
