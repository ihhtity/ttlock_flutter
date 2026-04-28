# 厂商插件系统使用指南

## 📋 概述

本项目采用**插件化架构**，支持多厂商设备对接。每个厂商作为独立插件实现，通过统一的接口进行调用，方便扩展和维护。

## 🏗️ 架构设计

```
┌─────────────────────────────────────┐
│       应用层 (Application)          │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│     厂商管理器 (VendorManager)      │
│  - 插件注册                         │
│  - 厂商切换                         │
│  - 统一接口代理                     │
└──────────────┬──────────────────────┘
               │
    ┌──────────┼──────────┐
    │          │          │
┌───▼───┐ ┌───▼───┐ ┌───▼───┐
│TTLock │ │ BSLD  │ │ Other │
│Plugin │ │Plugin │ │Plugin │
└───────┘ └───────┘ └───────┘
```

## 🚀 快速开始

### 1. 初始化默认厂商

```dart
import 'package:ttlock_flutter/vendor.dart';

// 在应用启动时初始化
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化默认厂商（TTLock）
  await VendorManager().initializeDefault();
  
  runApp(MyApp());
}
```

### 2. 扫描设备

```dart
// 开始扫描
await VendorManager().startScan(
  timeout: Duration(seconds: 10),
  onDeviceFound: (device) {
    print('发现设备: ${device.deviceName}');
    print('MAC地址: ${device.macAddress}');
    print('信号强度: ${device.rssi}');
  },
);

// 停止扫描
await VendorManager().stopScan();
```

### 3. 连接和操作设备

```dart
// 连接设备
final connected = await VendorManager().connectDevice('AA:BB:CC:DD:EE:FF');

if (connected) {
  // 解锁
  await VendorManager().unlock();
  
  // 上锁
  await VendorManager().lock();
  
  // 获取电池电量
  final battery = await VendorManager().getBatteryLevel();
  print('电池电量: $battery%');
}
```

### 4. 密码管理

```dart
// 添加密码
await VendorManager().addPasscode(
  passcode: '123456',
  startDate: DateTime.now(),
  endDate: DateTime.now().add(Duration(days: 30)),
);

// 删除密码
await VendorManager().deletePasscode(12345);

// 修改密码
await VendorManager().modifyPasscode(
  passcodeId: 12345,
  newPasscode: '654321',
  startDate: DateTime.now(),
  endDate: DateTime.now().add(Duration(days: 30)),
);
```

## 🔄 切换厂商

### 当前支持的厂商

- ✅ **TTLock** - 已实现并可用
- ⏳ **BSLD** - 模板已创建，待实现
- ⏳ **Other** - 待添加

### 切换示例

```dart
// 切换到 BSLD 厂商（当实现后）
final success = await VendorManager().switchVendor(VendorType.bsld);

if (success) {
  print('成功切换到 BSLD 厂商');
  
  // 现在所有操作都会使用 BSLD 插件
  await VendorManager().unlock();
} else {
  print('切换失败');
}
```

## 📱 添加新厂商插件

### 步骤 1: 创建插件类

```dart
import 'package:ttlock_flutter/vendor.dart';

class MyVendorPlugin implements IVendorPlugin {
  @override
  VendorType get vendorType => VendorType.other;

  @override
  String get vendorName => 'My Vendor';

  @override
  Future<bool> initialize() async {
    // TODO: 初始化您的厂商 SDK
    return true;
  }

  @override
  Future<void> dispose() async {
    // TODO: 释放资源
  }

  // 实现所有接口方法...
  @override
  Future<bool> unlock({int? eKeyId}) async {
    // TODO: 实现解锁逻辑
    return true;
  }
  
  // ... 其他方法
}
```

### 步骤 2: 注册插件

```dart
// 在 VendorManager 中注册
VendorManager().registerPlugin(MyVendorPlugin());

// 然后可以切换到此厂商
await VendorManager().switchVendor(VendorType.other);
```

