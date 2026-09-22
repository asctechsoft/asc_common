import 'package:logger/logger.dart';

export 'package:logger/logger.dart' show Level;

/// Logger dùng chung - bọc gói `logger` (Pretty Printer sẵn màu/emoji cho
/// console dev), có thể nối thêm sink tuỳ chỉnh qua [onLog] - ví dụ ghi
/// breadcrumb vào Crashlytics (`AscCrashlytics.log`) mỗi khi có log warning
/// trở lên.
class AscLogger {
  AscLogger({void Function(Level level, String message)? onLog})
    // Không dùng initializing formal (`this._onLog`): tên tham số bên ngoài
    // sẽ trùng tên field riêng tư (`_onLog`), và named parameter đặt tên
    // theo một field riêng tư thì library khác không gọi `onLog:` được nữa
    // - giữ constructor nhận `onLog` rồi tự gán vào field riêng như hiện tại.
    // ignore: prefer_initializing_formals
    : _onLog = onLog,
      _logger = Logger(printer: PrettyPrinter(methodCount: 0));

  final Logger _logger;
  final void Function(Level level, String message)? _onLog;

  void debug(String message) => _log(Level.debug, message);
  void info(String message) => _log(Level.info, message);
  void warning(String message) => _log(Level.warning, message);

  void error(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
    _onLog?.call(Level.error, message);
  }

  void _log(Level level, String message) {
    _logger.log(level, message);
    _onLog?.call(level, message);
  }
}
