// lib/core/utils/device_utils.dart
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DeviceUtils {
  static Future<Map<String, dynamic>> getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    final packageInfo = await PackageInfo.fromPlatform();

    Map<String, dynamic> info = {
      'appName': packageInfo.appName,
      'packageName': packageInfo.packageName,
      'version': packageInfo.version,
      'buildNumber': packageInfo.buildNumber,
    };

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      info.addAll({
        'platform': 'Android',
        'model': androidInfo.model,
        'manufacturer': androidInfo.manufacturer,
        'androidId': androidInfo.id,
        'sdkInt': androidInfo.version.sdkInt,
        'release': androidInfo.version.release,
        'brand': androidInfo.brand,
        'device': androidInfo.device,
        'hardware': androidInfo.hardware,
        'isPhysicalDevice': androidInfo.isPhysicalDevice,
      });
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      info.addAll({
        'platform': 'iOS',
        'model': iosInfo.model,
        'name': iosInfo.name,
        'systemName': iosInfo.systemName,
        'systemVersion': iosInfo.systemVersion,
        'identifierForVendor': iosInfo.identifierForVendor,
        'isPhysicalDevice': iosInfo.isPhysicalDevice,
        'utsname': iosInfo.utsname.machine,
      });
    }

    return info;
  }

  static Future<bool> isPhysicalDevice() async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.isPhysicalDevice;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.isPhysicalDevice;
    }

    return true;
  }

  static Future<String> getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? 'unknown';
    }

    return 'unknown';
  }

  static bool get isAndroid => Platform.isAndroid;
  static bool get isIOS => Platform.isIOS;

  static Future<double> getStorageSpace() async {
    // Implementation would depend on specific storage plugin
    // Placeholder for now
    return 0.0;
  }
}