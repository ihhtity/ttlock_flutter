import 'package:flutter/material.dart';
import 'package:ttlock_flutter/ttlock/ttelectricMeter.dart';
import 'package:ttlock_flutter/ttlock/ttgateway.dart';
import 'package:ttlock_flutter/ttlock/ttlock.dart';
import 'package:ttlock_flutter/ttlock/ttremoteKeypad.dart';
import 'package:ttlock_flutter/ttlock/ttwaterMeter.dart';
import '../config.dart';
import 'key_pad_page.dart';
import 'wifi_page.dart';
import 'package:bmprogresshud/progresshud.dart';
import 'lock_page.dart';
import 'electric_meter_page.dart';
import 'gateway_page.dart';
import 'water_meter_page.dart';
import '../theme.dart';


enum ScanType { lock, gateway, electricMeter, keyPad, waterMeter }

class ScanPage extends StatefulWidget {
  ScanPage({required this.scanType}) : super();
  final ScanType scanType;
  @override
  _ScanPageState createState() => _ScanPageState(scanType);
}

class _ScanPageState extends State<ScanPage> {
  ScanType? scanType;
  BuildContext? _context;

  _ScanPageState(ScanType scanType) {
    super.initState();
    this.scanType = scanType;

    // Print TTLock Log
    TTLock.printLog = true;

    if (scanType == ScanType.lock) {
      _startScanLock();
    } else if (scanType == ScanType.gateway) {
      _startScanGateway();
    } else if (scanType == ScanType.electricMeter) {
      _startScanElectricMeter();
    } else if (scanType == ScanType.keyPad) {
      _startScanKeyPad();
    } else if (scanType == ScanType.waterMeter) {
      _startScanWaterMeter();
    }
  }

  List<TTLockScanModel> _lockList = [];
  List<TTGatewayScanModel> _gatewayList = [];
  List<TTElectricMeterScanModel> _electricMeterList = [];
  List<TTRemoteAccessoryScanModel> _keyPadList = [];
  List<TTWaterMeterScanModel> _waterMeterList = [];
  void dispose() {
    if (scanType == ScanType.lock) {
      TTLock.stopScanLock();
    } else if (scanType == ScanType.gateway) {
      TTGateway.stopScan();
    } else if (scanType == ScanType.electricMeter) {
      TTElectricMeter.stopScan();
    } else if (scanType == ScanType.keyPad) {
      TTRemoteKeypad.stopScan();
    }else if (scanType == ScanType.waterMeter) {
      TTWaterMeter.stopScan();
    }
    super.dispose();
  }

  void _showLoading() {
    ProgressHud.of(_context!)!.showLoading(text: '');
  }

  void _dismissLoading() {
    ProgressHud.of(_context!)!.dismiss();
  }

  void _initLock(TTLockScanModel scanModel) async {
    _showLoading();

    Map map = Map();
    map["lockMac"] = scanModel.lockMac;
    map["lockVersion"] = scanModel.lockVersion;
    map["isInited"] = scanModel.isInited;
    TTLock.initLock(map, (lockData) {
      _dismissLoading();
      LockConfig.lockData = lockData;
      LockConfig.lockMac = scanModel.lockMac;
      Navigator.push(context,
          new MaterialPageRoute(builder: (BuildContext context) {
        return LockPage(
          title: scanModel.lockName,
          lockData: lockData,
          lockMac: scanModel.lockMac,
        );
      }));
    }, (errorCode, errorMsg) {
      _dismissLoading();
    });
  }

  void _initElectricMeter(TTElectricMeterScanModel scanModel) async {
    print("init electric meter：" + scanModel.isInited.toString());
    if (scanModel.isInited) {
      Navigator.push(context,
          new MaterialPageRoute(builder: (BuildContext context) {
        return ElectricMeterPage(
          name: scanModel.name,
          mac: scanModel.mac,
        );
      }));
    } else {
      _showLoading();

      Map initParamMap = Map();
      initParamMap["mac"] = scanModel.mac;
      initParamMap["number"] = scanModel.name;
      initParamMap["payMode"] = TTMeterPayMode.postpaid.index;
      initParamMap["price"] = '1';
      TTElectricMeter.init(initParamMap, () {
        _dismissLoading();
        Navigator.push(context,
            new MaterialPageRoute(builder: (BuildContext context) {
          return ElectricMeterPage(
            name: scanModel.name,
            mac: scanModel.mac,
          );
        }));
      }, (errorCode, errorMsg) {
        _dismissLoading();
      });
    }
  }

