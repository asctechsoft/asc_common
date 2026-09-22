import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Widget hiện Native Ad theo template dựng sẵn của Google
/// (`NativeTemplateStyle`) - app chỉ cần truyền `adUnitId`, không phải tự vẽ
/// layout native ad bằng tay.
class AscNativeAdView extends StatefulWidget {
  const AscNativeAdView({
    super.key,
    required this.adUnitId,
    this.templateType = TemplateType.medium,
    this.height = 320,
  });

  final String adUnitId;
  final TemplateType templateType;
  final double height;

  @override
  State<AscNativeAdView> createState() => _AscNativeAdViewState();
}

class _AscNativeAdViewState extends State<AscNativeAdView> {
  NativeAd? _ad;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _ad = NativeAd(
      adUnitId: widget.adUnitId,
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
    if (!_loaded || _ad == null) return SizedBox(height: widget.height);
    return SizedBox(height: widget.height, child: AdWidget(ad: _ad!));
  }
}
