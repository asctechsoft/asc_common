import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart';

/// GetX-backed localization from Android-style XML (`values*/strings.xml`),
/// so the existing translation workflow keeps working.
///
/// `.tr` / `.trParams` are GetX's own `Trans` extension on `String`, backed by
/// `Get.translations` / `Get.locale`. This class owns *what is* in
/// `Get.translations` (parsed from the XML) and which `Get.locale` is active.
///
/// The XML→GetX conversion matters: `%1$s`/`%2$s`/... (Android's positional
/// placeholders) are rewritten to `@args1`/`@args2`/... (GetX's `trParams`
/// syntax) at load time. A naive XML parser would leave `%1$s` untouched and
/// silently break every `.trParams({'args1': ...})` call.
///
/// Call [configure] once at startup, then [setAppLocale]/[loadTranslations].
class AscLocale {
  AscLocale._();

  static const Locale _fallback = Locale('en', 'US');

  static List<Locale> _supportedLocales = const [_fallback];
  static String _assetRoot = 'lib/xml_strings';
  static String _languagePrefKey = 'language';
  static String _followSystemPrefKey = 'follow_system_language';

  static final Map<String, Map<String, String>> _translations = {};

  /// Cached from the language pref so [getConfiguredLocale]/[getAppLocale]
  /// stay synchronous (read from `build()` and field initializers). Warmed by
  /// the first [setAppLocale] call.
  static Locale? _configuredLocale;

  /// One entry per `values*/` folder under the asset root.
  static List<Locale> get supportedLocales => _supportedLocales;

  /// [supportedLocales]: the locales the app offers (English `en_US` is the
  /// fallback and is always loaded). [assetRoot]: folder holding the
  /// `values*/strings.xml` directories, declared in the app's `pubspec.yaml`
  /// assets. [languagePrefKey]/[followSystemPrefKey]: the SharedPreferences
  /// keys the app uses to persist the chosen language and the "follow system"
  /// flag.
  static void configure({
    required List<Locale> supportedLocales,
    required String languagePrefKey,
    required String followSystemPrefKey,
    String assetRoot = 'lib/xml_strings',
  }) {
    _supportedLocales = supportedLocales;
    _languagePrefKey = languagePrefKey;
    _followSystemPrefKey = followSystemPrefKey;
    _assetRoot = assetRoot;
  }

  /// Loads `en_US` (the fallback) plus whichever locale the device or the
  /// already-configured app language needs into GetX's global translation
  /// table. Call once at startup, before the app builds.
  static Future<void> loadTranslations() async {
    final deviceLanguageCode = getSystemLocale()?.languageCode ?? '';
    final appLanguageCode = getAppLocale().languageCode;

    for (final locale in _supportedLocales) {
      if (locale.toString() != 'en_US' &&
          locale.languageCode != deviceLanguageCode &&
          locale.languageCode != appLanguageCode) {
        continue;
      }
      await _ensureLoaded(locale);
    }
    Get.addTranslations(_translations);
  }

  /// Persists [locale], loads its strings if they weren't already, then
  /// activates it.
  ///
  /// Deliberately `Get.locale = locale; Get.appUpdate();`, never
  /// `Get.updateLocale()` — that calls `forceAppUpdate()`, a full engine
  /// reassemble that remounts `GetMaterialApp` from its `initialRoute` and
  /// drops the navigator stack. Setting `Get.locale` + `appUpdate()` rebuilds
  /// the root builder in place, refreshing every `.tr` string without
  /// touching the route stack.
  static Future<void> setAppLocale(Locale locale) async {
    _configuredLocale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languagePrefKey, _localeKey(locale));

    await _ensureLoaded(locale);
    Get.addTranslations(_translations);

    Get.locale = locale;
    Get.appUpdate();
  }

  static Future<void> _ensureLoaded(Locale locale) async {
    final localeName = locale.toString();
    if (_translations.containsKey(localeName)) return;
    try {
      _translations[localeName] = await _loadXml(_filePath(locale));
    } catch (e) {
      debugPrint('AscLocale: failed to load $localeName: $e');
    }
  }

  static Locale? getConfiguredLocale() => _configuredLocale;

  /// Activates the [supportedLocales] entry closest to the device's system
  /// locale and sets the follow-system flag so a later cold start re-detects
  /// instead of trusting the persisted resolved locale as a pin. Counterpart
  /// to [setAppLocale] (callers should pair that with clearing the flag).
  static Future<void> useSystemLocale() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_followSystemPrefKey, true);
    await setAppLocale(bestSupportedMatchFor(getSystemLocale()));
  }

  /// The [supportedLocales] entry closest to [locale] (by language code), or
  /// English if [locale] is null or unsupported.
  static Locale bestSupportedMatchFor(Locale? locale) {
    if (locale == null) return _fallback;
    return _supportedLocales.cast<Locale?>().firstWhere(
          (l) => l!.languageCode == locale.languageCode,
          orElse: () => null,
        ) ??
        _fallback;
  }

  /// The actual system locale from the platform — more reliable than
  /// `Get.deviceLocale`, which can return the wrong value on some devices.
  static Locale? getSystemLocale() {
    try {
      final locales = WidgetsBinding.instance.platformDispatcher.locales;
      if (locales.isNotEmpty) return locales.first;
    } catch (e) {
      debugPrint('AscLocale: getSystemLocale failed: $e');
    }
    return Get.deviceLocale;
  }

  static Locale getAppLocale() =>
      _configuredLocale ?? Get.locale ?? getSystemLocale() ?? _fallback;

  static String _localeKey(Locale l) =>
      l.countryCode != null && l.countryCode!.isNotEmpty
      ? '${l.languageCode}_${l.countryCode}'
      : l.languageCode;

  static String _filePath(Locale locale) {
    final folder = locale.languageCode == 'en'
        ? 'values'
        : locale.toString() == 'zh_TW'
        ? 'values-zh-rTW'
        : locale.toString() == 'zh_CN' || locale.languageCode == 'zh'
        ? 'values-zh-rCN'
        : 'values-${locale.languageCode}';
    return '$_assetRoot/$folder/strings.xml';
  }

  static Future<Map<String, String>> _loadXml(String path) async {
    final xmlString = await rootBundle.loadString(path);
    final document = XmlDocument.parse(xmlString);
    final translations = <String, String>{};
    for (final node in document.findAllElements('string')) {
      final key = node.getAttribute('name');
      if (key == null) continue;
      assert(
        !translations.containsKey(key),
        'Duplicated localization key "$key" in $path',
      );
      var value = node.innerText
          .replaceAll('\\"', '"')
          .replaceAll("\\'", "'")
          .replaceAll(r'\r\n', '\n')
          .replaceAll(r'\n', '\n')
          .replaceAll(r'\t', '\t');
      for (var i = 1; i <= 8; i++) {
        value = value.replaceAll('%$i\$s', '@args$i');
      }
      translations[key] = value;
    }
    return translations;
  }
}
