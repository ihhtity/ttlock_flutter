import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../l10n/app_localizations.dart';
import '../../theme.dart';
import '../../utils/country_selection_manager.dart';
import '../../utils/auth_service.dart';
import 'country_selector_page.dart';

/// 找回密码方式枚举
enum RecoveryMethod {
  phone,  // 通过手机号
  email,  // 通过邮箱
}

/// 忘记密码页面
class ForgotPasswordPage extends StatefulWidget {
  final LoginType loginType;
  
  const ForgotPasswordPage({
    Key? key,
    this.loginType = LoginType.client, // 默认用户端
  }) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _verificationCodeController = TextEditingController();
  
  final CountrySelectionManager _countryManager = CountrySelectionManager();
  RecoveryMethod _recoveryMethod = RecoveryMethod.phone;
  bool _isLoading = false;
  int _countdown = 0;
  String? _retrievedPassword; // 找回的密码
  bool _isPasswordVisible = false; // 密码是否可见

  @override
  void initState() {
    super.initState();
    // 监听国家选择变化
    _countryManager.addListener(_onCountryChanged);
  }

  @override
  void dispose() {
    _countryManager.removeListener(_onCountryChanged);
    _phoneController.dispose();
    _emailController.dispose();
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

  /// 找回密码
  Future<void> _sendVerificationCode() async {
    // 验证输入
    if (_recoveryMethod == RecoveryMethod.phone) {
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
      debugPrint('📧 ========== 开始发送验证码（找回密码） ==========');
      debugPrint('   - 找回方式: ${_recoveryMethod == RecoveryMethod.phone ? "手机号" : "邮箱"}');
      debugPrint('   - Phone: ${_recoveryMethod == RecoveryMethod.phone ? _phoneController.text.trim() : "null"}');
      debugPrint('   - Email: ${_recoveryMethod == RecoveryMethod.email ? _emailController.text.trim() : "null"}');
      
      // 调用后端 API 发送验证码
      final response = await AuthService.sendVerificationCode(
        phone: _recoveryMethod == RecoveryMethod.phone ? _phoneController.text.trim() : null,
        email: _recoveryMethod == RecoveryMethod.email ? _emailController.text.trim() : null,
        type: 2, // 2-找回密码
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

  /// 找回密码
  Future<void> _retrievePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    
    try {
      debugPrint('🔑 ========== 开始找回密码 ==========');
      debugPrint('   - 找回方式: ${_recoveryMethod == RecoveryMethod.phone ? "手机号" : "邮箱"}');
      debugPrint('   - Phone: ${_recoveryMethod == RecoveryMethod.phone ? _phoneController.text.trim() : "null"}');
      debugPrint('   - Email: ${_recoveryMethod == RecoveryMethod.email ? _emailController.text.trim() : "null"}');
      debugPrint('   - LoginType: ${widget.loginType}');
      
      // 调用后端 API 找回密码
      final response = await AuthService.retrievePassword(
        phone: _recoveryMethod == RecoveryMethod.phone ? _phoneController.text.trim() : null,
        email: _recoveryMethod == RecoveryMethod.email ? _emailController.text.trim() : null,
        code: _verificationCodeController.text.trim(),
        loginType: widget.loginType,
      );

      if (!mounted) return;

      setState(() => _isLoading = false);

      if (response.isSuccess && response.data != null) {
        debugPrint('✅ 密码找回成功');
        debugPrint('=====================================');
        
        // 显示密码
        setState(() {
          _retrievedPassword = response.data;
        });
        
        // 显示成功提示
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('密码找回成功！'),
            backgroundColor: AppTheme.successColor,
          ),
        );
      } else {
        debugPrint('❌ 密码找回失败 [${response.code}]: ${response.message}');
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
      
      debugPrint('❌ 找回密码异常: $e');
      debugPrint('   - 堆栈信息: $stackTrace');
      debugPrint('=====================================');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('找回失败: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  /// 复制密码到剪贴板
  void _copyPassword() {
    if (_retrievedPassword != null) {
      Clipboard.setData(ClipboardData(text: _retrievedPassword!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('密码已复制到剪贴板'),
          backgroundColor: AppTheme.successColor,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(l10n.forgotPassword),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
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
          padding: const EdgeInsets.all(AppTheme.spacingXLarge),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 找回方式选择
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingMedium),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
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
                              isSelected: _recoveryMethod == RecoveryMethod.phone,
                              onTap: () {
                                setState(() => _recoveryMethod = RecoveryMethod.phone);
                              },
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacingMedium),
                          Expanded(
                            child: _buildMethodButton(
                              icon: Icons.email_rounded,
                              label: l10n.viaEmail,
                              isSelected: _recoveryMethod == RecoveryMethod.email,
                              onTap: () {
                                setState(() => _recoveryMethod = RecoveryMethod.email);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: AppTheme.spacingLarge),
                
                // 手机号输入（当选择手机号找回时显示）
                if (_recoveryMethod == RecoveryMethod.phone) ...[
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
                          Text(_countryManager.selectedCountry.flag, style: const TextStyle(fontSize: 24)),
                          const SizedBox(width: AppTheme.spacingSmall),
                          Expanded(
                            child: Text(
                              _countryManager.selectedCountry.getName(l10n.locale.languageCode),
                              style: const TextStyle(fontSize: 16, color: AppTheme.textPrimary),
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
                  
                  const SizedBox(height: AppTheme.spacingMedium),
                  
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: l10n.phoneNumber,
                      prefixText: '${_countryManager.selectedCountry.dialCode} ',
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
                ],
                
                // 邮箱输入（当选择邮箱找回时显示）
                if (_recoveryMethod == RecoveryMethod.email) ...[
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: l10n.emailAddress,
                      hintText: l10n.pleaseEnterEmail,
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
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
                            borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
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
                        onPressed: _countdown > 0 || _isLoading ? null : _sendVerificationCode,
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
                
                const SizedBox(height: AppTheme.spacingMedium),
                
                // 找回密码按钮
                ElevatedButton(
                  onPressed: _isLoading ? null : _retrievePassword,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
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
                      : const Text(
                          '找回密码',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                ),
                
                const SizedBox(height: AppTheme.spacingMedium),
                
                // 提示信息
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingMedium),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: AppTheme.primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: AppTheme.spacingSmall),
                      Expanded(
                        child: Text(
                          _recoveryMethod == RecoveryMethod.phone
                              ? l10n.codeWillSendToPhone
                              : l10n.codeWillSendToEmail,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // 显示找回的密码
                if (_retrievedPassword != null) ...[
                  const SizedBox(height: AppTheme.spacingLarge),
                  Container(
                    padding: const EdgeInsets.all(AppTheme.spacingLarge),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.successColor.withOpacity(0.1),
                          AppTheme.successColor.withOpacity(0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
                      border: Border.all(
                        color: AppTheme.successColor.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              color: AppTheme.successColor,
                              size: 24,
                            ),
                            const SizedBox(width: AppTheme.spacingSmall),
                            const Text(
                              '密码找回成功',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.successColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppTheme.spacingMedium),
                        Container(
                          padding: const EdgeInsets.all(AppTheme.spacingMedium),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                            border: Border.all(
                              color: AppTheme.successColor.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _isPasswordVisible ? _retrievedPassword! : '••••••••',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'monospace',
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textPrimary,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility_off_rounded
                                      : Icons.visibility_rounded,
                                  color: AppTheme.primaryColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingMedium),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _copyPassword,
                            icon: const Icon(Icons.copy_rounded),
                            label: const Text('复制密码'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.successColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingSmall),
                        Text(
                          '请妥善保管您的密码，建议立即复制并保存',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  /// 构建找回方式按钮
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
            color: isSelected 
                ? AppTheme.primaryColor
                : AppTheme.backgroundColor,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected 
                  ? AppTheme.primaryColor
                  : AppTheme.textHint,
              size: 28,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected 
                    ? AppTheme.primaryColor
                    : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
