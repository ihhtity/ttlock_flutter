import 'package:flutter/material.dart';
import 'package:ttlock_flutter/ttlock/ttelectricMeter.dart';
import 'package:bmprogresshud/progresshud.dart';
import 'package:ttlock_flutter/ttlock/ttlock.dart';
import 'package:ttlock_flutter/ttlock/ttremoteKeypad.dart';

/// TTLock 多功能键盘测试页面
/// 
/// 该页面用于测试和管理 TTLock 多功能蓝牙键盘配件，提供以下功能：
/// - 获取已存储的锁列表
/// - 删除已存储的锁
/// - 添加指纹（录入指纹并绑定到锁）
/// - 添加卡片（录入IC卡并绑定到锁）
/// 
/// 使用场景：
/// 1. 在扫描页面发现键盘后，点击进入此页面进行初始化
/// 2. 对已初始化的键盘进行功能测试
/// 3. 管理键盘与锁的绑定关系
/// 4. 录入指纹和卡片等开锁方式
/// 
/// 依赖关系：
/// - 需要关联一个已初始化的智能锁（lockMac 和 lockData）
/// - 键盘必须与锁配对后才能正常使用
/// 
/// 注意事项：
/// - 多功能键盘需要先与锁进行配对
/// - 普通键盘只需 lockMac，多功能键盘需要 lockData
/// - 添加指纹和卡片时需要用户现场操作设备
class KeyPadPage extends StatefulWidget {
  KeyPadPage(
      {Key? key,
      required this.name,
      required this.mac,
      required this.lockMac,
      required this.lockData})
      : super(key: key);
  final String name;
  final String mac;
  final String lockMac;
  final String lockData;
  _KeyPadState createState() => _KeyPadState(name, mac, lockMac, lockData);
}

enum Command { getStoredLocks, deleteStoredLock, addFingerprint, addCard }

class _KeyPadState extends State<KeyPadPage> {
  List<Map<String, Command>> _commandList = [
    {"getStoredLocks": Command.getStoredLocks},
    {"deleteStoredLock": Command.deleteStoredLock},
    {"addFingerprint": Command.addFingerprint},
    {"addCard": Command.addCard}
  ];

  String note =
      'Note: You need to reset the electric meter before pop current page,otherwise the electric meter will can\'t be initialized again';

  String mac = '';
  String name = '';
  String lockMac = '';
  String lockData = '';
  BuildContext? _context;

  _KeyPadState(String name, String mac, String lockMac, String lockData) {
    super.initState();
    this.name = name;
    this.mac = mac;
    this.lockMac = lockMac;
    this.lockData = lockData;
  }

  void _showLoading(String text) {
    ProgressHud.of(_context!)!.showLoading(text: text);
  }

  void _showSuccessAndDismiss(String text) {
    ProgressHud.of(_context!)!.showSuccessAndDismiss(text: text);
  }

  void _showErrorAndDismiss(
      TTRemoteKeyPadAccessoryError errorCode, String errorMsg) {
    ProgressHud.of(_context!)!.showErrorAndDismiss(
        text: 'errorCode:$errorCode errorMessage:$errorMsg');
  }

  void _click(Command command, BuildContext context) async {
    _showLoading('');
    switch (command) {
      case Command.getStoredLocks:
        TTRemoteKeypad.getStoredLocks(mac, (List lockMacList) {
          _showSuccessAndDismiss("lockMacList:$lockMacList");
        }, (errorCode, errorMsg) {
          _showErrorAndDismiss(errorCode, errorMsg);
        });
        break;

      case Command.deleteStoredLock:
        TTRemoteKeypad.deleteStoredLock(mac, 1, () {
          _showSuccessAndDismiss("Set Power success");
        }, (errorCode, errorMsg) {
          _showErrorAndDismiss(errorCode, errorMsg);
        });
        break;
      case Command.addFingerprint:
        TTRemoteKeypad.addFingerprint(mac,
            null,
            1746673751000,
            1746760151000,
            lockData,
                (int currentCount, int totalCount){
               print("addFingerprint;;;currentCount:$currentCount;;;;totalCount:$totalCount");
            }, (String fingerprintNumber) {
              print("addFingerprint fingerprintNumber:$fingerprintNumber");
            }, (errorCode, errorMsg) {
              print("addFingerprint;;;errorCode:$errorCode;;;;errorMsg:$errorMsg");

            }, (TTRemoteKeyPadAccessoryError errorCode, String errorMsg){
              print("addFingerprint;;;errorCode:$errorCode;;;;errorMsg:$errorMsg");
            });
        break;
      case Command.addCard:
        TTRemoteKeypad.addCard(
            null,
            0,
            0,
            lockData,
                (){
              print("addCard;;;请刷卡");
            }, (String cardNumber) {
              print("addCard fingerprintNumber:$cardNumber");
              _showSuccessAndDismiss("addCard success");
            }, (errorCode, errorMsg) {
              print("addCard;;;errorCode:$errorCode;;;;errorMsg:$errorMsg");
              ProgressHud.of(_context!)!.showErrorAndDismiss(
                  text: 'errorCode:$errorCode errorMessage:$errorMsg');
            });
        break;
      default:
    }
  }

  Widget getListView() {
    return ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
          return Divider(height: 2, color: Colors.green);
        },
        itemCount: _commandList.length,
        itemBuilder: (context, index) {
          Map<String, Command> map = _commandList[index];
          String title = '${map.keys.first}';

          return ListTile(
            title: Text(title),
            subtitle: Text(index == 0 ? note : ''),
            onTap: () {
              _click(map.values.first, context);
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Key Pad'),
        ),
        body: Material(child: ProgressHud(
          child: Container(
            child: Builder(builder: (context) {
              _context = context;
              return getListView();
            }),
          ),
        )));
  }
}
