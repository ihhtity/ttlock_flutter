import 'ivendor_plugin.dart';
import 'vendor_info.dart';
import 'ttlock_plugin.dart';

/// 厂商管理器 - 负责管理和切换不同厂商插件
class VendorManager {
  static final VendorManager _instance = VendorManager._internal();
  
  factory VendorManager() => _instance;
  
  VendorManager._internal();

  // 当前激活的厂商插件
  IVendorPlugin? _currentPlugin;
  
  // 已注册的厂商插件
  final Map<VendorType, IVendorPlugin> _plugins = {};

  /// 获取当前厂商类型
  VendorType? get currentVendorType => _currentPlugin?.vendorType;

  /// 获取当前厂商名称
  String get currentVendorName => _currentPlugin?.vendorName ?? 'Unknown';

  /// 检查是否已初始化
  bool get isInitialized => _currentPlugin != null;

  /// 注册厂商插件
  void registerPlugin(IVendorPlugin plugin) {
    _plugins[plugin.vendorType] = plugin;
    print('[VendorManager] 注册插件: ${plugin.vendorName}');
  }

  /// 切换到指定厂商
  Future<bool> switchVendor(VendorType vendorType) async {
    // 如果已经是当前厂商，直接返回
    if (_currentPlugin?.vendorType == vendorType) {
      print('[VendorManager] 已是当前厂商: $vendorType');
      return true;
    }

    // 释放当前插件资源
    if (_currentPlugin != null) {
      await _currentPlugin!.dispose();
      _currentPlugin = null;
    }

    // 获取新厂商插件
    final plugin = _plugins[vendorType];
    if (plugin == null) {
      print('[VendorManager] 未找到厂商插件: $vendorType');
      return false;
    }

    // 初始化新插件
    final success = await plugin.initialize();
    if (success) {
      _currentPlugin = plugin;
      print('[VendorManager] 切换到厂商: ${plugin.vendorName}');
    } else {
      print('[VendorManager] 厂商初始化失败: ${plugin.vendorName}');
    }

    return success;
  }

  /// 获取当前插件实例
  IVendorPlugin? getCurrentPlugin() {
    return _currentPlugin;
  }

  /// 获取所有已注册的厂商
  List<VendorType> getRegisteredVendors() {
    return _plugins.keys.toList();
  }

  /// 初始化默认厂商（TTLock）
  Future<bool> initializeDefault() async {
    // 注册 TTLock 插件
    if (!_plugins.containsKey(VendorType.ttlock)) {
      registerPlugin(TTLockPlugin());
    }

    // 切换到 TTLock
    return await switchVendor(VendorType.ttlock);
  }

  // ==================== 代理方法 - 转发到当前插件 ====================

  /// 开始扫描设备
  Future<void> startScan({
    Duration timeout = const Duration(seconds: 10),
    Function(ScanResult)? onDeviceFound,
  }) async {
    _checkInitialized();
    await _currentPlugin!.startScan(
      timeout: timeout,
      onDeviceFound: onDeviceFound,
    );
  }

  /// 停止扫描
  Future<void> stopScan() async {
    _checkInitialized();
    await _currentPlugin!.stopScan();
  }

  /// 连接设备
  Future<bool> connectDevice(String macAddress) async {
    _checkInitialized();
    return await _currentPlugin!.connectDevice(macAddress);
  }

  /// 断开连接
  Future<void> disconnectDevice() async {
    _checkInitialized();
    await _currentPlugin!.disconnectDevice();
  }

  /// 检查连接状态
  Future<bool> isConnected() async {
    _checkInitialized();
    return await _currentPlugin!.isConnected();
  }

  /// 初始化锁
  Future<Map<String, dynamic>> initLock(String lockData) async {
    _checkInitialized();
    return await _currentPlugin!.initLock(lockData);
  }

  /// 解锁
  Future<bool> unlock({int? eKeyId}) async {
    _checkInitialized();
    return await _currentPlugin!.unlock(eKeyId: eKeyId);
  }

  /// 上锁
  Future<bool> lock() async {
    _checkInitialized();
    return await _currentPlugin!.lock();
  }

  /// 添加密码
  Future<bool> addPasscode({
    required String passcode,
    required DateTime startDate,
    required DateTime endDate,
    int? cycleType,
  }) async {
    _checkInitialized();
    return await _currentPlugin!.addPasscode(
      passcode: passcode,
      startDate: startDate,
      endDate: endDate,
      cycleType: cycleType,
    );
  }

  /// 删除密码
  Future<bool> deletePasscode(int passcodeId) async {
    _checkInitialized();
    return await _currentPlugin!.deletePasscode(passcodeId);
  }

  /// 修改密码
  Future<bool> modifyPasscode({
    required int passcodeId,
    required String newPasscode,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    _checkInitialized();
    return await _currentPlugin!.modifyPasscode(
      passcodeId: passcodeId,
      newPasscode: newPasscode,
      startDate: startDate,
      endDate: endDate,
    );
  }

  /// 获取开锁记录
  Future<List<Map<String, dynamic>>> getUnlockRecords({
    int page = 1,
    int pageSize = 50,
  }) async {
    _checkInitialized();
    return await _currentPlugin!.getUnlockRecords(
      page: page,
      pageSize: pageSize,
    );
  }

  /// 初始化网关
  Future<Map<String, dynamic>> initGateway(String gatewayData) async {
    _checkInitialized();
    return await _currentPlugin!.initGateway(gatewayData);
  }

  /// 重置网关
  Future<bool> resetGateway() async {
    _checkInitialized();
    return await _currentPlugin!.resetGateway();
  }

  /// 获取网关信息
  Future<Map<String, dynamic>> getGatewayInfo() async {
    _checkInitialized();
    return await _currentPlugin!.getGatewayInfo();
  }

  /// 初始化电源控制器
  Future<Map<String, dynamic>> initPowerController(String powerData) async {
    _checkInitialized();
    return await _currentPlugin!.initPowerController(powerData);
  }

  /// 开电
  Future<bool> powerOn() async {
    _checkInitialized();
    return await _currentPlugin!.powerOn();
  }

  /// 关电
  Future<bool> powerOff() async {
    _checkInitialized();
    return await _currentPlugin!.powerOff();
  }

  /// 查询电源状态
  Future<Map<String, dynamic>> getPowerStatus() async {
    _checkInitialized();
    return await _currentPlugin!.getPowerStatus();
  }

  /// 恢复出厂设置
  Future<bool> factoryReset() async {
    _checkInitialized();
    return await _currentPlugin!.factoryReset();
  }

  /// 获取固件版本
  Future<String> getFirmwareVersion() async {
    _checkInitialized();
    return await _currentPlugin!.getFirmwareVersion();
  }

  /// OTA 升级
  Future<bool> otaUpgrade(String firmwarePath) async {
    _checkInitialized();
    return await _currentPlugin!.otaUpgrade(firmwarePath);
  }

  /// 获取电池电量
  Future<int> getBatteryLevel() async {
    _checkInitialized();
    return await _currentPlugin!.getBatteryLevel();
  }

  /// 检查是否已初始化
  void _checkInitialized() {
    if (_currentPlugin == null) {
      throw Exception('厂商插件未初始化，请先调用 initializeDefault() 或 switchVendor()');
    }
  }

  /// 释放所有资源
  Future<void> dispose() async {
    for (final plugin in _plugins.values) {
      await plugin.dispose();
    }
    _plugins.clear();
    _currentPlugin = null;
    print('[VendorManager] 所有资源已释放');
  }
}
