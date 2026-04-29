import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

/// API响应模型
class ApiResponse<T> {
  final int code;
  final String message;
  final T? data;

  ApiResponse({
    required this.code,
    required this.message,
    this.data,
  });

  bool get isSuccess => code == 200;

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'],
    );
  }

  factory ApiResponse.fromSuccess(T data) {
    return ApiResponse(
      code: 200,
      message: 'success',
      data: data,
    );
  }

  factory ApiResponse.fromError(int code, String message) {
    return ApiResponse(
      code: code,
      message: message,
    );
  }
}

/// HTTP客户端 - 统一管理API请求
class HttpClient {
  // Android模拟器使用 10.0.2.2 访问宿主机 localhost
  // iOS模拟器使用 localhost
  // 真机测试需要使用电脑的实际IP地址
  static const String baseUrl = 'http://10.0.2.2:8080/api/v1';
  
  static String? _token;
  
  /// 设置认证Token
  static void setToken(String? token) {
    _token = token;
  }
  
  /// 获取当前Token
  static String? get token => _token;
  
  /// GET请求
  static Future<ApiResponse> get(
    String path, {
    Map<String, String>? queryParameters,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$path').replace(
        queryParameters: queryParameters,
      );
      
      debugPrint('🌐 GET $uri');
      
      final response = await http.get(
        uri,
        headers: _buildHeaders(),
      );
      
      debugPrint('✅ Response: ${response.statusCode}');
      
      return _handleResponse(response);
    } catch (e) {
      debugPrint('❌ GET Error: $e');
      return ApiResponse.fromError(500, '网络错误: $e');
    }
  }
  
  /// POST请求
  static Future<ApiResponse> post(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$path');
      
      debugPrint('🌐 POST $uri');
      debugPrint('📤 Body: ${jsonEncode(body)}');
      
      final response = await http.post(
        uri,
        headers: _buildHeaders(isPost: true),
        body: body != null ? jsonEncode(body) : null,
      );
      
      debugPrint('✅ Response: ${response.statusCode}');
      
      return _handleResponse(response);
    } catch (e) {
      debugPrint('❌ POST Error: $e');
      return ApiResponse.fromError(500, '网络错误: $e');
    }
  }
  
  /// PUT请求
  static Future<ApiResponse> put(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$path');
      
      debugPrint('🌐 PUT $uri');
      
      final response = await http.put(
        uri,
        headers: _buildHeaders(isPost: true),
        body: body != null ? jsonEncode(body) : null,
      );
      
      return _handleResponse(response);
    } catch (e) {
      debugPrint('❌ PUT Error: $e');
      return ApiResponse.fromError(500, '网络错误: $e');
    }
  }
  
  /// DELETE请求
  static Future<ApiResponse> delete(String path) async {
    try {
      final uri = Uri.parse('$baseUrl$path');
      
      debugPrint('🌐 DELETE $uri');
      
      final response = await http.delete(
        uri,
        headers: _buildHeaders(),
      );
      
      return _handleResponse(response);
    } catch (e) {
      debugPrint('❌ DELETE Error: $e');
      return ApiResponse.fromError(500, '网络错误: $e');
    }
  }
  
  /// 构建请求头
  static Map<String, String> _buildHeaders({bool isPost = false}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    
    return headers;
  }
  
  /// 处理响应
  static ApiResponse _handleResponse(http.Response response) {
    try {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return ApiResponse.fromJson(data);
    } catch (e) {
      return ApiResponse.fromError(
        response.statusCode,
        '解析响应失败: $e',
      );
    }
  }
  
  /// 清除Token（登出）
  static void clearToken() {
    _token = null;
  }
}
