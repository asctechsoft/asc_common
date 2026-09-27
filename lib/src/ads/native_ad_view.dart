import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ads_config.dart';
import 'test_ad_ids.dart';

/// Widget hiện Native Ad theo template dựng sẵn của Google
/// (`NativeTemplateStyle`) - app chỉ cần truyền `adUnitId`, không phải tự vẽ
/// layout native ad bằng tay.
///
/// Tự áp [AscAdsConfig.isHideAd]/[AscAdsConfig.isAdTestIds] như
/// [AscBannerAdView] - xem đó để biết lý do.
class AscNativeAdView extends StatefulWidget {
  const AscNativeAdView({
    super.key,
    required this.adUnitId,
    this.templateType = TemplateType.medium,
    this.height = 320,
    this.onPaidEvent,
  });

  final String adUnitId;
  final TemplateType templateType;
  final double height;

  /// Gọi khi ghi nhận doanh thu quy đổi - xem [AscBannerAdView.onPaidEvent].
  final void Function(
    Ad ad,
    double valueMicros,
    PrecisionType precision,
    String currencyCode,
  )?
  onPaidEvent;

  @override
  State<AscNativeAdView> createState() => _AscNativeAdViewState();
}

class _AscNativeAdViewState extends State<AscNativeAdView> {
  NativeAd? _ad;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    if (AscAdsConfig.isHideAd) return;
    final effectiveId = AscAdsConfig.resolveAdUnitId(
      adUnitId: widget.adUnitId,
      androidTestId: AscTestAdIds.androidNative,
      iosTestId: AscTestAdIds.iosNative,
    );
    _ad = NativeAd(
      adUnitId: effectiveId,
      request: const AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: widget.templateType,
      ),
      listener: NativeAdListener(
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
    if (AscAdsConfig.isHideAd || !_loaded || _ad == null) {
      return SizedBox(height: widget.height);
    }
    return SizedBox(height: widget.height, child: AdWidget(ad: _ad!));
  }
}
