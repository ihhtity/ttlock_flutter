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

#### 2026-04-30 - 添加中文输入检测，禁止账号密码验证码包含中文字符
**功能优化：**
- ✅ 登录页面：账号和密码不能包含中文字符
- ✅ 注册页面：账号、密码、确认密码、验证码都不能包含中文字符
- ✅ 忘记密码页面：账号和验证码不能包含中文字符
- ✅ 提供清晰的错误提示

**前端修改：**
- ✅ `example/lib/pages/auth/login_page.dart`
  - 添加 `_containsChinese` 方法检测中文字符
  - 登录前检查账号和密码是否包含中文
  
- ✅ `example/lib/pages/auth/register_page.dart`
  - 添加 `_containsChinese` 方法检测中文字符
  - 注册前检查所有输入字段是否包含中文
  
- ✅ `example/lib/pages/auth/forgot_password_page.dart`
  - 添加 `_containsChinese` 方法检测中文字符
  - 找回密码前检查账号和验证码是否包含中文

**技术改进：**
- 🎯 使用正则表达式全面匹配中文字符（包括简体、繁体）
- 🎯 在提交前进行验证，避免无效请求
- 🎯 统一错误提示，用户体验友好
- 🎯 防止数据库存储异常字符

#### 2026-04-30 - 更新前端测试默认数据
**功能优化：**
- ✅ 登录页面默认数据：手机号 13277751142、密码 12345678、邮箱 2794159940@qq.com
- ✅ 注册页面默认数据：手机号 13277751142、密码 l12345678、确认密码 l12345678、验证码 123456、邮箱 ihhtity@qq.com
- ✅ 忘记密码页面默认数据：手机号 13277751142、邮箱 2794159940@qq.com、验证码 123456

**前端修改：**
- ✅ `example/lib/pages/auth/login_page.dart`
  - 更新默认手机号、密码、邮箱
  
- ✅ `example/lib/pages/auth/register_page.dart`
  - 更新默认手机号、邮箱、密码、确认密码、验证码
  
- ✅ `example/lib/pages/auth/forgot_password_page.dart`
  - 更新默认手机号、邮箱、验证码

**技术改进：**
- 🎯 方便开发和测试，无需每次手动输入测试数据
- 🎯 统一测试账号，便于团队协作

#### 2026-04-30 - 完善管理端注册验证码状态标记
**功能优化：**
- ✅ 管理端注册成功后，标记验证码为“已使用”
- ✅ 用户端和管理端注册逻辑完全一致
- ✅ 验证码状态管理覆盖所有场景

**后端修改：**
- ✅ `backend/internal/service/auth_service.go`
  - registerAdmin 方法添加验证码标记逻辑
  - 注册成功后查找并标记验证码为已使用（type=1）
  - 与 registerClient 保持完全一致的处理流程

**验证码状态管理规则：**
- 📌 **未使用 (status=0)**：
  - 验证码创建时的初始状态
  - 验证时只检查，不改变状态
  - 如果注册/找回密码失败，保持未使用，用户可以重新尝试
  
- 📌 **已使用 (status=1)**：
  - 用户端注册成功后标记
  - 管理端注册成功后标记
  - 密码重置成功后标记
  - 密码找回成功后标记
  
- 📌 **已过期 (status=2)**：
  - 超过5分钟有效期后，查询时自动标记
  - 发送新验证码时，旧验证码自动标记为已过期

**技术改进：**
- 🎯 管理端和用户端验证码处理逻辑完全对称
- 🎯 验证码状态流转清晰，符合业务需求
- 🎯 失败的请求不消耗验证码，提升用户体验
- 🎯 自动过期机制保证数据准确性

#### 2026-04-30 - 修复管理端注册空指针异常
**问题分析：**
- ❌ 管理端注册成功后返回“服务器错误”，用户端注册正常
- ❌ 原因：日志记录时直接解引用可能为 nil 的 `req.Phone` 和 `req.Email`
- ❌ 当用户使用邮箱注册时，`req.Phone` 为 nil，导致 panic

**修复内容：**
- ✅ `backend/internal/service/auth_service.go`
  - registerAdmin 方法添加安全的 nil 检查
  - 先判断 Phone 和 Email 是否为 nil，再解引用
  - 与 registerClient 保持一致的处理逻辑

**技术改进：**
- 🎯 避免空指针解引用导致的 panic
- 🎯 管理端和用户端注册逻辑更加一致
- 🎯 提高代码健壮性

#### 2026-04-30 - 优化管理端登录逻辑，支持国家/地区自动更新
**功能优化：**
- ✅ 管理端登录时检查并更新国家/地区信息（如果不一致）
- ✅ 管理端和用户端登录逻辑统一，都支持国家/地区自动更新
- ✅ 前端上传参数：用户类型、手机号/邮箱、密码、国家/地区
- ✅ 后端根据用户类型访问不同的表（admins或clients）
- ✅ 通过手机号或邮箱自动识别账号

**后端修改：**
- ✅ `backend/internal/repository/admin_repo.go`
  - 新增 `UpdateCountry` 方法：更新管理员的国家/地区信息
  
- ✅ `backend/internal/service/auth_service.go`
  - `loginAdminByPhoneOrEmail` 方法添加 country、dialCode 参数
  - 登录时检查管理员的国家/地区是否与数据库一致
  - 如果不一致，自动更新为前端传递的实际值
  - 更新失败不影响登录流程，只记录警告日志

**技术改进：**
- 🎯 管理端和用户端登录逻辑完全对称
- 🎯 国家/地区信息实时同步，保证数据准确性
- 🎯 登录流程更加智能，自动维护用户信息
- 🎯 错误处理更加健壮，非关键错误不影响主流程

#### 2026-04-30 - 优化用户表结构
**数据库优化：**
- ✅ 管理端用户表（admins）添加 `country`（国家代码）和 `dial_code`（电话区号）字段
- ✅ 用户端用户表（clients）删除 `phone_bound`、`email_bound`、`is_vendor` 字段
- ✅ 简化表结构，移除冗余字段

**后端修改：**
- ✅ `backend/scripts/optimize_user_tables.sql` - 新增数据库迁移脚本
- ✅ `backend/scripts/init_db.sql` - 更新建表脚本
  - admins 表添加 country、dial_code 字段
  - clients 表删除 phone_bound、email_bound、is_vendor 字段
  
- ✅ `backend/internal/model/user.go`
  - Admin 模型添加 Country、DialCode 字段
  - Client 模型删除 PhoneBound、EmailBound、IsVendor 字段
  
- ✅ `backend/internal/repository/admin_repo.go`
  - FindByUsername、FindByPhone、FindByEmail 方法添加 country、dial_code 查询
  - Create 方法添加 country、dial_code 插入
  
