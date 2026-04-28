import 'package:flutter/material.dart';

/// 语言管理器 - 管理应用的语言设置
class LanguageManager extends ChangeNotifier {
  static final LanguageManager _instance = LanguageManager._internal();
  
  factory LanguageManager() => _instance;
  
  LanguageManager._internal();
  
  Locale _currentLocale = const Locale('zh', 'CN');
  
  /// 获取当前语言
  Locale get currentLocale => _currentLocale;
  
  /// 根据国家代码设置语言
  void setLanguageByCountry(String countryCode) {
    // 根据国家代码映射到对应的语言
    final locale = _getLocaleFromCountry(countryCode);
    if (locale != null) {
      _currentLocale = locale;
      notifyListeners(); // 通知所有监听者
    }
  }
  
  /// 直接设置语言
  void setLocale(Locale locale) {
    _currentLocale = locale;
    notifyListeners(); // 通知所有监听者
  }
  
  /// 根据国家代码获取对应的语言
  static Locale? _getLocaleFromCountry(String countryCode) {
    // 简体中文地区
    const chineseCountries = {'CN', 'TW', 'HK', 'SG'};
    if (chineseCountries.contains(countryCode)) {
      return const Locale('zh', 'CN');
    }
    
    // 日本
    if (countryCode == 'JP') {
      return const Locale('ja', 'JP');
    }
    
    // 韩国
    if (countryCode == 'KR') {
      return const Locale('ko', 'KR');
    }
    
    // 法国
    if (countryCode == 'FR') {
      return const Locale('fr', 'FR');
    }
    
    // 德国、奥地利、瑞士（德语区）
    const germanCountries = {'DE', 'AT', 'CH'};
    if (germanCountries.contains(countryCode)) {
      return const Locale('de', 'DE');
    }
    
    // 西班牙、墨西哥、阿根廷等（西班牙语区）
    const spanishCountries = {'ES', 'MX', 'AR', 'CO', 'CL', 'PE', 'VE'};
    if (spanishCountries.contains(countryCode)) {
      return const Locale('es', 'ES');
    }
    
    // 其他国家默认使用英文
    return const Locale('en', 'US');
  }
  
  /// 获取支持的语言列表
  List<Locale> get supportedLocales => [
    const Locale('zh', 'CN'),
    const Locale('en', 'US'),
    const Locale('ja', 'JP'),
    const Locale('ko', 'KR'),
    const Locale('fr', 'FR'),
    const Locale('de', 'DE'),
    const Locale('es', 'ES'),
  ];
}
