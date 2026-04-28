import 'package:flutter/foundation.dart';

/// 日志级别枚举
enum LogLevel {
  debug,   // 调试信息
  info,    // 一般信息
  warning, // 警告
  error,   // 错误
}

/// 日志记录工具类
/// 
/// 提供统一的日志记录功能，支持不同级别的日志
/// 在发布模式下自动禁用DEBUG级别日志
class Logger {
  static const String _tag = 'TTLock';
  
  /// 是否启用日志（发布模式可关闭）
  static bool _enabled = kDebugMode;
  
  /// 最小日志级别
  static LogLevel _minLevel = LogLevel.debug;
  
  /// 设置日志启用状态
  static void setEnabled(bool enabled) {
    _enabled = enabled;
  }
  
  /// 设置最小日志级别
  static void setMinLevel(LogLevel level) {
    _minLevel = level;
  }
  
  /// 格式化日志消息
  static String _formatMessage(LogLevel level, String message, [String? tag]) {
    final now = DateTime.now();
    final timeStr = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
    final levelStr = level.toString().split('.').last.toUpperCase();
    final tagStr = tag ?? _tag;
    
    return '[$timeStr] [$levelStr] [$tagStr] $message';
  }
  
  /// 输出日志
  static void _log(LogLevel level, String message, [String? tag]) {
    if (!_enabled) return;
    if (level.index < _minLevel.index) return;
    
    final formattedMessage = _formatMessage(level, message, tag);
    
    switch (level) {
      case LogLevel.debug:
        debugPrint('\x1B[37m$formattedMessage\x1B[0m'); // 白色
        break;
      case LogLevel.info:
        debugPrint('\x1B[32m$formattedMessage\x1B[0m'); // 绿色
        break;
      case LogLevel.warning:
        debugPrint('\x1B[33m$formattedMessage\x1B[0m'); // 黄色
        break;
      case LogLevel.error:
        debugPrint('\x1B[31m$formattedMessage\x1B[0m'); // 红色
        break;
    }
  }
  
  // ==================== 各级别日志方法 ====================
  
  /// 调试日志
  static void debug(String message, [String? tag]) {
    _log(LogLevel.debug, message, tag);
  }
  
  /// 信息日志
  static void info(String message, [String? tag]) {
    _log(LogLevel.info, message, tag);
  }
  
  /// 警告日志
  static void warning(String message, [String? tag]) {
    _log(LogLevel.warning, message, tag);
  }
  
  /// 错误日志
  static void error(String message, [String? tag, Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.error, message, tag);
    if (error != null) {
      debugPrint('\x1B[31mError: $error\x1B[0m');
    }
    if (stackTrace != null) {
      debugPrint('\x1B[31mStackTrace: $stackTrace\x1B[0m');
    }
  }
  
  // ==================== 业务日志方法 ====================
  
  /// 用户操作日志
  static void userAction(String action, {String? detail}) {
    final message = detail != null ? '用户操作: $action - $detail' : '用户操作: $action';
    info(message, 'UserAction');
  }
  
  /// 网络请求日志
  static void networkRequest(String url, {String? method, int? statusCode}) {
    final message = '网络请求: ${method ?? "GET"} $url${statusCode != null ? " - 状态码: $statusCode" : ""}';
    info(message, 'Network');
  }
  
  /// 网络错误日志
  static void networkError(String url, Object err) {
    error('网络请求失败: $url - $err', 'Network', err);
  }
  
  /// 页面导航日志
  static void pageNavigation(String fromPage, String toPage) {
    info('页面导航: $fromPage -> $toPage', 'Navigation');
  }
  
  /// 设备操作日志
  static void deviceOperation(String operation, {String? deviceId, String? result}) {
    final message = '设备操作: $operation${deviceId != null ? " - 设备ID: $deviceId" : ""}${result != null ? " - 结果: $result" : ""}';
    info(message, 'Device');
  }
  
  /// 认证日志
  static void authEvent(String event, {String? userId, String? detail}) {
    final message = '认证事件: $event${userId != null ? " - 用户ID: $userId" : ""}${detail != null ? " - $detail" : ""}';
    info(message, 'Auth');
  }
  
  /// 缓存操作日志
  static void cacheOperation(String operation, String key, {bool? success}) {
    final message = '缓存操作: $operation - Key: $key${success != null ? " - 成功: $success" : ""}';
    debug(message, 'Cache');
  }
  
  /// 性能日志
  static void performance(String operation, Duration duration) {
    final message = '性能监控: $operation - 耗时: ${duration.inMilliseconds}ms';
    info(message, 'Performance');
  }
  
  /// 异常捕获日志
  static void captureException(Object exception, StackTrace stackTrace, {String? context}) {
    final message = '异常捕获${context != null ? " ($context)" : ""}: $exception';
    error(message, 'Exception', exception, stackTrace);
  }
}