- ✅ `backend/internal/repository/user_repo.go`
  - FindByPhone、FindByEmail 方法移除 phone_bound、email_bound、is_vendor 查询
  - Create 方法移除 phone_bound、email_bound、is_vendor 插入
  
- ✅ `backend/internal/service/auth_service.go`
  - registerAdmin 方法添加 country、dial_code 处理逻辑
  - registerClient 方法移除 phone_bound、email_bound、is_vendor 处理逻辑

**技术改进：**
- 🎯 表结构更加简洁，减少不必要的字段
- 🎯 管理端和用户端都支持国家/地区信息
- 🎯 注册逻辑更加清晰，只保留必要字段
- 🎯 前后端数据模型保持一致

#### 2026-04-30 - 优化验证码状态管理逻辑
**功能优化：**
- ✅ 验证码状态流转更加清晰：未使用(0) → 已使用(1) / 已过期(2)
- ✅ 注册成功后才标记验证码为“已使用”，失败则保持“未使用”
- ✅ 密码重置/找回成功后才标记验证码为“已使用”，失败则保持“未使用”
- ✅ 查询验证码时自动检查并更新已过期的验证码状态为“已过期”
- ✅ 发送新验证码时，自动将同一账号的旧验证码标记为“已过期”

**后端修改：**
- ✅ `backend/internal/repository/verification_repo.go`
  - 新增 `ExpireExpiredCodes` 方法：批量将所有已过期的验证码标记为已过期
  - 在 `FindValidCode` 方法中调用 `ExpireExpiredCodes`，确保查询时自动更新过期状态
  
**状态管理逻辑：**
- 📌 **未使用 (status=0)**：验证码刚创建时的初始状态
- 📌 **已使用 (status=1)**：注册/密码重置/找回密码成功后标记
- 📌 **已过期 (status=2)**：
  - 超过5分钟有效期后自动标记
  - 发送新验证码时，旧验证码自动标记为已过期

**技术改进：**
- 🎯 验证码状态更新时机更加合理，只在业务成功后才标记为已使用
- 🎯 失败的请求不会消耗验证码，用户可以重新尝试
- 🎯 自动过期机制保证数据库中的验证码状态准确性
- 🎯 避免验证码被重复使用，提高安全性

#### 2026-04-30 - 优化管理端和用户端登录注册逻辑
**功能优化：**
- ✅ 前端上传参数增加：用户类型（区分管理端、用户端）、国家/地区代码、电话区号
- ✅ 后端根据用户类型自动访问不同的用户表（admins表或clients表）
- ✅ 登录时根据手机号或邮箱自动识别账号，无需手动选择
- ✅ 登录时如果国家/地区与数据库不一致，自动更新为实际值
- ✅ 注册时同样支持用户类型和国家/地区信息

**后端修改：**
- ✅ `backend/internal/model/user.go`
  - LoginRequest 添加 user_type、country、dial_code 字段
  
- ✅ `backend/internal/service/auth_service.go`
  - Login 方法签名修改，增加 userType、country、dialCode 参数
  - 新增 loginAdminByPhoneOrEmail 方法：管理员登录（通过手机号或邮箱）
  - 新增 loginClientByPhoneOrEmail 方法：客户端用户登录（通过手机号或邮箱）
  - 登录时检查并更新国家/地区信息（如果不一致）
  
- ✅ `backend/internal/repository/user_repo.go`
  - 新增 UpdateCountry 方法：更新用户的国家/地区信息
  
- ✅ `backend/internal/handler/auth_handler.go`
  - Login handler 传递新的参数到 service 层
  - 日志记录增加 user_type、country、dial_code 信息

**前端修改：**
- ✅ `example/lib/utils/auth_service.dart`
  - login 方法增加 country、dialCode 参数（默认 CN、+86）
  - 请求体添加 user_type、country、dial_code 字段
  - register 方法改用 loginType 参数替代 registerType
  
- ✅ `example/lib/pages/auth/login_page.dart`
  - 登录时传递当前选择的国家代码和区号
  
- ✅ `example/lib/pages/auth/register_page.dart`
  - 注册时使用 loginType 参数

**技术改进：**
- 🎯 前后端字段统一，优先匹配数据库结构
- 🎯 登录流程更智能，自动识别用户类型和登录方式
- 🎯 国家/地区信息实时同步，保证数据准确性
- 🎯 代码结构更清晰，职责分离更明确

#### 2026-04-30 - 优化后端认证逻辑和错误返回
**优化内容：**
- ✅ 统一错误提示语，更加友好和明确
- ✅ 完善参数验证，提前拦截无效请求
- ✅ 优化日志记录，区分 Info/Warn/Error 级别
- ✅ 增强错误上下文信息，便于问题排查

**登录功能优化：**
- ✅ 添加密码非空验证
- ✅ 添加手机号/邮箱非空验证
- ✅ 优化错误提示：
  - “密码不能为空”
  - “手机号或邮箱不能为空”
  - “账号不存在，请先注册”
  - “密码错误，请重新输入”
  - “账号已被禁用，请联系管理员/客服”
- ✅ 登录成功日志增加昵称信息
- ✅ 登录失败使用 Warn 级别日志（而非 Error）

**注册功能优化：**
- ✅ 添加密码非空验证
- ✅ 添加昵称非空验证
- ✅ 优化重复注册提示：
  - “该手机号已被注册，请直接登录”
  - “该邮箱已被注册，请直接登录”
- ✅ 注册失败日志增加详细信息
- ✅ 移除冗余的重复验证逻辑

**验证码发送优化：**
- ✅ 注册时同时检查客户端和管理员表
- ✅ 找回密码时验证用户是否存在
- ✅ 优化错误提示：
  - “该手机号/邮箱已被注册，请直接登录”
  - “该账号不存在，请先注册”
  - “发送邮件验证码失败，请检查邮箱地址”
  - “发送验证码失败，请稍后重试”

**验证码验证优化：**
- ✅ 添加验证码非空验证
- ✅ 添加手机号/邮箱非空验证
- ✅ 优化错误提示：
  - “验证码不能为空”
  - “手机号或邮箱不能为空”
  - “验证码无效或已过期，请重新获取”
  - “验证码错误，请重新输入”
  - “服务器错误，请稍后重试”

**密码重置优化：**
- ✅ 添加新密码非空验证
- ✅ 添加密码长度验证（至少6位）
- ✅ 优化错误提示：
  - “新密码不能为空”
  - “密码长度至少为6位”
  - “重置密码失败，请稍后重试”
- ✅ 更新密码失败日志增加用户ID

**密码找回优化：**
- ✅ 查询失败日志增加详细错误信息
- ✅ 优化错误提示：“服务器错误，请稍后重试”
- ✅ 密码找回成功日志增加详细信息

