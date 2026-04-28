// import 'ttlock.dart';
import 'dart:convert' as convert;

import 'ttlock.dart';

/// TTLock 智能电表管理类
/// 
/// 提供智能电表的扫描、连接、初始化和控制功能。
/// 智能电表用于远程监控和控制电力使用，支持预付费和后付费模式。
/// 
/// 主要功能：
/// - 配置服务器参数
/// - 扫描附近的电表设备
/// - 连接和断开电表
/// - 初始化电表（设置价格、付费模式等）
/// - 控制电源开关（通电/断电）
/// - 设置和查询剩余电量
/// - 充值操作
/// - 读取电表数据（电压、电流、功率等）
/// - 设置最大负载功率
/// - 删除电表配置
class TTElectricMeter {
  static const String COMMAND_CONFIG_SERVER_ELECTRIC_METER =
      "electricMeterConfigServer";
  static const String COMMAND_START_SCAN_ELECTRIC_METER =
      "electricMeterStartScan";
  static const String COMMAND_STOP_SCAN_ELECTRIC_METER =
      "electricMeterStopScan";
  static const String COMMAND_ELECTRIC_METER_CONNECT = "electricMeterConnect";
  static const String COMMAND_ELECTRIC_METER_DISCONNECT =
      "electricMeterDisconnect";
  static const String COMMAND_ELECTRIC_METER_INIT = "electricMeterInit";
  static const String COMMAND_ELECTRIC_METER_DELETE = "electricMeterDelete";
  static const String COMMAND_ELECTRIC_METER_SET_POWER_ON_OFF =
      "electricMeterSetPowerOnOff";
  static const String COMMAND_ELECTRIC_METER_SET_REMAINING_ELECTRICITY =
      "electricMeterSetRemainingElectricity";
  static const String COMMAND_ELECTRIC_METER_CLEAR_REMAINING_ELECTRICITY =
      "electricMeterClearRemainingElectricity";
  static const String COMMAND_ELECTRIC_METER_READ_DATA =
      "electricMeterReadData";
  static const String COMMAND_ELECTRIC_METER_SET_PAY_MODE =
      "electricMeterSetPayMode";
  static const String COMMAND_ELECTRIC_METER_CHARGE = "electricMeterCharg";
  static const String COMMAND_ELECTRIC_METER_SET_MAX_POWER =
      "electricMeterSetMaxPower";
  static const String COMMAND_ELECTRIC_METER_GET_FEATURE_VALUE =
      "electricMeterGetFeatureValue";
  static const String COMMAND_ELECTRIC_METER_ENTER_UPGRADE_MODE =
      "electricMeterEnterUpgradeMode";

  static void configServer(ElectricMeterServerParamMode paramMode) {
    Map map = Map();
    map["url"] = paramMode.url;
    map["clientId"] = paramMode.clientId;
    map["accessToken"] = paramMode.accessToken;
    TTLock.invoke(COMMAND_CONFIG_SERVER_ELECTRIC_METER, map, null);
  }

  static void startScan(TTElectricMeterScanCallback scanCallback) {
    TTLock.invoke(COMMAND_START_SCAN_ELECTRIC_METER, null, scanCallback);
  }

  static void stopScan() {
    TTLock.invoke(COMMAND_STOP_SCAN_ELECTRIC_METER, null, null);
  }

  static void connect(String mac, TTSuccessCallback callback,
      TTMeterFailedCallback failedCallback) {
    Map map = Map();
    map["mac"] = mac;
    TTLock.invoke(COMMAND_ELECTRIC_METER_CONNECT, map, callback,
        fail_callback: failedCallback);
  }

  static void disconnect(String mac) {
    Map map = Map();
    map["mac"] = mac;
    TTLock.invoke(COMMAND_ELECTRIC_METER_DISCONNECT, map, null);
  }

  /**
   * 
   *  Map paramMap = Map();
      paramMap["mac"] = scanModel.mac;
      paramMap["price"] = scanModel.price;
      paramMap["payMode"] = TTElectricMeterPayMode.postpaid.index;
      paramMap["number"] = scanModel.name;
   */
  static void init(
    Map paramMap,
    TTSuccessCallback successCallback,
    TTMeterFailedCallback failedCallback,
  ) {
    TTLock.invoke(COMMAND_ELECTRIC_METER_INIT, paramMap, successCallback,
        fail_callback: failedCallback);
  }

