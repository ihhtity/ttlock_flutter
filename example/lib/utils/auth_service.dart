import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'api_client.dart';

/// 用户模型
class UserModel {
  final int id;
  final String phone;
  final String? nickname;
  final String? avatar;

  UserModel({
    required this.id,
    required this.phone,
    this.nickname,
    this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      phone: json['phone'] ?? '',
      nickname: json['nickname'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'nickname': nickname,
      'avatar': avatar,
    };
  }
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
    required String phone,
    required String password,
  }) async {
    try {
      final response = await HttpClient.post('/auth/login', body: {
        'phone': phone,
        'password': password,
      });

      if (response.isSuccess && response.data != null) {
        final loginData = LoginResponse.fromJson(response.data as Map<String, dynamic>);
        
        // 保存Token
        HttpClient.setToken(loginData.token);
        
        debugPrint('✅ 登录成功: ${loginData.user.nickname ?? loginData.user.phone}');
        
        return ApiResponse.fromSuccess(loginData);
      } else {
        debugPrint('❌ 登录失败: ${response.message}');
        return ApiResponse.fromError(response.code, response.message);
      }
    } catch (e) {
      debugPrint('❌ 登录异常: $e');
      return ApiResponse.fromError(500, '登录失败: $e');
    }
  }

  /// 用户注册
  static Future<ApiResponse> register({
    required String phone,
    required String password,
    required String nickname,
    required int adminsId,
    required bool agreeTerms,
  }) async {
    try {
      final response = await HttpClient.post('/auth/register', body: {
        'phone': phone,
        'password': password,
        'nickname': nickname,
        'admins_id': adminsId,
        'agree_terms': agreeTerms,
      });

      if (response.isSuccess) {
        debugPrint('✅ 注册成功');
        return ApiResponse.fromSuccess(null);
      } else {
        debugPrint('❌ 注册失败: ${response.message}');
        return ApiResponse.fromError(response.code, response.message);
      }
    } catch (e) {
      debugPrint('❌ 注册异常: $e');
      return ApiResponse.fromError(500, '注册失败: $e');
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
