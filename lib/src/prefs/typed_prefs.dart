import 'package:shared_preferences/shared_preferences.dart';

/// Khai một khoá SharedPreferences có kiểu - tránh gõ nhầm string key hoặc
/// đọc sai kiểu dữ liệu đã ghi, lỗi hay gặp nhất khi dùng
/// `SharedPreferences` trực tiếp bằng string tự do rải rác khắp app.
class AscPrefKey<T> {
  const AscPrefKey(this.key, {this.defaultValue});

  final String key;
  final T? defaultValue;
}

/// Wrapper `SharedPreferences` đọc/ghi theo [AscPrefKey] thay vì string.
/// Hỗ trợ `String`, `bool`, `int`, `double`, `List<String>` - đúng các kiểu
/// `SharedPreferences` hỗ trợ sẵn.
class AscPrefs {
  AscPrefs(this._prefs);

  final SharedPreferences _prefs;

  static Future<AscPrefs> instance() async =>
      AscPrefs(await SharedPreferences.getInstance());

  T? get<T>(AscPrefKey<T> key) {
    final Object? value;
    if (T == String) {
      value = _prefs.getString(key.key);
    } else if (T == bool) {
      value = _prefs.getBool(key.key);
    } else if (T == int) {
      value = _prefs.getInt(key.key);
    } else if (T == double) {
      value = _prefs.getDouble(key.key);
    } else if (T == List<String>) {
      value = _prefs.getStringList(key.key);
    } else {
      throw UnsupportedError('Kiểu $T chưa được AscPrefs hỗ trợ');
    }
    return (value as T?) ?? key.defaultValue;
  }

  Future<bool> set<T>(AscPrefKey<T> key, T value) => switch (value) {
    String v => _prefs.setString(key.key, v),
    bool v => _prefs.setBool(key.key, v),
    int v => _prefs.setInt(key.key, v),
    double v => _prefs.setDouble(key.key, v),
    List<String> v => _prefs.setStringList(key.key, v),
    _ => throw UnsupportedError(
      'Kiểu ${value.runtimeType} chưa được AscPrefs hỗ trợ',
    ),
  };

  Future<bool> remove<T>(AscPrefKey<T> key) => _prefs.remove(key.key);
}
