import 'ttlock.dart';

/// TTLock 门磁传感器管理类
/// 
/// 提供门磁传感器的扫描和初始化功能。
/// 门磁传感器用于检测门的开关状态，可以与智能锁配合使用实现更多安全功能。
/// 
/// 主要功能：
/// - 扫描附近的门磁传感器
/// - 初始化并绑定到智能锁
class TTDoorSensor {
  static const String COMMAND_START_SCAN_DOOR_SENSOR = "doorSensorStartScan";
  static const String COMMAND_STOP_SCAN_DOOR_SENSOR = "doorSensorStopScan";
  static const String COMMAND_INIT_DOOR_SENSOR = "doorSensorInit";

  static void startScan(TTRemoteAccessoryScanCallback scanCallback) {
    TTLock.invoke(COMMAND_START_SCAN_DOOR_SENSOR, null, scanCallback);
  }

  static void stopScan() {
    TTLock.invoke(COMMAND_STOP_SCAN_DOOR_SENSOR, null, null);
  }

  static void init(
    String mac,
    String lockData,
    TTGetLockSystemCallback callback,
    TTRemoteFailedCallback failedCallback,
  ) {
    Map map = Map();
    map[TTResponse.mac] = mac;
    map[TTResponse.lockData] = lockData;
    TTLock.invoke(COMMAND_INIT_DOOR_SENSOR, map, callback,
        fail_callback: failedCallback);
  }
}