**Handler 层优化：**
- ✅ 统一参数错误提示：“请求参数错误，请检查输入”
- ✅ 业务失败使用 Warn 级别日志（而非 Error）
- ✅ 所有失败日志增加 `reason` 字段记录具体原因
- ✅ 成功日志增加更多上下文信息（昵称、类型等）
- ✅ 日志格式标准化，便于日志分析

**技术改进：**
- 📊 日志级别合理化：
  - Info: 正常业务流程（登录成功、注册成功等）
  - Warn: 业务失败但非系统错误（密码错误、验证码错误等）
  - Error: 系统级错误（数据库错误、服务器错误等）
- 🔍 错误追踪更清晰：每个失败都记录具体原因
- 💬 用户体验提升：错误提示更加友好和明确
- 🛡️ 参数验证前置：减少不必要的数据库查询

#### 2026-04-30 - 忘记密码改为找回密码功能
**功能改进：**
- ✅ 将“重置密码”改为“找回密码”
- ✅ 验证通过后直接返回明文密码，无需设置新密码
- ✅ 添加密码显示/隐藏切换功能
- ✅ 添加一键复制密码到剪贴板功能
- ✅ 优化UI界面，增加密码找回成功提示卡片

**后端修改：**
- ✅ `backend/internal/model/verification.go`
  - 新增 `RetrievePasswordRequest` 模型
  
- ✅ `backend/internal/service/verification_service.go`
  - 新增 `RetrievePassword` 方法，返回明文密码
  - 验证成功后标记验证码为已使用
  
- ✅ `backend/internal/handler/auth_handler.go`
  - 新增 `RetrievePassword` handler
  - 返回包含密码的 JSON 响应
  
- ✅ `backend/internal/router/router.go`
  - 注册新路由 `/api/v1/auth/retrieve-password`

**前端修改：**
- ✅ `example/lib/utils/auth_service.dart`
  - 新增 `retrievePassword` 方法
  - 调用后端 `/auth/retrieve-password` API
  - 返回密码字符串
  
- ✅ `example/lib/pages/auth/forgot_password_page.dart`
  - 移除新密码输入框和密码强度验证
  - 移除 `_newPasswordController`
  - 新增 `_retrievedPassword` 和 `_isPasswordVisible` 状态
  - 新增 `_retrievePassword` 方法替代 `_resetPassword`
  - 新增 `_copyPassword` 方法实现复制功能
  - 添加密码显示区域（带渐变背景和边框）
  - 添加密码可见性切换按钮
  - 添加复制密码按钮（绿色主题）
  - 添加提示信息：“请妥善保管您的密码，建议立即复制并保存”

**UI特性：**
- 🎨 密码找回成功卡片采用绿色渐变背景
- 🎨 密码显示区域使用等宽字体（monospace）
- 🎨 默认隐藏密码（显示为 ••••••••）
- 🎨 点击眼睛图标切换密码可见性
- 🎨 复制成功后显示 SnackBar 提示
- 🎨 响应式布局，适配不同屏幕尺寸

**用户体验：**
- 用户输入手机号/邮箱 → 发送验证码 → 输入验证码 → 点击“找回密码”
- 系统验证通过后直接显示密码
- 用户可以查看、复制密码
- 无需记忆新密码，直接使用原密码登录

#### 2026-04-30 - 密码改为明文存储（仅用于开发调试）
**⚠️ 重要警告：此修改仅用于开发环境，生产环境严禁使用明文密码！**

**修改内容：**
- ✅ 移除所有 bcrypt 密码加密逻辑
- ✅ 管理员和用户密码改为明文存储和验证
- ✅ 方便开发调试时查看和验证密码

**后端修改：**
- ✅ `backend/internal/repository/admin_repo.go`
  - 移除 `bcrypt` 导入
  - `VerifyPassword` 改为明文对比
  - `Create` 方法直接存储明文密码
  - `UpdatePassword` 方法直接存储明文密码
  
- ✅ `backend/internal/repository/user_repo.go`
  - 移除 `bcrypt` 导入
  - `VerifyPassword` 改为明文对比
  - `Create` 方法直接存储明文密码
  - `UpdatePassword` 方法直接存储明文密码

**数据库修改：**
- ✅ 执行 `backend/scripts/reset_passwords_to_plaintext.sql`
- ✅ 重置所有管理员密码为明文：
  - admin: `123456`
  - operator: `admin123`
  - 19830357494: `123456`
  - ihhtity@qq.com: `test123456`
- ✅ 重置所有用户密码为明文：
  - 19830357494 (张三): `user1@test.com`
  - 13900139000 (李四): `user2@test.com`
  - 13700137000 (厂商代表): `vendor1@test.com`
  - ihhtity@qq.com: `test123456`

**测试账号信息：**
```
管理端：
- 用户名: admin, 密码: 123456
- 用户名: operator, 密码: admin123
- 手机号: 19830357494, 密码: 123456
- 邮箱: ihhtity@qq.com, 密码: test123456

用户端：
- 手机号: 19830357494, 密码: user1@test.com
- 手机号: 13900139000, 密码: user2@test.com
- 手机号: 13700137000, 密码: vendor1@test.com
- 邮箱: ihhtity@qq.com, 密码: test123456
```

**技术说明：**
- ⚠️ 此修改仅用于开发调试，便于查看密码是否正确
- ⚠️ 生产环境必须恢复 bcrypt 加密
- ⚠️ 所有新注册和修改密码都将使用明文存储

#### 2026-04-30 - 修复密码重置验证失败问题
**问题分析：**
- ❌ 使用邮箱重置密码时报错 `密码重置失败 [400]: 验证失败`
- ❌ Gin 框架的 `required_without` 验证规则无法正确处理空字符串
- ❌ 前端传递 `phone=null` 时，Go 接收为空字符串 `""`，导致验证失败

**解决方案：**
- ✅ 移除 `ResetPasswordRequest` 中的 `binding:"required_without=Email/Phone"` 验证标签
- ✅ 在 handler 中手动验证 phone 或 email 至少有一个不为空
- ✅ 提供更清晰的错误提示信息

**修改文件：**
- ✅ `backend/internal/model/verification.go`
  - 移除 Phone 和 Email 字段的 binding 验证标签
  - 允许字段为空字符串，由 handler 层进行验证
  
- ✅ `backend/internal/handler/auth_handler.go`
  - 添加手动验证逻辑：检查 phone 和 email 不能同时为空
  - 提供更明确的错误提示

**技术改进：**
- ✅ 避免 Gin 验证器对空字符串的错误判断
- ✅ 提高代码可读性和可维护性
- ✅ 支持手机号或邮箱任意一种方式重置密码

#### 2026-04-30 - 个人中心退出登录返回登录选择页面
**功能优化：**
- ✅ 管理端个人中心退出登录 → 返回到登录选择页面（LoginEntryPage）
- ✅ 用户端个人中心退出登录 → 返回到登录选择页面（LoginEntryPage）
- ✅ 统一退出登录行为，用户体验更一致

