import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_frequency_tracker.dart';
import 'ad_load_state.dart';

/// Bọc vòng đời Rewarded Ad - trả phần thưởng qua callback
/// `onUserEarnedReward` khi người dùng xem hết quảng cáo.
class AscRewardedAdService {
  AscRewardedAdService({
    required this.adUnitId,
    AscAdFrequencyTracker? frequencyTracker,
  }) : frequencyTracker = frequencyTracker ?? AscAdFrequencyTracker();

  final String adUnitId;
  final AscAdFrequencyTracker frequencyTracker;

  RewardedAd? _ad;
  AdLoadState _state = const AdIdle();
  AdLoadState get state => _state;

  Future<void> load() async {
    _state = const AdLoading();
    await RewardedAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
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

  /// Hiện quảng cáo, gọi [onUserEarnedReward] khi người dùng xem xong. Trả
  /// về `true` nếu đã hiện được quảng cáo - **không** đồng nghĩa người dùng
  /// nhận thưởng, họ vẫn có thể thoát giữa chừng.
  Future<bool> showIfReady({
    required void Function(AdWithoutView ad, RewardItem reward)
    onUserEarnedReward,
  }) async {
    final ad = _ad;
    if (ad == null) return false;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _ad = null;
        _state = const AdIdle();
        load();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _ad = null;
        _state = AdFailed(error.message);
        load();
      },
    );

    frequencyTracker.markShown();
    _state = const AdShown();
    await ad.show(onUserEarnedReward: onUserEarnedReward);
    return true;
  }

  void dispose() => _ad?.dispose();
}
