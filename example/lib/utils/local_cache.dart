// import 'package:shared_preferences/shared_preferences.dart';  // 暂时禁用，Kotlin版本兼容性问题

/// 本地数据缓存工具类（内存版本）
/// 
/// 使用内存存储简单的键值对数据
/// 注意：应用重启后数据会丢失，待shared_preferences兼容性问题解决后恢复持久化存储
class LocalCache {
  // static SharedPreferences? _prefs;  // 暂时禁用
  
  // 使用内存Map存储
  static final Map<String, dynamic> _memoryCache = {};
  
  /// 初始化（在应用启动时调用）
  static Future<void> init() async {
    // _prefs = await SharedPreferences.getInstance();  // 暂时禁用
  }
  
  /// 确保已初始化
  static Future<void> _ensureInitialized() async {
    // if (_prefs == null) {
    //   await init();
    // }
  }
  
  // ==================== 字符串存储 ====================
  
  /// 保存字符串
  static Future<bool> setString(String key, String value) async {
    await _ensureInitialized();
    _memoryCache[key] = value;
    return true;
  }
  
  /// 获取字符串
  static String? getString(String key) {
    return _memoryCache[key] as String?;
  }
  
  // ==================== 整数存储 ====================
  
  /// 保存整数
  static Future<bool> setInt(String key, int value) async {
    await _ensureInitialized();
    _memoryCache[key] = value;
    return true;
  }
  
  /// 获取整数
  static int? getInt(String key) {
    return _memoryCache[key] as int?;
  }
  
  // ==================== 布尔值存储 ====================
  
  /// 保存布尔值
  static Future<bool> setBool(String key, bool value) async {
    await _ensureInitialized();
    _memoryCache[key] = value;
    return true;
  }
  
  /// 获取布尔值
  static bool? getBool(String key) {
    return _memoryCache[key] as bool?;
  }
  
  // ==================== 双精度浮点数存储 ====================
  
  /// 保存双精度浮点数
  static Future<bool> setDouble(String key, double value) async {
    await _ensureInitialized();
    _memoryCache[key] = value;
    return true;
  }
  
  /// 获取双精度浮点数
  static double? getDouble(String key) {
    return _memoryCache[key] as double?;
  }
  
  // ==================== 字符串列表存储 ====================
  
  /// 保存字符串列表
  static Future<bool> setStringList(String key, List<String> value) async {
    await _ensureInitialized();
    _memoryCache[key] = value;
    return true;
  }
  
  /// 获取字符串列表
  static List<String>? getStringList(String key) {
    return _memoryCache[key] as List<String>?;
  }
  
  // ==================== 删除操作 ====================
  
  /// 删除指定键
  static Future<bool> remove(String key) async {
    await _ensureInitialized();
    _memoryCache.remove(key);
    return true;
  }
  
  /// 清空所有数据
  static Future<bool> clear() async {
    await _ensureInitialized();
    _memoryCache.clear();
    return true;
  }
  
  // ==================== 常用业务方法 ====================
  
  /// 保存登录状态
  static Future<bool> saveLoginStatus(bool isLoggedIn) {
    return setBool('is_logged_in', isLoggedIn);
  }
  
  /// 获取登录状态
  static bool getLoginStatus() {
    return getBool('is_logged_in') ?? false;
  }
  
  /// 保存用户Token
  static Future<bool> saveToken(String token) {
    return setString('user_token', token);
  }
  
  /// 获取用户Token
  static String? getToken() {
    return getString('user_token');
  }
  
  /// 保存用户ID
  static Future<bool> saveUserId(int userId) {
    return setInt('user_id', userId);
  }
  
  /// 获取用户ID
  static int? getUserId() {
    return getInt('user_id');
  }
  
  /// 保存用户手机号
  static Future<bool> savePhoneNumber(String phoneNumber) {
    return setString('phone_number', phoneNumber);
  }
  
  /// 获取用户手机号
  static String? getPhoneNumber() {
    return getString('phone_number');
  }
  
  /// 保存国家代码
  static Future<bool> saveCountryCode(String countryCode) {
    return setString('country_code', countryCode);
  }
  
  /// 获取国家代码
  static String? getCountryCode() {
    return getString('country_code');
  }
  
  /// 保存语言设置
  static Future<bool> saveLanguage(String language) {
    return setString('app_language', language);
  }
  
  /// 获取语言设置
  static String? getLanguage() {
    return getString('app_language');
  }
  
  /// 是否首次启动
  static bool isFirstLaunch() {
    return getBool('is_first_launch') ?? true;
  }
  
  /// 标记已完成首次启动
  static Future<bool> markFirstLaunchCompleted() {
    return setBool('is_first_launch', false);
  }
  
  /// 保存最后更新时间
  static Future<bool> saveLastUpdateTime(DateTime time) {
    return setString('last_update_time', time.toIso8601String());
  }
  
  /// 获取最后更新时间
  static DateTime? getLastUpdateTime() {
    final timeStr = getString('last_update_time');
    if (timeStr != null) {
      try {
        return DateTime.parse(timeStr);
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}
