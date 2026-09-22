import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Widget hiện Banner Ad, tự tải/dispose theo vòng đời widget - app chỉ cần
/// đặt vào cây UI, không phải tự quản `BannerAd` như code cũ.
class AscBannerAdView extends StatefulWidget {
  const AscBannerAdView({
    super.key,
    required this.adUnitId,
    this.size = AdSize.banner,
  });

  final String adUnitId;
  final AdSize size;

  @override
  State<AscBannerAdView> createState() => _AscBannerAdViewState();
}

class _AscBannerAdViewState extends State<AscBannerAdView> {
  BannerAd? _ad;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _ad = BannerAd(
      adUnitId: widget.adUnitId,
      size: widget.size,
      request: const AdRequest(),
      listener: BannerAdListener(
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
    final ad = _ad;
    if (!_loaded || ad == null) {
      // Giữ đúng kích thước để layout không giật khi quảng cáo tải xong.
      return SizedBox(
        width: widget.size.width.toDouble(),
        height: widget.size.height.toDouble(),
      );
    }
    return SizedBox(
      width: ad.size.width.toDouble(),
      height: ad.size.height.toDouble(),
      child: AdWidget(ad: ad),
    );
  }
}
