/// 国家/地区数据模型
class CountryModel {
  final String code; // 国家代码 (CN, US, etc.)
  final String nameZh; // 中文名称
  final String nameEn; // 英文名称
  final String nameLocal; // 本地语言名称
  final String dialCode; // 电话区号
  final String flag; // emoji国旗

  const CountryModel({
    required this.code,
    required this.nameZh,
    required this.nameEn,
    required this.nameLocal,
    required this.dialCode,
    required this.flag,
  });

  /// 根据语言代码获取国家名称
  String getName(String languageCode) {
    switch (languageCode) {
      case 'zh':
        return nameZh;
      case 'en':
      default:
        return nameEn;
    }
  }

  @override
  String toString() => '$flag $nameZh ($dialCode)';
}

/// 国家和地区列表（包含电话前缀和本地化名称）
class CountryList {
  static const List<CountryModel> countries = [
    // 亚洲
    CountryModel(
      code: 'CN',
      nameZh: '中国',
      nameEn: 'China',
      nameLocal: '中国',
      dialCode: '+86',
      flag: '🇨🇳',
    ),
    CountryModel(
      code: 'HK',
      nameZh: '中国香港',
      nameEn: 'Hong Kong',
      nameLocal: '香港',
      dialCode: '+852',
      flag: '🇭🇰',
    ),
    CountryModel(
      code: 'MO',
      nameZh: '中国澳门',
      nameEn: 'Macau',
      nameLocal: '澳門',
      dialCode: '+853',
      flag: '🇲🇴',
    ),
    CountryModel(
      code: 'TW',
      nameZh: '中国台湾',
      nameEn: 'Taiwan',
      nameLocal: '臺灣',
      dialCode: '+886',
      flag: '🇹🇼',
    ),
    CountryModel(
      code: 'JP',
      nameZh: '日本',
      nameEn: 'Japan',
      nameLocal: '日本',
      dialCode: '+81',
      flag: '🇯🇵',
    ),
    CountryModel(
      code: 'KR',
      nameZh: '韩国',
      nameEn: 'South Korea',
      nameLocal: '대한민국',
      dialCode: '+82',
      flag: '🇰🇷',
    ),
    CountryModel(
      code: 'SG',
      nameZh: '新加坡',
      nameEn: 'Singapore',
      nameLocal: 'Singapore',
      dialCode: '+65',
      flag: '🇸🇬',
    ),
    CountryModel(
      code: 'MY',
      nameZh: '马来西亚',
      nameEn: 'Malaysia',
      nameLocal: 'Malaysia',
      dialCode: '+60',
      flag: '🇲🇾',
    ),
    CountryModel(
      code: 'TH',
      nameZh: '泰国',
      nameEn: 'Thailand',
      nameLocal: 'ประเทศไทย',
      dialCode: '+66',
      flag: '🇹🇭',
    ),
    CountryModel(
      code: 'VN',
      nameZh: '越南',
      nameEn: 'Vietnam',
      nameLocal: 'Việt Nam',
      dialCode: '+84',
      flag: '🇻🇳',
    ),
    CountryModel(
      code: 'ID',
      nameZh: '印度尼西亚',
      nameEn: 'Indonesia',
      nameLocal: 'Indonesia',
      dialCode: '+62',
      flag: '🇮🇩',
    ),
    CountryModel(
      code: 'PH',
      nameZh: '菲律宾',
      nameEn: 'Philippines',
      nameLocal: 'Pilipinas',
      dialCode: '+63',
      flag: '🇵🇭',
    ),
    CountryModel(
      code: 'IN',
      nameZh: '印度',
      nameEn: 'India',
      nameLocal: 'भारत',
      dialCode: '+91',
      flag: '🇮🇳',
    ),

    // 欧洲
    CountryModel(
      code: 'US',
      nameZh: '美国',
      nameEn: 'United States',
      nameLocal: 'United States',
      dialCode: '+1',
      flag: '🇺🇸',
    ),
    CountryModel(
      code: 'CA',
      nameZh: '加拿大',
      nameEn: 'Canada',
      nameLocal: 'Canada',
      dialCode: '+1',
      flag: '🇨🇦',
    ),
    CountryModel(
      code: 'GB',
      nameZh: '英国',
      nameEn: 'United Kingdom',
      nameLocal: 'United Kingdom',
      dialCode: '+44',
      flag: '🇬🇧',
    ),
    CountryModel(
      code: 'FR',
      nameZh: '法国',
      nameEn: 'France',
      nameLocal: 'France',
      dialCode: '+33',
      flag: '🇫🇷',
    ),
    CountryModel(
      code: 'DE',
      nameZh: '德国',
      nameEn: 'Germany',
      nameLocal: 'Deutschland',
      dialCode: '+49',
      flag: '🇩🇪',
    ),
    CountryModel(
      code: 'IT',
      nameZh: '意大利',
      nameEn: 'Italy',
      nameLocal: 'Italia',
      dialCode: '+39',
      flag: '🇮🇹',
    ),
    CountryModel(
      code: 'ES',
      nameZh: '西班牙',
      nameEn: 'Spain',
      nameLocal: 'España',
      dialCode: '+34',
      flag: '🇪🇸',
    ),
    CountryModel(
      code: 'RU',
      nameZh: '俄罗斯',
      nameEn: 'Russia',
      nameLocal: 'Россия',
      dialCode: '+7',
      flag: '🇷🇺',
    ),

    // 大洋洲
    CountryModel(
      code: 'AU',
      nameZh: '澳大利亚',
      nameEn: 'Australia',
      nameLocal: 'Australia',
      dialCode: '+61',
      flag: '🇦🇺',
    ),
    CountryModel(
      code: 'NZ',
      nameZh: '新西兰',
      nameEn: 'New Zealand',
      nameLocal: 'New Zealand',
      dialCode: '+64',
      flag: '🇳🇿',
    ),

    // 其他常用国家
    CountryModel(
      code: 'BR',
      nameZh: '巴西',
      nameEn: 'Brazil',
      nameLocal: 'Brasil',
      dialCode: '+55',
      flag: '🇧🇷',
    ),
    CountryModel(
      code: 'MX',
      nameZh: '墨西哥',
      nameEn: 'Mexico',
      nameLocal: 'México',
      dialCode: '+52',
      flag: '🇲🇽',
    ),
    CountryModel(
      code: 'ZA',
      nameZh: '南非',
      nameEn: 'South Africa',
      nameLocal: 'South Africa',
      dialCode: '+27',
      flag: '🇿🇦',
    ),
    CountryModel(
      code: 'AE',
      nameZh: '阿联酋',
      nameEn: 'United Arab Emirates',
      nameLocal: 'الإمارات',
      dialCode: '+971',
      flag: '🇦🇪',
    ),
    CountryModel(
      code: 'SA',
      nameZh: '沙特阿拉伯',
      nameEn: 'Saudi Arabia',
      nameLocal: 'السعودية',
      dialCode: '+966',
      flag: '🇸🇦',
    ),
  ];

  /// 根据国家代码查找国家
  static CountryModel? findByCode(String code) {
    try {
      return countries.firstWhere((c) => c.code == code);
    } catch (e) {
      return null;
    }
  }

  /// 根据电话区号查找国家
  static List<CountryModel> findByDialCode(String dialCode) {
    return countries.where((c) => c.dialCode == dialCode).toList();
  }

  /// 搜索国家（支持中英文）
  static List<CountryModel> search(String query, String languageCode) {
    if (query.isEmpty) return countries;
    
    final lowerQuery = query.toLowerCase();
    return countries.where((country) {
      final name = country.getName(languageCode).toLowerCase();
      final nameEn = country.nameEn.toLowerCase();
      final dialCode = country.dialCode.toLowerCase();
      
      return name.contains(lowerQuery) ||
          nameEn.contains(lowerQuery) ||
          dialCode.contains(lowerQuery);
    }).toList();
  }
}