**修改文件：**
- ✅ `example/lib/pages/admin/profile/profile_page.dart`
  - 导入 `LoginEntryPage` 替代 `LoginPage`
  - 退出登录时跳转到 `LoginEntryPage`
  - 清除所有路由栈
  
- ✅ `example/lib/pages/user/profile_page.dart`
  - 导入 `LoginEntryPage` 替代 `LoginPage`
  - 退出登录时跳转到 `LoginEntryPage`
  - 清除所有路由栈

**技术改进：**
- ✅ 删除不必要的 `LoginType` 参数传递
- ✅ 简化代码逻辑，提高可维护性
- ✅ 用户可以在登录选择页面重新选择管理端或用户端

#### 2026-04-30 - 修复登录页面返回按钮黑屏问题
**问题分析：**
- ❌ 当登录页面是路由栈的第一个页面时，点击返回按钮会导致黑屏
- ❌ 之前使用 `pushAndRemoveUntil` 强制清除路由栈并跳转到登录选择页面
- ❌ 如果用户直接从登录页启动应用（没有经过登录选择页），会导致异常

**解决方案：**
- ✅ 使用 `Navigator.canPop(context)` 检查是否有路由可以返回
- ✅ 只有当路由栈不为空时才显示返回按钮
- ✅ 当路由栈为空时，返回按钮设置为 `null`（不显示）
- ✅ 避免在栈底页面点击返回导致的黑屏问题

**修改文件：**
- ✅ `example/lib/pages/auth/login_page.dart`
  - 将自定义的返回按钮逻辑改为条件显示
  - 简化返回逻辑，直接使用 `Navigator.pop()`
  - 删除不必要的 `LoginEntryPage` 导入和复杂的路由清除逻辑

**技术改进：**
- ✅ 遵循 Flutter 最佳实践，使用 `Navigator.canPop()` 检查路由状态
- ✅ 保持代码简洁，减少不必要的路由操作
- ✅ 提升用户体验，避免异常情况下的黑屏问题

#### 2026-04-30 - 登录页面和个人中心导航优化
**登录页面优化：**
- ✅ 添加 AppBar 导航栏
- ✅ 返回按钮始终显示（无论路由栈状态）
- ✅ 点击返回按钮先清除所有路由栈
- ✅ 然后返回到登录选择页面（LoginEntryPage）
- ✅ 标题根据登录类型显示（管理端/用户端）
- ✅ AppBar 背景色根据登录类型变化（蓝色/绿色）
- ✅ 减少顶部间距（40px → 20px）
- ✅ **修复退出登录后返回按钮导致黑屏的问题**
  - 使用 `pushAndRemoveUntil` 清空路由栈
  - 确保始终返回到登录选择页面
  - 避免在路由栈为空时调用 `pop()` 导致黑屏

**退出登录优化：**
- ✅ 管理端退出登录 → 跳转到管理端登录页面
- ✅ 用户端退出登录 → 跳转到用户端登录页面
- ✅ 使用 `pushAndRemoveUntil` 清除路由栈
- ✅ 确保返回正确的登录类型

**技术改进：**
- ✅ 导入 `LoginType` 枚举（auth_service.dart）
- ✅ 明确指定登录类型参数
- ✅ 保持编码格式不变

**详细文档：**
- 所有修改记录请查看本 README.md 的更新日志部分

#### 2026-04-30 - 用户端个人中心页面优化
**样式优化：**
- ✅ 移除 AppBar，使用沉浸式渐变头部设计
- ✅ 顶部区域采用全宽渐变背景（蓝色渐变）
- ✅ 个人信息卡片重新设计：
  - 白色圆形头像（带阴影效果）
  - 昵称 + 手机号标签（半透明白色背景）
  - 编辑按钮（圆角边框设计）
- ✅ 功能菜单改为卡片式布局：
  - 账号管理卡片（带图标标题）
  - 服务支持卡片（带图标标题）
  - 每个菜单项有独立图标容器
  - 更宽松的间距和留白
- ✅ 退出登录按钮优化：
  - 白色卡片背景
  - 居中红色图标+文字
  - 点击涟漪效果
- ✅ 使用 CustomScrollView 替代 SingleChildScrollView
- ✅ 整体风格更加简洁、现代、美观

**技术改进：**
- ✅ 添加 MenuItemData 数据模型类
- ✅ 重构 _buildMenuCards() 方法
- ✅ 新增 _buildMenuCard() 通用卡片组件
- ✅ Hero 动画支持（头像）
- ✅ 响应式布局（适配状态栏高度）

#### 2026-04-30 - Redis 缓存服务配置
**Redis 安装与配置：**
- ✅ 安装 Redis for Windows (v3.0.504)
- ✅ 启动 Redis 服务（端口：6379）
- ✅ 后端成功连接 Redis
- ✅ 双层缓存架构生效（Ristretto + Redis）

**缓存功能：**
- ✅ 设备缓存（5分钟 TTL）
- ✅ 用户缓存（30分钟 TTL）
- ✅ 设备列表缓存（2分钟 TTL）
- ✅ 本地缓存（30秒 TTL）+ Redis 缓存（300秒 TTL）

**配置文件：** `backend/configs/config.yaml`
```yaml
redis:
  enabled: true
  host: "localhost"
  port: 6379
  password: ""
  db: 0
  pool_size: 100
```

**验证命令：**
```powershell
# 测试 Redis 连接
& "C:\Program Files\Redis\redis-cli.exe" ping
# 返回: PONG

# 查看 Redis 信息
& "C:\Program Files\Redis\redis-cli.exe" info server
```

#### 2026-04-30 - 用户端页面开发
**新增页面：**
- ✅ `example/lib/pages/user/self_service_page.dart` - 用户端自助服务页面
  - ✅ 欢迎卡片（渐变背景 + 图标）
  - ✅ 快捷功能（开门、记录、二维码、帮助）
  - ✅ 常用服务（门锁管理、家庭成员、密码管理等6个功能）
  - ✅ 底部导航栏（服务/我的切换）
  
- ✅ `example/lib/pages/user/profile_page.dart` - 用户端个人中心页面
  - ✅ 个人信息卡片（头像、昵称、手机号）
  - ✅ 功能菜单分组（账号管理、服务支持）
  - ✅ 退出登录功能（带确认对话框）
  - ✅ 底部导航栏（服务/我的切换）

**登录跳转优化：**
- ✅ 管理端登录成功 → 跳转到房间管理页面
- ✅ 用户端登录成功 → 跳转到自助服务页面
- ✅ 根据 `LoginType` 自动判断跳转目标

**设计特点：**
- 🎨 简洁美观的卡片式布局
- 🎨 渐变色背景和阴影效果
- 🎨 统一的图标和颜色系统
- 🎨 流畅的页面切换动画
- 🎨 友好的用户交互反馈

