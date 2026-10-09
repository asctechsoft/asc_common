import 'dart:io' show Platform;

import 'package:flutter/widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';

/// "Share this app" through the system share sheet.
class AscShare {
  AscShare._();

  /// Opens the share sheet with [message] plus a store link. The package name
  /// is read from the installed bundle, so flavours with an
  /// `applicationIdSuffix` still share a link that resolves. With an empty
  /// [iosAppId] (app not on the App Store yet) iOS falls back to the Play
  /// Store link rather than a dead App Store URL.
  ///
  /// [context] anchors the sheet: on iPad the popover needs a source rect and
  /// UIKit throws instead of presenting without one.
  static Future<void> shareApp(
    BuildContext context, {
    required String message,
    String iosAppId = '',
  }) async {
    final info = await PackageInfo.fromPlatform();
    final link = Platform.isIOS && iosAppId.isNotEmpty
        ? 'https://apps.apple.com/app/id$iosAppId'
        : 'https://play.google.com/store/apps/details?id=${info.packageName}';

    if (!context.mounted) return;

    await SharePlus.instance.share(
      ShareParams(
        text: '$message\n$link',
        // Only used by targets that have a subject line, e.g. email.
        subject: info.appName,
        sharePositionOrigin: _originOf(context),
      ),
    );
  }

  /// Global rect of the widget that triggered the share, or null when it has
  /// no size yet — iOS is the only platform that reads this.
  static Rect? _originOf(BuildContext context) {
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.hasSize) return null;
    return box.localToGlobal(Offset.zero) & box.size;
  }
}
