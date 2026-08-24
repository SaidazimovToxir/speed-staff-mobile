import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:speed_staff_mobile/config/config.dart';

class LanguageSelector extends StatefulWidget {
  const LanguageSelector({super.key});

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  bool _isExpanded = false;
  final List<Locale> _locales = const [
    Locale('uz', 'UZ'),
    Locale('ru', 'RU'),
    Locale('en', 'EN'),
  ];

  String _getFlag(String langCode) {
    switch (langCode) {
      case 'uz':
        return '🇺🇿';
      case 'ru':
        return '🇷🇺';
      case 'en':
        return '🇬🇧';
      default:
        return '🌍';
    }
  }

  void _changeLanguage(Locale locale) async {
    await context.setLocale(locale);
    await LangService.setLanguageCode(locale.languageCode);
    setState(() {
      _isExpanded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;

    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: 60,
        height: _isExpanded ? (40.0 * _locales.length + 10) : 48.0,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Selected Language
              SizedBox(
                height: 48,
                child: Center(
                  child: Text(
                    _getFlag(currentLocale.languageCode),
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              // Other Languages
              if (_isExpanded)
                ..._locales.where((l) => l.languageCode != currentLocale.languageCode).map((locale) {
                  return GestureDetector(
                    onTap: () => _changeLanguage(locale),
                    child: Container(
                      height: 40,
                      width: double.infinity,
                      color: Colors.transparent,
                      child: Center(
                        child: Text(
                          _getFlag(locale.languageCode),
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                  );
                }),
              if (_isExpanded) const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
