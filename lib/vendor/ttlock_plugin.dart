import 'dart:async';
import '../ttlock/ttlock.dart' as TTLockSDK;
import '../ttlock/ttgateway.dart';
import '../ttlock/ttelectricMeter.dart';
import 'ivendor_plugin.dart';
import 'vendor_info.dart';

/// TTLock 厂商插件实现
class TTLockPlugin implements IVendorPlugin {
  static final TTLockPlugin _instance = TTLockPlugin._internal();
  
  factory TTLockPlugin() => _instance;
  
  TTLockPlugin._internal();

  bool _isInitialized = false;
  String? _currentLockData; // 当前操作的锁数据

  @override
  VendorType get vendorType => VendorType.ttlock;

  @override
  String get vendorName => 'TTLock';

  @override
  Future<bool> initialize() async {
    if (_isInitialized) return true;
    
    try {
      // TTLock SDK 不需要显式初始化，直接使用即可
      _isInitialized = true;
      print('[TTLockPlugin] 初始化成功');
      return true;
    } catch (e) {
      print('[TTLockPlugin] 初始化失败: $e');
      return false;
    }
  }

  @override
  Future<void> dispose() async {
    // 释放 TTLock 资源
    _isInitialized = false;
    _currentLockData = null;
    print('[TTLockPlugin] 资源已释放');
  }

  // ==================== 蓝牙扫描相关 ====================

  @override
  Future<void> startScan({
    Duration timeout = const Duration(seconds: 10),
    Function(ScanResult)? onDeviceFound,
  }) async {
    try {
      // 使用 TTLock 原生扫描
      TTLockSDK.TTLock.startScanLock((TTLockSDK.TTLockScanModel scanModel) {
        // 转换为统一格式
        final result = ScanResult(
          deviceName: scanModel.lockName,
          macAddress: scanModel.lockMac,
          rssi: scanModel.rssi,
          deviceType: DeviceType.lock,
          extraData: {
            'lockVersion': scanModel.lockVersion,
            'isInited': scanModel.isInited,
          },
        );
        
        if (onDeviceFound != null) {
          onDeviceFound(result);
        }
      });
      
      print('[TTLockPlugin] 开始扫描设备');
    } catch (e) {
      print('[TTLockPlugin] 扫描失败: $e');
      rethrow;
    }
  }

  @override
  Future<void> stopScan() async {
    try {
      TTLockSDK.TTLock.stopScanLock();
      print('[TTLockPlugin] 停止扫描');
    } catch (e) {
      print('[TTLockPlugin] 停止扫描失败: $e');
    }
  }

  // ==================== 设备连接相关 ====================

  @override
  Future<bool> connectDevice(String macAddress) async {
    try {
      // TTLock 通过 lockData 进行连接，不需要单独的连接步骤
      print('[TTLockPlugin] 设备连接准备: $macAddress');
      return true;
    } catch (e) {
      print('[TTLockPlugin] 连接失败: $e');
      return false;
    }
  }

  @override
  Future<void> disconnectDevice() async {
    try {
      print('[TTLockPlugin] 断开连接');
    } catch (e) {
      print('[TTLockPlugin] 断开连接失败: $e');
    }
  }

  @override
  Future<bool> isConnected() async {
    // TTLock 基于蓝牙，连接状态由底层管理
    return _isInitialized;
  }

  // ==================== 智能锁操作 ====================

  /// 设置当前操作的锁数据
  void setCurrentLockData(String lockData) {
    _currentLockData = lockData;
  }

