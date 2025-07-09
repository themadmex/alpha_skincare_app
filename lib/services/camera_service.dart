// lib/services/camera_service.dart
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class CameraService {
  static CameraService? _instance;
  static CameraService get instance => _instance ??= CameraService._();
  CameraService._();

  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;

  CameraController? get controller => _controller;
  bool get isInitialized => _isInitialized;

  Future<bool> initialize() async {
    try {
      // Request camera permission
      final permission = await Permission.camera.request();
      if (permission != PermissionStatus.granted) {
        throw Exception('Camera permission denied');
      }

      // Get available cameras
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        throw Exception('No cameras available');
      }

      // Use front camera for selfie
      final frontCamera = _cameras!.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras!.first,
      );

      // Initialize camera controller
      _controller = CameraController(
        frontCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _controller!.initialize();
      _isInitialized = true;
      return true;
    } catch (e) {
      debugPrint('Camera initialization failed: $e');
      _isInitialized = false;
      return false;
    }
  }

  Future<File?> takePicture() async {
    if (!_isInitialized || _controller == null) {
      throw Exception('Camera not initialized');
    }

    try {
      final XFile picture = await _controller!.takePicture();
      return File(picture.path);
    } catch (e) {
      debugPrint('Failed to take picture: $e');
      return null;
    }
  }

  Future<void> dispose() async {
    if (_controller != null) {
      await _controller!.dispose();
      _controller = null;
    }
    _isInitialized = false;
  }

  Future<void> switchCamera() async {
    if (_cameras == null || _cameras!.length < 2) return;

    final currentLens = _controller!.description.lensDirection;
    final newCamera = _cameras!.firstWhere(
          (camera) => camera.lensDirection != currentLens,
      orElse: () => _cameras!.first,
    );

    await _controller!.dispose();
    _controller = CameraController(
      newCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _controller!.initialize();
  }
}