import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'pages/auth/login_entry_page.dart';
import 'ttlocktest/home_page.dart';
import 'theme.dart';
import 'utils/language_manager.dart';
// import 'utils/local_cache.dart';  // 暂时注释

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // await LocalCache.init();  // 暂时注释
  
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final LanguageManager _languageManager = LanguageManager();
  
  @override
  void initState() {
    super.initState();
    // 监听语言变化
    _languageManager.addListener(_onLanguageChanged);
  }
  
  @override
  void dispose() {
    _languageManager.removeListener(_onLanguageChanged);
    super.dispose();
  }
  
  void _onLanguageChanged() {
    setState(() {
      // 当语言改变时，重建整个应用
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '宝士力得',
      theme: AppTheme.lightTheme,
      // 国际化配置
      locale: _languageManager.currentLocale,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: _languageManager.supportedLocales,
      localeResolutionCallback: (locale, supportedLocales) {
        // 使用 LanguageManager 中设置的语言
        return _languageManager.currentLocale;
      },
      home: const LoginEntryPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
