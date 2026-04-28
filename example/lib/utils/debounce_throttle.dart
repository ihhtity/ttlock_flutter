import 'dart:async';

/// 节流防抖工具类
/// 
/// 用于优化频繁触发的事件，如搜索输入、按钮点击等
class DebounceThrottle {
  /// 防抖（Debounce）
  /// 
  /// 在事件被触发n秒后再执行回调，如果n秒内又被触发，则重新计时
  /// 适用场景：搜索框输入、窗口resize
  static Timer? _debounceTimer;
  
  static void debounce(Function() action, {int milliseconds = 500}) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: milliseconds), action);
  }
  
  /// 立即执行的防抖
  /// 
  /// 第一次触发时立即执行，之后在n秒内的触发都会被忽略
  static bool _isImmediateExecuting = false;
  static Timer? _immediateTimer;
  
  static void debounceImmediate(Function() action, {int milliseconds = 500}) {
    if (!_isImmediateExecuting) {
      action();
      _isImmediateExecuting = true;
      
      _immediateTimer?.cancel();
      _immediateTimer = Timer(Duration(milliseconds: milliseconds), () {
        _isImmediateExecuting = false;
      });
    }
  }
  
  /// 节流（Throttle）
  /// 
  /// 规定在一个单位时间内，只能触发一次函数
  /// 如果这个单位时间内触发多次函数，只有一次生效
  /// 适用场景：滚动事件、按钮点击防止重复提交
  static Timer? _throttleTimer;
  static bool _canExecute = true;
  
  static void throttle(Function() action, {int milliseconds = 1000}) {
    if (!_canExecute) return;
    
    _canExecute = false;
    action();
    
    _throttleTimer?.cancel();
    _throttleTimer = Timer(Duration(milliseconds: milliseconds), () {
      _canExecute = true;
    });
  }
  
  /// 清理所有定时器
  static void dispose() {
    _debounceTimer?.cancel();
    _immediateTimer?.cancel();
    _throttleTimer?.cancel();
    _debounceTimer = null;
    _immediateTimer = null;
    _throttleTimer = null;
    _isImmediateExecuting = false;
    _canExecute = true;
  }
}

/// 异步防抖包装器
class AsyncDebounce {
  static Timer? _timer;
  
  /// 异步防抖
  /// 
  /// 返回一个防抖后的Future，只有最后一次调用会真正执行
  static Future<T> debounce<T>(Future<T> Function() action, {int milliseconds = 500}) {
    _timer?.cancel();
    
    final completer = Completer<T>();
    
    _timer = Timer(Duration(milliseconds: milliseconds), () async {
      try {
        final result = await action();
        if (!completer.isCompleted) {
          completer.complete(result);
        }
      } catch (e) {
        if (!completer.isCompleted) {
          completer.completeError(e);
        }
      }
    });
    
    return completer.future;
  }
}

/// 请求队列管理器
/// 
/// 用于管理并发请求，避免同时发起过多网络请求
class RequestQueue {
  static final RequestQueue _instance = RequestQueue._internal();
  
  factory RequestQueue() => _instance;
  
  RequestQueue._internal();
  
  final List<Function()> _queue = [];
  bool _isProcessing = false;
  int _maxConcurrent = 3; // 最大并发数
  int _running = 0;
  
  /// 添加请求到队列
  Future<T> add<T>(Future<T> Function() request) async {
    final completer = Completer<T>();
    
    _queue.add(() async {
      try {
        final result = await request();
        completer.complete(result);
      } catch (e) {
        completer.completeError(e);
      } finally {
        _running--;
        _processQueue();
      }
    });
    
    _processQueue();
    return completer.future as Future<T>;
  }
  
  /// 处理队列中的请求
  void _processQueue() {
    if (_isProcessing || _queue.isEmpty || _running >= _maxConcurrent) {
      return;
    }
    
    _isProcessing = true;
    
    while (_queue.isNotEmpty && _running < _maxConcurrent) {
      final request = _queue.removeAt(0);
      _running++;
      request();
    }
    
    _isProcessing = false;
  }
  
  /// 设置最大并发数
  void setMaxConcurrent(int max) {
    _maxConcurrent = max;
  }
  
  /// 清空队列
  void clear() {
    _queue.clear();
  }
  
  /// 获取队列长度
  int get queueLength => _queue.length;
}
