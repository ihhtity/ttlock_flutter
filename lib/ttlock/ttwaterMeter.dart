import 'ttlock.dart';
import 'dart:convert' as convert;

/// TTLock 智能水表管理类
/// 
/// 提供智能水表的扫描、连接、初始化和控制功能。
/// 智能水表用于远程监控和控制水资源使用，支持预付费和后付费模式。
/// 
/// 主要功能：
/// - 配置服务器参数
/// - 扫描附近的水表设备
/// - 连接和断开水表
/// - 初始化水表（设置价格、付费模式等）
/// - 控制水阀开关（通水/断水）
/// - 设置和查询剩余水量
/// - 充值操作
/// - 读取水表数据（总用量、剩余量等）
/// - 设置总用水量
/// - 删除水表配置
class TTWaterMeter {
  static const String COMMAND_CONFIG_SERVER_WATER_METER =
      "waterMeterConfigServer";
  static const String COMMAND_START_SCAN_WATER_METER = "waterMeterStartScan";
  static const String COMMAND_STOP_SCAN_WATER_METER = "waterMeterStopScan";
  static const String COMMAND_WATER_METER_CONNECT = "waterMeterConnect";
  static const String COMMAND_WATER_METER_DISCONNECT = "waterMeterDisconnect";
  static const String COMMAND_WATER_METER_INIT = "waterMeterInit";
  static const String COMMAND_WATER_METER_DELETE = "waterMeterDelete";
  static const String COMMAND_WATER_METER_SET_POWER_ON_OFF =
      "waterMeterSetPowerOnOff";
  static const String COMMAND_WATER_METER_SET_REMAINING_M3 =
      "waterMeterSetRemainingM3";
  static const String COMMAND_WATER_METER_CLEAR_REMAINING_M3 =
      "waterMeterClearRemainingM3";
  static const String COMMAND_WATER_METER_READ_DATA = "waterMeterReadData";
  static const String COMMAND_WATER_METER_SET_PAY_MODE = "waterMeterSetPayMode";
  static const String COMMAND_WATER_METER_CHARGE = "waterMeterCharge";
  static const String COMMAND_WATER_METER_SET_TOTAL_USAGE =
      "waterMeterSetTotalUsage";
  static const String COMMAND_WATER_METER_GET_FEATURE_VALUE =
      "waterMeterGetFeatureValue";
  static const String COMMAND_WATER_METER_ENTER_UPGRADE_MODE =
      "waterMeterEnterUpgradeMode";

  static void configServer(WaterMeterServerParamMode paramMode) {
    Map map = Map();
    map["url"] = paramMode.url;
    map["clientId"] = paramMode.clientId;
    map["accessToken"] = paramMode.accessToken;
    TTLock.invoke(COMMAND_CONFIG_SERVER_WATER_METER, map, null);
  }

  static void startScan(TTWaterMeterScanCallback scanCallback) {
    TTLock.invoke(COMMAND_START_SCAN_WATER_METER, null, scanCallback);
  }

  static void stopScan() {
    TTLock.invoke(COMMAND_STOP_SCAN_WATER_METER, null, null);
  }

  static void connect(String mac, TTSuccessCallback callback,
      TTMeterFailedCallback failedCallback) {
    Map map = Map();
    map["mac"] = mac;
    TTLock.invoke(COMMAND_WATER_METER_CONNECT, map, callback,
        fail_callback: failedCallback);
  }

  static void disconnect(String mac) {
    Map map = Map();
    map["mac"] = mac;
    TTLock.invoke(COMMAND_WATER_METER_DISCONNECT, map, null);
  }

  /**
   * 
   *  Map paramMap = Map();
      paramMap["mac"] = scanModel.mac;
      paramMap["price"] = scanModel.price;
      paramMap["payMode"] = TTMeterPayMode.postpaid.index;
      paramMap["number"] = scanModel.name;
   */
  static void init(
    Map paramMap,
    TTSuccessCallback successCallback,
    TTMeterFailedCallback failedCallback,
  ) {
    TTLock.invoke(COMMAND_WATER_METER_INIT, paramMap, successCallback,
        fail_callback: failedCallback);
  }

  static void delete(
    String mac,
    TTSuccessCallback successCallback,
    TTMeterFailedCallback failedCallback,
  ) {
    Map map = Map();
    map["mac"] = mac;
    TTLock.invoke(COMMAND_WATER_METER_DELETE, map, successCallback,
        fail_callback: failedCallback);
  }

  static void setPowerOnOff(
    String mac,
    bool isOn,
    TTSuccessCallback successCallback,
    TTMeterFailedCallback failedCallback,
  ) {
    Map map = Map();
    map["mac"] = mac;
    map["isOn"] = isOn;
    TTLock.invoke(COMMAND_WATER_METER_SET_POWER_ON_OFF, map, successCallback,
        fail_callback: failedCallback);
  }

