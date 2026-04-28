import 'package:flutter/material.dart';
import '../../../theme.dart';
import '../../../models/country_model.dart';
import '../../../utils/country_selection_manager.dart';
import '../../auth/country_selector_page.dart';

/// 个人信息页面
class PersonalInfoPage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const PersonalInfoPage({Key? key, required this.userData}) : super(key: key);

  @override
  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  late Map<String, dynamic> _userData;
  final _nicknameController = TextEditingController();
  final CountrySelectionManager _countryManager = CountrySelectionManager();
  
  // 安全问题数据
  List<Map<String, String>> _securityQuestions = [];

  @override
  void initState() {
    super.initState();
    _userData = Map<String, dynamic>.from(widget.userData);
    _nicknameController.text = _userData['nickname'] ?? '';
    
    // 初始化安全问题数据（从用户数据中加载）
    if (_userData['securityQuestions'] != null) {
      _securityQuestions = List<Map<String, String>>.from(_userData['securityQuestions']);
    }
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            
            // 安全问题
            _buildSecurityQuestionSection(),
            
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
        _userData['nickname'] ?? '未设置',
        style: const TextStyle(fontSize: 14),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppTheme.textHint),
      onTap: _editNickname,
    );
  }

  /// 编辑昵称
  void _editNickname() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
        ),
        title: const Text('修改昵称'),
        content: TextField(
          controller: _nicknameController,
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
            onPressed: () {
              if (_nicknameController.text.trim().isNotEmpty) {
                setState(() {
                  _userData['nickname'] = _nicknameController.text.trim();
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('昵称修改成功'),
                    backgroundColor: AppTheme.successColor,
                  ),
                );
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
    final isBound = _userData['phoneBound'] ?? false;
    
    return ListTile(
      leading: const Icon(Icons.phone_android_rounded, color: AppTheme.primaryColor),
      title: const Text('手机号'),
      subtitle: Text(
        isBound ? _userData['phone'] ?? '未绑定' : '未绑定',
        style: const TextStyle(fontSize: 14),
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
        ),
        title: const Text('绑定手机号'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: '手机号',
                hintText: '请输入手机号',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: '验证码',
                hintText: '请输入验证码',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _userData['phoneBound'] = true;
                _userData['phone'] = '19874947494';
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('手机号绑定成功'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  /// 更换手机号
  void _changePhone() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
        ),
        title: const Text('更换手机号'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: '新手机号',
                hintText: '请输入新手机号',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: '验证码',
                hintText: '请输入验证码',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _userData['phone'] = '13800138000';
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('手机号更换成功'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  /// 解绑手机号
  void _unbindPhone() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
        ),
        title: const Text('确认解绑'),
        content: const Text('解绑后将无法通过手机号找回密码，确定要解绑吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _userData['phoneBound'] = false;
                _userData['phone'] = '';
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('手机号已解绑'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('确定解绑'),
          ),
        ],
      ),
    );
  }

  /// 邮箱设置
  Widget _buildEmailSection() {
    final isBound = _userData['emailBound'] ?? false;
    
    return ListTile(
      leading: const Icon(Icons.email_outlined, color: AppTheme.primaryColor),
      title: const Text('邮箱'),
      subtitle: Text(
        isBound ? _userData['email'] ?? '未绑定' : '未绑定',
        style: const TextStyle(fontSize: 14),
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
        ),
        title: const Text('绑定邮箱'),
        content: TextField(
          decoration: const InputDecoration(
            labelText: '邮箱地址',
            hintText: '请输入邮箱地址',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _userData['emailBound'] = true;
                _userData['email'] = 'user@example.com';
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('邮箱绑定成功'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  /// 更换邮箱
  void _changeEmail() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
        ),
        title: const Text('更换邮箱'),
        content: TextField(
          decoration: const InputDecoration(
            labelText: '新邮箱地址',
            hintText: '请输入新邮箱地址',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _userData['email'] = 'newuser@example.com';
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('邮箱更换成功'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  /// 解绑邮箱
  void _unbindEmail() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
        ),
        title: const Text('确认解绑'),
        content: const Text('解绑后将无法通过邮箱找回密码，确定要解绑吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _userData['emailBound'] = false;
                _userData['email'] = '';
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('邮箱已解绑'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('确定解绑'),
          ),
        ],
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
        ),
        title: const Text('重置密码'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: '当前密码',
                hintText: '请输入当前密码',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: '新密码',
                hintText: '请输入新密码（8-20位）',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
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
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('密码重置成功'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  /// 安全问题
  Widget _buildSecurityQuestionSection() {
    return ListTile(
      leading: const Icon(Icons.security_rounded, color: AppTheme.primaryColor),
      title: const Text('安全问题'),
      subtitle: const Text(
        '设置安全问题，用于设备丢失时找回账号',
        style: TextStyle(fontSize: 14),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppTheme.textHint),
      onTap: _setSecurityQuestion,
    );
  }

  /// 设置安全问题
  void _setSecurityQuestion() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _SecurityQuestionSettingPage(
          securityQuestions: _securityQuestions,
          onSave: (questions) {
            setState(() {
              _userData['securityQuestions'] = questions;
            });
          },
        ),
      ),
    );
  }

  /// 国家/地区
  Widget _buildCountrySection() {
    return ListTile(
      leading: const Icon(Icons.public_rounded, color: AppTheme.primaryColor),
      title: const Text('国家/地区'),
      subtitle: Text(
        '${_userData['country'] ?? '中国'} (${_userData['countryCode'] ?? '+86'})',
        style: const TextStyle(fontSize: 14),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppTheme.textHint),
      onTap: _selectCountry,
    );
  }

  /// 选择国家/地区
  void _selectCountry() async {
    final result = await Navigator.push<CountryModel>(
      context,
      MaterialPageRoute<CountryModel>(
        builder: (context) => CountrySelectorPage(
          selectedCountry: _findCurrentCountry(),
          onCountrySelected: (country) {
            // 国家选择后会通过 CountrySelectionManager 更新
          },
        ),
      ),
    );
    
    if (result != null && mounted) {
      setState(() {
        _userData['country'] = result.nameZh;
        _userData['countryCode'] = result.dialCode;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('已选择 ${result.nameZh}'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    }
  }
  
  /// 查找当前国家
  CountryModel _findCurrentCountry() {
    final countryCode = _userData['countryCode'] ?? '+86';
    return CountryList.countries.firstWhere(
      (c) => c.dialCode == countryCode,
      orElse: () => CountryList.countries[0], // 默认返回中国
    );
  }
}

/// 安全问题设置页面
class _SecurityQuestionSettingPage extends StatefulWidget {
  final List<Map<String, String>> securityQuestions;
  final Function(List<Map<String, String>>) onSave;

  const _SecurityQuestionSettingPage({
    Key? key,
    required this.securityQuestions,
    required this.onSave,
  }) : super(key: key);

  @override
  _SecurityQuestionSettingPageState createState() => _SecurityQuestionSettingPageState();
}

class _SecurityQuestionSettingPageState extends State<_SecurityQuestionSettingPage> {
  // 可选的安全问题列表
  final List<String> _availableQuestions = [
    '您的宠物名字是什么？',
    '您的小学名称是什么？',
    '您的母亲姓名是什么？',
    '您最喜欢的城市是哪里？',
    '您的出生日期是什么？',
    '您第一份工作的公司是什么？',
    '您最喜欢的食物是什么？',
    '您最喜欢的电影是什么？',
  ];

  // 3个问题的控制器
  final List<TextEditingController> _questionControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  
  final List<TextEditingController> _answerControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  @override
  void initState() {
    super.initState();
    // 加载已设置的问题
    for (int i = 0; i < widget.securityQuestions.length && i < 3; i++) {
      _questionControllers[i].text = widget.securityQuestions[i]['question'] ?? '';
      _answerControllers[i].text = widget.securityQuestions[i]['answer'] ?? '';
    }
  }

  @override
  void dispose() {
    for (var controller in _questionControllers) {
      controller.dispose();
    }
    for (var controller in _answerControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('安全问题设置'),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // 说明文字
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: const Text(
              '当你手机丢了，可以通过回答设置的安全问题来登录新设备。',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF666666),
                height: 1.5,
              ),
            ),
          ),
          
          const SizedBox(height: 10),
          
          // 3个问题输入区域
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildQuestionItem(0, '问题一'),
                  const SizedBox(height: 10),
                  _buildQuestionItem(1, '问题二'),
                  const SizedBox(height: 10),
                  _buildQuestionItem(2, '问题三'),
                  const SizedBox(height: 30),
                  
                  // 确定按钮
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _saveSecurityQuestions,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB0B0B0),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: const Text(
                          '确定',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建单个问题项
  Widget _buildQuestionItem(int index, String label) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // 问题选择
          InkWell(
            onTap: () => _showQuestionSelector(index),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _questionControllers[index].text.isEmpty
                          ? label
                          : _questionControllers[index].text,
                      style: TextStyle(
                        fontSize: 15,
                        color: _questionControllers[index].text.isEmpty
                            ? const Color(0xFF333333)
                            : const Color(0xFF333333),
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFFCCCCCC),
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
          
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          
          // 答案输入
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: TextField(
              controller: _answerControllers[index],
              decoration: const InputDecoration(
                hintText: '请输入你的答案',
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: Color(0xFFCCCCCC),
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF333333),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 显示问题选择器
  void _showQuestionSelector(int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  '选择安全问题',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(height: 1),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _availableQuestions.length,
                itemBuilder: (context, qIndex) {
                  final question = _availableQuestions[qIndex];
                  final isSelected = _questionControllers[index].text == question;
                  
                  return ListTile(
                    title: Text(
                      question,
                      style: TextStyle(
                        fontSize: 15,
                        color: isSelected ? AppTheme.primaryColor : const Color(0xFF333333),
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_rounded, color: AppTheme.primaryColor)
                        : null,
                    onTap: () {
                      setState(() {
                        _questionControllers[index].text = question;
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// 保存安全问题
  void _saveSecurityQuestions() {
    // 构建问题列表
    List<Map<String, String>> questions = [];
    
    for (int i = 0; i < 3; i++) {
      if (_questionControllers[i].text.isNotEmpty && _answerControllers[i].text.isNotEmpty) {
        questions.add({
          'question': _questionControllers[i].text,
          'answer': _answerControllers[i].text.trim(),
        });
      }
    }
    
    if (questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请至少设置1个安全问题'),
          backgroundColor: AppTheme.warningColor,
        ),
      );
      return;
    }
    
    // 调用保存回调
    widget.onSave(questions);
    
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('安全问题设置成功'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }
}