  @override
  Future<Map<String, dynamic>> initLock(String lockData) async {
    final completer = Completer<Map<String, dynamic>>();
    try {
      // 解析 lockData (JSON 字符串)
      // lockData 格式: {"lockMac": "xx:xx:xx:xx:xx:xx", "lockVersion": "x.x", "isInited": true}
      TTLockSDK.TTLock.initLock(
        {}, // 这里应该传入从服务器获取的锁数据
        (String data) {
          print('[TTLockPlugin] 初始化锁成功');
          _currentLockData = data; // 保存锁数据供后续操作使用
          completer.complete({'success': true, 'lockData': data});
        },
        (TTLockSDK.TTLockError errorCode, String errorDesc) {
          print('[TTLockPlugin] 初始化锁失败: $errorDesc');
          completer.completeError(Exception('初始化失败: $errorDesc'));
        },
      );
      
      return await completer.future;
    } catch (e) {
      print('[TTLockPlugin] 初始化锁异常: $e');
      rethrow;
    }
  }

  @override
  Future<bool> unlock({int? eKeyId}) async {
    if (_currentLockData == null) {
      print('[TTLockPlugin] 错误: 未设置锁数据');
      return false;
    }

    final completer = Completer<bool>();
    try {
      TTLockSDK.TTLock.controlLock(
        _currentLockData!,
        TTLockSDK.TTControlAction.unlock,
        (int lockTime, int electricQuantity, int uniqueId, String lockData) {
          print('[TTLockPlugin] 解锁成功');
          _currentLockData = lockData; // 更新锁数据
          completer.complete(true);
        },
        (TTLockSDK.TTLockError errorCode, String errorDesc) {
          print('[TTLockPlugin] 解锁失败: $errorDesc');
          completer.complete(false);
        },
      );
      
      return await completer.future;
    } catch (e) {
      print('[TTLockPlugin] 解锁异常: $e');
      return false;
    }
  }

  @override
  Future<bool> lock() async {
    if (_currentLockData == null) {
      print('[TTLockPlugin] 错误: 未设置锁数据');
      return false;
    }

    final completer = Completer<bool>();
    try {
      TTLockSDK.TTLock.controlLock(
        _currentLockData!,
        TTLockSDK.TTControlAction.lock,
        (int lockTime, int electricQuantity, int uniqueId, String lockData) {
          print('[TTLockPlugin] 上锁成功');
          _currentLockData = lockData; // 更新锁数据
          completer.complete(true);
        },
        (TTLockSDK.TTLockError errorCode, String errorDesc) {
          print('[TTLockPlugin] 上锁失败: $errorDesc');
          completer.complete(false);
        },
      );
      
      return await completer.future;
    } catch (e) {
      print('[TTLockPlugin] 上锁异常: $e');
      return false;
    }
  }

  @override
  Future<bool> addPasscode({
    required String passcode,
    required DateTime startDate,
    required DateTime endDate,
    int? cycleType,
  }) async {
    if (_currentLockData == null) {
      print('[TTLockPlugin] 错误: 未设置锁数据');
      return false;
    }

    final completer = Completer<bool>();
    try {
      TTLockSDK.TTLock.createCustomPasscode(
        passcode,
        startDate.millisecondsSinceEpoch,
        endDate.millisecondsSinceEpoch,
        _currentLockData!,
        () {
          print('[TTLockPlugin] 添加密码成功');
          completer.complete(true);
        },
        (TTLockSDK.TTLockError errorCode, String errorDesc) {
          print('[TTLockPlugin] 添加密码失败: $errorDesc');
          completer.complete(false);
        },
      );
      
      return await completer.future;
    } catch (e) {
      print('[TTLockPlugin] 添加密码异常: $e');
      return false;
    }
  }

  @override
  Future<bool> deletePasscode(int passcodeId) async {
    if (_currentLockData == null) {
      print('[TTLockPlugin] 错误: 未设置锁数据');
      return false;
    }

    final completer = Completer<bool>();
    try {
      // 注意: deletePasscode 需要传入密码字符串，不是 ID
      // 这里假设 passcodeId 实际上是密码字符串
      TTLockSDK.TTLock.deletePasscode(
        passcodeId.toString(),
        _currentLockData!,
        () {
          print('[TTLockPlugin] 删除密码成功');
          completer.complete(true);
        },
        (TTLockSDK.TTLockError errorCode, String errorDesc) {
          print('[TTLockPlugin] 删除密码失败: $errorDesc');
          completer.complete(false);
        },
      );
      
      return await completer.future;
    } catch (e) {
      print('[TTLockPlugin] 删除密码异常: $e');
      return false;
    }
  }

