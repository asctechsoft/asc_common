/// Giới hạn tần suất hiện quảng cáo toàn màn hình - tránh spam Interstitial/
/// AppOpen liên tục làm phiền người dùng.
class AscAdFrequencyTracker {
  AscAdFrequencyTracker({this.minInterval = const Duration(minutes: 1)});

  final Duration minInterval;
  DateTime? _lastShownAt;

  /// Có được hiện quảng cáo ngay bây giờ không (đã đủ khoảng cách tối thiểu
  /// kể từ lần hiện gần nhất).
  bool get canShow {
    final last = _lastShownAt;
    if (last == null) return true;
    return DateTime.now().difference(last) >= minInterval;
  }

  /// Gọi ngay sau khi quảng cáo đã hiện thành công.
  void markShown() => _lastShownAt = DateTime.now();
}
