import 'package:flutter/material.dart';
import '../models/country_model.dart';

/// 国家选择管理器 - 在登录、注册、忘记密码页面之间共享国家选择状态
class CountrySelectionManager extends ChangeNotifier {
  static final CountrySelectionManager _instance = CountrySelectionManager._internal();
  
  factory CountrySelectionManager() => _instance;
  
  CountrySelectionManager._internal();
  
  // 默认选择中国
  CountryModel _selectedCountry = CountryList.countries[0];
  
  /// 获取当前选择的国家
  CountryModel get selectedCountry => _selectedCountry;
  
  /// 设置选择的国家
  void selectCountry(CountryModel country) {
    _selectedCountry = country;
    notifyListeners(); // 通知所有监听者更新
  }
  
  /// 根据国家代码设置国家
  void selectCountryByCode(String countryCode) {
    final country = CountryList.countries.firstWhere(
      (c) => c.code == countryCode,
      orElse: () => CountryList.countries[0], // 如果找不到，默认返回中国
    );
    selectCountry(country);
  }
}