### 步骤 3: 更新枚举和配置

在 `vendor_info.dart` 中添加新厂商：

```dart
enum VendorType {
  ttlock,
  bsld,
  myVendor,  // 新增
}

static List<VendorInfo> get availableVendors => [
  // ... 现有厂商
  const VendorInfo(
    type: VendorType.myVendor,
    name: 'myVendor',
    displayName: '我的厂商',
    logo: 'assets/vendors/my_vendor_logo.png',
    isAvailable: true,
  ),
];
```

## 🎯 最佳实践

### 1. 错误处理

```dart
try {
  await VendorManager().unlock();
} catch (e) {
  print('解锁失败: $e');
  // 显示错误提示给用户
}
```

### 2. 检查连接状态

```dart
final isConnected = await VendorManager().isConnected();
if (!isConnected) {
  // 提示用户连接设备
  showConnectDeviceDialog();
  return;
}
```

### 3. 资源释放

```dart
// 在应用退出时释放资源
@override
void dispose() {
  VendorManager().dispose();
  super.dispose();
}
```

### 4. 监听扫描结果

```dart
final devices = <ScanResult>[];

await VendorManager().startScan(
  onDeviceFound: (device) {
    setState(() {
      devices.add(device);
    });
  },
);
```

## 📊 API 参考

### VendorManager 主要方法

| 方法 | 说明 | 返回值 |
|------|------|--------|
| `initializeDefault()` | 初始化默认厂商 | `Future<bool>` |
| `switchVendor(type)` | 切换厂商 | `Future<bool>` |
| `startScan()` | 开始扫描 | `Future<void>` |
| `stopScan()` | 停止扫描 | `Future<void>` |
| `connectDevice(mac)` | 连接设备 | `Future<bool>` |
| `disconnectDevice()` | 断开连接 | `Future<void>` |
| `unlock()` | 解锁 | `Future<bool>` |
| `lock()` | 上锁 | `Future<bool>` |
| `addPasscode()` | 添加密码 | `Future<bool>` |
| `getBatteryLevel()` | 获取电量 | `Future<int>` |

### 完整 API 列表

查看 `IVendorPlugin` 接口定义获取所有可用方法。

## 🔧 Android/iOS 原生集成

### Android

每个厂商需要在 `android/` 目录下创建独立的模块：

```
android/
├── src/main/java/com/ttlock/    # TTLock 实现
├── src/main/java/com/bsld/      # BSLD 实现（待添加）
└── src/main/java/com/other/     # 其他厂商（待添加）
```

### iOS

每个厂商需要在 `ios/Classes/` 目录下创建独立的文件夹：

```
ios/Classes/
├── TTLock/      # TTLock 实现
├── BSLD/        # BSLD 实现（待添加）
└── Other/       # 其他厂商（待添加）
```

## ❓ 常见问题

### Q: 如何知道当前使用的是哪个厂商？

```dart
final vendorType = VendorManager().currentVendorType;
final vendorName = VendorManager().currentVendorName;
print('当前厂商: $vendorName ($vendorType)');
```

### Q: 切换厂商会影响已连接的设备吗？

是的，切换厂商会自动断开当前连接并释放资源。建议在切换前确保没有正在进行的操作。

### Q: 可以同时使用多个厂商吗？

不可以同时激活多个厂商，但可以注册多个厂商并随时切换。

### Q: BSLD 厂商什么时候可用？

BSLD 插件模板已创建，需要等待 BSLD 厂商提供 Android/iOS SDK 后完成实现。

## 📝 更新日志

- **2026-04-28**: 初始版本，支持 TTLock 厂商，BSLD 模板就绪

## 🤝 贡献指南

欢迎添加新的厂商插件！请遵循以下步骤：

1. Fork 本仓库
2. 创建新厂商插件类
3. 实现 `IVendorPlugin` 接口
4. 提交 Pull Request

## 📄 许可证

MIT License
