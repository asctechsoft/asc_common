import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'remote_config_utils.dart';

/// Provider cho [AscRemoteConfig].
///
/// App gọi `AscRemoteConfig.init(...)` lúc bootstrap (xem
/// `AscCommon.bootstrap`), rồi override provider này ở gốc cây widget:
/// ```dart
/// ProviderScope(
///   overrides: [ascRemoteConfigProvider.overrideWithValue(result.remoteConfig)],
///   child: const MyApp(),
/// )
/// ```
/// Đọc trước khi override sẽ throw để lỗi lộ ra ngay lúc dev thay vì âm thầm
/// trả giá trị rác.
final ascRemoteConfigProvider = Provider<AscRemoteConfig>((ref) {
  throw UnimplementedError(
    'ascRemoteConfigProvider chưa được override - gọi AscRemoteConfig.init() '
    'lúc bootstrap rồi override provider này trước khi runApp.',
  );
});
