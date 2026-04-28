import 'ttlock.dart';
import 'dart:convert' as convert;

/// TTLock 网关管理类
/// 
/// 提供 WiFi/4G 网关的扫描、连接、初始化和配置功能。
/// 网关用于将蓝牙锁连接到互联网，实现远程控制和管理。
/// 
/// 主要功能：
/// - 扫描附近的网关设备
/// - 连接和断开网关
/// - 初始化网关（配置 WiFi 或 4G）
/// - 获取周围 WiFi 列表
/// - 配置 IP 地址（静态/动态）
/// - 配置 APN（4G 网络）
/// - 固件升级
class TTGateway {
  static const String COMMAND_START_SCAN_GATEWAY = "startScanGateway";
  static const String COMMAND_STOP_SCAN_GATEWAY = "stopScanGateway";
  static const String COMMAND_CONNECT_GATEWAY = "connectGateway";
  static const String COMMAND_DISCONNECT_GATEWAY = "disconnectGateway";
  static const String COMMAND_GET_SURROUND_WIFI = "getSurroundWifi";
  static const String COMMAND_INIT_GATEWAY = "initGateway";
  static const String COMMAND_UPGRADE_GATEWAY = "upgradeGateway";

  static const String COMMAND_CONFIG_IP = "gatewayConfigIp";
  static const String COMMAND_CONFIG_APN = "gatewayConfigApn";

  static void startScan(TTGatewayScanCallback scanCallback) {
    TTLock.invoke(COMMAND_START_SCAN_GATEWAY, null, scanCallback);
  }

  static void stopScan() {
    TTLock.invoke(COMMAND_STOP_SCAN_GATEWAY, null, null);
  }

  static void connect(String mac, TTGatewayConnectCallback callback) {
    Map map = Map();
    map["mac"] = mac;
    TTLock.invoke(COMMAND_CONNECT_GATEWAY, map, callback);
  }

  static void getNearbyWifi(TTGatewayGetAroundWifiCallback callback,
      TTGatewayFailedCallback failedCallback) {
    TTLock.invoke(COMMAND_GET_SURROUND_WIFI, null, callback,
        fail_callback: failedCallback);
  }

  static void init(
    Map map,
    TTGatewayInitCallback callback,
    TTGatewayFailedCallback failedCallback,
  ) {
    if (map["uid"] != null) {
      map["ttlockUid"] = map["uid"];
    }
    if (map["ttlockLoginPassword"] == null) {
      map["ttlockLoginPassword"] = "123456";
    }

    map[TTResponse.addGatewayJsonStr] = convert.jsonEncode(map);
    TTLock.invoke(COMMAND_INIT_GATEWAY, map, callback, fail_callback: failedCallback);
  }

  ///[map] {"type":x, "ipAddress": "xxx", "subnetMask": xxx"", "router": "xxx", "preferredDns": "xxx", "alternateDns": "xxx"}
  //type  0表示手动，1表示自动
  //  ipAddress (可选)  例如 0.0.0.0
  //  subnetMask (可选)  例如 255.255.0.0
  //  router (可选)  例如 0.0.0.0
  //  preferredDns (可选)  例如 0.0.0.0
  //  alternateDns (可选)  例如 0.0.0.0
  static void configIp(
    Map map,
    TTSuccessCallback callback,
    TTGatewayFailedCallback failedCallback,
  ) {
    map[TTResponse.ipSettingJsonStr] = convert.jsonEncode(map);
    TTLock.invoke(COMMAND_CONFIG_IP, map, callback, fail_callback: failedCallback);
  }

  static void setGatewayEnterUpgradeMode(String mac, TTSuccessCallback callback,
      TTGatewayFailedCallback failedCallback) {
    Map map = Map();
    map["mac"] = mac;
    TTLock.invoke(COMMAND_UPGRADE_GATEWAY, map, callback, fail_callback: failedCallback);
  }

  static void disconnect(String mac, TTSuccessCallback callback) {
    Map map = Map();
    map["mac"] = mac;
    TTLock.invoke(COMMAND_DISCONNECT_GATEWAY, map, callback);
  }

  static void configApn(String mac, String apn, TTSuccessCallback callback,
      TTGatewayFailedCallback failedCallback) {
    Map map = Map();
    map["mac"] = mac;
    map["apn"] = apn;
    TTLock.invoke(COMMAND_CONFIG_APN, map, callback, fail_callback: failedCallback);
  }
}
