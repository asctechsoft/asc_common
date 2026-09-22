import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

/// Thông tin thiết bị gọn - chỉ giữ vài trường hay dùng nhất (model, hệ điều
/// hành, có phải máy thật không) thay vì trả nguyên `AndroidDeviceInfo`/
/// `IosDeviceInfo` (khác field nhau giữa hai nền tảng, gọi code phải tự
/// `if (Platform.isAndroid)` khắp nơi).
class AscDeviceInfo {
  const AscDeviceInfo({
    required this.platform,
    required this.model,
    required this.osVersion,
    required this.isPhysicalDevice,
  });

  /// `'android'` | `'ios'` | `'khác'`.
  final String platform;
  final String model;
  final String osVersion;
  final bool isPhysicalDevice;

  static Future<AscDeviceInfo> current() async {
    final plugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final info = await plugin.androidInfo;
      return AscDeviceInfo(
        platform: 'android',
        model: info.model,
        osVersion: 'Android ${info.version.release}',
        isPhysicalDevice: info.isPhysicalDevice,
      );
    }
    if (Platform.isIOS) {
      final info = await plugin.iosInfo;
      return AscDeviceInfo(
        platform: 'ios',
        model: info.utsname.machine,
        osVersion: '${info.systemName} ${info.systemVersion}',
        isPhysicalDevice: info.isPhysicalDevice,
      );
    }
    return const AscDeviceInfo(
      platform: 'khác',
      model: 'unknown',
      osVersion: 'unknown',
      isPhysicalDevice: true,
    );
  }
}
