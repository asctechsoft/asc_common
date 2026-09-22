import 'package:in_app_review/in_app_review.dart';

/// Bọc `in_app_review` (API "đánh giá app" chính thức của Google/Apple) -
/// thay cho cách tự dựng dialog 5 sao rồi mở link store bằng tay của bản cũ.
class AscReview {
  AscReview._();

  static final _plugin = InAppReview.instance;

  static Future<bool> get isAvailable => _plugin.isAvailable();

  /// Hiện popup đánh giá trong app (Android: Google Play In-App Review; iOS:
  /// `SKStoreReviewController`) - hệ điều hành **tự quyết định** có hiện hay
  /// không (có ngưỡng/giới hạn số lần riêng của Google/Apple, app không
  /// kiểm soát được), không đảm bảo hiện mỗi lần gọi.
  static Future<void> requestReview() async {
    if (await isAvailable) await _plugin.requestReview();
  }

  /// Mở thẳng trang app trên store - dùng khi muốn chắc chắn mở được màn
  /// đánh giá (ví dụ bấm từ menu Cài đặt "Đánh giá ứng dụng"), khác với
  /// [requestReview] chỉ là gợi ý cho hệ điều hành.
  static Future<void> openStoreListing({
    String? appStoreId,
    String? microsoftStoreId,
  }) => _plugin.openStoreListing(
    appStoreId: appStoreId,
    microsoftStoreId: microsoftStoreId,
  );
}
