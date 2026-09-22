import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../firebase/crashlytics_utils.dart';
import '../firebase/remote_config_utils.dart';

/// Kết quả của [AscCommon.bootstrap] - đưa lại thứ app cần đọc tiếp ngay sau
/// khi khởi động xong (ví dụ override provider Riverpod).
class AscBootstrapResult {
  const AscBootstrapResult({required this.remoteConfig});

  final AscRemoteConfig remoteConfig;
}

/// Entry point khởi động **duy nhất** của package - gom các bước hay bị rải
/// rác ở nhiều nơi (Firebase, Crashlytics, Remote Config, Mobile Ads SDK)
/// vào một hàm. App gọi một lần lúc mở app (trước hoặc trong lúc hiện splash
/// screen), khác hẳn kiểu `comm_app.dart` gọi tuần tự thủ công của bản cũ.
///
/// **Không** tự gọi `runApp`/dựng `ProviderScope` - app vẫn tự chủ hoàn toàn
/// cấu trúc UI của mình, package chỉ lo phần khởi tạo hạ tầng dùng chung.
///
/// **Không** tự chạy luồng GDPR/UMP ở đây: `AscGdprNotifier` là Riverpod
/// `AsyncNotifier`, cần một `ProviderContainer`/`WidgetRef` thật để chạy -
/// gọi nó sau khi `ProviderScope` đã dựng xong
/// (`ref.read(ascGdprProvider.notifier).requestConsentInfoUpdate()`), không
/// gọi được từ một hàm static thuần tuý mà không tạo container trùng lặp
/// với container thật của app.
class AscCommon {
  AscCommon._();

  static Future<AscBootstrapResult> bootstrap({
    required FirebaseOptions firebaseOptions,
    required Map<String, dynamic> remoteConfigDefaults,
    bool enableCrashlytics = true,
    bool initAds = false,
  }) async {
    await Firebase.initializeApp(options: firebaseOptions);

    if (enableCrashlytics) {
      AscCrashlytics.install();
    }

    final remoteConfig = await AscRemoteConfig.init(
      defaults: remoteConfigDefaults,
    );

    if (initAds) {
      await MobileAds.instance.initialize();
    }

    return AscBootstrapResult(remoteConfig: remoteConfig);
  }
}
