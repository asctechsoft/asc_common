import 'package:flutter/widgets.dart';
import 'package:xml/xml.dart';

/// Truy cập chuỗi đa ngôn ngữ đã tải - lấy qua `AscLocalizations.of(context)`.
///
/// Nguồn dữ liệu vẫn là file XML kiểu Android (`values/strings.xml`,
/// `values-vi/strings.xml`...) để giữ nguyên quy trình dịch thuật 60+ ngôn
/// ngữ hiện có của công ty (đội dịch quen làm việc với định dạng này) - chỉ
/// đổi cách nạp: qua `LocalizationsDelegate` chuẩn của Flutter
/// ([AscLocalizationsDelegate]) thay vì tự parse rải rác trong code cũ.
class AscLocalizations {
  AscLocalizations(this._strings);

  final Map<String, String> _strings;

  static AscLocalizations? of(BuildContext context) =>
      Localizations.of<AscLocalizations>(context, AscLocalizations);

  /// Lấy chuỗi theo `key`. Không có thì trả về chính `key` để dễ nhận ra chỗ
  /// thiếu bản dịch khi test bằng mắt, thay vì hiện rỗng hoặc crash.
  String tr(String key) => _strings[key] ?? key;

  /// Tương tự [tr] nhưng thay `{0}`, `{1}`... trong chuỗi bằng [args] theo
  /// đúng thứ tự.
  String trArgs(String key, List<Object?> args) {
    var value = tr(key);
    for (var i = 0; i < args.length; i++) {
      value = value.replaceAll('{$i}', '${args[i]}');
    }
    return value;
  }

  /// Parse một file `strings.xml` kiểu Android
  /// (`<resources><string name="hello">Xin chào</string></resources>`)
  /// thành map tra cứu.
  static Map<String, String> parseXml(String xmlContent) {
    final doc = XmlDocument.parse(xmlContent);
    final map = <String, String>{};
    for (final node in doc.findAllElements('string')) {
      final name = node.getAttribute('name');
      if (name != null) map[name] = node.innerText;
    }
    return map;
  }
}
