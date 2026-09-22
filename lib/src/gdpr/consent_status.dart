/// Trạng thái consent GDPR/UMP của người dùng hiện tại.
///
/// `sealed` để nơi dùng (ví dụ quyết định có nạp quảng cáo cá nhân hoá hay
/// không) bắt buộc xử lý đủ nhánh qua `switch`.
sealed class AscConsentStatus {
  const AscConsentStatus();
}

/// Chưa xác định được (chưa gọi hoặc chưa fetch xong thông tin consent).
class AscConsentUnknown extends AscConsentStatus {
  const AscConsentUnknown();
}

/// Không cần hỏi consent (người dùng không ở khu vực EEA/UK theo IP).
class AscConsentNotRequired extends AscConsentStatus {
  const AscConsentNotRequired();
}

/// Cần hỏi nhưng người dùng chưa đưa ra quyết định.
class AscConsentRequired extends AscConsentStatus {
  const AscConsentRequired();
}

/// Người dùng đã đồng ý cá nhân hoá quảng cáo.
class AscConsentObtained extends AscConsentStatus {
  const AscConsentObtained();
}
