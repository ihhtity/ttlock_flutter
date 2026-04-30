import 'package:flutter/foundation.dart';
import 'api_client.dart';

/// 登录类型枚举
enum LoginType {
  admin, // 管理端
  client, // 用户端
}

/// 用户模型
class UserModel {
  final int id;
  final String? phone;
  final String? email;
  final String? nickname;
  final String? avatar;
  final int? role; // 0-客户端, 1-管理员

  UserModel({
    required this.id,
    this.phone,
    this.email,
    this.nickname,
    this.avatar,
    this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      phone: json['phone'],
      email: json['email'],
      nickname: json['nickname'],
      avatar: json['avatar'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'email': email,
      'nickname': nickname,
      'avatar': avatar,
      'role': role,
    };
  }

  /// 是否为管理员
  bool get isAdmin => role == 1 || role != null && role! > 0;
}

/// 登录响应
class LoginResponse {
  final String token;
  final UserModel user;

  LoginResponse({
    required this.token,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] ?? '',
      user: UserModel.fromJson(json['user'] ?? {}),
    );
  }
}

/// 认证API服务
class AuthService {
  /// 用户登录
  static Future<ApiResponse<LoginResponse>> login({
    String? phone,
    String? email,
    required String password,
    LoginType loginType = LoginType.client,
  }) async {
    try {
      final body = <String, dynamic>{
        'password': password,
      };

      if (phone != null && phone.isNotEmpty) {
        body['phone'] = phone;
      }
      if (email != null && email.isNotEmpty) {
        body['email'] = email;
      }

      debugPrint('🔐 开始登录请求 [${loginType == LoginType.admin ? "管理端" : "用户端"}]');
      debugPrint('   - Phone: ${phone ?? "null"}');
      debugPrint('   - Email: ${email ?? "null"}');

      final response = await HttpClient.post('/auth/login', body: body);

      if (response.isSuccess && response.data != null) {
        final loginData =
            LoginResponse.fromJson(response.data as Map<String, dynamic>);

        // 保存Token
        HttpClient.setToken(loginData.token);

        debugPrint(
            '✅ 登录成功: ${loginData.user.nickname ?? loginData.user.phone ?? loginData.user.email}');

        return ApiResponse.fromSuccess(loginData);
      } else {
        debugPrint('❌ 登录失败 [${response.code}]: ${response.message}');
        debugPrint('   - 请求参数: phone=${phone ?? "null"}, email=${email ?? "null"}');
        debugPrint('   - 响应数据: ${response.data}');
        return ApiResponse.fromError(response.code, response.message);
      }
    } catch (e, stackTrace) {
      debugPrint('❌ 登录异常: $e');
      debugPrint('   - 堆栈信息: $stackTrace');
      return ApiResponse.fromError(500, '登录失败: $e');
    }
  }

  /// 用户注册
  static Future<ApiResponse> register({
    required String phone,
    String? email,
    required String password,
    required String nickname,
    required int adminsId,
    required bool agreeTerms,
    int registerType = 2, // 1-管理端注册，2-用户端注册（默认）
    String country = 'CN',
    String dialCode = '+86',
  }) async {
    try {
      final body = <String, dynamic>{
        'phone': phone.isNotEmpty ? phone : null, // 空字符串转为 null
        'email': (email != null && email.isNotEmpty) ? email : null,
        'password': password,
        'nickname': nickname,
        'admins_id': adminsId,
        'agree_terms': agreeTerms ? 1 : 0, // 将布尔值转换为整数
        'country': country,
        'dial_code': dialCode,
        'phone_bound': phone.isNotEmpty ? 1 : 0,
        'email_bound': (email != null && email.isNotEmpty) ? 1 : 0,
        'register_type': registerType, // 注册类型：1-管理端，2-用户端
      };

      debugPrint('📝 开始注册请求');
      debugPrint('   - Phone: ${phone.isNotEmpty ? phone : "null"}');
      debugPrint('   - Email: ${email?.isNotEmpty == true ? email : "null"}');
      debugPrint('   - Nickname: $nickname');
      debugPrint('   - AdminsID: $adminsId');

      final response = await HttpClient.post('/auth/register', body: body);

      if (response.isSuccess) {
        debugPrint('✅ 注册成功');
        return ApiResponse.fromSuccess(null);
      } else {
        debugPrint('❌ 注册失败 [${response.code}]: ${response.message}');
        debugPrint('   - 请求参数: $body');
        debugPrint('   - 响应数据: ${response.data}');
        return ApiResponse.fromError(response.code, response.message);
      }
    } catch (e, stackTrace) {
      debugPrint('❌ 注册异常: $e');
      debugPrint('   - 堆栈信息: $stackTrace');
      return ApiResponse.fromError(500, '注册失败: $e');
    }
  }

  /// 发送验证码
  static Future<ApiResponse> sendVerificationCode({
    String? phone,
    String? email,
    required int type, // 1-注册，2-找回密码，3-绑定手机，4-绑定邮箱
  }) async {
    try {
      final requestBody = {
        if (phone != null) 'phone': phone,
        if (email != null) 'email': email,
        'type': type,
      };

      debugPrint('📧 发送验证码请求 [type=$type]');
      debugPrint('   - Phone: ${phone ?? "null"}');
      debugPrint('   - Email: ${email ?? "null"}');

      final response = await HttpClient.post('/auth/send-code', body: requestBody);

      if (response.isSuccess) {
        debugPrint('✅ 验证码发送成功');
        return ApiResponse.fromSuccess(null);
      } else {
        debugPrint('❌ 验证码发送失败 [${response.code}]: ${response.message}');
        debugPrint('   - 请求参数: $requestBody');
        debugPrint('   - 响应数据: ${response.data}');
        return ApiResponse.fromError(response.code, response.message);
      }
    } catch (e, stackTrace) {
      debugPrint('❌ 验证码发送异常: $e');
      debugPrint('   - 堆栈信息: $stackTrace');
      return ApiResponse.fromError(500, '发送验证码失败: $e');
    }
  }

