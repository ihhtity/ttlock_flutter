import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../models/country_model.dart';
import '../../theme.dart';
import '../../utils/language_manager.dart';

/// 国家/地区选择器页面
class CountrySelectorPage extends StatefulWidget {
  final CountryModel? selectedCountry;
  final Function(CountryModel) onCountrySelected;

  const CountrySelectorPage({
    Key? key,
    this.selectedCountry,
    required this.onCountrySelected,
  }) : super(key: key);

  @override
  _CountrySelectorPageState createState() => _CountrySelectorPageState();
}

class _CountrySelectorPageState extends State<CountrySelectorPage> {
  List<CountryModel> _filteredCountries = CountryList.countries;
  String _searchQuery = '';
  late Locale _currentLocale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentLocale = AppLocalizations.of(context).locale;
  }

  void _filterCountries(String query) {
    setState(() {
      _searchQuery = query;
      _filteredCountries = CountryList.search(query, _currentLocale.languageCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(l10n.selectCountry),
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
      body: Column(
        children: [
          // 搜索框
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingMedium),
            color: Colors.white,
            child: TextField(
              onChanged: _filterCountries,
              decoration: InputDecoration(
                hintText: l10n.searchCountry,
                prefixIcon: const Icon(Icons.search, color: AppTheme.textHint),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: AppTheme.textHint),
                        onPressed: () => _filterCountries(''),
                      )
                    : null,
                filled: true,
                fillColor: AppTheme.backgroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingMedium,
                  vertical: AppTheme.spacingSmall,
                ),
              ),
            ),
          ),

          // 国家列表
          Expanded(
            child: ListView.builder(
              itemCount: _filteredCountries.length,
              itemBuilder: (context, index) {
                final country = _filteredCountries[index];
                final isSelected = widget.selectedCountry?.code == country.code;
                
                return InkWell(
                  onTap: () {
                    // 选择国家
                    widget.onCountrySelected(country);
                    
                    // 根据国家代码切换语言（使用单例）
                    LanguageManager().setLanguageByCountry(country.code);
                    
                    // 返回选择的国家
                    Navigator.pop(context, country);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingMedium,
                      vertical: AppTheme.spacingSmall,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? AppTheme.primaryColor.withOpacity(0.1)
                          : Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          color: AppTheme.backgroundColor,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        // 国旗
                        Text(
                          country.flag,
                          style: const TextStyle(fontSize: 32),
                        ),
                        const SizedBox(width: AppTheme.spacingMedium),
                        
                        // 国家信息
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                country.getName(_currentLocale.languageCode),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                  color: isSelected 
                                      ? AppTheme.primaryColor
                                      : AppTheme.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${country.nameEn} ${country.dialCode}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // 选中图标
                        if (isSelected)
                          const Icon(
                            Icons.check_circle,
                            color: AppTheme.primaryColor,
                            size: 24,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