#### 2026-04-30 - 页面目录结构优化
**目录重构：**
- ✅ `example/lib/pages/` - 重新组织页面目录结构
- ✅ `auth/` - 管理端和用户端公用（登录、注册、忘记密码等）
- ✅ `admin/` - 管理端专用页面
  - ✅ `admin/profile/` - 管理端个人中心
  - ✅ `admin/rooms/` - 管理端房间管理
- ✅ `user/` - 用户端专用页面
  - ✅ `user/profile/` - 用户端个人中心
  - ✅ `user/service/` - 用户端自助服务

**路径修复：**
- ✅ 批量修复 admin 目录下所有文件的导入路径
- ✅ `../../` → `../../../` (lib 目录引用，profile/rooms 根目录)
- ✅ `../../../` → `../../../../` (lib 目录引用，子目录如 account/device/finance等)
- ✅ `../auth/` → `../../auth/` (auth 目录引用，profile/rooms 根目录)
- ✅ `../profile/` → `../profile/` (同级目录引用)
- ✅ 保持 UTF-8 编码格式不变
- ✅ 删除 main.dart 中未使用的导入

#### 2026-04-30 - 用户端个人信息页面开发
**功能实现：**
- ✅ 创建用户端个人信息页面 `example/lib/pages/user/profile/user_personal_info_page.dart`
- ✅ 从登录账号获取真实数据（UserModel）
- ✅ 手机号/邮箱未绑定时显示"未绑定"
- ✅ 手机号/邮箱换绑需要验证码和登录密码验证
- ✅ 支持昵称修改、密码重置功能

**页面功能：**
- 📱 **昵称设置**：可编辑修改用户昵称
- 📞 **手机号管理**：
  - 未绑定：点击绑定，需输入手机号+验证码+登录密码
  - 已绑定：可更换或解绑，需验证码+登录密码验证
- 📧 **邮箱管理**：
  - 未绑定：点击绑定，需输入邮箱+验证码+登录密码
  - 已绑定：可更换或解绑，需验证码+登录密码验证
- 🔒 **密码重置**：需输入当前密码+新密码+确认新密码

**技术实现：**
- ✅ 使用 UserModel 从 AuthService 获取真实用户数据
- ✅ 所有敏感操作（绑定/换绑/解绑）都需要验证码+登录密码双重验证
- ✅ 对话框采用 StatefulBuilder 支持加载状态显示
- ✅ 发送验证码按钮独立控制，防止重复发送
- ✅ 完善的表单验证和错误提示
- ✅ TODO 标记后端 API 集成点

**UI 特性：**
- 🎨 列表式布局，清晰展示各项信息
- 🎨 已绑定项显示 PopupMenuButton 提供更多操作
- 🎨 未绑定项直接点击进入绑定流程
- 🎨 加载状态使用 CircularProgressIndicator
- 🎨 成功/失败操作都有 SnackBar 提示

**集成到个人中心：**
- ✅ 更新 `example/lib/pages/user/profile/profile_page.dart`
- ✅ 点击个人基本信息卡片跳转到个人信息页面
- ✅ 导航栏标题居中显示
- ✅ 删除“个人资料”菜单项
- ✅ 借鉴管理端个人中心的布局风格

**与后端对接说明：**
- 📌 需要后端提供以下 API：
  - GET `/api/v1/user/profile` - 获取用户信息
  - POST `/api/v1/user/update-nickname` - 更新昵称
  - POST `/api/v1/user/bind-phone` - 绑定手机号（phone, code, password）
  - POST `/api/v1/user/change-phone` - 更换手机号（phone, code, password）
  - POST `/api/v1/user/unbind-phone` - 解绑手机号（password）
  - POST `/api/v1/user/bind-email` - 绑定邮箱（email, code, password）
  - POST `/api/v1/user/change-email` - 更换邮箱（email, code, password）
  - POST `/api/v1/user/unbind-email` - 解绑邮箱（password）
  - POST `/api/v1/user/reset-password` - 重置密码（current_password, new_password）
  - POST `/api/v1/auth/send-code` - 发送验证码（已存在，type=3绑定手机，type=4绑定邮箱）

#### 2026-04-30 - 登录成功后缓存用户信息
**功能实现：**
- ✅ 管理端和用户端登录成功后，自动缓存后端返回的完整用户信息
- ✅ 使用 LocalCache 保存用户信息（JSON格式）
- ✅ 其他页面可从缓存中读取用户信息使用
- ✅ 退出登录时自动清除缓存的用户信息

**技术实现：**
- ✅ `example/lib/utils/local_cache.dart`
  - 新增 `saveUserInfo()` - 保存用户信息（Map转JSON字符串）
  - 新增 `getUserInfo()` - 获取用户信息（JSON字符串转Map）
  - 新增 `clearUserInfo()` - 清除用户信息
  - 实现简单的 JSON 序列化/反序列化（不依赖 dart:convert）
  
- ✅ `example/lib/utils/auth_service.dart`
  - 登录成功后调用 `LocalCache.saveUserInfo()` 缓存用户信息
  - 同时保存登录状态、用户ID、手机号等关键信息
  - 添加调试日志：“💾 用户信息已缓存到本地”
  
- ✅ `example/lib/pages/user/profile/profile_page.dart`
  - 在 `initState()` 中从缓存加载用户信息
  - 根据缓存数据显示昵称、手机号、邮箱
  - 未绑定时显示“未绑定手机/邮箱”
  
- ✅ `example/lib/pages/admin/profile/profile_page.dart`
  - 退出登录时清除缓存的用户信息
  
- ✅ `example/lib/pages/user/profile/profile_page.dart`
  - 退出登录时清除缓存的用户信息

**缓存数据结构：**
```json
{
  "id": 1,
  "phone": "13800138000",
  "email": "user@example.com",
  "nickname": "张三",
  "avatar": null,
  "role": 2
}
```

**使用场景：**
- 📱 个人中心显示用户基本信息
- 📝 个人信息页面展示和编辑
- 🔐 其他需要用户信息的页面
- 🚪 退出登录时自动清除

**优势：**
- ✅ 避免重复请求后端获取用户信息
- ✅ 提升页面加载速度
- ✅ 支持离线查看用户信息
- ✅ 统一管理用户数据

#### 2026-04-30 - 个人中心和信息页面优化（第一阶段）
**功能实现：**
- ✅ 用户端和管理端个人中心从缓存加载真实用户信息
- ✅ 用户端个人信息页面完全重构，使用 Map 存储数据
- ✅ 用户端添加国家/地区选择UI
- ✅ **实现完整的国家选择器功能** - 集成 CountrySelectorPage
- ✅ 所有绑定/换绑操作需要验证码+登录密码双重验证
- ✅ 未绑定手机号/邮箱时显示“未绑定”
- ✅ **优化基本信息卡片显示逻辑** - 只显示已绑定的手机号或邮箱
- ✅ **管理端删除安全问题功能** - 完整移除安全问题相关代码
- ✅ **修复导入路径错误** - 修正用户端国家选择器导入路径

