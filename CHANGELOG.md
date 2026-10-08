## 0.1.0

* Tách Firebase (Analytics/Crashlytics/Remote Config) + Ads + GDPR/UMP + bootstrap sang package `dsp_base`.
* Bỏ `flutter_riverpod`: `AscConnectivity` thay `ascConnectivityProvider`/`ascIsOnlineProvider` (Stream/Future thuần Dart).

## 0.0.1

* Bản đầu: UI primitives, localization XML, ads (Google Mobile Ads), GDPR/UMP
  (Riverpod `AsyncNotifier`), Firebase utils (Crashlytics/Analytics/Remote
  Config), prefs có kiểu, permission, device/connectivity, logging, in-app
  review, và `AscCommon.bootstrap` làm entry point khởi động duy nhất.
