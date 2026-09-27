import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ads_config.dart';
import 'test_ad_ids.dart';

/// Widget hiện Banner Ad, tự tải/dispose theo vòng đời widget - app chỉ cần
/// đặt vào cây UI, không phải tự quản `BannerAd` như code cũ.
///
/// Tự áp [AscAdsConfig.isHideAd] (ẩn hẳn, không tải) và
/// [AscAdsConfig.isAdTestIds] (đổi sang ID test chính thức của Google theo
/// nền tảng) - app không cần tự if/else ở nơi gọi.
class AscBannerAdView extends StatefulWidget {
  const AscBannerAdView({
    super.key,
    required this.adUnitId,
    this.size = AdSize.banner,
    this.onPaidEvent,
  }) : anchoredAdaptiveWidth = null;

  /// A banner sized by Google's anchored adaptive algorithm for the current
  /// orientation, given the screen (or container) [anchoredAdaptiveWidth] -
  /// typically `MediaQuery.sizeOf(context).width`. Falls back to [AdSize.banner]
  /// if the platform can't compute one for that width.
  const AscBannerAdView.anchoredAdaptive({
    super.key,
    required this.adUnitId,
    required double this.anchoredAdaptiveWidth,
    this.onPaidEvent,
  }) : size = AdSize.banner;

  final String adUnitId;
  final AdSize size;
  final double? anchoredAdaptiveWidth;

  /// Gọi khi ghi nhận doanh thu quy đổi (impression đã được tính tiền) -
  /// app tự quyết định log đi đâu (Firebase Analytics, ...); package không
  /// hardcode sự kiện phân tích nào.
  final void Function(
    Ad ad,
    double valueMicros,
    PrecisionType precision,
    String currencyCode,
  )?
  onPaidEvent;

  @override
  State<AscBannerAdView> createState() => _AscBannerAdViewState();
}

class _AscBannerAdViewState extends State<AscBannerAdView> {
  BannerAd? _ad;
  bool _loaded = false;
  AdSize _resolvedSize = AdSize.banner;

  @override
  void initState() {
    super.initState();
    if (!AscAdsConfig.isHideAd) _load();
  }

  Future<void> _load() async {
    final adaptiveWidth = widget.anchoredAdaptiveWidth;
    _resolvedSize = adaptiveWidth == null
        ? widget.size
        : await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
                adaptiveWidth.truncate(),
              ) ??
              widget.size;
    if (!mounted) return;

    final effectiveId = AscAdsConfig.resolveAdUnitId(
      adUnitId: widget.adUnitId,
      androidTestId: AscTestAdIds.androidBanner,
      iosTestId: AscTestAdIds.iosBanner,
    );
    _ad = BannerAd(
      adUnitId: effectiveId,
      size: _resolvedSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (mounted) setState(() => _loaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _ad = null;
        },
        onPaidEvent: (ad, valueMicros, precision, currencyCode) {
          widget.onPaidEvent?.call(ad, valueMicros, precision, currencyCode);
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Ẩn hẳn - không có gì sẽ tải nên không giữ chỗ (khác nhánh dưới, vẫn
    // giữ chỗ trong lúc CHỜ tải xong để layout không giật).
    if (AscAdsConfig.isHideAd) return const SizedBox.shrink();

    final ad = _ad;
    if (!_loaded || ad == null) {
      // Giữ đúng kích thước để layout không giật khi quảng cáo tải xong.
      return SizedBox(
        width: _resolvedSize.width.toDouble(),
        height: _resolvedSize.height.toDouble(),
      );
    }
    return SizedBox(
      width: ad.size.width.toDouble(),
      height: ad.size.height.toDouble(),
      child: AdWidget(ad: ad),
    );
  }
}
