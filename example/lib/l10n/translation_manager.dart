import 'translations_zh.dart';
import 'translations_en.dart';
import 'translations_ja.dart';
import 'translations_ko.dart';
import 'translations_fr.dart';
import 'translations_de.dart';
import 'translations_es.dart';

/// 翻译管理器 - 根据语言代码加载对应的翻译文件
class TranslationManager {
  /// 获取指定语言的翻译Map
  static Map<String, String> getTranslations(String languageCode) {
    switch (languageCode) {
      case 'zh':
        return ZhTranslations.values;
      case 'en':
        return EnTranslations.values;
      case 'ja':
        return JaTranslations.values;
      case 'ko':
        return KoTranslations.values;
      case 'fr':
        return FrTranslations.values;
      case 'de':
        return DeTranslations.values;
      case 'es':
        return EsTranslations.values;
      default:
        // 默认返回英文
        return EnTranslations.values;
    }
  }

  /// 获取支持的语言列表
  static List<String> get supportedLanguages => ['zh', 'en', 'ja', 'ko', 'fr', 'de', 'es'];

  /// 检查是否支持该语言
  static bool isSupported(String languageCode) {
    return supportedLanguages.contains(languageCode);
  }
}
