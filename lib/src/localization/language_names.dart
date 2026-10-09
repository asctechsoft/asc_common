import 'package:flutter/widgets.dart';

/// Display names for locales: the endonym (the language's own name, for the
/// primary line of a language row) and the English name (secondary line that
/// disambiguates regional variants).
class LanguageNames {
  LanguageNames._();

  static const Map<String, String> _native = {
    'en_US': 'English',
    'vi_VN': 'Tiếng Việt',
    'fr_FR': 'Français',
    'it_IT': 'Italiano',
    'de_DE': 'Deutsch',
    'es_ES': 'Español',
    'ru_RU': 'Русский',
    'pt_PT': 'Português',
    'tr_TR': 'Türkçe',
    'ar_SA': 'العربية',
    'id_ID': 'Bahasa Indonesia',
    'fa_IR': 'فارسی',
    'zh_CN': '简体中文',
    'zh_TW': '繁體中文',
    'ja_JP': '日本語',
    'ko_KR': '한국어',
  };

  static const Map<String, String> _english = {
    'en': 'English (United States)',
    'vi': 'Vietnamese (Vietnam)',
    'fr': 'French (France)',
    'it': 'Italian (Italy)',
    'de': 'German (Germany)',
    'es': 'Spanish (Spain)',
    'ru': 'Russian (Russia)',
    'pt': 'Portuguese (Portugal)',
    'tr': 'Turkish (Turkey)',
    'ar': 'Arabic (Saudi Arabia)',
    'id': 'Indonesian (Indonesia)',
    'fa': 'Persian (Iran)',
    'ja': 'Japanese (Japan)',
    'ko': 'Korean (South Korea)',
  };

  /// The locale's endonym, falling back to the language code when unmapped.
  static String nativeName(Locale locale) =>
      _native[locale.toString()] ??
      _native[locale.languageCode] ??
      locale.languageCode.toUpperCase();

  /// English display name, e.g. "Vietnamese (Vietnam)".
  static String englishName(Locale locale) {
    if (locale.languageCode == 'zh') {
      return locale.countryCode == 'TW'
          ? 'Chinese (Traditional)'
          : 'Chinese (Simplified)';
    }
    return _english[locale.languageCode] ?? locale.toString();
  }
}
