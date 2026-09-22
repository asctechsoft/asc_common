import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Trạng thái mạng hiện tại, expose qua Riverpod `StreamProvider` - màn hình
/// nào cần biết online/offline thì `ref.watch(ascConnectivityProvider)`
/// thay vì tự đăng ký/huỷ `StreamSubscription` bằng tay.
final ascConnectivityProvider = StreamProvider<List<ConnectivityResult>>((
  ref,
) {
  return Connectivity().onConnectivityChanged;
});

/// Có đang online hay không (còn ít nhất một kết nối khác `none`). Trả về
/// `true` khi chưa xác định được (tránh chớp UI "mất mạng" lúc app vừa mở).
final ascIsOnlineProvider = Provider<bool>((ref) {
  final result = ref.watch(ascConnectivityProvider).value;
  if (result == null) return true;
  return result.any((r) => r != ConnectivityResult.none);
});
