import 'package:flutter/material.dart';
import 'package:ttlock_flutter/ttlock/ttlock.dart';
import 'package:bmprogresshud/progresshud.dart';
import '../../theme.dart';
import '../../utils/ttlock_api_service.dart';

/// 房间详情/编辑页面
///
/// 显示房间详细信息并提供智能锁控制功能：
/// - 查看房间基本信息（名称、类型、楼栋、楼层等）
/// - 智能锁控制（蓝牙开锁、密码管理、卡片管理等）
/// - 电源设备控制（通电、断电等）
/// - 房间设置和设备绑定
class RoomDetailPage extends StatefulWidget {
  final Map<String, dynamic> room;

  const RoomDetailPage({Key? key, required this.room}) : super(key: key);

  @override
  _RoomDetailPageState createState() => _RoomDetailPageState();
}

class _RoomDetailPageState extends State<RoomDetailPage> {
  BuildContext? _context;
  String? _lockData; // 智能锁数据
  String? _lockMac; // 智能锁 MAC 地址
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // 从房间信息中获取锁数据（如果有）
    _lockData = widget.room['lockData'];
    _lockMac = widget.room['lockMac'];

    // 如果没有锁数据，尝试加载测试数据
    if (_lockData == null || _lockData!.isEmpty) {
      _loadTestLockData();
    }
  }

  /// 加载测试锁数据（用于演示）
  /// 注意：实际使用时应从 TTLock API 获取真实数据
  void _loadTestLockData() {
    // TODO: 这里应该调用 TTLock API 获取真实的锁数据
    // API 文档: https://open.ttlock.com/doc/api/v3/key/list
    //
    // 示例 API 调用流程：
    // 1. 登录获取 access_token
    //    POST https://api.ttlock.com/v3/oauth2/token
    //    参数: clientId, clientSecret, username, password
    //
    // 2. 获取钥匙列表
    //    GET https://api.ttlock.com/v3/key/list
    //    参数: access_token, page, pageSize
    //
    // 3. 解析返回的 lockData 和 lockMac

    print('提示: 当前为测试模式，请使用真实的 lockData');
    print('如需从服务器获取数据，请集成 TTLock Open API');

    // 显示提示对话框
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showLoadDeviceDialog();
    });
  }

  /// 显示加载设备对话框
  void _showLoadDeviceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('加载智能锁设备'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '请选择加载方式：',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.cloud_download_rounded,
                  color: AppTheme.primaryColor),
              title: const Text('从 API 加载'),
              subtitle: const Text('使用账号 19830357494 登录'),
              onTap: () {
                Navigator.pop(context);
                _loadDeviceFromAPI();
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.edit_rounded, color: AppTheme.primaryColor),
              title: const Text('手动输入'),
              subtitle: const Text('直接输入 lockData'),
              onTap: () {
                Navigator.pop(context);
                _showManualInputDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.bluetooth_searching_rounded,
                  color: AppTheme.primaryColor),
              title: const Text('蓝牙扫描'),
              subtitle: const Text('扫描附近的智能锁'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('请使用主页的扫描功能')),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
        ],
      ),
    );
  }

  /// 从 API 加载设备
  Future<void> _loadDeviceFromAPI() async {
    _showLoading('正在登录...');

    try {
      final device = await TTLockApiService.loadFirstDevice(
        TestAccount.username,
        TestAccount.password,
      );

      if (device == null) {
        _showError(TTLockError.fail, '加载失败，请检查配置');
        return;
      }

      setState(() {
        _lockData = device['lockData'];
        _lockMac = device['lockMac'];
      });

      _showSuccess('设备加载成功\n${device['lockName']}');
    } catch (e) {
      _showError(TTLockError.fail, '加载异常: $e');
    }
  }

  /// 显示手动输入对话框
  void _showManualInputDialog() {
    final lockDataController = TextEditingController();
    final lockMacController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('手动输入设备信息'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: lockDataController,
              decoration: const InputDecoration(
                labelText: 'Lock Data',
                hintText: '请输入完整的 lockData',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: lockMacController,
              decoration: const InputDecoration(
                labelText: 'MAC 地址',
                hintText: '例如: AA:BB:CC:DD:EE:FF',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              final lockData = lockDataController.text.trim();
              final lockMac = lockMacController.text.trim();

              if (lockData.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('请输入 lockData')),
                );
                return;
              }

              Navigator.pop(context);

              setState(() {
                _lockData = lockData;
                _lockMac = lockMac.isEmpty ? null : lockMac;
              });

              _showSuccess('设备信息已设置');
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  /// 显示加载提示
  void _showLoading(String text) {
    if (_context != null) {
      ProgressHud.of(_context!)!.showLoading(text: text);
    }
  }

  /// 显示成功提示
  void _showSuccess(String text) {
    if (_context != null) {
      ProgressHud.of(_context!)!.showSuccessAndDismiss(text: text);
    }
  }

  /// 显示错误提示
  void _showError(TTLockError errorCode, String errorMsg) {
    if (_context != null) {
      ProgressHud.of(_context!)!.showErrorAndDismiss(
        text: '错误代码: $errorCode\n错误信息: $errorMsg',
      );
    }
  }

  /// 检查锁数据是否有效
  Future<bool> _checkLockData() async {
    if (_lockData == null || _lockData!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('未绑定智能锁，请先在设备绑定中添加智能锁'),
          backgroundColor: Colors.orange,
        ),
      );
      return false;
    }
    
    // 检查蓝牙状态
    return await _checkBluetoothState();
  }
  
  /// 检查蓝牙状态
  Future<bool> _checkBluetoothState() async {
    try {
      TTLock.getBluetoothState((state) {
        if (state != TTBluetoothState.turnOn) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('请先开启蓝牙功能'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      });
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('蓝牙检查失败'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
  }

  /// 蓝牙开锁
  Future<void> _unlock() async {
    if (!await _checkLockData()) return;

    _showLoading('正在开锁...');
    print('正在开锁中...');

    try {
      TTLock.controlLock(
        _lockData!,
        TTControlAction.unlock,
        (lockTime, electricQuantity, uniqueId, lockData) {
          _showSuccess('开锁成功\n电量: ${electricQuantity}%');
          // 更新锁数据
          setState(() {
            _lockData = lockData;
          });
        },
        (errorCode, errorMsg) {
          _showError(errorCode, errorMsg);
        },
      );
    } catch (e) {
      _showError(TTLockError.fail, '开锁异常: $e');
    }
  }

  /// 获取电池电量
  Future<void> _getBatteryLevel() async {
    if (!await _checkLockData()) return;

    _showLoading('正在获取电量...');

    try {
      TTLock.getLockPower(
        _lockData!,
        (electricQuantity) {
          _showSuccess('当前电量: ${electricQuantity}%');
        },
        (errorCode, errorMsg) {
          _showError(errorCode, errorMsg);
        },
      );
    } catch (e) {
      _showError(TTLockError.fail, '获取电量异常: $e');
    }
  }

  /// 获取操作记录
  Future<void> _getOperateRecord() async {
    if (!await _checkLockData()) return;

    _showLoading('正在获取记录...');

    try {
      TTLock.getLockOperateRecord(
        TTOperateRecordType.latest,
        _lockData!,
        (operateRecord) {
          _showSuccess('获取成功');
          // TODO: 显示详细记录
          print('操作记录: $operateRecord');
        },
        (errorCode, errorMsg) {
          _showError(errorCode, errorMsg);
        },
      );
    } catch (e) {
      _showError(TTLockError.fail, '获取记录异常: $e');
    }
  }

  /// 显示密码管理对话框
  void _showPasscodeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('密码管理'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading:
                  const Icon(Icons.add_rounded, color: AppTheme.primaryColor),
              title: const Text('添加密码'),
              onTap: () {
                Navigator.pop(context);
                _showAddPasscodeDialog();
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.edit_rounded, color: AppTheme.primaryColor),
              title: const Text('修改密码'),
              onTap: () {
                Navigator.pop(context);
                _showModifyPasscodeDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_rounded, color: Colors.red),
              title: const Text('删除密码'),
              onTap: () {
                Navigator.pop(context);
                _showDeletePasscodeDialog();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
        ],
      ),
    );
  }

  /// 显示添加密码对话框
  void _showAddPasscodeDialog() {
    final passcodeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('添加密码'),
        content: TextField(
          controller: passcodeController,
          decoration: const InputDecoration(
            labelText: '请输入4-9位数字密码',
            hintText: '例如: 123456',
          ),
          keyboardType: TextInputType.number,
          maxLength: 9,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              final passcode = passcodeController.text;
              if (passcode.length < 4 || passcode.length > 9) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('密码长度必须在4-9位之间')),
                );
                return;
              }
              Navigator.pop(context);
              _addPasscode(passcode);
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  /// 添加密码
  Future<void> _addPasscode(String passcode) async {
    if (!await _checkLockData()) return;

    _showLoading('正在添加密码...');

    final startDate = DateTime.now().millisecondsSinceEpoch;
    final endDate = startDate + (30 * 24 * 60 * 60 * 1000); // 30天后过期

    try {
      TTLock.createCustomPasscode(
        passcode,
        startDate,
        endDate,
        _lockData!,
        () {
          _showSuccess('密码添加成功');
        },
        (errorCode, errorMsg) {
          _showError(errorCode, errorMsg);
        },
      );
    } catch (e) {
      _showError(TTLockError.fail, '添加密码异常: $e');
    }
  }

  /// 显示修改密码对话框
  void _showModifyPasscodeDialog() {
    final oldPasscodeController = TextEditingController();
    final newPasscodeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('修改密码'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPasscodeController,
              decoration: const InputDecoration(labelText: '原密码'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPasscodeController,
              decoration: const InputDecoration(labelText: '新密码'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              final oldPasscode = oldPasscodeController.text;
              final newPasscode = newPasscodeController.text;
              if (oldPasscode.isEmpty || newPasscode.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('请输入原密码和新密码')),
                );
                return;
              }
              Navigator.pop(context);
              _modifyPasscode(oldPasscode, newPasscode);
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  /// 修改密码
  Future<void> _modifyPasscode(String oldPasscode, String newPasscode) async {
    if (!await _checkLockData()) return;

    _showLoading('正在修改密码...');

    final startDate = DateTime.now().millisecondsSinceEpoch;
    final endDate = startDate + (30 * 24 * 60 * 60 * 1000);

    try {
      TTLock.modifyPasscode(
        oldPasscode,
        newPasscode,
        startDate,
        endDate,
        _lockData!,
        () {
          _showSuccess('密码修改成功');
        },
        (errorCode, errorMsg) {
          _showError(errorCode, errorMsg);
        },
      );
    } catch (e) {
      _showError(TTLockError.fail, '修改密码异常: $e');
    }
  }

  /// 显示删除密码对话框
  void _showDeletePasscodeDialog() {
    final passcodeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除密码'),
        content: TextField(
          controller: passcodeController,
          decoration: const InputDecoration(
            labelText: '请输入要删除的密码',
          ),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              final passcode = passcodeController.text;
              if (passcode.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('请输入要删除的密码')),
                );
                return;
              }
              Navigator.pop(context);
              _deletePasscode(passcode);
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  /// 删除密码
  Future<void> _deletePasscode(String passcode) async {
    if (!await _checkLockData()) return;

    _showLoading('正在删除密码...');

    try {
      TTLock.deletePasscode(
        passcode,
        _lockData!,
        () {
          _showSuccess('密码删除成功');
        },
        (errorCode, errorMsg) {
          _showError(errorCode, errorMsg);
        },
      );
    } catch (e) {
      _showError(TTLockError.fail, '删除密码异常: $e');
    }
  }

  /// 显示卡片管理对话框
  void _showCardDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('卡片管理'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.credit_card_rounded,
                  color: AppTheme.primaryColor),
              title: const Text('添加卡片'),
              subtitle: const Text('请将卡片靠近手机'),
              onTap: () {
                Navigator.pop(context);
                _addCard();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_rounded, color: Colors.red),
              title: const Text('清除所有卡片'),
              onTap: () {
                Navigator.pop(context);
                _clearAllCards();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
        ],
      ),
    );
  }

  /// 添加卡片
  Future<void> _addCard() async {
    if (!await _checkLockData()) return;

    _showLoading('请刷卡...');

    final startDate = DateTime.now().millisecondsSinceEpoch;
    final endDate = startDate + (30 * 24 * 60 * 60 * 1000);

    try {
      TTLock.addCard(
        null,
        startDate,
        endDate,
        _lockData!,
        () {
          _showLoading('等待刷卡...');
        },
        (cardNumber) {
          _showSuccess('卡片添加成功\n卡号: $cardNumber');
        },
        (errorCode, errorMsg) {
          _showError(errorCode, errorMsg);
        },
      );
    } catch (e) {
      _showError(TTLockError.fail, '添加卡片异常: $e');
    }
  }

  /// 清除所有卡片
  Future<void> _clearAllCards() async {
    if (!await _checkLockData()) return;

    _showLoading('正在清除...');

    try {
      TTLock.clearAllCards(
        _lockData!,
        () {
          _showSuccess('所有卡片已清除');
        },
        (errorCode, errorMsg) {
          _showError(errorCode, errorMsg);
        },
      );
    } catch (e) {
      _showError(TTLockError.fail, '清除卡片异常: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final room = widget.room;

    return Scaffold(
      appBar: AppBar(
        title: Text('${room['name']} - 房间详情'),
        centerTitle: true,
        actions: [
          // 刷新设备按钮
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: '重新加载设备',
            onPressed: _showLoadDeviceDialog,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ProgressHud(
        child: Builder(
          builder: (context) {
            _context = context;
            return SingleChildScrollView(
              child: Column(
                children: [
                  // 房间基本信息卡片
                  _buildRoomInfoCard(room),

                  // 操作按钮区域
                  _buildActionButtons(room),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// 房间基本信息卡片
  Widget _buildRoomInfoCard(Map<String, dynamic> room) {
    return Container(
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            room['color'],
            room['color'].withOpacity(0.9),
            room['color'].withOpacity(0.75),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: room['color'].withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // 顶部房间信息区域
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 左侧：房间号大图标
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.meeting_room_rounded,
                    color: room['color'],
                    size: 32,
                  ),
                ),
                const SizedBox(width: 12),

                // 中间：房间名称和类型
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        room['name'],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.0,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.hotel_rounded,
                              color: Colors.white,
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              room['type'],
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // 右侧：房态标签
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: room['color'],
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        _getRoomStatusText(room['status']),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: room['color'],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 底部信息统计条
          Container(
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildInfoStatItem(
                    '楼栋', room['building'] ?? '未设置', Icons.apartment_rounded),
                Container(
                  width: 1,
                  height: 28,
                  color: Colors.white.withOpacity(0.2),
                ),
                _buildInfoStatItem(
                    '楼层', '${room['floor'] ?? 0}层', Icons.layers_rounded),
                Container(
                  width: 1,
                  height: 28,
                  color: Colors.white.withOpacity(0.2),
                ),
                _buildInfoStatItem(
                    '电量', '${room['battery']}%', Icons.battery_full_rounded),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 信息统计项
  Widget _buildInfoStatItem(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white.withOpacity(0.9),
            size: 16,
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              color: Colors.white.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _getRoomStatusText(String status) {
    switch (status) {
      case 'vacant':
        return '空闲';
      case 'rented':
        return '租用';
      case 'maintenance':
        return '维修';
      default:
        return status;
    }
  }

  /// 操作按钮区域
  Widget _buildActionButtons(Map<String, dynamic> room) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 房间设置
          _buildButtonGroup(
            '房间设置',
            [
              {'icon': Icons.settings_rounded, 'label': '设置'},
              {'icon': Icons.link_rounded, 'label': '设备绑定'},
              {'icon': Icons.history_rounded, 'label': '操作记录'},
              {'icon': Icons.delete_rounded, 'label': '删除房间'},
            ],
          ),
          const SizedBox(height: 16),

          // 智能锁控制
          if (room['devices'].contains('lock'))
            _buildButtonGroup(
              '智能锁控制',
              [
                {
                  'icon': Icons.bluetooth_rounded,
                  'label': '蓝牙开锁',
                  'action': _unlock
                },
                {
                  'icon': Icons.battery_full_rounded,
                  'label': '获取电量',
                  'action': _getBatteryLevel
                },
                {
                  'icon': Icons.password_rounded,
                  'label': '密码管理',
                  'action': _showPasscodeDialog
                },
                {
                  'icon': Icons.credit_card_rounded,
                  'label': '发卡管理',
                  'action': _showCardDialog
                },
                {
                  'icon': Icons.history_rounded,
                  'label': '开锁记录',
                  'action': _getOperateRecord
                },
                {'icon': Icons.key_rounded, 'label': '电子钥匙', 'action': null},
                {
                  'icon': Icons.manage_accounts_rounded,
                  'label': '钥匙管理',
                  'action': null
                },
                {
                  'icon': Icons.lock_open_rounded,
                  'label': '常开模式',
                  'action': null
                },
                {'icon': Icons.router_rounded, 'label': '网关管理', 'action': null},
                {
                  'icon': Icons.link_off_rounded,
                  'label': '解除绑定',
                  'action': null
                },
              ],
            ),
          const SizedBox(height: 16),

          // 电源设备控制
          if (room['devices'].contains('light'))
            _buildButtonGroup(
              '电源设备控制',
              [
                {'icon': Icons.power_rounded, 'label': '开锁通电'},
                {'icon': Icons.toggle_on_rounded, 'label': '常开电源'},
                {'icon': Icons.power_off_rounded, 'label': '关闭电源'},
                {'icon': Icons.timer_rounded, 'label': '按时开电'},
                {'icon': Icons.volume_up_rounded, 'label': '语言播报'},
                {'icon': Icons.query_stats_rounded, 'label': '查询状态'},
                {'icon': Icons.history_rounded, 'label': '操作记录'},
                {'icon': Icons.settings_rounded, 'label': '设备设置'},
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildButtonGroup(String title, List<Map<String, dynamic>> buttons) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 6),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
        ),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          mainAxisSpacing: 6,
          crossAxisSpacing: 6,
          childAspectRatio: 0.95,
          children: buttons.map((btn) {
            return _buildActionButton(
              btn['icon']!,
              btn['label']!,
              btn['action'],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback? action) {
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: InkWell(
        onTap: action != null
            ? action
            : () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$label 功能开发中'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 22,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppTheme.textPrimary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
