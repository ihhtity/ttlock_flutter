import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../models/country_model.dart';
import '../../theme.dart';
import '../../utils/country_selection_manager.dart';
import '../../utils/auth_service.dart';
import '../../utils/local_cache.dart';
import 'country_selector_page.dart';
import 'login_entry_page.dart';
import 'register_page.dart';
import 'forgot_password_page.dart';
import 'terms_pages.dart';
import '../admin/rooms/room_management_page.dart';
import '../user/self_service_page.dart';

/// 登录页面
class LoginPage extends StatefulWidget {
  final LoginType loginType;

  const LoginPage({
    Key? key,
    this.loginType = LoginType.client, // 默认用户端
  }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final CountrySelectionManager _countryManager = CountrySelectionManager();
  bool _obscurePassword = true;
  bool _agreeToTerms = true; // 开发环境默认勾选，方便测试
  bool _isLoading = false;
  bool _usePhoneLogin = true; // true-手机号登录，false-邮箱登录

  @override
  void initState() {
    super.initState();
    // 监听国家选择变化
    _countryManager.addListener(_onCountryChanged);

    // 设置默认测试数据
    _phoneController.text = '19830357494';
    _passwordController.text = '19830357494a.';

    // 加载用户协议同意状态（持久化）
    _loadAgreementStatus();
    
    // 加载已保存的国家选择
    _loadSavedCountry();
  }

  /// 加载已保存的国家选择
  Future<void> _loadSavedCountry() async {
    final savedCountryCode = LocalCache.getSelectedCountryCode();
    if (savedCountryCode != null) {
      // 根据保存的国家代码设置国家
      _countryManager.selectCountryByCode(savedCountryCode);
    }
  }

  /// 加载用户协议同意状态（持久化）
  Future<void> _loadAgreementStatus() async {
    try {
      final agreed = LocalCache.getAgreeTermsStatus();
      if (mounted) {
        setState(() {
          _agreeToTerms = agreed;
        });
      }
    } catch (e) {
      print('加载协议状态失败: $e');
    }
  }

  @override
  void dispose() {
    _countryManager.removeListener(_onCountryChanged);
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// 国家选择变化回调
  void _onCountryChanged() {
    setState(() {
      // 当国家改变时，重建页面以更新显示
    });
    
    // 保存国家选择到本地缓存
    _saveCountrySelection();
  }
  
  /// 保存国家选择
  Future<void> _saveCountrySelection() async {
    final country = _countryManager.selectedCountry;
    // 根据国家代码推断语言代码
    String languageCode = 'zh'; // 默认中文
    if (country.code == 'US' || country.code == 'GB' || country.code == 'CA' || 
        country.code == 'AU' || country.code == 'NZ') {
      languageCode = 'en';
    } else if (country.code == 'JP') {
      languageCode = 'ja';
    } else if (country.code == 'KR') {
      languageCode = 'ko';
    } else if (country.code == 'FR') {
      languageCode = 'fr';
    } else if (country.code == 'DE') {
      languageCode = 'de';
    } else if (country.code == 'ES') {
      languageCode = 'es';
    }
    
    await LocalCache.saveSelectedCountry(country.code, languageCode);
    debugPrint('💾 已保存国家选择: ${country.nameZh} (${country.code}), 语言: $languageCode');
  }

  /// 构建登录方式按钮
  Widget _buildLoginMethodButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      AppTheme.primaryColor,
                      AppTheme.primaryColor.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isSelected ? null : Colors.white,
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : AppTheme.textSecondary,
                size: 22,
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? Colors.white : AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建输入框容器
  Widget _buildInputContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
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

  /// 验证邮箱格式
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegex.hasMatch(email);
  }

  /// 登录
  Future<void> _login() async {
    if (!_validateForm()) return;

    setState(() => _isLoading = true);

    try {
      debugPrint('🔑 ========== 开始登录流程 ==========');
      debugPrint(
          '   - 登录类型: ${(widget.loginType == LoginType.admin) ? "管理端" : "用户端"}');
      debugPrint('   - 登录方式: ${_usePhoneLogin ? "手机号" : "邮箱"}');
      debugPrint(
          '   - 手机号: ${_usePhoneLogin ? _phoneController.text.trim() : "null"}');
      debugPrint(
          '   - 邮箱: ${_usePhoneLogin ? "null" : _emailController.text.trim()}');

      // 调用后端 API 登录
      final response = await AuthService.login(
        phone: _usePhoneLogin ? _phoneController.text.trim() : null,
        email: _usePhoneLogin ? null : _emailController.text.trim(),
        password: _passwordController.text,
        loginType: widget.loginType,
      );

      if (!mounted) return;

      setState(() => _isLoading = false);

      if (response.isSuccess) {
        debugPrint('✅ 登录成功，准备跳转...');
        // 保存用户协议同意状态（持久化）
        await LocalCache.saveAgreeTermsStatus(_agreeToTerms);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).loginSuccess),
            backgroundColor: AppTheme.successColor,
          ),
        );

