import 'dart:convert' as convert;

import 'ttlock.dart';

/// TTLock 远程键盘（蓝牙键盘）管理类
/// 
/// 提供蓝牙键盘的扫描、初始化和多功能管理功能。
/// 蓝牙键盘可以作为智能锁的输入设备，支持密码输入、指纹录入、卡片管理等功能。
/// 
/// 主要功能：
/// - 扫描附近的蓝牙键盘
/// - 初始化普通蓝牙键盘
/// - 初始化多功能蓝牙键盘（支持指纹、卡片等）
/// - 管理已存储的锁信息
/// - 通过键盘添加指纹
/// - 通过键盘添加IC卡
class TTRemoteKeypad {
  static const String COMMAND_START_SCAN_REMOTE_KEYPAD =
      "remoteKeypadStartScan";
  static const String COMMAND_STOP_SCAN_REMOTE_KEYPAD = "remoteKeypadStopScan";
  static const String COMMAND_INIT_REMOTE_KEYPAD = "remoteKeypadInit";

  static const String COMMAND_INIT_MULTIFUNCTIONAL_REMOTE_KEYPAD =
      "multifunctionalRemoteKeypadInit";
  static const String COMMAND_MULTIFUNCTIONAL_REMOTE_KEYPAD_DELETE_STORED_LOCK =
      "multifunctionalRemoteKeypadDeleteLock";
  static const String COMMAND_MULTIFUNCTIONAL_REMOTE_KEYPAD_GET_STORED_LOCK =
      "multifunctionalRemoteKeypadGetLocks";
  static const String COMMAND_MULTIFUNCTIONAL_REMOTE_KEYPAD_ADD_FINGERPRINT =
      "multifunctionalRemoteKeypadAddFingerprint";
  static const String COMMAND_MULTIFUNCTIONAL_REMOTE_KEYPAD_ADD_CARD =
      "multifunctionalRemoteKeypadAddCard";

  static void startScan(TTRemoteAccessoryScanCallback scanCallback) {
    TTLock.invoke(COMMAND_START_SCAN_REMOTE_KEYPAD, null, scanCallback);
  }

  static void stopScan() {
    TTLock.invoke(COMMAND_STOP_SCAN_REMOTE_KEYPAD, null, null);
  }

  static void init(
    String mac,
    String lockMac,
    TTRemoteKeypadInitSuccessCallback callback,
    TTRemoteFailedCallback failedCallback,
  ) {
    Map map = Map();
    map[TTResponse.mac] = mac;
    map[TTResponse.lockMac] = lockMac;
    TTLock.invoke(COMMAND_INIT_REMOTE_KEYPAD, map, callback,
        fail_callback: failedCallback);
  }

  static void multifunctionalInit(
      String mac,
      String lockData,
      TTMultifunctionalRemoteKeypadInitSuccessCallback callback,
      TTFailedCallback lockFailedCallback,
      TTRemoteKeypadFailedCallback keyPadFailedCallback) {
    Map map = Map();
    map[TTResponse.mac] = mac;
    map[TTResponse.lockData] = lockData;
    TTLock.invoke(COMMAND_INIT_MULTIFUNCTIONAL_REMOTE_KEYPAD, map, callback,
        fail_callback: lockFailedCallback,
        other_fail_callback: keyPadFailedCallback);
  }

  static void getStoredLocks(
    String mac,
    TTRemoteKeypadGetStoredLockSuccessCallback callback,
    TTRemoteKeypadFailedCallback failedCallback,
  ) {
    Map map = Map();
    map[TTResponse.mac] = mac;
    TTLock.invoke(
        COMMAND_MULTIFUNCTIONAL_REMOTE_KEYPAD_GET_STORED_LOCK, map, callback,
        fail_callback: failedCallback);
  }

  static void deleteStoredLock(
    String mac,
    int slotNumber,
    TTRemoteKeypadSuccessCallback callback,
    TTRemoteKeypadFailedCallback failedCallback,
  ) {
    Map map = Map();
    map[TTResponse.mac] = mac;
    map[TTResponse.slotNumber] = slotNumber;
    TTLock.invoke(
        COMMAND_MULTIFUNCTIONAL_REMOTE_KEYPAD_DELETE_STORED_LOCK, map, callback,
        fail_callback: failedCallback);
  }

  static void addFingerprint(
      String mac,
      List<TTCycleModel>? cycleList,
      int startDate,
      int endDate,
      String lockData,
      TTAddFingerprintProgressCallback progressCallback,
      TTAddFingerprintCallback callback,
      TTFailedCallback lockFailedCallback,
      TTRemoteKeypadFailedCallback keyPadFailedCallback) {
    Map map = Map();
    map[TTResponse.mac] = mac;
    map[TTResponse.startDate] = startDate;
    map[TTResponse.endDate] = endDate;
    map[TTResponse.lockData] = lockData;
    if (cycleList != null && cycleList.length > 0) {
      map[TTResponse.cycleJsonList] = convert.jsonEncode(cycleList);
    }
    TTLock.invoke(
        COMMAND_MULTIFUNCTIONAL_REMOTE_KEYPAD_ADD_FINGERPRINT, map, callback,
        progress_callback: progressCallback,
        fail_callback: lockFailedCallback,
        other_fail_callback: keyPadFailedCallback);
  }

  static void addCard(
      List<TTCycleModel>? cycleList,
      int startDate,
      int endDate,
      String lockData,
      TTAddCardProgressCallback progressCallback,
      TTCardNumberCallback callback,
      TTFailedCallback failedCallback) {
    Map map = Map();
    map[TTResponse.startDate] = startDate;
    map[TTResponse.endDate] = endDate;
    map[TTResponse.lockData] = lockData;
    if (cycleList != null && cycleList.length > 0) {
      map[TTResponse.cycleJsonList] = convert.jsonEncode(cycleList);
    }
    TTLock.invoke(COMMAND_MULTIFUNCTIONAL_REMOTE_KEYPAD_ADD_CARD, map, callback,
        progress_callback: progressCallback, fail_callback: failedCallback);
  }
}
