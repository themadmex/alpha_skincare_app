import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/auth_service.dart';
import '../../services/skin_analysis_service.dart';
import './widgets/camera_overlay_widget.dart';
import './widgets/capture_button_widget.dart';
import './widgets/loading_analysis_widget.dart';
import './widgets/permission_request_widget.dart';
import './widgets/retry_capture_widget.dart';

class CameraScanScreen extends StatefulWidget {
  const CameraScanScreen({super.key});

  @override
  State<CameraScanScreen> createState() => _CameraScanScreenState();
}

class _CameraScanScreenState extends State<CameraScanScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  // Camera variables
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _isPermissionGranted = false;

  // UI state
  bool _isCapturing = false;
  bool _isAnalyzing = false;
  XFile? _capturedImage;

  // Services
  final AuthService _authService = AuthService();
  final SkinAnalysisService _analysisService = SkinAnalysisService();
  final ImagePicker _imagePicker = ImagePicker();

  // Animation controllers
  late AnimationController _pulseController;
  late AnimationController _overlayController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Initialize animation controllers
    _pulseController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this)
          ..repeat();

    _overlayController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    _pulseController.dispose();
    _overlayController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: _buildAppBar(),
        body: _buildBody());
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
            icon: CustomIconWidget(
                iconName: 'close', color: Colors.white, size: 24),
            onPressed: () => Navigator.pop(context)),
        title: Text('Skin Analysis',
            style: AppTheme.lightTheme.textTheme.titleLarge
                ?.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
        centerTitle: true,
        actions: [
          if (_isCameraInitialized)
            IconButton(
                icon: CustomIconWidget(
                    iconName: 'flip_camera_ios', color: Colors.white, size: 24),
                onPressed: _switchCamera),
        ]);
  }

  Widget _buildBody() {
    if (!_isPermissionGranted) {
      return PermissionRequestWidget(
          onRequestPermission: _requestCameraPermission,
          onCancel: () => Navigator.pop(context));
    }

    if (_isAnalyzing) {
      return LoadingAnalysisWidget(
          skincareTips: ['Ensure good lighting', 'Keep face steady', 'Remove glasses if possible']);
    }

    if (_capturedImage != null) {
      return RetryCaptureWidget(
          errorMessage: 'Review your photo',
          onCancel: _cancelAnalysis,
          onRetry: _retakePhoto,
          positioningTips: ['Position face in oval', 'Ensure good lighting', 'Look directly at camera']);
    }

    return _buildCameraView();
  }

  Widget _buildCameraView() {
    if (!_isCameraInitialized || _cameraController == null) {
      return const Center(
          child: CircularProgressIndicator(color: Colors.white));
    }

    return Stack(children: [
      // Camera preview
      SizedBox.expand(child: CameraPreview(_cameraController!)),

      // Camera overlay with face guide
      CameraOverlayWidget(
          feedbackMessage: 'Position your face in the oval',
          isOptimalPosition: true,
          onClose: () => Navigator.pop(context)),

      // Bottom controls
      Positioned(bottom: 8.h, left: 0, right: 0, child: _buildBottomControls()),

      // Instructions
      Positioned(top: 12.h, left: 6.w, right: 6.w, child: _buildInstructions()),
    ]);
  }

  Widget _buildInstructions() {
    return Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(AppTheme.mediumRadius)),
        child: Column(children: [
          Text('Position your face in the oval',
              style: AppTheme.lightTheme.textTheme.titleMedium
                  ?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center),
          SizedBox(height: 1.h),
          Text(
              '• Ensure good lighting\n• Look directly at camera\n• Remove glasses if possible',
              style: AppTheme.lightTheme.textTheme.bodyMedium
                  ?.copyWith(color: Colors.white.withValues(alpha: 0.8)),
              textAlign: TextAlign.center),
        ]));
  }

  Widget _buildBottomControls() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      // Gallery button
      IconButton(
          onPressed: _pickImageFromGallery,
          icon: Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle),
              child: CustomIconWidget(
                  iconName: 'photo_library', color: Colors.white, size: 24))),

      // Capture button
      CaptureButtonWidget(
          countdownValue: 0,
          isCountingDown: false,
          isOptimalPosition: true,
          onCapture: _capturePhoto),

      // Flash toggle (mobile only)
      if (!kIsWeb)
        IconButton(
            onPressed: _toggleFlash,
            icon: Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle),
                child: CustomIconWidget(
                    iconName: 'flash_auto', color: Colors.white, size: 24)))
      else
        SizedBox(width: 12.w), // Placeholder for web
    ]);
  }

  Future<void> _initializeCamera() async {
    try {
      if (!await _requestCameraPermission()) return;

      _cameras = await availableCameras();
      if (_cameras.isEmpty) return;

      // Select front camera for web, rear for mobile
      final camera = kIsWeb
          ? _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.front,
              orElse: () => _cameras.first)
          : _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.back,
              orElse: () => _cameras.first);

      _cameraController = CameraController(
          camera, kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high);

      await _cameraController!.initialize();

      // Apply platform-specific settings
      await _applyPlatformSettings();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
        _overlayController.forward();
      }
    } catch (e) {
      debugPrint('Camera initialization error: $e');
      if (mounted) {
        _showErrorSnackBar('Failed to initialize camera: $e');
      }
    }
  }

  Future<void> _applyPlatformSettings() async {
    if (_cameraController == null) return;

    try {
      await _cameraController!.setFocusMode(FocusMode.auto);

      if (!kIsWeb) {
        try {
          await _cameraController!.setFlashMode(FlashMode.auto);
        } catch (e) {
          debugPrint('Flash mode not supported: $e');
        }
      }
    } catch (e) {
      debugPrint('Settings error: $e');
    }
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) {
      setState(() => _isPermissionGranted = true);
      return true;
    }

    final permission = await Permission.camera.request();
    final granted = permission.isGranted;

    setState(() => _isPermissionGranted = granted);
    return granted;
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      setState(() => _isCapturing = true);

      final XFile photo = await _cameraController!.takePicture();

      setState(() {
        _capturedImage = photo;
        _isCapturing = false;
      });
    } catch (e) {
      setState(() => _isCapturing = false);
      _showErrorSnackBar('Failed to capture photo: $e');
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? photo = await _imagePicker.pickImage(
          source: ImageSource.gallery, imageQuality: 80);

      if (photo != null) {
        setState(() => _capturedImage = photo);
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick image: $e');
    }
  }

  Future<void> _switchCamera() async {
    if (_cameras.length < 2) return;

    try {
      setState(() => _isCameraInitialized = false);

      await _cameraController?.dispose();

      final currentDirection = _cameraController!.description.lensDirection;
      final newDirection = currentDirection == CameraLensDirection.back
          ? CameraLensDirection.front
          : CameraLensDirection.back;

      final newCamera =
          _cameras.firstWhere((camera) => camera.lensDirection == newDirection);

      _cameraController = CameraController(
          newCamera, kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high);

      await _cameraController!.initialize();
      await _applyPlatformSettings();

      setState(() => _isCameraInitialized = true);
    } catch (e) {
      debugPrint('Camera switch error: $e');
      _showErrorSnackBar('Failed to switch camera: $e');
    }
  }

  Future<void> _toggleFlash() async {
    if (_cameraController == null || kIsWeb) return;

    try {
      final currentMode = _cameraController!.value.flashMode;
      final newMode =
          currentMode == FlashMode.off ? FlashMode.auto : FlashMode.off;

      await _cameraController!.setFlashMode(newMode);
    } catch (e) {
      debugPrint('Flash toggle error: $e');
    }
  }

  void _retakePhoto() {
    setState(() => _capturedImage = null);
  }

  Future<void> _confirmAndAnalyze() async {
    if (_capturedImage == null) return;

    try {
      setState(() => _isAnalyzing = true);

      // Check if user can perform analysis
      final user = await _authService.getCurrentUser();
      if (user == null) {
        _showErrorSnackBar('Please sign in to analyze your skin');
        return;
      }

      final profile = await _authService.getCurrentUserProfile();
      if (profile != null && !profile.canScan) {
        _showUpgradeDialog();
        return;
      }

      // Upload image and create analysis
      final imageUrl =
          await _analysisService.uploadImage(_capturedImage!, user.id);
      final analysis =
          await _analysisService.createAnalysis(imageUrl: imageUrl);

      if (mounted) {
        // Navigate to results or dashboard
        Navigator.pushReplacementNamed(context, AppRoutes.dashboardHome);

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content:
                Text('Analysis started! Results will be available shortly.')));
      }
    } catch (e) {
      _showErrorSnackBar('Analysis failed: $e');
    } finally {
      if (mounted) {
        setState(() => _isAnalyzing = false);
      }
    }
  }

  void _cancelAnalysis() {
    setState(() {
      _isAnalyzing = false;
      _capturedImage = null;
    });
  }

  void _showUpgradeDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Upgrade to Premium',
                  style: AppTheme.lightTheme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w600)),
              content: Text(
                  'You have used all your free scans this month. Upgrade to Premium for unlimited scans and advanced analytics.',
                  style: AppTheme.lightTheme.textTheme.bodyMedium),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Maybe Later',
                        style: AppTheme.lightTheme.textTheme.labelLarge
                            ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant))),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Navigate to subscription screen
                    },
                    child: Text('Upgrade Now',
                        style: AppTheme.lightTheme.textTheme.labelLarge
                            ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600))),
              ]);
        });
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorLight,
        behavior: SnackBarBehavior.floating));
  }
}