  void _initKeyPad(TTRemoteAccessoryScanModel scanModel) async {
    print("init keyPad");
    var mac = scanModel.mac;
    var lockMac = LockConfig.lockMac;
    var lockData = LockConfig.lockData;
    print("多功能键盘lockData:$lockData");
    print("多功能键盘：$lockMac");
    if (scanModel.isMultifunctionalKeypad) {
      assert(lockMac.isNotEmpty);
      assert(lockData.isNotEmpty);
      TTRemoteKeypad.multifunctionalInit(
          mac,
          lockData,
          (int electricQuantity,
              String wirelessKeypadFeatureValue,
              int slotNumber,
              int slotLimit) {
            Navigator.push(context,
                new MaterialPageRoute(builder: (BuildContext context) {
                  return KeyPadPage(
                    name: scanModel.name,
                    mac: scanModel.mac,
                    lockData: lockData,
                    lockMac: lockMac,
                  );
                }));
          }, (TTLockError errorCode, String errorMsg) {

      }, (TTRemoteKeyPadAccessoryError errorCode, String errorMsg) {});
    } else {
      assert(lockMac.isNotEmpty);
      TTRemoteKeypad.init(mac, lockMac,
          (int electricQuantity, String wirelessKeypadFeatureValue) {
        Navigator.push(context,
            new MaterialPageRoute(builder: (BuildContext context) {
          return KeyPadPage(
            name: scanModel.name,
            mac: scanModel.mac,
            lockData: lockData,
            lockMac: lockMac,
          );
        }));
      }, (TTRemoteAccessoryError errorCode, String errorMsg) {});
    }
  }

  void _initWaterMeter(TTWaterMeterScanModel scanModel) async {
    print("init electric meter：" + scanModel.isInited.toString());
    if (scanModel.isInited) {
      Navigator.push(context,
          new MaterialPageRoute(builder: (BuildContext context) {
            return WaterMeterPage(
              name: scanModel.name,
              mac: scanModel.mac,
            );
          }));
    } else {
      _showLoading();

      Map initParamMap = Map();
      initParamMap["mac"] = scanModel.mac;
      initParamMap["number"] = scanModel.name;
      initParamMap["payMode"] = TTMeterPayMode.postpaid.index;
      initParamMap["price"] = '1';
      initParamMap["date"] = DateTime.now().millisecondsSinceEpoch;
      TTWaterMeter.init(initParamMap, () {
        _dismissLoading();
        Navigator.push(context,
            new MaterialPageRoute(builder: (BuildContext context) {
              return WaterMeterPage(
                name: scanModel.name,
                mac: scanModel.mac,
              );
            }));
      }, (errorCode, errorMsg) {
        _dismissLoading();
      });
    }
  }


  void _connectGateway(String mac, TTGatewayType type) async {
    _showLoading();
    TTGateway.connect(mac, (status) {
      _dismissLoading();
      if (status == TTGatewayConnectStatus.success) {
        //for test
        _configIp(mac);
        StatefulWidget? widget;
        if (type == TTGatewayType.g2) {
          widget = WifiPage(mac: mac);
        } else if (type == TTGatewayType.g3 || type == TTGatewayType.g4) {
          widget = GatewayPage(type: type);
        }

        Navigator.push(context,
            new MaterialPageRoute(builder: (BuildContext context) {
          return widget!;
        }));
      }
    });
  }

