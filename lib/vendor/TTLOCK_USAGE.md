# TTLock 厂商插件使用指南

## 📖 概述

`TTLockPlugin` 是基于 `lib/ttlock/` 目录下的 TTLock SDK 实现的厂商插件，提供了统一的接口来控制 TTLock 智能锁设备。

## 🚀 快速开始

### 1. 初始化插件

```dart
import 'package:ttlock_flutter/vendor.dart';

// 获取 TTLock 插件实例
final ttlockPlugin = TTLockPlugin();

// 初始化插件
await ttlockPlugin.initialize();
```

### 2. 扫描设备

```dart
// 开始扫描
await ttlockPlugin.startScan(
  onDeviceFound: (device) {
    print('发现设备: ${device.deviceName}');
    print('MAC 地址: ${device.macAddress}');
    print('信号强度: ${device.rssi}');
  },
);

// 停止扫描
await ttlockPlugin.stopScan();
```

### 3. 初始化锁

```dart
// 从服务器获取锁数据后初始化
// lockData 格式: {"lockMac": "xx:xx:xx:xx:xx:xx", "lockVersion": "x.x", "isInited": true}
final result = await ttlockPlugin.initLock(lockData);

if (result['success'] == true) {
  print('锁初始化成功');
  // 插件会自动保存 lockData 供后续操作使用
}
```

### 4. 控制锁

#### 解锁

```dart
final success = await ttlockPlugin.unlock();
if (success) {
  print('解锁成功');
} else {
  print('解锁失败');
}
```

#### 上锁

```dart
final success = await ttlockPlugin.lock();
if (success) {
  print('上锁成功');
}
```

### 5. 密码管理

#### 添加密码

```dart
final success = await ttlockPlugin.addPasscode(
  passcode: '123456',
  startDate: DateTime.now(),
  endDate: DateTime.now().add(Duration(days: 30)),
);

if (success) {
  print('密码添加成功');
}
```

#### 删除密码

```dart
// 注意: passcodeId 应该是密码字符串
final success = await ttlockPlugin.deletePasscode(123456);
if (success) {
  print('密码删除成功');
}
```

#### 修改密码

```dart
final success = await ttlockPlugin.modifyPasscode(
  passcodeId: 123456, // 原始密码
  newPasscode: '654321',
  startDate: DateTime.now(),
  endDate: DateTime.now().add(Duration(days: 30)),
);

if (success) {
  print('密码修改成功');
}
```

### 6. 其他操作

#### 获取电池电量

```dart
final batteryLevel = await ttlockPlugin.getBatteryLevel();
print('电池电量: $batteryLevel%');
```

#### 获取固件版本

```dart
final version = await ttlockPlugin.getFirmwareVersion();
print('固件版本: $version');
```

#### 恢复出厂设置

```dart
final success = await ttlockPlugin.factoryReset();
if (success) {
  print('恢复出厂设置成功');
}
```

## 🔧 高级用法

### 手动设置锁数据

如果您已经从其他地方获取了锁数据，可以手动设置：

```dart
ttlockPlugin.setCurrentLockData(lockData);
```

### 通过 VendorManager 使用

推荐使用 `VendorManager` 来管理多个厂商插件：

```dart
import 'package:ttlock_flutter/vendor.dart';

// 注册 TTLock 插件
VendorManager().registerPlugin(TTLockPlugin());

// 切换到 TTLock 厂商
await VendorManager().switchVendor(VendorType.ttlock);

// 使用统一接口操作
await VendorManager().unlock();
await VendorManager().lock();
```

## ⚠️ 注意事项

1. **锁数据管理**: 
   - 所有锁操作都需要先调用 `initLock()` 或手动设置 `setCurrentLockData()`
   - 插件会自动更新 lockData，无需手动维护

2. **异步操作**:
   - 所有方法都是异步的，需要使用 `await` 等待结果
   - 建议在 try-catch 块中调用以捕获异常

3. **蓝牙连接**:
   - TTLock 基于蓝牙通信，确保手机蓝牙已开启
   - 设备需要在蓝牙范围内

4. **密码格式**:
   - 密码必须是 4-9 位数字
   - 删除和修改密码时需要传入密码字符串，不是 ID

## 📝 API 参考

| 方法 | 说明 | 返回值 |
|------|------|--------|
| `initialize()` | 初始化插件 | `Future<bool>` |
| `startScan()` | 开始扫描设备 | `Future<void>` |
| `stopScan()` | 停止扫描 | `Future<void>` |
| `initLock(lockData)` | 初始化锁 | `Future<Map>` |
| `unlock()` | 解锁 | `Future<bool>` |
| `lock()` | 上锁 | `Future<bool>` |
| `addPasscode(...)` | 添加密码 | `Future<bool>` |
| `deletePasscode(id)` | 删除密码 | `Future<bool>` |
| `modifyPasscode(...)` | 修改密码 | `Future<bool>` |
| `getBatteryLevel()` | 获取电量 | `Future<int>` |
| `getFirmwareVersion()` | 获取版本 | `Future<String>` |
| `factoryReset()` | 恢复出厂 | `Future<bool>` |

## 🐛 常见问题

### Q: 为什么操作失败？
A: 请检查：
- 是否已正确初始化锁
- 蓝牙是否开启
- 设备是否在范围内
- lockData 是否正确

### Q: 如何获取 lockData？
A: lockData 通常从您的服务器获取，包含锁的 MAC 地址、版本等信息。

### Q: 支持哪些设备？
A: 目前仅支持 TTLock 品牌的智能锁设备。

## 📞 技术支持

如有问题，请参考：
- [VENDOR_PLUGIN_GUIDE.md](../VENDOR_PLUGIN_GUIDE.md) - 厂商插件系统总览
- TTLock 官方文档
