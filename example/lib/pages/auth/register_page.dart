import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../models/country_model.dart';
import '../../theme.dart';
import '../../utils/country_selection_manager.dart';
import '../../utils/auth_service.dart';
import '../../utils/local_cache.dart';
import 'country_selector_page.dart';
import 'terms_pages.dart';

/// 注册方式枚举
enum RegisterMethod {
  phone, // 手机号注册
  email, // 邮箱注册
}

/// 注册页面
class RegisterPage extends StatefulWidget {
  final LoginType loginType;

  const RegisterPage({
    Key? key,
    this.loginType = LoginType.client, // 默认用户端
  }) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _verificationCodeController = TextEditingController();

  final CountrySelectionManager _countryManager = CountrySelectionManager();
  RegisterMethod _registerMethod = RegisterMethod.phone;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = true; // 开发环境默认勾选，方便测试
  bool _isLoading = false;
  int _countdown = 0;

  @override
  void initState() {
    super.initState();
    // 监听国家选择变化
    _countryManager.addListener(_onCountryChanged);

    // 设置默认测试数据
    _phoneController.text = '13277751142';
    _emailController.text = 'ihhtity@qq.com';
    _passwordController.text = 'l12345678';
    _confirmPasswordController.text = 'l12345678';
    _verificationCodeController.text = '123456';

    // 加载用户协议同意状态（持久化）
    _loadAgreementStatus();
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
    _confirmPasswordController.dispose();
    _verificationCodeController.dispose();
    super.dispose();
  }

  /// 国家选择变化回调
  void _onCountryChanged() {
    setState(() {
      // 当国家改变时，重建页面以更新显示
    });
  }

