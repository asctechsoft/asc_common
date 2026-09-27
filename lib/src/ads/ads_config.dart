import 'dart:io' show Platform;

/// Global ads switches this app's screens/services check before loading or
/// rendering an ad - mirrors what used to live on a shared `AdvertsConfig`
/// singleton in the legacy internal package this replaces. Deliberately
/// plain mutable statics (not Riverpod state): these are read at ad-request
/// time, not watched/rebuilt on by widgets.
class AscAdsConfig {
  AscAdsConfig._();

  /// Hides every ad (banner/native/interstitial/rewarded/app open)
  /// regardless of load state - flip on for a debug/test build.
  static bool isHideAd = false;

  /// Forces every ad request to use Google's official test ad unit ids
  /// instead of the real ones - flip on outside a shipped release build so
  /// development traffic never hits real inventory (Google can flag an
  /// AdMob account for abnormal real-ad request volume from test devices).
  static bool isAdTestIds = false;

  /// Resolves the ad unit id a service should actually request: the real
  /// [adUnitId] normally, or the matching platform id from
  /// [androidTestId]/[iosTestId] (see [AscTestAdIds]) when [isAdTestIds] is
  /// on.
  static String resolveAdUnitId({
    required String adUnitId,
    required String androidTestId,
    required String iosTestId,
  }) {
    if (!isAdTestIds) return adUnitId;
    return Platform.isAndroid ? androidTestId : iosTestId;
  }
}