  @override
  Future<bool> modifyPasscode({
    required int passcodeId,
    required String newPasscode,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    if (_currentLockData == null) {
      print('[TTLockPlugin] 错误: 未设置锁数据');
      return false;
    }

    final completer = Completer<bool>();
    try {
      // 注意: modifyPasscode 需要原始密码字符串
      TTLockSDK.TTLock.modifyPasscode(
        passcodeId.toString(), // 原始密码
        newPasscode,
        startDate.millisecondsSinceEpoch,
        endDate.millisecondsSinceEpoch,
        _currentLockData!,
        () {
          print('[TTLockPlugin] 修改密码成功');
          completer.complete(true);
        },
        (TTLockSDK.TTLockError errorCode, String errorDesc) {
          print('[TTLockPlugin] 修改密码失败: $errorDesc');
          completer.complete(false);
        },
      );
      
      return await completer.future;
    } catch (e) {
      print('[TTLockPlugin] 修改密码异常: $e');
      return false;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getUnlockRecords({
    int page = 1,
    int pageSize = 50,
  }) async {
    if (_currentLockData == null) {
      print('[TTLockPlugin] 错误: 未设置锁数据');
      return [];
    }

    final completer = Completer<List<Map<String, dynamic>>>();
    try {
      // TODO: TTLock API 中获取开锁记录的具体方法需要确认
      print('[TTLockPlugin] 获取开锁记录 (page: $page, pageSize: $pageSize)');
      completer.complete([]);
      return await completer.future;
    } catch (e) {
      print('[TTLockPlugin] 获取开锁记录失败: $e');
      return [];
    }
  }

  // ==================== 网关操作 ====================
  
  @override
  Future<Map<String, dynamic>> initGateway(String gatewayData) async {
    final completer = Completer<Map<String, dynamic>>();
    try {
      // gatewayData 应该是包含网关信息的 Map
      final Map<String, dynamic> gatewayMap = {};
      // TODO: 根据实际数据格式解析 gatewayData
      
      TTGateway.init(
        gatewayMap,
        (Map map) {
          print('[TTLockPlugin] 初始化网关成功');
          completer.complete({'success': true, 'data': map});
        },
        (TTLockSDK.TTGatewayError errorCode, String errorDesc) {
          print('[TTLockPlugin] 初始化网关失败: $errorDesc');
          completer.completeError(Exception('初始化网关失败: $errorDesc'));
        },
      );
      
      return await completer.future;
    } catch (e) {
      print('[TTLockPlugin] 初始化网关异常: $e');
      rethrow;
    }
  }
  
  @override
  Future<bool> resetGateway() async {
    try {
      // TODO: 实现重置网关逻辑
      print('[TTLockPlugin] 重置网关');
      return true;
    } catch (e) {
      print('[TTLockPlugin] 重置网关失败: $e');
      return false;
    }
  }
  
  @override
  Future<Map<String, dynamic>> getGatewayInfo() async {
    try {
      // TODO: 实现获取网关信息
      print('[TTLockPlugin] 获取网关信息');
      return {};
    } catch (e) {
      print('[TTLockPlugin] 获取网关信息失败: $e');
      rethrow;
    }
  }
  
  // ==================== 电源控制器操作 ====================
  
  @override
  Future<Map<String, dynamic>> initPowerController(String powerData) async {
    final completer = Completer<Map<String, dynamic>>();
    try {
      // 使用 TTElectricMeter 初始化
      final Map<String, dynamic> powerMap = {};
      // TODO: 解析 powerData
      
      TTElectricMeter.init(
        powerMap,
        () {
          print('[TTLockPlugin] 初始化电源控制器成功');
          completer.complete({'success': true});
        },
        (TTLockSDK.TTMeterErrorCode errorCode, String errorDesc) {
          print('[TTLockPlugin] 初始化电源控制器失败: $errorDesc');
          completer.completeError(Exception('初始化失败: $errorDesc'));
        },
      );
      
      return await completer.future;
    } catch (e) {
      print('[TTLockPlugin] 初始化电源控制器异常: $e');
      rethrow;
    }
  }
  
  @override
  Future<bool> powerOn() async {
    try {
      // TODO: 需要传入 mac 地址
      print('[TTLockPlugin] 开电');
      return true;
    } catch (e) {
      print('[TTLockPlugin] 开电失败: $e');
      return false;
    }
  }
  
  @override
  Future<bool> powerOff() async {
    try {
      // TODO: 需要传入 mac 地址
      print('[TTLockPlugin] 关电');
      return true;
    } catch (e) {
      print('[TTLockPlugin] 关电失败: $e');
      return false;
    }
  }
  
  @override
  Future<Map<String, dynamic>> getPowerStatus() async {
    try {
      // TODO: 查询电源状态
      print('[TTLockPlugin] 查询电源状态');
      return {};
    } catch (e) {
      print('[TTLockPlugin] 查询电源状态失败: $e');
      rethrow;
    }
  }

  // ==================== 其他通用操作 ====================

  @override
  Future<bool> factoryReset() async {
    if (_currentLockData == null) {
      print('[TTLockPlugin] 错误: 未设置锁数据');
      return false;
    }

    final completer = Completer<bool>();
    try {
      TTLockSDK.TTLock.resetLock(
        _currentLockData!,
        () {
          print('[TTLockPlugin] 恢复出厂设置成功');
          completer.complete(true);
        },
        (TTLockSDK.TTLockError errorCode, String errorDesc) {
          print('[TTLockPlugin] 恢复出厂设置失败: $errorDesc');
          completer.complete(false);
        },
      );
      
      return await completer.future;
    } catch (e) {
      print('[TTLockPlugin] 恢复出厂设置异常: $e');
      return false;
    }
  }

  @override
  Future<String> getFirmwareVersion() async {
    if (_currentLockData == null) {
      print('[TTLockPlugin] 错误: 未设置锁数据');
      return '';
    }

    final completer = Completer<String>();
    try {
      TTLockSDK.TTLock.getLockVersion(
        _currentLockData!,
        (String version) {
          print('[TTLockPlugin] 获取固件版本: $version');
          completer.complete(version);
        },
        (TTLockSDK.TTLockError errorCode, String errorDesc) {
          print('[TTLockPlugin] 获取固件版本失败: $errorDesc');
          completer.complete('');
        },
      );
      
      return await completer.future;
    } catch (e) {
      print('[TTLockPlugin] 获取固件版本异常: $e');
      return '';
    }
  }

  @override
  Future<bool> otaUpgrade(String firmwarePath) async {
    try {
      // TODO: 实现 OTA 升级逻辑
      print('[TTLockPlugin] OTA 升级: $firmwarePath');
      return true;
    } catch (e) {
      print('[TTLockPlugin] OTA 升级失败: $e');
      return false;
    }
  }

  @override
  Future<int> getBatteryLevel() async {
    if (_currentLockData == null) {
      print('[TTLockPlugin] 错误: 未设置锁数据');
      return 0;
    }

    final completer = Completer<int>();
    try {
      TTLockSDK.TTLock.getLockPower(
        _currentLockData!,
        (int power) {
          print('[TTLockPlugin] 电池电量: $power%');
          completer.complete(power);
        },
        (TTLockSDK.TTLockError errorCode, String errorDesc) {
          print('[TTLockPlugin] 获取电池电量失败: $errorDesc');
          completer.complete(0);
        },
      );
      
      return await completer.future;
    } catch (e) {
      print('[TTLockPlugin] 获取电池电量异常: $e');
      return 0;
    }
  }
}