**修改文件：**

1. **用户端个人中心** (`example/lib/pages/user/profile/profile_page.dart`)
   - ✅ 已实现从 LocalCache.getUserInfo() 加载真实数据
   - ✅ 显示真实的昵称、手机号、邮箱
   - ✅ **优化显示逻辑**：
     - 只展示已绑定的手机号
     - 只展示已绑定的邮箱
     - 如果两者都未绑定，显示“点击完善个人信息”
     - 如果两者都已绑定，自动添加间距

2. **用户端个人信息页面** (`example/lib/pages/user/profile/user_personal_info_page.dart`)
   - ✅ 导入 local_cache.dart、country_model.dart、country_selector_page.dart
   - ✅ **修复导入路径** - 从 `../../../auth/` 改为 `../../auth/`
   - ✅ 数据结构从 UserModel 改为 Map<String, dynamic>
   - ✅ 添加 _updateUserInfo() 方法更新缓存
   - ✅ 添加 _findCountryByCode() 辅助方法
   - ✅ 昵称编辑：使用 _userInfo 和 _updateUserInfo
   - ✅ 手机号部分：
     - 显示逻辑改用 _userInfo
     - **绑定对话框集成完整的国家选择器**：
       - 点击国家/地区区域打开 CountrySelectorPage
       - 显示国家名称和区号（如：中国 (+86)）
       - 选择后实时更新 selectedCountryCode 和 selectedCountryName
       - 使用 context.mounted 确保安全性
     - 绑定成功后更新缓存：`await _updateUserInfo({'phone': phone, 'country_code': code})`
     - 更换手机号：`await _updateUserInfo({'phone': newPhone})`
     - 解绑手机号：`await _updateUserInfo({'phone': null})`
   - ✅ 邮箱部分：
     - 显示逻辑改用 _userInfo
     - 绑定成功后更新缓存：`await _updateUserInfo({'email': email})`
     - 更换邮箱：`await _updateUserInfo({'email': newEmail})`
     - 解绑邮箱：`await _updateUserInfo({'email': null})`
   - ✅ 重置密码：保持不变（需调用后端API）
   - ✅ 所有 `_currentUser` 引用已清除（grep确认0处）
   - ✅ flutter analyze 无错误

3. **管理端个人中心** (`example/lib/pages/admin/profile/profile_page.dart`)
   - ✅ 导入 local_cache.dart
   - ✅ 添加 _loadUserInfo() 方法从缓存加载数据
   - ✅ 在 initState() 中调用 _loadUserInfo()
   - ✅ 修改 _userData 初始化逻辑为可变的 Map
   - ✅ 显示真实的昵称、手机号、邮箱、国家/地区
   - ✅ **优化显示逻辑**：
     - 只展示已绑定的手机号
     - 只展示已绑定的邮箱
     - 如果两者都未绑定，显示“点击完善个人信息”
     - 如果两者都已绑定，自动添加间距

4. **管理端个人信息页面** (`example/lib/pages/admin/profile/account/personal_info_page.dart`)
   - ✅ **删除安全问题数据** - 移除 `_securityQuestions` 变量
   - ✅ **删除安全问题初始化** - 移除 initState 中的加载逻辑
   - ✅ **删除安全问题UI** - 移除 build 中的渲染调用
   - ✅ **删除安全问题方法** - 移除 `_buildSecurityQuestionSection()` 和 `_setSecurityQuestion()`
   - ✅ **删除安全问题设置页面** - 完整移除 `_SecurityQuestionSettingPage` 类（约300行代码）
   - ✅ 保留其他功能：昵称、手机号、邮箱、重置密码、国家/地区
   - ✅ flutter analyze 无错误

**技术要点：**
- 📦 使用 LocalCache 统一管理用户数据
- 🔄 数据更新后自动同步到缓存
- 🌍 **用户端国家/地区选择器完整实现** - 集成 CountrySelectorPage，支持全球200+国家
- 🔐 所有敏感操作都需要验证码+登录密码
- 📱 未绑定状态清晰提示
- 🗑️ 管理端已删除安全问题功能，简化账户设置流程

**待完成：**
- ⏳ 后端 API 集成（当前使用 Future.delayed 模拟）

#### 2026-04-30 - 优化个人信息页面（第二阶段）
**功能优化：**
- ✅ 用户基本信息展示由登录获取后端数据的真实展示
- ✅ 手机号、邮箱不能同时解绑（后端验证）
- ✅ 手机号或者邮箱换绑需要验证码和登录密码
- ✅ 绑定则不需要登录密码，只需要验证码
- ✅ 用户端在重置密码下面添加国家/地区选择

**后端修改：**
- ✅ `backend/internal/model/user.go`
  - 新增 UpdateProfileRequest、BindPhoneRequest、BindEmailRequest
  - 新增 ChangePhoneRequest、ChangeEmailRequest
  - 新增 UnbindPhoneRequest、UnbindEmailRequest
  
- ✅ `backend/internal/repository/user_repo.go`
  - 新增 UpdateNickname 方法：更新昵称
  - 新增 UpdatePhone 方法：更新手机号
  - 新增 UpdateEmail 方法：更新邮箱
  - 新增 UnbindPhone 方法：解绑手机号
  - 新增 UnbindEmail 方法：解绑邮箱
  - 新增 FindByID 方法：根据ID查找用户
  
- ✅ `backend/internal/repository/verification_repo.go`
  - 新增 VerifyAndMarkAsUsed 方法：验证验证码并标记为已使用
  
- ✅ `backend/internal/service/auth_service.go`
  - 新增 UpdateProfile 方法：更新用户个人信息
  - 新增 BindPhone 方法：绑定手机号（不需要密码）
  - 新增 BindEmail 方法：绑定邮箱（不需要密码）
  - 新增 ChangePhone 方法：更换手机号（需要密码）
  - 新增 ChangeEmail 方法：更换邮箱（需要密码）
  - 新增 UnbindPhone 方法：解绑手机号（需要密码，检查不能同时解绑）
  - 新增 UnbindEmail 方法：解绑邮箱（需要密码，检查不能同时解绑）
  
- ✅ `backend/internal/handler/auth_handler.go`
  - 新增 UpdateProfile handler：PUT /api/v1/user/profile
  - 新增 BindPhone handler：POST /api/v1/user/bind-phone
  - 新增 BindEmail handler：POST /api/v1/user/bind-email
  - 新增 ChangePhone handler：POST /api/v1/user/change-phone
  - 新增 ChangeEmail handler：POST /api/v1/user/change-email
  - 新增 UnbindPhone handler：POST /api/v1/user/unbind-phone
  - 新增 UnbindEmail handler：POST /api/v1/user/unbind-email
  