  static void setRemainderM3(
    String mac,
    String remainderM3,
    TTSuccessCallback successCallback,
    TTMeterFailedCallback failedCallback,
  ) {
    Map map = Map();
    map["mac"] = mac;
    map["remainderM3"] = remainderM3;
    TTLock.invoke(COMMAND_WATER_METER_SET_REMAINING_M3, map, successCallback,
        fail_callback: failedCallback);
  }

  static void clearRemainderM3(
    String mac,
    TTSuccessCallback successCallback,
    TTMeterFailedCallback failedCallback,
  ) {
    Map map = Map();
    map["mac"] = mac;

    TTLock.invoke(COMMAND_WATER_METER_CLEAR_REMAINING_M3, map, successCallback,
        fail_callback: failedCallback);
  }

  static void readData(
    String mac,
    TTSuccessCallback successCallback,
    TTMeterFailedCallback failedCallback,
  ) {
    Map map = Map();
    map["mac"] = mac;
    TTLock.invoke(COMMAND_WATER_METER_READ_DATA, map, successCallback,
        fail_callback: failedCallback);
  }

  static void setPayMode(
    String mac,
    String price,
    TTMeterPayMode payMode,
    TTSuccessCallback successCallback,
    TTMeterFailedCallback failedCallback,
  ) {
    Map map = Map();
    map["mac"] = mac;
    map["price"] = price;
    map["payMode"] = payMode.index;
    TTLock.invoke(COMMAND_WATER_METER_SET_PAY_MODE, map, successCallback,
        fail_callback: failedCallback);
  }

  static void recharge(
    String mac,
    String amount,
    String m3,
    TTSuccessCallback successCallback,
    TTMeterFailedCallback failedCallback,
  ) {
    Map map = Map();
    map["mac"] = mac;
    map["m3"] = m3;
    map["chargeAmount"] = amount;
    TTLock.invoke(COMMAND_WATER_METER_CHARGE, map, successCallback,
        fail_callback: failedCallback);
  }

  static void setTotalUsage(
    String mac,
    double totalM3,
    TTSuccessCallback successCallback,
    TTMeterFailedCallback failedCallback,
  ) {
    Map map = Map();
    map["mac"] = mac;
    map["totalM3"] = totalM3.toString();
    TTLock.invoke(COMMAND_WATER_METER_SET_TOTAL_USAGE, map, successCallback,
        fail_callback: failedCallback);
  }

  static void readFeatureValue(
    String mac,
    TTSuccessCallback successCallback,
    TTMeterFailedCallback failedCallback,
  ) {
    Map map = Map();
    map["mac"] = mac;
    TTLock.invoke(COMMAND_WATER_METER_GET_FEATURE_VALUE, map, successCallback,
        fail_callback: failedCallback);
  }

  // static void enterUpgradeMode(
  //   String mac,
  //   TTSuccessCallback successCallback,
  //   TTMeterFailedCallback failedCallback,
  // ) {
  //   Map map = Map();
  //   map["mac"] = mac;
  //   TTLock.invoke(
  //       COMMAND_WATER_METER_ENTER_UPGRADE_MODE, map, successCallback,
  //       fail: failedCallback);
  // }
}

/// 水表服务器配置参数类
/// 
/// 用于配置水表服务的连接参数，包括服务器地址、客户端ID和访问令牌。
class WaterMeterServerParamMode {
  late String url;          // 服务器 URL
  late String clientId;     // 客户端 ID
  late String accessToken;  // 访问令牌
}

/// 水表初始化参数模型类
/// 
/// 包含初始化水表所需的参数，如 MAC 地址、名称、价格和付费模式。
class WaterMeterInitParamModel {
  late String mac;              // 水表 MAC 地址
  late String name;             // 水表名称/编号
  late String price;            // 水价（元/吨）
  late TTMeterPayMode payMode;  // 付费模式（预付费/后付费）
}

/// TTLock 水表扫描结果模型类
/// 
/// 表示扫描到的水表设备信息，包含设备状态和读数数据。
class TTWaterMeterScanModel {
  String name = '';
  String mac = '';
  bool isInited = true;
  String totalM3 = '';
  String remainderM3 = '';
  bool onOff = true;
  int rssi = -1;
  int magneticInterference = 0;
  int electricQuantity = -1;
  int waterValveFailure = 0;
  TTMeterPayMode payMode = TTMeterPayMode.postpaid;
  int scanTime = 0;

  TTWaterMeterScanModel(Map map) {
    this.name = map[TTResponse.name];
    this.mac = map[TTResponse.mac];
    this.isInited = map[TTResponse.isInited];
    this.totalM3 = map[TTResponse.totalM3];
    this.remainderM3 = map[TTResponse.remainderM3];
    this.electricQuantity = map[TTResponse.electricQuantity];
    this.waterValveFailure = map[TTResponse.waterValveFailure];
    this.rssi = map[TTResponse.rssi];
    this.onOff = map[TTResponse.onOff];
    this.payMode = map[TTResponse.payMode] == 0
        ? TTMeterPayMode.postpaid
        : TTMeterPayMode.prepaid;
    this.scanTime = map[TTResponse.scanTime];
  }
}
