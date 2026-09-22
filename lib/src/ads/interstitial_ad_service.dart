import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_frequency_tracker.dart';
import 'ad_load_state.dart';

/// Bọc vòng đời Interstitial Ad: tải trước, giữ sẵn, hiện khi cần rồi tự
/// tải lại quảng cáo tiếp theo - app gọi [load] một lần lúc khởi động rồi
/// [showIfReady] ở điểm chuyển màn hình cần hiện quảng cáo, không phải tự
/// quản `InterstitialAd?` như code cũ.
class AscInterstitialAdService {
  AscInterstitialAdService({
    required this.adUnitId,
    AscAdFrequencyTracker? frequencyTracker,
  }) : frequencyTracker = frequencyTracker ?? AscAdFrequencyTracker();

  final String adUnitId;
  final AscAdFrequencyTracker frequencyTracker;

  InterstitialAd? _ad;
  AdLoadState _state = const AdIdle();
  AdLoadState get state => _state;

  Future<void> load() async {
    _state = const AdLoading();
    await InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _ad = ad;
          _state = const AdLoaded();
        },
        onAdFailedToLoad: (error) {
          _ad = null;
          _state = AdFailed(error.message);
        },
      ),
    );
  }

  /// Hiện quảng cáo nếu đã tải xong và chưa vi phạm [frequencyTracker]. Trả
  /// về `true` nếu đã hiện được. Tự [load] lại cho lần sau sau khi đóng.
  Future<bool> showIfReady() async {
    final ad = _ad;
    if (ad == null || !frequencyTracker.canShow) return false;

    final done = Completer<void>();
    void finishAndReload() {
      if (!done.isCompleted) done.complete();
    }

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _ad = null;
        _state = const AdIdle();
        finishAndReload();
        load();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _ad = null;
        _state = AdFailed(error.message);
        finishAndReload();
        load();
      },
    );

    frequencyTracker.markShown();
    _state = const AdShown();
    await ad.show();
    await done.future;
    return true;
  }

  void dispose() => _ad?.dispose();
}
