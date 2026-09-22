import 'package:firebase_analytics/firebase_analytics.dart';

/// Một sự kiện Analytics - gói `name` + `parameters` vào một type thay vì
/// gọi `logEvent(name: '...')` bằng chuỗi tự do rải rác khắp app (dễ gõ sai
/// tên/tham số, không có gợi ý kiểu lúc viết code). App tự định nghĩa các
/// hằng số [AscAnalyticsEvent] riêng rồi log qua [AscAnalytics.log].
class AscAnalyticsEvent {
  const AscAnalyticsEvent(this.name, [this.parameters]);

  final String name;
  final Map<String, Object>? parameters;
}

/// Wrapper `FirebaseAnalytics`.
class AscAnalytics {
  AscAnalytics(this._analytics);

  final FirebaseAnalytics _analytics;

  Future<void> log(AscAnalyticsEvent event) =>
      _analytics.logEvent(name: event.name, parameters: event.parameters);

  Future<void> setUserId(String? id) => _analytics.setUserId(id: id);

  Future<void> setUserProperty(String name, String? value) =>
      _analytics.setUserProperty(name: name, value: value);

  Future<void> logScreenView(String screenName) =>
      _analytics.logScreenView(screenName: screenName);
}
