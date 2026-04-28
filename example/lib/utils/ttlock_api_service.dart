import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ttlock_flutter/ttlock/ttlock.dart';
import 'package:crypto/crypto.dart';

/// TTLock API 服务类
///
/// 用于从 TTLock 服务器获取设备数据
/// API 文档: https://open.ttlock.com/doc/api/v3/
///
/// ✅ 已配置完成，可以直接使用
/// - clientId 和 clientSecret 已配置（来自项目 home_page.dart）
/// - HTTP 依赖已添加 (http: ^1.1.0)
/// - login() 和 getKeyList() 方法已启用
///
/// ⚠️ 重要修正：
/// - OAuth2 端点: https://api.ttlock.com/oauth2/token (不是 /v3/oauth2/token)
/// - Content-Type: application/x-www-form-urlencoded (不是 application/json)
class TTLockApiService {
  static const String baseUrl = 'https://api.ttlock.com';

  // 使用项目中已有的测试凭证（来自 home_page.dart）
  // 注意：这些是测试环境的凭证，生产环境请使用自己的凭证
  static const String clientId = '52677255d4444803a0325d06564b0e8f';
  static const String clientSecret = 'a3ba38227cb2f2da96828b4910c9801a';

  /// MD5 加密
  static String md5Encrypt(String input) {
    final bytes = utf8.encode(input);
    final digest = md5.convert(bytes);
    return digest.toString();
  }

  /// 登录获取 access_token
  ///
  /// [username] 用户名（手机号或邮箱）
  /// [password] 密码（会自动进行 MD5 加密）
  /// 返回 access_token，失败返回 null
  static Future<String?> login(String username, String password) async {
    print('=== TTLock 登录 ===');
    print('用户名: $username');
    print('原始密码: $password');

    // TTLock API 要求密码必须 MD5 加密
    final encryptedPassword = md5Encrypt(password);
    print('MD5 加密后: $encryptedPassword');
    print('clientId: $clientId');
    print('clientSecret: $clientSecret');
    print('请求 URL: $baseUrl/oauth2/token');

    try {
      // 注意：TTLock OAuth2 API 需要使用 form-urlencoded 格式，不是 JSON
      final response = await http.post(
        Uri.parse('$baseUrl/oauth2/token'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'clientId': clientId,
          'clientSecret': clientSecret,
          'username': username,
          'password': encryptedPassword, // 使用 MD5 加密后的密码
          'grant_type': 'password',
        },
      );

      print('响应状态码: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // 输出完整的响应数据
        print('✅ 登录成功！完整响应数据:');
        print(jsonEncode(data));

        final token = data['access_token'];
        return token;
      } else {
        print('❌ 登录失败: ${response.statusCode}');
        print('响应内容: ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ 登录异常: $e');
      return null;
    }
  }

  /// 获取钥匙列表
  ///
  /// [accessToken] 登录获取的 token
  /// 返回钥匙列表，每个元素包含 lockData、lockMac 等信息
  /// 
  /// 根据 API 文档，必要参数：
  /// - clientId: 创建应用分配的 client_id
  /// - accessToken: 访问令牌
  /// - pageNo: 页码，从1开始
  /// - pageSize: 每页数量，最大1000
  /// - date: 当前时间（时间戳，单位毫秒）
  static Future<List<Map<String, dynamic>>?> getKeyList(
      String accessToken) async {
    print('=== 获取钥匙列表 ===');
    print('Token: ${accessToken}');

    try {
      // 当前时间戳（毫秒）
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      
      // 只传递必要参数
      final url = Uri.parse('$baseUrl/v3/key/list').replace(queryParameters: {
        'clientId': clientId,          // 必需：应用 ID
        'accessToken': accessToken,    // 必需：访问令牌
        'pageNo': '1',                 // 必需：页码，从1开始
        'pageSize': '10',              // 必需：每页数量
        'date': currentTime.toString(), // 必需：当前时间戳（毫秒）
      });

      print('请求 URL: $url');

      final response = await http.get(url);
      
      print('响应状态码: ${response.statusCode}');
      print('响应内容: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // 检查是否有错误码
        if (data.containsKey('errcode')) {
          print('❌ API 返回错误:');
          print('   错误码: ${data['errcode']}');
          print('   错误信息: ${data['errmsg']}');
          if (data.containsKey('description')) {
            print('   详细描述: ${data['description']}');
          }
          return null;
        }

        final List list = data['list'] ?? [];

        print('✅ 找到 ${list.length} 个设备');

        return list
            .map((item) => {
                  'keyId': item['keyId'],
                  'lockId': item['lockId'],
                  'lockName': item['lockName'],
                  'lockMac': item['lockMac'],
                  'lockData': item['lockData'],
                  'startDate': item['startDate'],
                  'endDate': item['endDate'],
                })
            .toList();
      } else {
        print('❌ 获取钥匙列表失败: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('❌ 获取钥匙列表异常: $e');
      return null;
    }
  }

  /// 完整的登录并获取设备流程
  ///
  /// [username] 用户名
  /// [password] 密码
  /// 返回第一个设备的 lockData 和 lockMac
  static Future<Map<String, String>?> loadFirstDevice(
      String username, String password) async {
    print('=== 开始加载设备 ===');

    // 1. 登录
    final token = await login(username, password);
    if (token == null) {
      print('登录失败');
      return null;
    }

    print('登录成功，Token: ${token.substring(0, 20)}...');

    // 2. 获取钥匙列表
    final keyList = await getKeyList(token);
    if (keyList == null || keyList.isEmpty) {
      print('未找到设备');
      return null;
    }

    // 3. 返回第一个设备
    final firstKey = keyList[0];
    print('找到设备: ${firstKey['lockName']}');
    print('MAC: ${firstKey['lockMac']}');
    print('LockData: ${firstKey['lockData']?.substring(0, 20)}...');

    return {
      'lockData': firstKey['lockData']!,
      'lockMac': firstKey['lockMac']!,
      'lockName': firstKey['lockName']!,
    };
  }
}

/// 测试账号信息
class TestAccount {
  static const String username = '19830357494';
  static const String password = '19830357494a.';
  static const String description = '该账号只绑定了一把设备';
}
