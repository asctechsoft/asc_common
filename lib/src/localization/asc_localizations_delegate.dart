import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';

import 'asc_localizations.dart';

/// `LocalizationsDelegate` chuẩn Flutter cho [AscLocalizations] - gắn vào
/// `MaterialApp.localizationsDelegates`/`supportedLocales` của app gọi, thay
/// cho cách nạp XML thủ công ngoài vòng đời Flutter của bản cũ.
///
/// Quy ước thư mục asset theo đúng chuẩn Android: mặc định
/// `<assetPath>/values/strings.xml`, còn lại
/// `<assetPath>/values-<languageCode>/strings.xml` (ví dụ `values-vi`). App
/// phải tự khai các file này trong `pubspec.yaml` > `flutter.assets`.
class AscLocalizationsDelegate extends LocalizationsDelegate<AscLocalizations> {
  const AscLocalizationsDelegate({this.assetPath = 'assets/l10n'});

  final String assetPath;

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<AscLocalizations> load(Locale locale) async {
    final path = '$assetPath/values-${locale.languageCode}/strings.xml';
    try {
      final content = await rootBundle.loadString(path);
      return AscLocalizations(AscLocalizations.parseXml(content));
    } catch (_) {
      // Ngôn ngữ này chưa có file dịch riêng - rơi về `values/strings.xml`
      // mặc định thay vì app trắng chữ hoặc crash.
      final fallback = await rootBundle.loadString(
        '$assetPath/values/strings.xml',
      );
      return AscLocalizations(AscLocalizations.parseXml(fallback));
    }
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AscLocalizations> old) =>
      false;
}
