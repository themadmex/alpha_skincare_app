import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState {
  CameraController? _controller;
  List? _cameras;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras!.isNotEmpty) {
      _controller = CameraController(
        _cameras!.first,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await _controller!.initialize();
      setState(() => _isInitialized = true);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future _capture() async {
    if (!_controller!.value.isInitialized) return;
    final XFile file = await _controller!.takePicture();
// Navigate to processing or results with file
    context.go('/results', extra: File(file.path));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isInitialized && _controller != null
          ? Stack(
        children: [
          CameraPreview(_controller!),
// Optional overlay
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: FloatingActionButton(
                onPressed: _capture,
                child: const Icon(Icons.camera),
              ),
            ),
          ),
        ],
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}