  void _configIp(String mac) {
    Map paramMap = Map();
    paramMap["mac"] = mac;
    paramMap["type"] = TTIpSettingType.DHCP.index;
    //for static ip setting
    // paramMap["type"] = TTIpSettingType.STATIC_IP.index;
    // paramMap["ipAddress"] = "192.168.1.100";
    // paramMap["subnetMask"] = "255.255.255.0";
    // paramMap["router"] = "192.168.1.1";
    // paramMap["preferredDns"] = "xxx.xxx.xxx.xxx";
    // paramMap["alternateDns"] = "xxx.xxx.xxx.xxx";

    TTGateway.configIp(paramMap, () {
      print("config ip success");
    }, (errorCode, errorMsg) {
      print('config ip errorCode:$errorCode msg:$errorMsg');
    });
  }

  void _startScanLock() async {
    _lockList = [];
    TTLock.startScanLock((scanModel) {
      bool contain = false;
      bool initStateChanged = false;
      for (var model in _lockList) {
        if (scanModel.lockMac == model.lockMac) {
          contain = true;
          initStateChanged = model.isInited != scanModel.isInited;
          if (initStateChanged) {
            model.isInited = scanModel.isInited;
          }
          break;
        }
      }
      if (!contain) {
        _lockList.add(scanModel);
      }
      if (!contain || initStateChanged) {
        setState(() {
          _lockList.sort((model1, model2) =>
              (model2.isInited ? 0 : 1) - (model1.isInited ? 0 : 1));
        });
      }
    });
  }

  void _startScanGateway() {
    _gatewayList = [];
    TTGateway.startScan((scanModel) {
      bool contain = false;
      for (TTGatewayScanModel model in _gatewayList) {
        if (scanModel.gatewayMac == model.gatewayMac) {
          contain = true;
          break;
        }
      }
      if (!contain) {
        setState(() {
          _gatewayList.add(scanModel);
        });
      }
    });
  }

  void _startScanElectricMeter() {
    _electricMeterList = [];
    TTElectricMeter.startScan((scanModel) {
      bool contain = false;
      for (TTElectricMeterScanModel model in _electricMeterList) {
        if (scanModel.mac == model.mac) {
          contain = true;
          break;
        }
      }
      if (!contain) {
        setState(() {
          _electricMeterList.add(scanModel);
        });
      }
    });
  }

  void _startScanKeyPad() {
    _keyPadList = [];
    TTRemoteKeypad.startScan((scanModel) {
      bool contain = false;
      for (TTRemoteAccessoryScanModel model in _keyPadList) {
        if (scanModel.mac == model.mac) {
          contain = true;
          break;
        }
      }
      if (!contain) {
        setState(() {
          _keyPadList.add(scanModel);
        });
      }
    });
  }

