import 'package:permission_handler/permission_handler.dart';

/// Bọc `permission_handler` - gộp bước "xin quyền" + "nếu bị từ chối vĩnh
/// viễn thì mở Settings hệ điều hành" thành một hàm, thay vì lặp lại logic
/// này ở từng nơi cần xin quyền trong app.
class AscPermissions {
  AscPermissions._();

  /// Xin quyền [permission]. Trả về `true` nếu được cấp. Nếu người dùng đã
  /// từ chối vĩnh viễn từ trước và [openSettingsIfPermanentlyDenied] là
  /// `true` (mặc định) thì tự mở màn Settings của hệ điều hành - xin lại
  /// bằng dialog lúc này sẽ không hiện gì cả (hành vi chuẩn của OS).
  static Future<bool> request(
    Permission permission, {
    bool openSettingsIfPermanentlyDenied = true,
  }) async {
    final status = await permission.request();
    if (status.isGranted) return true;
    if (status.isPermanentlyDenied && openSettingsIfPermanentlyDenied) {
      await openAppSettings();
    }
    return false;
  }

  static Future<bool> isGranted(Permission permission) async =>
      (await permission.status).isGranted;
}