  static void delete(
    String mac,
    TTSuccessCallback successCallback,
    TTMeterFailedCallback failedCallback,
  ) {
    Map map = Map();
    map["mac"] = mac;
    TTLock.invoke(COMMAND_ELECTRIC_METER_DELETE, map, successCallback,
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
    TTLock.invoke(COMMAND_ELECTRIC_METER_SET_POWER_ON_OFF, map, successCallback,
        fail_callback: failedCallback);
  }

  static void setRemainderKwh(
    String mac,
    String remainderKwh,
    TTSuccessCallback successCallback,
    TTMeterFailedCallback failedCallback,
  ) {
    Map map = Map();
    map["mac"] = mac;
    map["remainderKwh"] = remainderKwh;
    TTLock.invoke(
        COMMAND_ELECTRIC_METER_SET_REMAINING_ELECTRICITY, map, successCallback,
        fail_callback: failedCallback);
  }

  static void clearRemainderKwh(
    String mac,
    TTSuccessCallback successCallback,
    TTMeterFailedCallback failedCallback,
  ) {
    Map map = Map();
    map["mac"] = mac;

    TTLock.invoke(COMMAND_ELECTRIC_METER_CLEAR_REMAINING_ELECTRICITY, map,
        successCallback,
        fail_callback: failedCallback);
  }

  static void readData(
    String mac,
    TTSuccessCallback successCallback,
    TTMeterFailedCallback failedCallback,
  ) {
    Map map = Map();
    map["mac"] = mac;
    TTLock.invoke(COMMAND_ELECTRIC_METER_READ_DATA, map, successCallback,
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
    TTLock.invoke(COMMAND_ELECTRIC_METER_SET_PAY_MODE, map, successCallback,
        fail_callback: failedCallback);
  }

  static void recharge(
    String mac,
    String amount,
    String kwh,
    TTSuccessCallback successCallback,
    TTMeterFailedCallback failedCallback,
  ) {
    Map map = Map();
    map["mac"] = mac;
    map["chargeKwh"] = kwh;
    map["chargeAmount"] = amount;
    TTLock.invoke(COMMAND_ELECTRIC_METER_CHARGE, map, successCallback,
        fail_callback: failedCallback);
  }

  static void setMaxPower(
    String mac,
    int maxPower,
    TTSuccessCallback successCallback,
    TTMeterFailedCallback failedCallback,
  ) {
    Map map = Map();
    map["mac"] = mac;
    map["maxPower"] = maxPower;
    TTLock.invoke(COMMAND_ELECTRIC_METER_SET_MAX_POWER, map, successCallback,
        fail_callback: failedCallback);
  }

  static void readFeatureValue(
    String mac,
    TTSuccessCallback successCallback,
    TTMeterFailedCallback failedCallback,
  ) {
    Map map = Map();
    map["mac"] = mac;
    TTLock.invoke(
        COMMAND_ELECTRIC_METER_GET_FEATURE_VALUE, map, successCallback,
        fail_callback: failedCallback);
  }

  // static void enterUpgradeMode(
  //   String mac,
  //   TTSuccessCallback successCallback,
  //   TTElectricMeterFailedCallback failedCallback,
  // ) {
  //   Map map = Map();
  //   map["mac"] = mac;
  //   TTLock.invoke(
  //       COMMAND_ELECTRIC_METER_ENTER_UPGRADE_MODE, map, successCallback,
  //       fail: failedCallback);
  // }
}

/// 电表服务器配置参数类
/// 
/// 用于配置电表服务的连接参数，包括服务器地址、客户端ID和访问令牌。
class ElectricMeterServerParamMode {
  late String url;          // 服务器 URL
  late String clientId;     // 客户端 ID
  late String accessToken;  // 访问令牌
}

/// 电表初始化参数模型类
/// 
/// 包含初始化电表所需的参数，如 MAC 地址、名称、价格和付费模式。
class ElectricMeterInitParamModel {
  late String mac;              // 电表 MAC 地址
  late String name;             // 电表名称/编号
  late String price;            // 电价（元/度）
  late TTMeterPayMode payMode;  // 付费模式（预付费/后付费）
}

/// TTLock 电表扫描结果模型类
/// 
/// 表示扫描到的电表设备信息，包含设备状态和读数数据。
class TTElectricMeterScanModel {
  String name = '';
  String mac = '';
  bool isInited = true;
  String totalKwh = '';
  String remainderKwh = '';
  String voltage = '';
  String electricCurrent = '';
  bool onOff = true;
  int rssi = -1;
  TTMeterPayMode payMode = TTMeterPayMode.postpaid;
  int scanTime = 0;

  TTElectricMeterScanModel(Map map) {
    this.name = map[TTResponse.name];
    this.mac = map[TTResponse.mac];
    this.isInited = map[TTResponse.isInited];
    this.totalKwh = map[TTResponse.totalKwh];
    this.remainderKwh = map[TTResponse.remainderKwh];
    this.voltage = map[TTResponse.voltage];
    this.electricCurrent = map[TTResponse.electricCurrent];
    this.rssi = map[TTResponse.rssi];
    this.onOff = map[TTResponse.onOff];
    this.payMode = map[TTResponse.payMode] == 0
        ? TTMeterPayMode.postpaid
        : TTMeterPayMode.prepaid;
    this.scanTime = map[TTResponse.scanTime];
  }
}
