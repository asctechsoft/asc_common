/// asc_common - shared internal Flutter package của ASC Tech Soft.
///
/// UI primitives, ads, GDPR/UMP, Firebase utils, localization XML, prefs có
/// kiểu, permission, device/connectivity, logging, in-app review - dùng
/// chung cho nhiều app. Xem README.md để biết chi tiết từng mảng.
library;

// UI primitives.
export 'src/ui/app_icon.dart';
export 'src/ui/app_layout.dart';
export 'src/ui/app_modifier.dart';
export 'src/ui/app_spacer.dart';
export 'src/ui/app_text.dart';
export 'src/ui/app_text_auto_resize.dart';

// Localization (XML kiểu Android, giữ tương thích quy trình dịch thuật cũ).
export 'src/localization/asc_localizations.dart';
export 'src/localization/asc_localizations_delegate.dart';

// Ads (Google Mobile Ads).
export 'src/ads/ad_frequency_tracker.dart';
export 'src/ads/ad_load_state.dart';
export 'src/ads/ad_preload_service.dart';
export 'src/ads/ads_config.dart';
export 'src/ads/app_open_ad_service.dart';
export 'src/ads/banner_ad_view.dart';
export 'src/ads/interstitial_ad_service.dart';
export 'src/ads/native_ad_view.dart';
export 'src/ads/rewarded_ad_service.dart';
export 'src/ads/test_ad_ids.dart';

// GDPR / UMP consent.
export 'src/gdpr/consent_status.dart';
export 'src/gdpr/gdpr_consent_notifier.dart';

// Firebase utils.
export 'src/firebase/analytics_utils.dart';
export 'src/firebase/crashlytics_utils.dart';
export 'src/firebase/remote_config_provider.dart';
export 'src/firebase/remote_config_utils.dart';

// Prefs có kiểu.
export 'src/prefs/typed_prefs.dart';

// Permission.
export 'src/permissions/permission_utils.dart';

// Device & connectivity.
export 'src/connectivity/connectivity_provider.dart';
export 'src/device/device_info_utils.dart';

// Logging.
export 'src/logging/asc_logger.dart';

// In-app review.
export 'src/review/review_utils.dart';

// Bootstrap - entry point khởi động duy nhất.
export 'src/init/asc_common_bootstrap.dart';
