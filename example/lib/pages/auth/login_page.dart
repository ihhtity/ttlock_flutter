import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../models/country_model.dart';
import '../../theme.dart';
import '../../utils/country_selection_manager.dart';
// import '../../utils/local_json_storage.dart';  // 已移除，使用内存存储
import 'country_selector_page.dart';
import 'register_page.dart';
import 'forgot_password_page.dart';
import 'terms_pages.dart';
import '../rooms/room_management_page.dart';

/// 登录页面
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  
  final CountrySelectionManager _countryManager = CountrySelectionManager();
  bool _obscurePassword = true;
  bool _agreeToTerms = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // 监听国家选择变化
    _countryManager.addListener(_onCountryChanged);
    
    // 设置默认测试数据
    _phoneController.text = '19830357494';
    _passwordController.text = '19830357494a.';
    
    // 加载用户协议同意状态（使用持久化存储）
    _loadAgreementStatus();
  }

  /// 加载用户协议同意状态（持久化）
  Future<void> _loadAgreementStatus() async {
    try {
      // final agreed = await LocalJsonStorage.getSetting('agree_to_terms');
      // if (mounted) {
      //   setState(() {
      //     _agreeToTerms = agreed == true;
      //   });
      // }
    } catch (e) {
      print('加载协议状态失败: $e');
    }
  }

  @override
  void dispose() {
    _countryManager.removeListener(_onCountryChanged);
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// 国家选择变化回调
  void _onCountryChanged() {
    setState(() {
      // 当国家改变时，重建页面以更新显示
    });
  }

  /// 选择国家/地区
  void _selectCountry() async {
    final result = await Navigator.push<CountryModel>(
      context,
      MaterialPageRoute<CountryModel>(
        builder: (context) => CountrySelectorPage(
          selectedCountry: _countryManager.selectedCountry,
          onCountrySelected: (country) {
            // 使用共享管理器设置国家
            _countryManager.selectCountry(country);
          },
        ),
      ),
    );
    
    if (result != null && mounted) {
      _countryManager.selectCountry(result);
    }
  }

  /// 验证表单
  bool _validateForm() {
    if (!_formKey.currentState!.validate()) return false;
    
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).mustAgreeToTerms),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return false;
    }
    
    return true;
  }

  /// 登录
  Future<void> _login() async {
    if (!_validateForm()) return;

    setState(() => _isLoading = true);

    // TODO: 实现实际的登录逻辑
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    if (mounted) {
      // 保存用户协议同意状态（持久化）
      // await LocalJsonStorage.updateSetting('agree_to_terms', _agreeToTerms);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).loginSuccess),
          backgroundColor: AppTheme.successColor,
        ),
      );
      
      // 登录成功后跳转到设备管理页面
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const RoomManagementPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacingXLarge),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                
                // Logo和标题
                Icon(
                  Icons.lock_outline_rounded,
                  size: 80,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(height: AppTheme.spacingMedium),
                Text(
                  l10n.appName,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.spacingSmall),
                Text(
                  l10n.welcomeToTTLock,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 48),
                
                // 国家/地区选择
                InkWell(
                  onTap: _selectCountry,
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                  child: Container(
                    padding: const EdgeInsets.all(AppTheme.spacingMedium),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                      border: Border.all(color: AppTheme.backgroundColor),
                    ),
                    child: Row(
                      children: [
                        Text(
                          _countryManager.selectedCountry.flag,
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(width: AppTheme.spacingSmall),
                        Text(
                          _countryManager.selectedCountry.getName(l10n.locale.languageCode),
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          _countryManager.selectedCountry.dialCode,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppTheme.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacingSmall),
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppTheme.textHint,
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: AppTheme.spacingMedium),
                
                // 手机号输入
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: l10n.phoneNumber,
                    hintText: l10n.pleaseEnterPhoneNumber,
                    prefixText: '${_countryManager.selectedCountry.dialCode} ',
                    prefixStyle: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.pleaseEnterPhoneNumber;
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: AppTheme.spacingMedium),
                
                // 密码输入
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: l10n.password,
                    hintText: l10n.pleaseEnterPassword,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        color: AppTheme.textHint,
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.pleaseEnterPassword;
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: AppTheme.spacingSmall),
                
                // 忘记密码
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordPage(),
                        ),
                      );
                    },
                    child: Text(
                      l10n.forgotPassword,
                      style: const TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: AppTheme.spacingMedium),
                
                // 用户协议
                Row(
                  children: [
                    Checkbox(
                      value: _agreeToTerms,
                      onChanged: (value) async {
                        setState(() => _agreeToTerms = value ?? false);
                        // 实时保存协议同意状态（持久化）
                        // await LocalJsonStorage.updateSetting('agree_to_terms', _agreeToTerms);
                      },
                      activeColor: AppTheme.primaryColor,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          setState(() => _agreeToTerms = !_agreeToTerms);
                          // 实时保存协议同意状态（持久化）
                          // await LocalJsonStorage.updateSetting('agree_to_terms', _agreeToTerms);
                        },
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppTheme.textSecondary,
                            ),
                            children: [
                              TextSpan(text: l10n.agreeToTerms),
                              TextSpan(
                                text: '《${l10n.userAgreement}》',
                                style: const TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const UserAgreementPage(),
                                      ),
                                    );
                                  },
                              ),
                              TextSpan(text: l10n.and),
                              TextSpan(
                                text: '《${l10n.privacyPolicy}》',
                                style: const TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const PrivacyPolicyPage(),
                                      ),
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppTheme.spacingLarge),
                
                // 登录按钮
                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          l10n.login,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
                
                const SizedBox(height: AppTheme.spacingMedium),
                
                // 注册链接
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.noAccount,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                        );
                      },
                      child: Text(
                        l10n.register,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
