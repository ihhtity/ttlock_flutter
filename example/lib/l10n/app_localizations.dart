import 'package:flutter/material.dart';
import 'translation_manager.dart';

/// 应用本地化代理 - 支持多语言切换
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  // 辅助方法：从上下文获取本地化实例
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  // 委托类列表
  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  // 支持的语言列表
  static const List<Locale> supportedLocales = [
    Locale('zh', 'CN'), // 简体中文
    Locale('en', 'US'), // 英语
    Locale('ja', 'JP'), // 日语
    Locale('ko', 'KR'), // 韩语
    Locale('fr', 'FR'), // 法语
    Locale('de', 'DE'), // 德语
    Locale('es', 'ES'), // 西班牙语
  ];

  // 当前语言的翻译Map（从TranslationManager动态获取）
  Map<String, String> _translations = {};

  // 加载对应语言的翻译
  Future<void> load() async {
    _translations = TranslationManager.getTranslations(locale.languageCode);
  }

  // ==================== 通用文本 ====================
  String get appName => translate('appName');
  String get confirm => translate('confirm');
  String get cancel => translate('cancel');
  String get ok => translate('ok');
  String get save => translate('save');
  String get delete => translate('delete');
  String get edit => translate('edit');
  String get loading => translate('loading');
  String get success => translate('success');
  String get error => translate('error');
  String get warning => translate('warning');
  String get retry => translate('retry');
  String get back => translate('back');
  String get next => translate('next');
  String get finish => translate('finish');
  String get skip => translate('skip');

  // ==================== 登录注册相关 ====================
  String get login => translate('login');
  String get register => translate('register');
  String get noAccount => translate('noAccount');
  String get hasAccount => translate('hasAccount');
  String get logout => translate('logout');
  String get forgotPassword => translate('forgotPassword');
  String get resetPassword => translate('resetPassword');
  String get phoneNumber => translate('phoneNumber');
  String get password => translate('password');
  String get confirmPassword => translate('confirmPassword');
  String get verificationCode => translate('verificationCode');
  String get sendCode => translate('sendCode');
  String get resendCode => translate('resendCode');
  String get getCode => translate('getCode');
  String get pleaseEnterPhoneNumber => translate('pleaseEnterPhoneNumber');
  String get pleaseEnterPassword => translate('pleaseEnterPassword');
  String get passwordStrengthHint => translate('passwordStrengthHint');
  String get passwordLengthError => translate('passwordLengthError');
  String get passwordComplexityError => translate('passwordComplexityError');
  String get pleaseEnterConfirmPassword => translate('pleaseEnterConfirmPassword');
  String get pleaseEnterVerificationCode => translate('pleaseEnterVerificationCode');
  String get passwordsDoNotMatch => translate('passwordsDoNotMatch');
  String get invalidPhoneNumber => translate('invalidPhoneNumber');
  String get invalidVerificationCode => translate('invalidVerificationCode');
  String get loginSuccess => translate('loginSuccess');
  String get registerSuccess => translate('registerSuccess');
  String get passwordResetSuccess => translate('passwordResetSuccess');
  String get accountNotFound => translate('accountNotFound');
  String get wrongPassword => translate('wrongPassword');
  String get accountDisabled => translate('accountDisabled');
  
  // 邮箱相关
  String get emailAddress => translate('emailAddress');
  String get pleaseEnterEmail => translate('pleaseEnterEmail');
  String get invalidEmail => translate('invalidEmail');
  String get recoveryMethod => translate('recoveryMethod');
  String get viaPhone => translate('viaPhone');
  String get viaEmail => translate('viaEmail');
  String get selectRecoveryMethod => translate('selectRecoveryMethod');
  String get codeWillSendToPhone => translate('codeWillSendToPhone');
  String get codeWillSendToEmail => translate('codeWillSendToEmail');
  
  // 用户协议和隐私政策
  String get userAgreement => translate('userAgreement');
  String get privacyPolicy => translate('privacyPolicy');
  String get agreeToTerms => translate('agreeToTerms');
  String get mustAgreeToTerms => translate('mustAgreeToTerms');
  String get readAndAgree => translate('readAndAgree');
  String get and => translate('and');
  String get lastUpdated => translate('lastUpdated');
  
  // 用户协议章节标题
  String get uaAcceptance => translate('uaAcceptance');
  String get uaServices => translate('uaServices');
  String get uaRegistration => translate('uaRegistration');
  String get uaConduct => translate('uaConduct');
  String get uaIP => translate('uaIP');
  String get uaDisclaimer => translate('uaDisclaimer');
  String get uaTermination => translate('uaTermination');
  String get uaLaw => translate('uaLaw');
  
  // 隐私政策章节标题
  String get ppIntro => translate('ppIntro');
  String get ppCollection => translate('ppCollection');
  String get ppCookies => translate('ppCookies');
  String get ppSharing => translate('ppSharing');
  String get ppProtection => translate('ppProtection');
  String get ppRights => translate('ppRights');
  String get ppMinors => translate('ppMinors');
  String get ppUpdates => translate('ppUpdates');
  String get ppContact => translate('ppContact');

  // 国家/地区选择
  String get selectCountry => translate('selectCountry');
  String get searchCountry => translate('searchCountry');
  String get countryRegion => translate('countryRegion');

  // ==================== 主页相关 ====================
  String get welcomeToTTLock => translate('welcomeToTTLock');
  String get manageSmartDevices => translate('manageSmartDevices');
  String get smartDevices => translate('smartDevices');
  String get smartLock => translate('smartLock');
  String get controlManage => translate('controlManage');
  String get gateway => translate('gateway');
  String get networkHub => translate('networkHub');
  String get electricMeter => translate('electricMeter');
  String get powerMonitor => translate('powerMonitor');
  String get keyPad => translate('keyPad');
  String get accessControl => translate('accessControl');
  String get waterMeter => translate('waterMeter');
  String get usageTracker => translate('usageTracker');

  // ==================== 扫描页面 ====================
  String get searchingDevices => translate('searchingDevices');
  String get makeSurePairingMode => translate('makeSurePairingMode');
  String get alreadyInitialized => translate('alreadyInitialized');
  String get tapToInitialize => translate('tapToInitialize');
  String get tapToConnect => translate('tapToConnect');
  String get touchKeyboard => translate('touchKeyboard');
  String get powerOnGateway => translate('powerOnGateway');

  // ==================== 错误消息 ====================
  String get networkError => translate('networkError');
  String get serverError => translate('serverError');
  String get timeoutError => translate('timeoutError');
  String get unknownError => translate('unknownError');

  // ==================== 翻译方法 ====================
  /// 根据key获取翻译文本
  String translate(String key) {
    return _translations[key] ?? key;
  }
}

/// 本地化委托
class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool isSupported(Locale locale) {
    return TranslationManager.isSupported(locale.languageCode);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
