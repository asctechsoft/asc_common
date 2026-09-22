import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'consent_status.dart';

/// Quản lý luồng xin sự đồng ý UMP (GDPR châu Âu/UK) - gọi
/// [requestConsentInfoUpdate] lúc khởi động, [showFormIfRequired] khi cần
/// hiện form hỏi người dùng.
///
/// Dùng Riverpod `AsyncNotifier` thay cho `GetxController` của bản cũ - state
/// là [AscConsentStatus] (`sealed class`), nơi dùng `watch` provider này rồi
/// `switch` đủ nhánh thay vì so sánh chuỗi/enum rời rạc.
class AscGdprNotifier extends AsyncNotifier<AscConsentStatus> {
  @override
  Future<AscConsentStatus> build() async => const AscConsentUnknown();

  /// Gọi lúc app khởi động - hỏi server của Google xem khu vực hiện tại
  /// (theo IP) có cần xin consent không.
  Future<void> requestConsentInfoUpdate({
    ConsentRequestParameters? params,
  }) async {
    final completer = Completer<void>();
    ConsentInformation.instance.requestConsentInfoUpdate(
      params ?? ConsentRequestParameters(),
      () async {
        final status = await ConsentInformation.instance.getConsentStatus();
        state = AsyncData(_mapStatus(status));
        completer.complete();
      },
      (error) {
        state = AsyncError(error.message, StackTrace.current);
        completer.complete();
      },
    );
    await completer.future;
  }

  /// Hiện form xin consent NẾU cần (`ConsentStatus.required`) - gọi sau
  /// [requestConsentInfoUpdate]. Tự bỏ qua nếu không cần hiện form.
  Future<void> showFormIfRequired() async {
    final isAvailable = await ConsentInformation.instance
        .isConsentFormAvailable();
    if (!isAvailable) return;

    final completer = Completer<void>();
    ConsentForm.loadConsentForm(
      (form) async {
        final status = await ConsentInformation.instance.getConsentStatus();
        if (status != ConsentStatus.required) {
          completer.complete();
          return;
        }
        form.show((formError) async {
          final newStatus = await ConsentInformation.instance
              .getConsentStatus();
          state = AsyncData(_mapStatus(newStatus));
          completer.complete();
        });
      },
      (error) {
        state = AsyncError(error.message, StackTrace.current);
        completer.complete();
      },
    );
    await completer.future;
  }

  AscConsentStatus _mapStatus(ConsentStatus status) => switch (status) {
    ConsentStatus.notRequired => const AscConsentNotRequired(),
    ConsentStatus.required => const AscConsentRequired(),
    ConsentStatus.obtained => const AscConsentObtained(),
    ConsentStatus.unknown => const AscConsentUnknown(),
  };
}

final ascGdprProvider =
    AsyncNotifierProvider<AscGdprNotifier, AscConsentStatus>(
      AscGdprNotifier.new,
    );
