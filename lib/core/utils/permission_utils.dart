// lib/core/utils/permission_utils.dart
import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  static Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status == PermissionStatus.granted;
  }

  static Future<bool> requestStoragePermission() async {
    final status = await Permission.storage.request();
    return status == PermissionStatus.granted;
  }

  static Future<bool> requestPhotoPermission() async {
    final status = await Permission.photos.request();
    return status == PermissionStatus.granted;
  }

  static Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    return status == PermissionStatus.granted;
  }

  static Future<bool> hasCameraPermission() async {
    final status = await Permission.camera.status;
    return status == PermissionStatus.granted;
  }

  static Future<bool> hasStoragePermission() async {
    final status = await Permission.storage.status;
    return status == PermissionStatus.granted;
  }

  static Future<bool> hasPhotoPermission() async {
    final status = await Permission.photos.status;
    return status == PermissionStatus.granted;
  }

  static Future<bool> hasNotificationPermission() async {
    final status = await Permission.notification.status;
    return status == PermissionStatus.granted;
  }

  static Future<Map<String, bool>> requestAllPermissions() async {
    final permissions = await [
      Permission.camera,
      Permission.storage,
      Permission.photos,
      Permission.notification,
    ].request();

    return {
      'camera': permissions[Permission.camera] == PermissionStatus.granted,
      'storage': permissions[Permission.storage] == PermissionStatus.granted,
      'photos': permissions[Permission.photos] == PermissionStatus.granted,
      'notification': permissions[Permission.notification] == PermissionStatus.granted,
    };
  }

  static Future<void> openAppSettings() async {
    await openAppSettings();
  }
}