  /// 验证验证码
  static Future<ApiResponse> verifyCode({
    String? phone,
    String? email,
    required String code,
    required int type, // 1-注册，2-找回密码，3-绑定手机，4-绑定邮箱
  }) async {
    try {
      final body = <String, dynamic>{
        'code': code,
        'type': type,
      };

      if (phone != null && phone.isNotEmpty) {
        body['phone'] = phone;
      }
      if (email != null && email.isNotEmpty) {
        body['email'] = email;
      }

      debugPrint('🔍 验证验证码请求 [type=$type]');
      debugPrint('   - Phone: ${phone ?? "null"}');
      debugPrint('   - Email: ${email ?? "null"}');
      debugPrint('   - Code: ${code.isNotEmpty ? "***" : "empty"}');

      final response = await HttpClient.post('/auth/verify-code', body: body);

      if (response.isSuccess) {
        debugPrint('✅ 验证码验证成功');
        return ApiResponse.fromSuccess(null);
      } else {
        debugPrint('❌ 验证码验证失败 [${response.code}]: ${response.message}');
        debugPrint('   - 请求参数: phone=${phone ?? "null"}, email=${email ?? "null"}, type=$type');
        debugPrint('   - 响应数据: ${response.data}');
        return ApiResponse.fromError(response.code, response.message);
      }
    } catch (e, stackTrace) {
      debugPrint('❌ 验证码验证异常: $e');
      debugPrint('   - 堆栈信息: $stackTrace');
      return ApiResponse.fromError(500, '验证验证码失败: $e');
    }
  }

  /// 重置密码
  static Future<ApiResponse> resetPassword({
    String? phone,
    String? email,
    required String code,
    required String newPassword,
    LoginType loginType = LoginType.client, // 默认用户端
  }) async {
    try {
      final requestBody = {
        if (phone != null) 'phone': phone,
        if (email != null) 'email': email,
        'code': code,
        'new_password': newPassword,
      };

      debugPrint('🔄 重置密码请求 [${loginType == LoginType.admin ? "管理端" : "用户端"}]');
      debugPrint('   - Phone: ${phone ?? "null"}');
      debugPrint('   - Email: ${email ?? "null"}');
      debugPrint('   - Code: ${code.isNotEmpty ? "***" : "empty"}');

      final response = await HttpClient.post('/auth/reset-password', body: requestBody);

      if (response.isSuccess) {
        debugPrint('✅ 密码重置成功');
        return ApiResponse.fromSuccess(null);
      } else {
        debugPrint('❌ 密码重置失败 [${response.code}]: ${response.message}');
        debugPrint('   - 请求参数: phone=${phone ?? "null"}, email=${email ?? "null"}');
        debugPrint('   - 响应数据: ${response.data}');
        return ApiResponse.fromError(response.code, response.message);
      }
    } catch (e, stackTrace) {
      debugPrint('❌ 密码重置异常: $e');
      debugPrint('   - 堆栈信息: $stackTrace');
      return ApiResponse.fromError(500, '重置密码失败: $e');
    }
  }

  /// 找回密码（返回明文密码）
  static Future<ApiResponse<String>> retrievePassword({
    String? phone,
    String? email,
    required String code,
    LoginType loginType = LoginType.client,
  }) async {
    try {
      final requestBody = {
        if (phone != null) 'phone': phone,
        if (email != null) 'email': email,
        'code': code,
      };

      debugPrint('🔑 ========== 开始找回密码 ==========');
      debugPrint('   - 登录类型: ${loginType == LoginType.admin ? "管理端" : "用户端"}');
      debugPrint('   - Phone: ${phone ?? "null"}');
      debugPrint('   - Email: ${email ?? "null"}');
      debugPrint('   - Code: ${code.isNotEmpty ? "***" : "empty"}');

      final response = await HttpClient.post('/auth/retrieve-password', body: requestBody);

      if (response.isSuccess && response.data != null) {
        final password = (response.data as Map<String, dynamic>)['password'] as String?;
        debugPrint('✅ 密码找回成功');
        debugPrint('=====================================');
        if (password != null) {
          return ApiResponse.fromSuccess(password);
        } else {
          return ApiResponse.fromError(500, '未找到密码信息');
        }
      } else {
        debugPrint('❌ 密码找回失败 [${response.code}]: ${response.message}');
        debugPrint('   - 请求参数: phone=${phone ?? "null"}, email=${email ?? "null"}');
        debugPrint('   - 响应数据: ${response.data}');
        debugPrint('=====================================');
        return ApiResponse.fromError(response.code, response.message);
      }
    } catch (e, stackTrace) {
      debugPrint('❌ 密码找回异常: $e');
      debugPrint('   - 堆栈信息: $stackTrace');
      debugPrint('=====================================');
      return ApiResponse.fromError(500, '找回密码失败: $e');
    }
  }

  /// 登出
  static void logout() {
    HttpClient.clearToken();
    debugPrint('👋 已登出');
  }

  /// 检查是否已登录
  static bool get isLoggedIn => HttpClient.token != null;

  /// 获取当前Token
  static String? get currentToken => HttpClient.token;
}