- ✅ `backend/internal/router/router.go`
  - 注册7个新的用户个人信息API路由

**前端修改：**
- ✅ `example/lib/pages/user/profile/user_personal_info_page.dart`
  - 导入 api_client.dart，实现真实API调用
  - **绑定手机号**：移除密码输入框，只需要手机号+验证码+国家/地区
  - **更换手机号**：保留密码输入框，需要新手机号+验证码+登录密码
  - **解绑手机号**：添加密码输入框，需要登录密码验证
  - **绑定邮箱**：移除密码输入框，只需要邮箱+验证码
  - **更换邮箱**：保留密码输入框，需要新邮箱+验证码+登录密码
  - **解绑邮箱**：添加密码输入框，需要登录密码验证
  - **昵称编辑**：调用后端API更新昵称
  - **国家/地区选择**：在重置密码下方添加国家/地区选项
    - 显示当前国家名称和区号
    - 点击打开 CountrySelectorPage 选择
    - 选择后调用后端API更新
  - 所有操作都有加载状态和错误提示
  - 成功后更新本地缓存

**技术改进：**
- 🎯 绑定操作简化流程，只需验证码即可
- 🎯 更换和解绑操作增加安全性，需要密码验证
- 🎯 后端严格验证手机号和邮箱不能同时解绑
- 🎯 前端实时同步缓存数据，保证UI一致性
- 🎯 完整的错误处理和用户反馈

#### 2026-04-30 - 优化管理端个人信息页面
**功能优化：**
- ✅ 昵称、重置密码、国家/地区：更新内容同步更新数据库信息
- ✅ 手机号、邮箱解绑时先判断不能同时为空
- ✅ 手机号、邮箱换绑需要验证码和登录密码
- ✅ 手机号、邮箱绑定只需要验证码即可

**前端修改：**
- ✅ `example/lib/pages/admin/profile/account/personal_info_page.dart`
  - 导入 api_client.dart，实现真实API调用
  - **昵称编辑**：调用后端API PUT /user/profile 更新昵称
  - **重置密码**：调用后端API POST /auth/reset-password 重置密码
  - **国家/地区选择**：调用后端API PUT /user/profile 更新国家/地区
  - **手机号绑定**：移除密码输入框，只需手机号+验证码，调用 POST /user/bind-phone
  - **手机号更换**：保留密码输入框，需要新手机号+验证码+登录密码，调用 POST /user/change-phone
  - **手机号解绑**：添加密码输入框，检查邮箱是否已绑定，调用 POST /user/unbind-phone
  - **邮箱绑定**：添加验证码发送，只需邮箱+验证码，调用 POST /user/bind-email
  - **邮箱更换**：添加验证码和密码验证，需要新邮箱+验证码+登录密码，调用 POST /user/change-email
  - **邮箱解绑**：添加密码输入框，检查手机号是否已绑定，调用 POST /user/unbind-email
  - 所有操作都有加载状态和错误提示
  - 成功后更新本地数据

**技术改进：**
- 🎯 绑定操作简化流程，只需验证码即可
- 🎯 更换和解绑操作增加安全性，需要密码验证
- 🎯 前端严格验证手机号和邮箱不能同时解绑
- 🎯 实时同步后端数据，保证UI一致性
- 🎯 完整的错误处理和用户反馈
- 🎯 与用户端个人信息页面保持一致的交互逻辑

#### 2026-04-30 - 修复绑定操作密码验证问题
**问题描述：**
- ❌ 绑定邮箱/手机号时，后端要求密码字段必填，但前端发送空字符串导致400错误
- ❌ 错误信息：`Key: 'BindEmailRequest.Password' Error:Field validation for 'Password' failed on the 'required' tag`

**修复内容：**
- ✅ `backend/internal/model/user.go`
  - 移除 `BindPhoneRequest.Password` 的 `required` 验证标记
  - 移除 `BindEmailRequest.Password` 的 `required` 验证标记
  - 添加注释说明绑定时不需要密码
- ✅ `backend/internal/service/auth_service.go`
  - 移除 `BindPhone` 方法中的密码验证逻辑
  - 移除 `BindEmail` 方法中的密码验证逻辑
  - 添加注释说明绑定时只需要验证码

**技术改进：**
- 🎯 符合需求规范：绑定操作只需验证码，更换和解绑需要密码
- 🎯 前后端一致：前端发送空密码，后端不再强制验证
- 🎯 安全性保持：更换和解绑操作仍然需要密码验证

#### 2026-04-30 - 修复验证码使用逻辑和管理端用户表问题
**问题描述：**
1. ❌ 绑定/换绑失败时，验证码已被标记为已使用，无法再次使用
2. ❌ 管理端修改个人信息时错误地操作了clients表，应该操作admins表

**修复内容：**
- ✅ `backend/internal/service/auth_service.go`
  - **BindPhone**: 调整执行顺序，先检查手机号是否被占用，再标记验证码为已使用
  - **BindEmail**: 调整执行顺序，先检查邮箱是否被占用，再标记验证码为已使用
  - **ChangePhone**: 调整执行顺序，先检查新手机号是否被占用，再标记验证码为已使用
  - **ChangeEmail**: 调整执行顺序，先检查新邮箱是否被占用，再标记验证码为已使用
  - 添加注释说明执行顺序的重要性
  
- ✅ `backend/internal/handler/auth_handler.go`
  - **UpdateProfile**: 根据role判断使用adminID还是userID
  - **BindPhone**: 根据role判断使用adminID还是userID
  - **BindEmail**: 根据role判断使用adminID还是userID
  - **ChangePhone**: 根据role判断使用adminID还是userID
  - **ChangeEmail**: 根据role判断使用adminID还是userID
  - **UnbindPhone**: 根据role判断使用adminID还是userID
  - **UnbindEmail**: 根据role判断使用adminID还是userID
  - 所有方法都添加了统一的角色判断逻辑

**技术改进：**
- 🎯 验证码事务优化：先验证所有业务条件，最后才标记验证码为已使用
- 🎯 失败回滚保障：如果业务检查失败，验证码保持未使用状态，可重复使用
- 🎯 双端架构完善：管理端操作admins表，用户端操作clients表
- 🎯 JWT角色识别：通过role字段区分管理端(role>0)和用户端(role=0)
- 🎯 代码一致性：所有handler方法采用相同的角色判断模式
**功能实现：**
- ✅ 优化管理端和用户端的底部导航栏跳转逻辑
- ✅ 防止重复点击同一标签页导致的不必要操作
- ✅ 统一使用 `pushAndRemoveUntil` 清理路由栈
- ✅ 修正管理端房间管理页面的导入路径