        // 根据登录类型跳转到不同页面
        final targetPage = widget.loginType == LoginType.admin
            ? const RoomManagementPage()  // 管理端跳转到房间管理
            : const SelfServicePage();     // 用户端跳转到自助服务
        
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => targetPage,
          ),
        );
      } else {
        debugPrint('❌ 登录失败 [${response.code}]: ${response.message}');
        debugPrint('=====================================');

        // 显示错误信息
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } catch (e, stackTrace) {
      setState(() => _isLoading = false);

      debugPrint('❌ 登录异常: $e');
      debugPrint('   - 堆栈信息: $stackTrace');
      debugPrint('=====================================');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('登录失败: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            : null,
        title: Text(
          widget.loginType == LoginType.admin ? '管理端登录' : '用户端登录',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: widget.loginType == LoginType.admin 
            ? AppTheme.primaryColor 
            : AppTheme.successColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacingXLarge),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),

                // 顶部标题 - 左图标右文字（无卡片背景）
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (widget.loginType == LoginType.admin 
                            ? AppTheme.primaryColor 
                            : AppTheme.successColor).withOpacity(0.1),
                      ),
                      child: Icon(
                        widget.loginType == LoginType.admin 
                          ? Icons.admin_panel_settings_rounded
                          : Icons.person_outline_rounded,
                        size: 48,
                        color: widget.loginType == LoginType.admin 
                          ? AppTheme.primaryColor
                          : AppTheme.successColor,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.loginType == LoginType.admin ? '管理端登录' : '用户端登录',
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.loginType == LoginType.admin 
                              ? '管理员、运维人员使用'
                              : '普通用户使用',
                            style: const TextStyle(
                              fontSize: 15,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // 登录方式选择卡片
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryColor.withOpacity(0.05),
                        AppTheme.primaryColor.withOpacity(0.02),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius:
                        BorderRadius.circular(AppTheme.borderRadiusLarge),
                    border: Border.all(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.swap_horiz_rounded,
                          size: 24,
                          color: AppTheme.primaryColor,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '选择登录方式',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildLoginMethodButton(
                                      icon: Icons.phone_android_rounded,
                                      label: '手机号',
                                      isSelected: _usePhoneLogin,
                                      onTap: () {
                                        setState(() => _usePhoneLogin = true);
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildLoginMethodButton(
                                      icon: Icons.email_rounded,
                                      label: '邮箱',
                                      isSelected: !_usePhoneLogin,
                                      onTap: () {
                                        setState(() => _usePhoneLogin = false);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                
                // 国家/地区选择卡片
                _buildInputContainer(
                  child: InkWell(
                    onTap: _selectCountry,
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        children: [
                          Text(
                            _countryManager.selectedCountry.flag,
                            style: const TextStyle(fontSize: 32),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '国家/地区',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _countryManager.selectedCountry.getName(l10n.locale.languageCode),
                                  style: const TextStyle(
                                    fontSize: 17,
                                    color: AppTheme.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _countryManager.selectedCountry.dialCode,
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.keyboard_arrow_right_rounded,
                            color: AppTheme.primaryColor,
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // 手机号输入（当选择手机号登录时显示）
                if (_usePhoneLogin) ...[
                  _buildInputContainer(
                    child: TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        labelText: l10n.phoneNumber,
                        hintText: l10n.pleaseEnterPhoneNumber,
                        prefixText: '${_countryManager.selectedCountry.dialCode} ',
                        prefixStyle: const TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                          borderSide: BorderSide(color: AppTheme.backgroundColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                          borderSide: BorderSide(color: AppTheme.backgroundColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                          borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.pleaseEnterPhoneNumber;
                        }
                        return null;
                      },
                    ),
                  ),
                ],

                // 邮箱输入（当选择邮箱登录时显示）
                if (!_usePhoneLogin) ...[
                  _buildInputContainer(
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        labelText: '邮箱地址',
                        hintText: '请输入邮箱地址',
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: AppTheme.primaryColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              AppTheme.borderRadiusMedium),
                          borderSide:
                              BorderSide(color: AppTheme.backgroundColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              AppTheme.borderRadiusMedium),
                          borderSide:
                              BorderSide(color: AppTheme.backgroundColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              AppTheme.borderRadiusMedium),
                          borderSide: const BorderSide(
                              color: AppTheme.primaryColor, width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入邮箱地址';
                        }
                        if (!_isValidEmail(value)) {
                          return '邮箱格式不正确';
                        }
                        return null;
                      },
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                // 密码输入
                _buildInputContainer(
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: const TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      labelText: l10n.password,
                      hintText: l10n.pleaseEnterPassword,
                      prefixIcon: Icon(
                        Icons.lock_outline_rounded,
                        color: AppTheme.primaryColor,
                      ),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppTheme.borderRadiusMedium),
                        borderSide: BorderSide(color: AppTheme.backgroundColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppTheme.borderRadiusMedium),
                        borderSide: BorderSide(color: AppTheme.backgroundColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppTheme.borderRadiusMedium),
                        borderSide: const BorderSide(
                            color: AppTheme.primaryColor, width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
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
                          builder: (context) => ForgotPasswordPage(
                            loginType: widget.loginType,
                          ),
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
                        await LocalCache.saveAgreeTermsStatus(_agreeToTerms);
                      },
                      activeColor: AppTheme.primaryColor,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          setState(() => _agreeToTerms = !_agreeToTerms);
                          // 实时保存协议同意状态（持久化）
                          await LocalCache.saveAgreeTermsStatus(_agreeToTerms);
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
                                        builder: (context) =>
                                            const UserAgreementPage(),
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
                                        builder: (context) =>
                                            const PrivacyPolicyPage(),
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
                      borderRadius:
                          BorderRadius.circular(AppTheme.borderRadiusMedium),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
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
                            builder: (context) => RegisterPage(
                              loginType: widget.loginType,
                            ),
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
