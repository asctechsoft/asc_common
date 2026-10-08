import 'package:connectivity_plus/connectivity_plus.dart';

/// Trạng thái mạng - thuần Dart (`Stream`/`Future`), không phụ thuộc state
/// management nào nên app dùng GetX/Riverpod/Bloc đều gọi được.
class AscConnectivity {
  AscConnectivity._();

  /// Luồng thay đổi kết nối - `listen` rồi nhớ `cancel` khi huỷ.
  static Stream<List<ConnectivityResult>> get onChanged =>
      Connectivity().onConnectivityChanged;

  /// Có đang online hay không (còn ít nhất một kết nối khác `none`).
  static Future<bool> isOnline() async =>
      isOnlineFrom(await Connectivity().checkConnectivity());

  /// Chuyển một kết quả kết nối thành online/offline - dùng cho phần tử của
  /// [onChanged].
  static bool isOnlineFrom(List<ConnectivityResult> result) =>
      result.any((r) => r != ConnectivityResult.none);
}