  void _startScanWaterMeter() {
    _waterMeterList = [];
    TTWaterMeter.startScan((scanModel) {
      bool contain = false;
      for (TTWaterMeterScanModel model in _waterMeterList) {
        if (scanModel.mac == model.mac) {
          contain = true;
          break;
        }
      }
      if (!contain) {
        setState(() {
          _waterMeterList.add(scanModel);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String title = [
      'Smart Lock',
      'Gateway',
      'Electric Meter',
      'Key Pad',
      'Water Meter'
    ][scanType!.index];
    
    IconData icon = [
      Icons.lock_rounded,
      Icons.wifi_tethering_rounded,
      Icons.electric_bolt_rounded,
      Icons.keyboard_rounded,
      Icons.water_drop_rounded,
    ][scanType!.index];
    
    Color iconColor = [
      const Color(0xFF3B82F6),
      const Color(0xFF8B5CF6),
      const Color(0xFFF59E0B),
      const Color(0xFF10B981),
      const Color(0xFF06B6D4),
    ][scanType!.index];
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(title),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [iconColor, iconColor.withOpacity(0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: ProgressHud(
        child: Builder(
          builder: (context) {
            _context = context;
            return getListView(icon, iconColor);
          },
        ),
      ),
    );
  }

  Widget getListView(IconData icon, Color iconColor) {
    String gatewayNote = 'Please power on the gateway again';
    String lockNote = 'Please touch the keyboard of lock';
    String electricMeterNote = '';
    String keypadNote = '';
    String waterMeterNote = '';
    String note =
        [lockNote, gatewayNote, electricMeterNote, keypadNote, waterMeterNote][scanType!.index];
    
    return Column(
      children: <Widget>[
        if (note.isNotEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppTheme.spacingMedium),
            margin: const EdgeInsets.all(AppTheme.spacingMedium),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
              border: Border.all(
                color: iconColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: iconColor,
                  size: 20,
                ),
                const SizedBox(width: AppTheme.spacingSmall),
                Expanded(
                  child: Text(
                    note,
                    style: TextStyle(
                      color: iconColor,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: _buildDeviceList(icon, iconColor),
        ),
      ],
    );
  }

  Widget _buildDeviceList(IconData icon, Color iconColor) {
    final deviceList = [
      _lockList,
      _gatewayList,
      _electricMeterList,
      _keyPadList,
      _waterMeterList
    ][scanType!.index];
    
    if (deviceList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bluetooth_searching_rounded,
              size: 80,
              color: iconColor.withOpacity(0.3),
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            Text(
              'Searching for devices...',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: AppTheme.spacingSmall),
            Text(
              'Make sure your device is in pairing mode',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.textHint,
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.spacingMedium),
      itemCount: deviceList.length,
      itemBuilder: (context, index) {
        return _buildDeviceCard(index, icon, iconColor);
      },
    );
  }

  Widget _buildDeviceCard(int index, IconData icon, Color iconColor) {
    String title = "";
    String subtitle = "";
    bool isInited = false;
    
    if (scanType == ScanType.lock) {
      TTLockScanModel scanModel = _lockList[index];
      title = scanModel.lockName;
      subtitle = scanModel.isInited
          ? 'Already initialized'
          : 'Tap to initialize';
      isInited = scanModel.isInited;
    } else if (scanType == ScanType.gateway) {
      TTGatewayScanModel scanModel = _gatewayList[index];
      title = scanModel.gatewayName;
      subtitle = 'Tap to connect';
    } else if (scanType == ScanType.electricMeter) {
      TTElectricMeterScanModel scanModel = _electricMeterList[index];
      title = scanModel.name;
      subtitle = scanModel.isInited
          ? 'Already initialized'
          : 'Tap to initialize';
      isInited = scanModel.isInited;
    } else if (scanType == ScanType.keyPad) {
      TTRemoteAccessoryScanModel scanModel = _keyPadList[index];
      title = scanModel.name;
      subtitle = 'Tap to connect';
    } else if (scanType == ScanType.waterMeter) {
      TTWaterMeterScanModel scanModel = _waterMeterList[index];
      title = scanModel.name;
      subtitle = scanModel.isInited
          ? 'Already initialized'
          : 'Tap to initialize';
      isInited = scanModel.isInited;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (scanType == ScanType.lock) {
              TTLockScanModel scanModel = _lockList[index];
              if (!scanModel.isInited) {
                TTLock.stopScanLock();
                _initLock(scanModel);
              }
            } else if (scanType == ScanType.gateway) {
              TTGatewayScanModel scanModel = _gatewayList[index];
              TTGateway.stopScan();
              _connectGateway(scanModel.gatewayMac, scanModel.type!);
            } else if (scanType == ScanType.electricMeter) {
              TTElectricMeterScanModel scanModel = _electricMeterList[index];
              TTElectricMeter.stopScan();
              _initElectricMeter(scanModel);
            } else if (scanType == ScanType.keyPad) {
              TTRemoteAccessoryScanModel scanModel = _keyPadList[index];
              TTRemoteKeypad.stopScan();
              _initKeyPad(scanModel);
            } else if (scanType == ScanType.waterMeter) {
              TTWaterMeterScanModel scanModel = _waterMeterList[index];
              TTWaterMeter.stopScan();
              _initWaterMeter(scanModel);
            }
          },
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingMedium),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        iconColor,
                        iconColor.withOpacity(0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                    boxShadow: [
                      BoxShadow(
                        color: iconColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          if (isInited)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.successColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Initialized',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppTheme.successColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          if (isInited) const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              subtitle,
                              style: TextStyle(
                                fontSize: 13,
                                color: isInited
                                    ? AppTheme.textHint
                                    : AppTheme.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: iconColor,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
