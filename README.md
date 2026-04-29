## Developers Email list
ttlock-developers-email-list@googlegroups.com

---

## 📱 Flutter App + Go Backend 完整项目

### 项目简介
这是一个完整的智能锁管理系统，包含：
- **Flutter Mobile App** - 跨平台移动应用（Android & iOS）
- **Go Backend API** - 高性能后端服务
- **MySQL Database** - 数据存储
- **Redis Cache** - 缓存层

### 快速开始

#### 1. 启动Go后端
```bash
cd backend
go mod tidy
mysql -u root -p123456 device_flutter < scripts/init_db.sql
go run cmd/server/main.go -config configs/config.yaml
```

#### 2. 运行Flutter App
```bash
cd example
flutter pub get
flutter run
```

#### 3. 测试登录
- 手机号: `13800138000`
- 密码: `123456`

### 详细文档
- [Flutter与后端对接指南](FLUTTER_BACKEND_INTEGRATION.md)
- [页面更新报告](FLUTTER_PAGE_UPDATE_REPORT.md)
- [后端开发指南](backend/DEVELOPMENT_GUIDE.md)
- [后端更新总结](backend/FINAL_UPDATE_v0.4.md)

### 已完成功能
✅ 用户认证（登录/注册）
✅ 房间管理（列表/添加/筛选/搜索）
✅ 设备管理（列表/筛选/搜索）
✅ 分组管理（API已就绪）
✅ 统一HTTP客户端
✅ Token自动管理
✅ 错误处理和加载状态
✅ 自动化测试套件
✅ 用户协议同意状态持久化（按设备记忆）
✅ 认证请求详细错误日志打印（2026-04-29）

### 运行测试

#### 方式1：一键运行所有测试
```bash
# Windows
run_tests.bat

# macOS/Linux
./run_tests.sh
```

#### 方式2：单独运行测试
```bash
# Go后端测试
cd backend
go test -v ./...

# Flutter测试
cd example
flutter test

# API集成测试
test_api.bat
```

详见：[自动化测试指南](TESTING_GUIDE.md)

### 更新日志

#### 2026-04-29 - 修复注册页面 LoginType 类型错误
**问题：** `type 'Null' is not a subtype of type 'LoginType' of 'function result'`

**原因：** Dart 三元运算符在字符串插值中可能产生类型推断问题

**修复：**
- ✅ `register_page.dart` - 为 `widget.loginType` 的三元运算添加括号，确保类型安全
- ✅ 修改前：`${widget.loginType == LoginType.admin ? 1 : 0}`
- ✅ 修改后：`${(widget.loginType == LoginType.admin) ? 1 : 0}`

#### 2026-04-29 - 增强认证请求错误日志
**前端修改：**
- ✅ `auth_service.dart` - 为所有认证方法添加详细错误日志，包括请求参数、响应数据和堆栈信息
- ✅ `login_page.dart` - 在登录失败时打印详细的错误信息和堆栈跟踪
- ✅ `register_page.dart` - 在注册和发送验证码失败时打印详细错误信息
- ✅ `forgot_password_page.dart` - 在找回密码相关操作失败时打印详细错误信息

**后端修改：**
- ✅ `auth_handler.go` - 增强所有认证接口的日志记录，使用 zap logger 记录详细的请求参数和错误信息

**改进内容：**
- 所有认证请求失败时都会在终端打印详细的错误信息
- 包含请求参数、响应代码、错误消息和堆栈跟踪
- 便于调试和排查问题

### 技术栈
- **Frontend**: Flutter, Dart
- **Backend**: Go, Gin Framework
- **Database**: MySQL 8.0, Redis
- **Architecture**: RESTful API, JWT Authentication

---

### ttlock_flutter



##### Config

iOS: 
1. In XCode,Add Key`Privacy - Bluetooth Peripheral Usage Description` Value `your description for bluetooth` to your project's `info` ➜ `Custom iOS Target Projectes`

Android:
AndroidManifest.xml configuration:
1. add 'xmlns:tools="http://schemas.android.com/tools"' to <manifest> element
2. add 'tools:replace="android:label"' to <application> element
3. additional permissions:
```  
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
<uses-permission android:name="android.permission.BLUETOOTH" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
```
4. in MainActivity extends FlutterActivity, you need add permissions result to ttlock plugin. 
       
first add import

```
import com.ttlock.ttlock_flutter.TtlockFlutterPlugin
```

second add below callback code:   
java code:

```
@Override
public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        TtlockFlutterPlugin ttlockflutterpluginPlugin = (TtlockFlutterPlugin) getFlutterEngine().getPlugins().get(TtlockFlutterPlugin.class);
        if (ttlockflutterpluginPlugin != null) {
            ttlockflutterpluginPlugin.onRequestPermissionsResult(requestCode, permissions, grantResults);
        }
    }
```
kotlin code:
```
override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String>, grantResults: IntArray) {
        val ttlockflutterpluginPlugin = flutterEngine!!.plugins[TtlockFlutterPlugin::class.java] as TtlockFlutterPlugin?
        ttlockflutterpluginPlugin?.onRequestPermissionsResult(requestCode, permissions, grantResults)
    }
```

5.you need config buildTypes in build.gradle file.like this:

```
    buildTypes {
        release {
            minifyEnabled false
            shrinkResources false
        }
    }
```

##### Ussage
```
import 'package:ttlock_flutter/ttlock.dart';

// Print TTLock Log
TTLock.printLog = true;

TTLock.controlLock(lockData, TTControlAction.unlock,(lockTime, electricQuantity, uniqueId) {
    print('success');
}, (errorCode, errorMsg) {
    print('errorCode');      
});
```
If you want to get log and set time immediately after unlocking, you can do the following:

```
void unlockAndGetLogAndSetTime() {

     //unlock
    TTLock.controlLock(lockData, TTControlAction.unlock,(lockTime, electricQuantity, uniqueId) {
        print('success');
    }, (errorCode, errorMsg) {
        print('errorCode');      
    });
    
     //get log
    TTLock.getLockOperateRecord(TTOperateRecordType.latest, lockData,(operateRecord) {
        print('$operateRecord');
    }, (errorCode, errorMsg) {
        print('errorCode');
    });
     //set time
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    TTLock.setLockTime(timestamp, lockData, () {
        print('$timestamp');
    }, (errorCode, errorMsg) {
        print('errorCode');
    });
}

```
##### How to determine the function of a lock
```
 TTLock.supportFunction(TTLockFuction.managePasscode, lockData,(isSupport) {
    if (isSupport) {
        TTLock.modifyPasscode("6666", "7777", startDate, endDate, lockData,() {
            print('success');
        }, (errorCode, errorMsg) {
            print('errorCode');
        });
    } else {
        print('Not support modify passcode');
    }
});
```




