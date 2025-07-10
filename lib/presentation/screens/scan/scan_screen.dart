// lib/presentation/screens/scan/scan_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';
import '../../providers/scan_provider.dart';
import '../../widgets/scan/camera_overlay.dart';
import '../../widgets/scan/scan_instructions.dart';
import '../../widgets/common/custom_button.dart';

class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  bool _showInstructions = true;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras!.isNotEmpty) {
        _cameraController = CameraController(
          _cameras![0],
          ResolutionPreset.high,
        );
        await _cameraController!.initialize();
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
        }
      }
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  Future<void> _takePicture() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      final image = await _cameraController!.takePicture();
      await ref.read(scanControllerProvider.notifier).analyzeSkin(image.path);
      context.go('/scan/results');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error taking picture: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scanState = ref.watch(scanControllerProvider);

    if (_showInstructions) {
      return ScanInstructions(
        onContinue: () {
          setState(() {
            _showInstructions = false;
          });
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Scan Your Skin',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          // Camera preview
          if (_isInitialized && _cameraController != null)
            Positioned.fill(
              child: CameraPreview(_cameraController!),
            )
          else
            const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),

          // Camera overlay
          if (_isInitialized)
            const Positioned.fill(
              child: CameraOverlay(),
            ),

          // Bottom controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Position your face in the circle',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Gallery button
                      IconButton(
                        onPressed: () {
                          // TODO: Implement gallery picker
                        },
                        icon: const Icon(
                          Icons.photo_library,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),

                      // Capture button
                      GestureDetector(
                        onTap: scanState.isLoading ? null : _takePicture,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: scanState.isLoading
                                ? Colors.grey
                                : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 4,
                            ),
                          ),
                          child: scanState.isLoading
                              ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.blue,
                            ),
                          )
                              : const Icon(
                            Icons.camera_alt,
                            color: Colors.black,
                            size: 32,
                          ),
                        ),
                      ),

                      // Switch camera button
                      IconButton(
                        onPressed: () {
                          // TODO: Implement camera switch
                        },
                        icon: const Icon(
                          Icons.flip_camera_ios,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
