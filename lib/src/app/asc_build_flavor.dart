import 'package:flutter/services.dart';

/// Build-flavor flags read from the `--flavor` name (`alpha`, `dev`,
/// `product`, `claude`; matched case-insensitively on the first letter).
class AscBuildFlavor {
  AscBuildFlavor._();

  static const bool isAlpha = appFlavor == 'Alpha' || appFlavor == 'alpha';
  static const bool isDev = appFlavor == 'Dev' || appFlavor == 'dev';
  static const bool isProduct =
      appFlavor == 'Product' || appFlavor == 'product';
  static const bool isClaude = appFlavor == 'Claude' || appFlavor == 'claude';

  /// Gates debug-only affordances (remote-config test overrides, forced test
  /// ad ids, ...) — everywhere except a shipped Product build.
  static const bool isShowTestOption = isClaude || isAlpha || isDev;
}