**修改文件：**

1. **用户端 - 自助服务页面** (`example/lib/pages/user/service/self_service_page.dart`)
   - 添加重复点击检测：`if (index == _selectedIndex) return;`
   - index 0: 服务页面（当前页，不跳转）
   - index 1: 跳转到个人中心页面

2. **用户端 - 个人中心页面** (`example/lib/pages/user/profile/profile_page.dart`)
   - 添加重复点击检测：`if (index == _selectedIndex) return;`
   - 导入 `api_client.dart` 用于退出登录
   - index 0: 跳转到自助服务页面
   - index 1: 我的页面（当前页，不跳转）

3. **管理端 - 房间管理页面** (`example/lib/pages/admin/rooms/room_management_page.dart`)
   - 添加重复点击检测：`if (index == _selectedIndex) return;`
   - 修正导入路径：从用户端改为管理端 `../profile/profile_page.dart`
   - 改用 `pushAndRemoveUntil` 替代 `push`，清理路由栈
   - index 0: 房间页面（当前页，不跳转）
   - index 1: 跳转到管理端个人中心页面

4. **管理端 - 个人中心页面** (`example/lib/pages/admin/profile/profile_page.dart`)
   - 添加重复点击检测：`if (index == _selectedIndex) return;`
   - 退出登录时清除缓存：`LocalCache.clearUserInfo()`
   - index 0: 跳转到房间管理页面
   - index 1: 我的页面（当前页，不跳转）

**导航结构：**

**用户端：**
```
[服务] ←→ [我的]
  ↓         ↓
SelfService  UserProfile
```

**管理端：**
```
[房间] ←→ [我的]
  ↓         ↓
RoomManagement  ProfilePage
```

**优化点：**
- ✅ 防止重复点击同一标签导致的页面重建
- ✅ 使用 `pushAndRemoveUntil` 清理路由栈，避免内存泄漏
- ✅ 统一的导航体验，点击即切换
- ✅ 修正导入路径错误，确保跳转到正确的页面
- ✅ 退出登录时彻底清除用户数据和Token

#### 2026-04-30 - 登录页面支持手机号或邮箱登录
**功能改进：**
- ✅ `example/lib/pages/auth/login_page.dart` - 添加登录方式切换功能
- ✅ 支持手机号登录和邮箱登录两种方式
- ✅ 添加登录方式选择按钮（手机号/邮箱）
- ✅ 根据选择的登录方式动态显示对应的输入框
- ✅ 添加邮箱格式验证
- ✅ 优化调试日志，显示登录方式和账号信息

**界面优化：**
- 🎨 重新设计登录方式选择卡片，使用渐变背景和阴影效果
- 🎨 选中的登录方式按钮有渐变色和投影效果，更加醒目
- 🎨 输入框采用卡片式设计，带有阴影和圆角
- 🎨 国家选择器独立卡片，在登录方式之后、输入框之前
- 🎨 国家选择卡片显示国旗、国家名称、区号，美观清晰
- 🎨 密码输入框添加锁图标，更加直观
- 🎨 所有输入框聚焦时有蓝色边框高亮
- 🎨 动画过渡效果流畅自然
- 🎨 删除重复的国家选择器，界面更简洁
- 🎨 **顶部标题**：左图标右文字布局（无卡片背景），管理端/用户端图标 + 标题 + 说明
- 🎨 **登录方式卡片**：左图标右文字布局，切换图标 + 标题 + 两个横向按钮
- 🎨 **登录方式按钮**：左图标右文字布局，图标 + 文字横向排列

**本地化功能：**
- 🌍 国家选择持久化保存（LocalCache）
- 🌍 下次启动自动恢复上次选择的国家
- 🌍 根据国家代码自动推断语言代码（中、英、日、韩、法、德、西等）
- 🌍 为后续应用语言切换提供基础支持

**用户体验：**
- 用户可以在登录时自由选择使用手机号或邮箱
- 国家选择一次，永久记忆，无需重复设置
- 界面美观现代，符合 Material Design 规范
- 切换流畅，视觉反馈清晰
- 邮箱输入有格式验证，防止输入错误
- 管理端和用户端都支持相同的登录方式

#### 2026-04-30 - 重置密码功能支持管理端和用户端
**问题：** 忘记密码页面无法区分管理端和用户端，管理员无法重置密码

**修复内容：**

**后端修改：**
- ✅ `backend/internal/service/verification_service.go` - 修改 ResetPassword 方法，先查询 admins 表，再查询 clients 表
- ✅ `backend/internal/repository/admin_repo.go` - 添加 UpdatePassword 方法，支持管理员密码更新
- ✅ `backend/internal/service/auth_service.go` - 修复类型错误，添加 verificationRepo 字段

**前端修改：**
- ✅ `example/lib/utils/auth_service.dart` - resetPassword 方法添加 loginType 参数（默认用户端）
- ✅ `example/lib/pages/auth/forgot_password_page.dart` - 传递 loginType 到重置密码方法
- ✅ 增加调试日志，显示登录类型信息

**技术细节：**
- 后端采用自动识别策略：先查 admins 表，如果找到则更新管理员密码，否则查 clients 表
- 前端通过 LoginType 枚举传递用户类型，便于日志记录和后续扩展
- 管理员和普通用户使用不同的数据表和 Repository

#### 2026-04-29 - 修复注册功能：允许邮箱单独注册（phone字段可为NULL）
**问题：** 使用邮箱注册时报错 `Error 1048 (23000): Column 'phone' cannot be null`

**原因：** 数据库 `clients` 表的 `phone` 字段定义为 `NOT NULL`，但邮箱注册时不传手机号

**修复：**
- ✅ 修改数据库表结构：`ALTER TABLE clients MODIFY COLUMN phone VARCHAR(20) DEFAULT NULL`
- ✅ 更新 `init_db.sql` 建表脚本，将 `phone` 字段改为允许 NULL
- ✅ 支持纯邮箱注册和纯手机号注册两种方式

**相关文件：**
- `backend/scripts/init_db.sql` - 建表脚本
- `backend/internal/handler/auth_handler.go` - 修复日志记录参数顺序
- `backend/internal/config/config.go` - 添加 Viper 配置类型设置
- `example/lib/pages/auth/login_page.dart` - 开发环境默认勾选用户协议
- `example/lib/pages/auth/register_page.dart` - 开发环境默认勾选用户协议

#### 2026-04-29 - 修复注册页面 LoginType 类型错误
**问题：** `type 'Null' is not a subtype of type 'LoginType' of 'function result'`

**原因：** Dart 三元运算符在字符串插值中可能产生类型推断问题

**修复：**
- ✅ `register_page.dart` - 为 `widget.loginType` 的三元运算添加括号，确保类型安全
- ✅ `login_page.dart` - 同样修复登录页面的调试日志中的三元运算符
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




