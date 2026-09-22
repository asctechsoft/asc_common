import 'app_open_ad_service.dart';
import 'interstitial_ad_service.dart';
import 'rewarded_ad_service.dart';

/// Gom cả ba loại quảng cáo toàn màn hình (Interstitial/Rewarded/AppOpen)
/// vào một chỗ, tải trước hết một lượt lúc app khởi động - thay vì rải rác
/// gọi `load()` ở từng nơi cần hiện quảng cáo như code cũ.
class AscAdPreloadService {
  AscAdPreloadService({this.interstitial, this.rewarded, this.appOpen});

  final AscInterstitialAdService? interstitial;
  final AscRewardedAdService? rewarded;
  final AscAppOpenAdService? appOpen;

  Future<void> preloadAll() async {
    await Future.wait([
      if (interstitial != null) interstitial!.load(),
      if (rewarded != null) rewarded!.load(),
      if (appOpen != null) appOpen!.load(),
    ]);
  }

  void disposeAll() {
    interstitial?.dispose();
    rewarded?.dispose();
    appOpen?.dispose();
  }
}
