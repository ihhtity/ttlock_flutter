import 'dart:async';
import 'vendor_info.dart';

/// 设备类型枚举
enum DeviceType {
  lock,      // 智能锁
  gateway,   // 网关
  keypad,    // 键盘
  remote,    // 遥控器
  sensor,    // 传感器
  power,     // 电源控制器
  meter,     // 电表/水表
}

/// 蓝牙扫描结果
class ScanResult {
  final String deviceName;
  final String macAddress;
  final int rssi;
  final DeviceType deviceType;
  final Map<String, dynamic>? extraData;

  const ScanResult({
    required this.deviceName,
    required this.macAddress,
    required this.rssi,
    required this.deviceType,
    this.extraData,
  });
}

/// 设备操作抽象接口 - 所有厂商插件必须实现此接口
abstract class IVendorPlugin {
  /// 获取厂商类型
  VendorType get vendorType;

  /// 获取厂商名称
  String get vendorName;

  /// 初始化插件
  Future<bool> initialize();

  /// 释放资源
  Future<void> dispose();

  // ==================== 蓝牙扫描相关 ====================

  /// 开始扫描设备
  Future<void> startScan({
    Duration timeout = const Duration(seconds: 10),
    Function(ScanResult)? onDeviceFound,
  });

  /// 停止扫描
  Future<void> stopScan();

  // ==================== 设备连接相关 ====================

  /// 连接设备
  Future<bool> connectDevice(String macAddress);

  /// 断开连接
  Future<void> disconnectDevice();

  /// 检查连接状态
  Future<bool> isConnected();

  // ==================== 智能锁操作 ====================

  /// 初始化锁
  Future<Map<String, dynamic>> initLock(String lockData);

  /// 解锁
  Future<bool> unlock({int? eKeyId});

  /// 上锁
  Future<bool> lock();

  /// 添加密码
  Future<bool> addPasscode({
    required String passcode,
    required DateTime startDate,
    required DateTime endDate,
    int? cycleType,
  });

  /// 删除密码
  Future<bool> deletePasscode(int passcodeId);

  /// 修改密码
  Future<bool> modifyPasscode({
    required int passcodeId,
    required String newPasscode,
    required DateTime startDate,
    required DateTime endDate,
  });

  /// 获取开锁记录
  Future<List<Map<String, dynamic>>> getUnlockRecords({
    int page = 1,
    int pageSize = 50,
  });

  // ==================== 网关操作 ====================

  /// 初始化网关
  Future<Map<String, dynamic>> initGateway(String gatewayData);

  /// 重置网关
  Future<bool> resetGateway();

  /// 获取网关信息
  Future<Map<String, dynamic>> getGatewayInfo();

  // ==================== 电源控制器操作 ====================

  /// 初始化电源控制器
  Future<Map<String, dynamic>> initPowerController(String powerData);

  /// 开电
  Future<bool> powerOn();

  /// 关电
  Future<bool> powerOff();

  /// 查询电源状态
  Future<Map<String, dynamic>> getPowerStatus();

  // ==================== 其他通用操作 ====================

  /// 恢复出厂设置
  Future<bool> factoryReset();

  /// 获取固件版本
  Future<String> getFirmwareVersion();

  /// OTA 升级
  Future<bool> otaUpgrade(String firmwarePath);

  /// 获取电池电量
  Future<int> getBatteryLevel();
}