  /// 验证邮箱格式
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegex.hasMatch(email);
  }

  /// 检测是否包含中文字符
  bool _containsChinese(String text) {
    // 匹配中文字符（包括简体中文、繁体中文）
    final chineseRegex = RegExp(r'[\u4e00-\u9fff\u3400-\u4dbf\uf900-\ufaff\u3300-\u33ff\ufe30-\ufe4f]');
    return chineseRegex.hasMatch(text);
  }

  /// 验证密码强度
  /// 要求：8-20位，至少包含数字/字母/符号中的两位
  String? _validatePassword(String? value) {
    final l10n = AppLocalizations.of(context);

    if (value == null || value.isEmpty) {
      return l10n.pleaseEnterPassword;
    }

    // 检查长度
    if (value.length < 8 || value.length > 20) {
      return l10n.passwordLengthError;
    }

    // 检查是否包含数字
    bool hasDigit = RegExp(r'\d').hasMatch(value);
    // 检查是否包含字母
    bool hasLetter = RegExp(r'[a-zA-Z]').hasMatch(value);
    // 检查是否包含符号
    bool hasSymbol = RegExp(r"[^\w\s]").hasMatch(value);

    // 统计包含的字符类型数量
    int typeCount = 0;
    if (hasDigit) typeCount++;
    if (hasLetter) typeCount++;
    if (hasSymbol) typeCount++;

    // 至少需要包含两种类型
    if (typeCount < 2) {
      return l10n.passwordComplexityError;
    }

    return null;
  }

  /// 发送验证码
  Future<void> _sendVerificationCode() async {
    // 验证输入
    if (_registerMethod == RegisterMethod.phone) {
      if (_phoneController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).pleaseEnterPhoneNumber),
            backgroundColor: AppTheme.errorColor,
          ),
        );
        return;
      }
    } else {
      if (_emailController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).pleaseEnterEmail),
            backgroundColor: AppTheme.errorColor,
          ),
        );
        return;
      }

      if (!_isValidEmail(_emailController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).invalidEmail),
            backgroundColor: AppTheme.errorColor,
          ),
        );
        return;
      }
    }

    setState(() => _isLoading = true);

    try {
      debugPrint('📧 ========== 开始发送验证码 ==========');
      debugPrint('   - 注册方式: ${_registerMethod == RegisterMethod.phone ? "手机号" : "邮箱"}');
      debugPrint('   - Phone: ${_registerMethod == RegisterMethod.phone ? _phoneController.text.trim() : "null"}');
      debugPrint('   - Email: ${_registerMethod == RegisterMethod.email ? _emailController.text.trim() : "null"}');
      
      // 调用后端 API 发送验证码
      final response = await AuthService.sendVerificationCode(
        phone: _registerMethod == RegisterMethod.phone
            ? _phoneController.text.trim()
            : null,
        email: _registerMethod == RegisterMethod.email
            ? _emailController.text.trim()
            : null,
        type: 1, // 1-注册
      );

      if (!mounted) return;

      setState(() => _isLoading = false);

      if (response.isSuccess) {
        debugPrint('✅ 验证码发送成功');
        debugPrint('=====================================');
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('验证码已发送'),
            backgroundColor: AppTheme.successColor,
          ),
        );

        // 开始倒计时
        setState(() => _countdown = 60);

        Future.doWhile(() async {
          await Future.delayed(const Duration(seconds: 1));
          if (_countdown > 0 && mounted) {
            setState(() => _countdown--);
            return true;
          }
          return false;
        });
      } else {
        debugPrint('❌ 验证码发送失败 [${response.code}]: ${response.message}');
        debugPrint('=====================================');
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } catch (e, stackTrace) {
      setState(() => _isLoading = false);

      debugPrint('❌ 发送验证码异常: $e');
      debugPrint('   - 堆栈信息: $stackTrace');
      debugPrint('=====================================');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('发送失败: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  /// 注册
  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).passwordsDoNotMatch),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).mustAgreeToTerms),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    // 验证验证码不能为空
    if (_verificationCodeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('请输入验证码'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    // 检查是否包含中文字符
    final account = _registerMethod == RegisterMethod.phone 
        ? _phoneController.text.trim() 
        : _emailController.text.trim();
    if (_containsChinese(account)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('账号不能包含中文字符'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    if (_containsChinese(_passwordController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('密码不能包含中文字符'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    if (_containsChinese(_confirmPasswordController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('确认密码不能包含中文字符'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    if (_containsChinese(_verificationCodeController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('验证码不能包含中文字符'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      debugPrint('📝 ========== 开始注册流程 ==========');
      debugPrint('   - 注册方式: ${_registerMethod == RegisterMethod.phone ? "手机号" : "邮箱"}');
      debugPrint('   - Phone: ${_registerMethod == RegisterMethod.phone ? _phoneController.text.trim() : "null"}');
      debugPrint('   - Email: ${_registerMethod == RegisterMethod.email ? _emailController.text.trim() : "null"}');
      debugPrint('   - LoginType: ${widget.loginType}');
      debugPrint('   - AdminsID: ${(widget.loginType == LoginType.admin) ? 1 : 0}');
      
      // 第一步：验证验证码
      debugPrint('🔍 步骤1: 验证验证码...');
      final verifyResponse = await AuthService.verifyCode(
        phone: _registerMethod == RegisterMethod.phone
            ? _phoneController.text.trim()
            : null,
        email: _registerMethod == RegisterMethod.email
            ? _emailController.text.trim()
            : null,
        code: _verificationCodeController.text.trim(),
        type: 1, // 1-注册
      );

      if (!verifyResponse.isSuccess) {
        setState(() => _isLoading = false);
        debugPrint('❌ 验证码验证失败: ${verifyResponse.message}');
        debugPrint('=====================================');
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('验证码错误: ${verifyResponse.message}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
        return;
      }

      debugPrint('✅ 验证码验证通过');

      // 第二步：验证码正确，执行注册
      debugPrint('📝 步骤2: 执行注册...');
      final response = await AuthService.register(
        phone: _registerMethod == RegisterMethod.phone
            ? _phoneController.text.trim()
            : '',
        email: _registerMethod == RegisterMethod.email
            ? _emailController.text.trim()
            : null,
        password: _passwordController.text,
        nickname: _registerMethod == RegisterMethod.phone
            ? _phoneController.text.trim()
            : _emailController.text.trim(),
        adminsId: (widget.loginType == LoginType.admin) ? 1 : 0, // 管理端需要 adminsId，用户端可以为 0
        agreeTerms: _agreeToTerms,
        loginType: widget.loginType, // 传递登录类型
        country: _countryManager.selectedCountry.code,
        dialCode: _countryManager.selectedCountry.dialCode,
      );

      if (!mounted) return;

      setState(() => _isLoading = false);

      if (response.isSuccess) {
        debugPrint('✅ 注册成功');
        debugPrint('=====================================');
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).registerSuccess),
            backgroundColor: AppTheme.successColor,
          ),
        );
        Navigator.pop(context);
      } else {
        debugPrint('❌ 注册失败 [${response.code}]: ${response.message}');
        debugPrint('=====================================');
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } catch (e, stackTrace) {
      setState(() => _isLoading = false);

      debugPrint('❌ 注册异常: $e');
      debugPrint('   - 堆栈信息: $stackTrace');
      debugPrint('=====================================');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('注册失败: $e'),
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
        title: Text(l10n.register),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.primaryGradient,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 注册方式选择
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingMedium),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(AppTheme.borderRadiusMedium),
                    border: Border.all(color: AppTheme.backgroundColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.selectRecoveryMethod,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingSmall),
                      Row(
                        children: [
                          Expanded(
                            child: _buildMethodButton(
                              icon: Icons.phone_android_rounded,
                              label: l10n.viaPhone,
                              isSelected:
                                  _registerMethod == RegisterMethod.phone,
                              onTap: () {
                                setState(() =>
                                    _registerMethod = RegisterMethod.phone);
                              },
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacingMedium),
                          Expanded(
                            child: _buildMethodButton(
                              icon: Icons.email_rounded,
                              label: l10n.viaEmail,
                              isSelected:
                                  _registerMethod == RegisterMethod.email,
                              onTap: () {
                                setState(() =>
                                    _registerMethod = RegisterMethod.email);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 手机号输入（当选择手机号注册时显示）
                if (_registerMethod == RegisterMethod.phone) ...[
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CountrySelectorPage(
                            selectedCountry: _countryManager.selectedCountry,
                            onCountrySelected: (country) {
                              _countryManager.selectCountry(country);
                            },
                          ),
                        ),
                      );
                    },
                    borderRadius:
                        BorderRadius.circular(AppTheme.borderRadiusMedium),
                    child: Container(
                      padding: const EdgeInsets.all(AppTheme.spacingMedium),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(AppTheme.borderRadiusMedium),
                        border: Border.all(color: AppTheme.backgroundColor),
                      ),
                      child: Row(
                        children: [
                          Text(_countryManager.selectedCountry.flag,
                              style: const TextStyle(fontSize: 24)),
                          const SizedBox(width: AppTheme.spacingSmall),
                          Expanded(
                            child: Text(
                              _countryManager.selectedCountry
                                  .getName(l10n.locale.languageCode),
                              style: const TextStyle(
                                  fontSize: 16, color: AppTheme.textPrimary),
                            ),
                          ),
                          Text(
                            _countryManager.selectedCountry.dialCode,
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppTheme.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: l10n.phoneNumber,
                      prefixText:
                          '${_countryManager.selectedCountry.dialCode} ',
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppTheme.borderRadiusMedium),
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
                ],

                // 邮箱输入（当选择邮箱注册时显示）
                if (_registerMethod == RegisterMethod.email) ...[
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: l10n.emailAddress,
                      hintText: l10n.pleaseEnterEmail,
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppTheme.borderRadiusMedium),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.pleaseEnterEmail;
                      }
                      if (!_isValidEmail(value)) {
                        return l10n.invalidEmail;
                      }
                      return null;
                    },
                  ),
                ],

                const SizedBox(height: AppTheme.spacingMedium),

                // 验证码
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _verificationCodeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: l10n.verificationCode,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                AppTheme.borderRadiusMedium),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.pleaseEnterVerificationCode;
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingSmall),
                    SizedBox(
                      width: 120,
                      child: ElevatedButton(
                        onPressed: _countdown > 0 || _isLoading
                            ? null
                            : _sendVerificationCode,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          _countdown > 0 ? '${_countdown}s' : l10n.getCode,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: l10n.password,
                    hintText: l10n.passwordStrengthHint,
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppTheme.borderRadiusMedium),
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
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    helperText: l10n.passwordComplexityError,
                    helperStyle:
                        const TextStyle(fontSize: 12, color: AppTheme.textHint),
                  ),
                  validator: _validatePassword,
                ),

                const SizedBox(height: 12),

                // 确认密码
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: l10n.confirmPassword,
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppTheme.borderRadiusMedium),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        color: AppTheme.textHint,
                      ),
                      onPressed: () => setState(() =>
                          _obscureConfirmPassword = !_obscureConfirmPassword),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.pleaseEnterConfirmPassword;
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),

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
                                fontSize: 13, color: AppTheme.textSecondary),
                            children: [
                              TextSpan(text: l10n.agreeToTerms),
                              TextSpan(
                                text: '《${l10n.userAgreement}》',
                                style: const TextStyle(
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.w500),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const UserAgreementPage()),
                                    );
                                  },
                              ),
                              TextSpan(text: l10n.and),
                              TextSpan(
                                text: '《${l10n.privacyPolicy}》',
                                style: const TextStyle(
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.w500),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const PrivacyPolicyPage()),
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

                const SizedBox(height: 20),

                // 注册按钮
                ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white)),
                        )
                      : Text(l10n.register,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 构建注册方式按钮
  Widget _buildMethodButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
          border: Border.all(
            color:
                isSelected ? AppTheme.primaryColor : AppTheme.backgroundColor,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.primaryColor : AppTheme.textHint,
              size: 28,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color:
                    isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
