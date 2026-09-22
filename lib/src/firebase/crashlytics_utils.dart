import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Gắn Crashlytics bắt lỗi Flutter framework + lỗi async ngoài framework
/// chưa được bắt - gọi [install] một lần lúc khởi động, ngay sau
/// `Firebase.initializeApp`.
class AscCrashlytics {
  AscCrashlytics._();

  static void install() {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  /// Ghi log không gây crash - dùng làm breadcrumb trước một thao tác quan
  /// trọng, để nếu crash sau đó Crashlytics còn giữ lại ngữ cảnh dẫn tới lỗi.
  static void log(String message) => FirebaseCrashlytics.instance.log(message);

  /// Ghi lỗi đã tự bắt bằng try/catch (không làm crash app) nhưng vẫn muốn
  /// Crashlytics theo dõi tần suất xảy ra.
  static Future<void> recordError(
    Object error,
    StackTrace stack, {
    String? reason,
    bool fatal = false,
  }) => FirebaseCrashlytics.instance.recordError(
    error,
    stack,
    reason: reason,
    fatal: fatal,
  );

  static Future<void> setUserId(String id) =>
      FirebaseCrashlytics.instance.setUserIdentifier(id);
}
