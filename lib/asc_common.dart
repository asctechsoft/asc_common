/// asc_common - shared internal Flutter package của ASC Tech Soft.
///
/// UI primitives, localization XML, prefs có kiểu, permission, device/
/// connectivity, logging, in-app review - dùng chung cho nhiều app. Firebase
/// (Analytics/Crashlytics/App Check/Remote Config) và quảng cáo nằm ở package
/// riêng `dsp_base`. Xem README.md để biết chi tiết từng mảng.
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

// Prefs có kiểu.
export 'src/prefs/typed_prefs.dart';

// Permission.
export 'src/permissions/permission_utils.dart';

// Device & connectivity.
export 'src/connectivity/asc_connectivity.dart';
export 'src/device/device_info_utils.dart';

// Logging.
export 'src/logging/asc_logger.dart';

// In-app review.
export 'src/review/review_utils.dart';

