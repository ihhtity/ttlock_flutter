import 'package:flutter/material.dart';
import '../../../../theme.dart';
import '../../../../utils/auth_service.dart';
import '../../../../utils/local_cache.dart';
import '../../../../utils/api_client.dart';
import '../../../../models/country_model.dart';
import '../../auth/country_selector_page.dart';

/// 用户端个人信息页面
class UserPersonalInfoPage extends StatefulWidget {
  const UserPersonalInfoPage({Key? key}) : super(key: key);

  @override
  _UserPersonalInfoPageState createState() => _UserPersonalInfoPageState();
}

class _UserPersonalInfoPageState extends State<UserPersonalInfoPage> {
  Map<String, dynamic>? _userInfo;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  /// 加载用户信息（从缓存）
  void _loadUserInfo() {
    setState(() {
      _isLoading = true;
    });

    try {
      final userInfo = LocalCache.getUserInfo();
      
      setState(() {
        _userInfo = userInfo ?? {};
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('加载用户信息失败: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  /// 更新缓存的用户信息
  Future<void> _updateUserInfo(Map<String, dynamic> updates) async {
    if (_userInfo != null) {
      _userInfo!.addAll(updates);
      await LocalCache.saveUserInfo(_userInfo!);
      setState(() {});
    }
  }
  
  /// 根据国家代码查找国家
  CountryModel _findCountryByCode(String countryCode) {
    return CountryList.countries.firstWhere(
      (c) => c.dialCode == countryCode,
      orElse: () => CountryList.countries[0], // 默认返回中国
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('个人信息'),
          centerTitle: true,
          backgroundColor: AppTheme.primaryColor,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('个人信息'),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 昵称
            _buildNicknameSection(),
            
            const Divider(height: 1),
            
            // 手机号
            _buildPhoneSection(),
            
            const Divider(height: 1),
            
            // 邮箱
            _buildEmailSection(),
            
            const Divider(height: 1),
            
            // 重置密码
            _buildResetPasswordSection(),
            
            const Divider(height: 1),
            
            // 国家/地区
            _buildCountrySection(),
          ],
        ),
      ),
    );
  }

  /// 昵称设置
  Widget _buildNicknameSection() {
    return ListTile(
      leading: const Icon(Icons.person_outline_rounded, color: AppTheme.primaryColor),
      title: const Text('昵称'),
      subtitle: Text(
        _userInfo?['nickname'] ?? '未设置',
        style: const TextStyle(fontSize: 14),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppTheme.textHint),
      onTap: _editNickname,
    );
  }

  /// 编辑昵称
  void _editNickname() {
    final controller = TextEditingController(text: _userInfo?['nickname'] ?? '');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
        ),
        title: const Text('修改昵称'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: '请输入昵称',
            border: OutlineInputBorder(),
          ),
          maxLength: 20,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.trim().isNotEmpty) {
                // 调用后端API更新昵称
                final response = await HttpClient.put('/user/profile', body: {
                  'nickname': controller.text.trim(),
                });
                
                if (response.isSuccess) {
                  await _updateUserInfo({'nickname': controller.text.trim()});
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('昵称修改成功'),
                      backgroundColor: AppTheme.successColor,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(response.message)),
                  );
                }
              }
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  /// 手机号设置
  Widget _buildPhoneSection() {
    final phone = _userInfo?['phone'];
    final isBound = phone != null && phone.toString().isNotEmpty;
    
    return ListTile(
      leading: const Icon(Icons.phone_android_rounded, color: AppTheme.primaryColor),
      title: const Text('手机号'),
      subtitle: Text(
        isBound ? phone! : '未绑定',
        style: TextStyle(
          fontSize: 14,
          color: isBound ? null : AppTheme.textHint,
        ),
      ),
      trailing: isBound
          ? PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert_rounded, color: AppTheme.textHint),
              onSelected: _handlePhoneAction,
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'change',
                  child: Text('更换手机号'),
                ),
                const PopupMenuItem(
                  value: 'unbind',
                  child: Text('解绑手机号', style: TextStyle(color: AppTheme.errorColor)),
                ),
              ],
            )
          : const Icon(Icons.chevron_right_rounded, color: AppTheme.textHint),
      onTap: isBound ? null : () => _bindPhone(),
    );
  }

  /// 处理手机号操作
  void _handlePhoneAction(String action) {
    switch (action) {
      case 'change':
        _changePhone();
        break;
      case 'unbind':
        _unbindPhone();
        break;
    }
  }

  /// 绑定手机号
  void _bindPhone() {
    final phoneController = TextEditingController();
    final codeController = TextEditingController();
    String selectedCountryCode = '+86'; // 默认中国
    String selectedCountryName = '中国';
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
          ),
          title: const Text('绑定手机号'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 国家/地区选择
                InkWell(
                  onTap: isLoading ? null : () async {
                    // 显示国家选择对话框
                    final result = await Navigator.push<CountryModel>(
                      context,
                      MaterialPageRoute<CountryModel>(
                        builder: (context) => CountrySelectorPage(
                          selectedCountry: _findCountryByCode(selectedCountryCode),
                          onCountrySelected: (country) {
                            // 国家选择后会通过返回值传递
                          },
                        ),
                      ),
                    );
                    
                    if (result != null && context.mounted) {
                      setState(() {
                        selectedCountryCode = result.dialCode;
                        selectedCountryName = result.nameZh;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '国家/地区: $selectedCountryName ($selectedCountryCode)',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const Icon(Icons.arrow_drop_down, color: AppTheme.textHint),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: '手机号',
                    hintText: '请输入手机号',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: codeController,
                        decoration: const InputDecoration(
                          labelText: '验证码',
                          hintText: '请输入验证码',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: isLoading ? null : () async {
                        if (phoneController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('请先输入手机号')),
                          );
                          return;
                        }
                        // 发送验证码
                        setState(() {
                          isLoading = true;
                        });
                        
                        final response = await HttpClient.post('/auth/send-code', body: {
                          'phone': phoneController.text,
                          'type': 3, // 3 = 绑定手机
                        });
                        
                        setState(() {
                          isLoading = false;
                        });
                        
                        if (response.isSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('验证码已发送')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(response.message)),
                          );
                        }
                      },
                      child: const Text('发送'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: isLoading ? null : () async {
                if (phoneController.text.isEmpty || codeController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('请填写完整信息')),
                  );
                  return;
                }

                setState(() {
                  isLoading = true;
                });

                // 调用后端API绑定手机号
                final response = await HttpClient.post('/user/bind-phone', body: {
                  'phone': phoneController.text,
                  'code': codeController.text,
                  'password': '', // 绑定时不需要密码
                  'country': selectedCountryName,
                  'dial_code': selectedCountryCode,
                });

                setState(() {
                  isLoading = false;
                });

                if (response.isSuccess) {
                  // 更新缓存
                  await _updateUserInfo({
                    'phone': phoneController.text,
                    'country': selectedCountryName,
                    'dial_code': selectedCountryCode,
                  });

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('手机号绑定成功'),
                      backgroundColor: AppTheme.successColor,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(response.message)),
                  );
                }
              },
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('确定'),
            ),
          ],
        ),
      ),
    );
  }

  /// 更换手机号
  void _changePhone() {
    final phoneController = TextEditingController();
    final codeController = TextEditingController();
    final passwordController = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
          ),
          title: const Text('更换手机号'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: '新手机号',
                  hintText: '请输入新手机号',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: codeController,
                      decoration: const InputDecoration(
                        labelText: '验证码',
                        hintText: '请输入验证码',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: isLoading ? null : () async {
                      if (phoneController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('请先输入手机号')),
                        );
                        return;
                      }
                      // 发送验证码
                      setState(() {
                        isLoading = true;
                      });
                      
                      final response = await HttpClient.post('/auth/send-code', body: {
                        'phone': phoneController.text,
                        'type': 3, // 3 = 绑定手机
                      });
                      
                      setState(() {
                        isLoading = false;
                      });
                      
                      if (response.isSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('验证码已发送')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(response.message)),
                        );
                      }
                    },
                    child: const Text('发送'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: '登录密码',
                  hintText: '请输入登录密码',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: isLoading ? null : () async {
                if (phoneController.text.isEmpty || 
                    codeController.text.isEmpty || 
                    passwordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('请填写完整信息')),
                  );
                  return;
                }

                setState(() {
                  isLoading = true;
                });

                // 调用后端API更换手机号
                final response = await HttpClient.post('/user/change-phone', body: {
                  'new_phone': phoneController.text,
                  'code': codeController.text,
                  'password': passwordController.text,
                });

                setState(() {
                  isLoading = false;
                });

                if (response.isSuccess) {
                  // 更新缓存
                  await _updateUserInfo({'phone': phoneController.text});

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('手机号更换成功'),
                      backgroundColor: AppTheme.successColor,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(response.message)),
                  );
                }
              },
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('确定'),
            ),
          ],
        ),
      ),
    );
  }

  /// 解绑手机号
  void _unbindPhone() {
    final passwordController = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
          ),
          title: const Text('解绑手机号'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '解绑后将无法通过手机号找回密码，确定要解绑吗？',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: '登录密码',
                  hintText: '请输入登录密码',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: isLoading ? null : () async {
                if (passwordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('请输入登录密码')),
                  );
                  return;
                }

                setState(() {
                  isLoading = true;
                });

                // 调用后端API解绑手机号
                final response = await HttpClient.post('/user/unbind-phone', body: {
                  'password': passwordController.text,
                });

                setState(() {
                  isLoading = false;
                });

                if (response.isSuccess) {
                  // 更新缓存
                  await _updateUserInfo({'phone': null});
                  
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('手机号已解绑'),
                      backgroundColor: AppTheme.successColor,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(response.message)),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorColor,
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('确定解绑'),
            ),
          ],
        ),
      ),
    );
  }

  /// 邮箱设置
  Widget _buildEmailSection() {
    final email = _userInfo?['email'];
    final isBound = email != null && email.toString().isNotEmpty;
    
    return ListTile(
      leading: const Icon(Icons.email_outlined, color: AppTheme.primaryColor),
      title: const Text('邮箱'),
      subtitle: Text(
        isBound ? email! : '未绑定',
        style: TextStyle(
          fontSize: 14,
          color: isBound ? null : AppTheme.textHint,
        ),
      ),
      trailing: isBound
          ? PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert_rounded, color: AppTheme.textHint),
              onSelected: _handleEmailAction,
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'change',
                  child: Text('更换邮箱'),
                ),
                const PopupMenuItem(
                  value: 'unbind',
                  child: Text('解绑邮箱', style: TextStyle(color: AppTheme.errorColor)),
                ),
              ],
            )
          : const Icon(Icons.chevron_right_rounded, color: AppTheme.textHint),
      onTap: isBound ? null : () => _bindEmail(),
    );
  }

  /// 处理邮箱操作
  void _handleEmailAction(String action) {
    switch (action) {
      case 'change':
        _changeEmail();
        break;
      case 'unbind':
        _unbindEmail();
        break;
    }
  }

  /// 绑定邮箱
  void _bindEmail() {
    final emailController = TextEditingController();
    final codeController = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
          ),
          title: const Text('绑定邮箱'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: '邮箱地址',
                  hintText: '请输入邮箱地址',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: codeController,
                      decoration: const InputDecoration(
                        labelText: '验证码',
                        hintText: '请输入验证码',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: isLoading ? null : () async {
                      if (emailController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('请先输入邮箱')),
                        );
                        return;
                      }
                      // 发送验证码
                      setState(() {
                        isLoading = true;
                      });
                      
                      final response = await HttpClient.post('/auth/send-code', body: {
                        'email': emailController.text,
                        'type': 4, // 4 = 绑定邮箱
                      });
                      
                      setState(() {
                        isLoading = false;
                      });
                      
                      if (response.isSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('验证码已发送')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(response.message)),
                        );
                      }
                    },
                    child: const Text('发送'),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: isLoading ? null : () async {
                if (emailController.text.isEmpty || codeController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('请填写完整信息')),
                  );
                  return;
                }

                setState(() {
                  isLoading = true;
                });

                // 调用后端API绑定邮箱
                final response = await HttpClient.post('/user/bind-email', body: {
                  'email': emailController.text,
                  'code': codeController.text,
                  'password': '', // 绑定时不需要密码
                });

                setState(() {
                  isLoading = false;
                });

                if (response.isSuccess) {
                  // 更新缓存
                  await _updateUserInfo({'email': emailController.text});

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('邮箱绑定成功'),
                      backgroundColor: AppTheme.successColor,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(response.message)),
                  );
                }
              },
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('确定'),
            ),
          ],
        ),
      ),
    );
  }

  /// 更换邮箱
  void _changeEmail() {
    final emailController = TextEditingController();
    final codeController = TextEditingController();
    final passwordController = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
          ),
          title: const Text('更换邮箱'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: '新邮箱地址',
                  hintText: '请输入新邮箱地址',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: codeController,
                      decoration: const InputDecoration(
                        labelText: '验证码',
                        hintText: '请输入验证码',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: isLoading ? null : () async {
                      if (emailController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('请先输入邮箱')),
                        );
                        return;
                      }
                      // 发送验证码
                      setState(() {
                        isLoading = true;
                      });
                      
                      final response = await HttpClient.post('/auth/send-code', body: {
                        'email': emailController.text,
                        'type': 4, // 4 = 绑定邮箱
                      });
                      
                      setState(() {
                        isLoading = false;
                      });
                      
                      if (response.isSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('验证码已发送')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(response.message)),
                        );
                      }
                    },
                    child: const Text('发送'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: '登录密码',
                  hintText: '请输入登录密码',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: isLoading ? null : () async {
                if (emailController.text.isEmpty || 
                    codeController.text.isEmpty || 
                    passwordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('请填写完整信息')),
                  );
                  return;
                }

                setState(() {
                  isLoading = true;
                });

                // 调用后端API更换邮箱
                final response = await HttpClient.post('/user/change-email', body: {
                  'new_email': emailController.text,
                  'code': codeController.text,
                  'password': passwordController.text,
                });

                setState(() {
                  isLoading = false;
                });

                if (response.isSuccess) {
                  // 更新缓存
                  await _updateUserInfo({'email': emailController.text});

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('邮箱更换成功'),
                      backgroundColor: AppTheme.successColor,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(response.message)),
                  );
                }
              },
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('确定'),
            ),
          ],
        ),
      ),
    );
  }

  /// 解绑邮箱
  void _unbindEmail() {
    final passwordController = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
          ),
          title: const Text('解绑邮箱'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '解绑后将无法通过邮箱找回密码，确定要解绑吗？',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: '登录密码',
                  hintText: '请输入登录密码',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: isLoading ? null : () async {
                if (passwordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('请输入登录密码')),
                  );
                  return;
                }

                setState(() {
                  isLoading = true;
                });

                // 调用后端API解绑邮箱
                final response = await HttpClient.post('/user/unbind-email', body: {
                  'password': passwordController.text,
                });

                setState(() {
                  isLoading = false;
                });

                if (response.isSuccess) {
                  // 更新缓存
                  await _updateUserInfo({'email': null});
                  
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('邮箱已解绑'),
                      backgroundColor: AppTheme.successColor,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(response.message)),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorColor,
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('确定解绑'),
            ),
          ],
        ),
      ),
    );
  }

  /// 重置密码
  Widget _buildResetPasswordSection() {
    return ListTile(
      leading: const Icon(Icons.lock_outline_rounded, color: AppTheme.primaryColor),
      title: const Text('重置密码'),
      subtitle: const Text(
        '修改登录密码',
        style: TextStyle(fontSize: 14),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppTheme.textHint),
      onTap: _resetPassword,
    );
  }

  /// 重置密码
  void _resetPassword() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
          ),
          title: const Text('重置密码'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPasswordController,
                decoration: const InputDecoration(
                  labelText: '当前密码',
                  hintText: '请输入当前密码',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: newPasswordController,
                decoration: const InputDecoration(
                  labelText: '新密码',
                  hintText: '请输入新密码（8-20位）',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: '确认新密码',
                  hintText: '请再次输入新密码',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: isLoading ? null : () async {
                if (currentPasswordController.text.isEmpty || 
                    newPasswordController.text.isEmpty || 
                    confirmPasswordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('请填写完整信息')),
                  );
                  return;
                }

                if (newPasswordController.text != confirmPasswordController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('两次输入的密码不一致')),
                  );
                  return;
                }

                if (newPasswordController.text.length < 8) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('密码长度不能少于8位')),
                  );
                  return;
                }

                setState(() {
                  isLoading = true;
                });

                // TODO: 调用后端API重置密码
                await Future.delayed(const Duration(seconds: 1));

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('密码重置成功'),
                    backgroundColor: AppTheme.successColor,
                  ),
                );
              },
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('确定'),
            ),
          ],
        ),
      ),
    );
  }

  /// 国家/地区设置
  Widget _buildCountrySection() {
    final country = _userInfo?['country'] ?? '中国';
    final dialCode = _userInfo?['dial_code'] ?? '+86';
    
    return ListTile(
      leading: const Icon(Icons.public_rounded, color: AppTheme.primaryColor),
      title: const Text('国家/地区'),
      subtitle: Text(
        '$country ($dialCode)',
        style: const TextStyle(fontSize: 14),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppTheme.textHint),
      onTap: _selectCountry,
    );
  }

  /// 选择国家/地区
  void _selectCountry() async {
    final currentCountryCode = _userInfo?['dial_code'] ?? '+86';
    final currentCountry = _findCountryByCode(currentCountryCode);
    
    final result = await Navigator.push<CountryModel>(
      context,
      MaterialPageRoute<CountryModel>(
        builder: (context) => CountrySelectorPage(
          selectedCountry: currentCountry,
          onCountrySelected: (country) {
            // 通过返回值传递
          },
        ),
      ),
    );
    
    if (result != null && mounted) {
      // 调用后端API更新国家/地区
      final response = await HttpClient.put('/user/profile', body: {
        'country': result.nameZh,
        'dial_code': result.dialCode,
      });
      
      if (response.isSuccess) {
        // 更新缓存
        await _updateUserInfo({
          'country': result.nameZh,
          'dial_code': result.dialCode,
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('国家/地区更新成功'),
            backgroundColor: AppTheme.successColor,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message)),
        );
      }
    }
  }
}
