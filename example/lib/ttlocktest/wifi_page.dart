import 'package:flutter/material.dart';
import 'package:ttlock_flutter/ttlock/ttlock.dart';
import 'gateway_page.dart';
import 'package:ttlock_flutter/ttlock/ttgateway.dart';
import 'package:bmprogresshud/progresshud.dart';

/// TTLock WiFi 选择页面
/// 
/// 该页面用于 G2 网关的 WiFi 配置，提供以下功能：
/// - 扫描附近的 WiFi 网络
/// - 显示 WiFi 列表及信号强度（RSSI）
/// - 选择 WiFi 后跳转到网关配置页面
/// 
/// 使用场景：
/// 1. 初始化 G2 网关时，需要配置 WiFi 连接
/// 2. 点击“扫描 WiFi”后进入此页面
/// 3. 从列表中选择一个 WiFi 网络
/// 4. 输入密码后完成网关初始化
/// 
/// 注意事项：
/// - 仅 G2 网关需要配置 WiFi（G3/G4 使用内置 4G）
/// - 手机需要有定位权限才能扫描 WiFi
/// - 选择的 WiFi 必须是 2.4GHz 频段（不支持 5GHz）
class WifiPage extends StatefulWidget {
  WifiPage({required this.mac}) : super();
  final String mac;
  @override
  _WifiPageState createState() => _WifiPageState();
}

class _WifiPageState extends State<WifiPage> {
  List _wifiList = [];
  // BuildContext _context;

  _WifiPageState() {
    super.initState();
    _getNearbyWifi();
  }

  void _getNearbyWifi() {
    // ProgressHud.of(_context).showLoading();
    TTGateway.getNearbyWifi((finished, wifiList) {
      // ProgressHud.of(_context).dismiss();
      setState(() {
        _wifiList = wifiList;
      });
    }, (errorCode, errorMsg) {});
  }

  void _pushGatewayPage(String wifi) {
    Navigator.push(context,
        new MaterialPageRoute(builder: (BuildContext context) {
      return GatewayPage(type: TTGatewayType.g2, wifi: wifi);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Select Wifi'),
        ),
        body: Material(child: ProgressHud(
          child: Container(
            child: Builder(builder: (context) {
              // _context = context;
              return getList();
            }),
          ),
        )));
  }

  Widget getList() {
    return ListView.builder(
        itemCount: _wifiList.length,
        padding: new EdgeInsets.all(5.0),
        itemExtent: 50.0,
        itemBuilder: (context, index) {
          Map wifiMap = _wifiList[index];
          int rssi = wifiMap['rssi'];
          return ListTile(
            title: Text(wifiMap['wifi']),
            subtitle: Text('rssi:$rssi'),
            onTap: () {
              Map wifiMap = _wifiList[index];
              String wifi = wifiMap['wifi'];
              _pushGatewayPage(wifi);
            },
          );
        });
  }
}
