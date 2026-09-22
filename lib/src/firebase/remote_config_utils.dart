import 'package:firebase_remote_config/firebase_remote_config.dart';

/// Wrapper Remote Config - app tự truyền [init]'s `defaults`, package
/// **không hardcode key/project nào** vì nhiều app khác nhau dùng chung
/// package này, mỗi app một bộ tham số riêng.
class AscRemoteConfig {
  AscRemoteConfig(this._rc);

  final FirebaseRemoteConfig _rc;

  /// Gọi lúc khởi động: set giá trị mặc định rồi fetch + activate một lần.
  /// Đặt [minimumFetchInterval] = `Duration.zero` khi cần dev test tức thì
  /// (đừng để vậy ở bản release - Firebase có giới hạn số lần fetch/ngày).
  static Future<AscRemoteConfig> init({
    required Map<String, dynamic> defaults,
    Duration fetchTimeout = const Duration(seconds: 10),
    Duration minimumFetchInterval = const Duration(hours: 1),
  }) async {
    final rc = FirebaseRemoteConfig.instance;
    await rc.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: fetchTimeout,
        minimumFetchInterval: minimumFetchInterval,
      ),
    );
    await rc.setDefaults(defaults);
    try {
      await rc.fetchAndActivate();
    } catch (_) {
      // Mất mạng lần đầu chạy - dùng defaults, không chặn app khởi động.
    }
    return AscRemoteConfig(rc);
  }

  String getString(String key) => _rc.getString(key);
  bool getBool(String key) => _rc.getBool(key);
  int getInt(String key) => _rc.getInt(key);
  double getDouble(String key) => _rc.getDouble(key);
}
