// lib/presentation/screens/scan/scan_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../../services/camera_service.dart';
import '../../providers/scan_provider.dart';
import '../../widgets/scan/face_overlay.dart';
import '../../widgets/scan/scan_controls.dart';
import '../../widgets/common/custom_button.dart';

class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  bool _isLoading = true;
  bool _hasPermission = false;
  String? _errorMessage;
  bool _showInstructions = true;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final success = await CameraService.instance.initialize();
      if (mounted) {
        setState(() {
          _hasPermission = success;
          _isLoading = false;
          if (!success) {
            _errorMessage = 'Failed to initialize camera';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasPermission = false;
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  @override
  void dispose() {
    CameraService.instance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!_hasPermission) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Scan Your Skin'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.camera_alt,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                _errorMessage ?? 'Camera permission required',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Grant Permission',
                onPressed: _initializeCamera,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Scan Your Skin',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Camera Preview
          if (CameraService.instance.controller != null)
            Positioned.fill(
              child: CameraPreview(CameraService.instance.controller!),
            ),

          // Face Overlay Guide
          const Positioned.fill(
            child: FaceOverlay(),
          ),

          // Instructions Overlay
          if (_showInstructions)
            Positioned.fill(
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: Card(
                    margin: const EdgeInsets.all(24),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Lottie.asset(
                            'assets/animations/face_scan_guide.json',
                            height: 120,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'How to take a good scan',
                            style: Theme.of(context).textTheme.headlineSmall,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InstructionItem(
                                icon: Icons.light_mode,
                                text: 'Use natural or bright lighting',
                              ),
                              InstructionItem(
                                icon: Icons.face,
                                text: 'Align your face within the oval',
                              ),
                              InstructionItem(
                                icon: Icons.cleaning_services,
                                text: 'Remove makeup for best results',
                              ),
                              InstructionItem(
                                icon: Icons.camera_alt,
                                text: 'Hold steady and tap to capture',
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          CustomButton(
                            text: 'Got it!',
                            onPressed: () {
                              setState(() {
                                _showInstructions = false;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Scan Controls
          if (!_showInstructions)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ScanControls(
                onCapture: _captureImage,
                onSwitchCamera: _switchCamera,
                onShowInstructions: () {
                  setState(() {
                    _showInstructions = true;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _captureImage() async {
    try {
      final imageFile = await CameraService.instance.takePicture();
      if (imageFile != null && mounted) {
        // Navigate to processing screen
        context.go('/scan/processing', extra: imageFile.path);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to capture image: $e')),
      );
    }
  }

  Future<void> _switchCamera() async {
    try {
      await CameraService.instance.switchCamera();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to switch camera: $e')),
      );
    }
  }
}

class InstructionItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const InstructionItem({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor),
          const SizedBox(width: 16),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}