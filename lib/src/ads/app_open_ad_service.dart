import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_load_state.dart';

/// Bọc App Open Ad - quảng cáo hiện khi người dùng quay lại app từ nền.
///
/// Quảng cáo đã tải có hạn dùng ([maxCacheDuration], mặc định 4 giờ theo
/// khuyến cáo của Google) - hiện quảng cáo đã tải quá lâu dễ bị tính là vi
/// phạm chính sách AdMob.
class AscAppOpenAdService {
  AscAppOpenAdService({
    required this.adUnitId,
    this.maxCacheDuration = const Duration(hours: 4),
  });

  final String adUnitId;
  final Duration maxCacheDuration;

  AppOpenAd? _ad;
  DateTime? _loadedAt;
  AdLoadState _state = const AdIdle();
  AdLoadState get state => _state;
  bool _isShowing = false;

  bool get _isAvailable {
    final ad = _ad;
    final loadedAt = _loadedAt;
    if (ad == null || loadedAt == null) return false;
    return DateTime.now().difference(loadedAt) < maxCacheDuration;
  }

  Future<void> load() async {
    _state = const AdLoading();
    await AppOpenAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _ad = ad;
          _loadedAt = DateTime.now();
          _state = const AdLoaded();
        },
        onAdFailedToLoad: (error) {
          _ad = null;
          _state = AdFailed(error.message);
        },
      ),
    );
  }

  /// Hiện quảng cáo nếu đã tải và còn hạn dùng. Trả về `true` nếu đã hiện.
  Future<bool> showIfAvailable() async {
    if (_isShowing || !_isAvailable) return false;
    final ad = _ad!;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (_) => _isShowing = true,
      onAdDismissedFullScreenContent: (ad) {
        _isShowing = false;
        ad.dispose();
        _ad = null;
        _state = const AdIdle();
        load();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _isShowing = false;
        ad.dispose();
        _ad = null;
        _state = AdFailed(error.message);
        load();
      },
    );

    _state = const AdShown();
    await ad.show();
    return true;
  }

  void dispose() => _ad?.dispose();
}
