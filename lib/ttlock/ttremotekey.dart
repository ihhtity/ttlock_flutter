import 'ttlock.dart';

/// TTLock 远程钥匙（遥控器）管理类
/// 
/// 提供蓝牙遥控器的扫描和初始化功能。
/// 遥控器可以作为智能锁的备用开锁方式，方便用户远程控制。
/// 
/// 主要功能：
/// - 扫描附近的遥控器
/// - 初始化并绑定到智能锁
class TTRemoteKey {
  static const String COMMAND_START_SCAN_REMOTE_KEY = "startScanRemoteKey";
  static const String COMMAND_STOP_SCAN_REMOTE_KEY = "stopScanRemoteKey";
  static const String COMMAND_INIT_REMOTE_KEY = "initRemoteKey";

  static void startScan(TTRemoteAccessoryScanCallback scanCallback) {
    TTLock.invoke(COMMAND_START_SCAN_REMOTE_KEY, null, scanCallback);
  }

  static void stopScan() {
    TTLock.invoke(COMMAND_STOP_SCAN_REMOTE_KEY, null, null);
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
    TTLock.invoke(COMMAND_INIT_REMOTE_KEY, map, callback, fail_callback: failedCallback);
  }
}
