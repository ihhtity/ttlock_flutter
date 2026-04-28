import 'dart:convert';
import 'package:http/http.dart' as http;

/// TTLock API 诊断工具
/// 用于测试和调试 API 连接问题
class TTLockApiDiagnostic {
  static const String baseUrl = 'https://api.ttlock.com/v3';
  
  /// 测试 OAuth2 登录（标准方式）
  static Future<void> testOAuth2Login() async {
    print('=== 测试 1: 标准 OAuth2 登录 ===');
    
    final clientId = '607ab4bcc9504a5da58c43575a1b3746';
    final clientSecret = 'fj81Mf4Mnglw5knoaTmjLG8c4H2fdhpWB37wwFJh2dI=';
    final username = '19830357494';
    final password = '19830357494a';
    
    print('请求 URL: $baseUrl/oauth2/token');
    print('clientId: $clientId');
    print('username: $username');
    
    try {
      // 方式 1: JSON body
      print('\n--- 方式 1: JSON Body ---');
      final response1 = await http.post(
        Uri.parse('$baseUrl/oauth2/token'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'clientId': clientId,
          'clientSecret': clientSecret,
          'username': username,
          'password': password,
          'grant_type': 'password',
        }),
      );
      
      print('状态码: ${response1.statusCode}');
      print('响应头: ${response1.headers}');
      print('响应体: ${response1.body}');
      
      // 方式 2: Form data
      print('\n--- 方式 2: Form Data ---');
      final response2 = await http.post(
        Uri.parse('$baseUrl/oauth2/token'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'clientId': clientId,
          'clientSecret': clientSecret,
          'username': username,
          'password': password,
          'grant_type': 'password',
        },
      );
      
      print('状态码: ${response2.statusCode}');
      print('响应头: ${response2.headers}');
      print('响应体: ${response2.body}');
      
    } catch (e) {
      print('异常: $e');
    }
  }
  
  /// 测试不同的 API 端点
  static Future<void> testDifferentEndpoints() async {
    print('\n=== 测试 2: 不同的 API 端点 ===');
    
    final endpoints = [
      'https://api.ttlock.com/v3/oauth2/token',
      'https://api.sciener.com/v3/oauth2/token',
      'https://cnapi.ttlock.com/v3/oauth2/token',
      'https://api.ttlock.com/oauth2/token',
    ];
    
    for (final endpoint in endpoints) {
      print('\n测试端点: $endpoint');
      try {
        final response = await http.post(
          Uri.parse(endpoint),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'test': 'connection',
          }),
        );
        print('  状态码: ${response.statusCode}');
        print('  响应: ${response.body.substring(0, response.body.length > 100 ? 100 : response.body.length)}');
      } catch (e) {
        print('  异常: $e');
      }
    }
  }
  
  /// 测试网络连接
  static Future<void> testNetworkConnection() async {
    print('\n=== 测试 3: 网络连接 ===');
    
    final urls = [
      'https://api.ttlock.com',
      'https://api.sciener.com',
      'https://www.baidu.com',
    ];
    
    for (final url in urls) {
      print('\n测试: $url');
      try {
        final response = await http.get(Uri.parse(url));
        print('  状态码: ${response.statusCode}');
        print('  连接成功');
      } catch (e) {
        print('  连接失败: $e');
      }
    }
  }
  
  /// 运行所有诊断测试
  static Future<void> runAllTests() async {
    print('========================================');
    print('TTLock API 诊断工具');
    print('========================================\n');
    
    await testNetworkConnection();
    await testDifferentEndpoints();
    await testOAuth2Login();
    
    print('\n========================================');
    print('诊断完成');
    print('========================================');
  }
}

void main() async {
  await TTLockApiDiagnostic.runAllTests();
}
