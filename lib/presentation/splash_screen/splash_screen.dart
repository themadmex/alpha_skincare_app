import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/animated_logo_widget.dart';
import './widgets/gradient_background_widget.dart';
import './widgets/loading_indicator_widget.dart';
import './widgets/retry_dialog_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _loadingProgress = 0.0;
  String _loadingText = 'Initializing AI models...';
  bool _isLoading = true;
  bool _hasError = false;
  int _retryCount = 0;
  static const int _maxRetries = 3;

  // Mock initialization tasks
  final List<Map<String, dynamic>> _initializationTasks = [
    {
      'text': 'Initializing AI models...',
      'duration': 800,
      'progress': 0.2,
    },
    {
      'text': 'Loading TensorFlow Lite...',
      'duration': 600,
      'progress': 0.4,
    },
    {
      'text': 'Checking authentication...',
      'duration': 400,
      'progress': 0.6,
    },
    {
      'text': 'Syncing product database...',
      'duration': 500,
      'progress': 0.8,
    },
    {
      'text': 'Preparing skincare analysis...',
      'duration': 400,
      'progress': 1.0,
    },
  ];

  @override
  void initState() {
    super.initState();
    _setSystemUIOverlay();
    _startInitialization();
  }

  void _setSystemUIOverlay() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppTheme.lightTheme.colorScheme.primary,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppTheme.lightTheme.colorScheme.surface,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  Future<void> _startInitialization() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _loadingProgress = 0.0;
    });

    try {
      for (int i = 0; i < _initializationTasks.length; i++) {
        final task = _initializationTasks[i];

        setState(() {
          _loadingText = task['text'] as String;
        });

        // Simulate initialization task
        await Future.delayed(Duration(milliseconds: task['duration'] as int));

        // Simulate potential failure on third retry
        if (_retryCount >= 2 && i == 2) {
          throw Exception('Network timeout');
        }

        setState(() {
          _loadingProgress = task['progress'] as double;
        });
      }

      // Complete initialization
      await Future.delayed(const Duration(milliseconds: 500));
      _navigateToNextScreen();
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
      _showRetryDialog();
    }
  }

  void _showRetryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => RetryDialogWidget(
        title: 'Initialization Failed',
        message: _retryCount >= _maxRetries - 1
            ? 'Unable to initialize the app. Please check your internet connection and try again.'
            : 'Failed to load AI models. Would you like to retry?',
        onRetry: () {
          Navigator.of(context).pop();
          _retryCount++;
          _startInitialization();
        },
        onCancel: () {
          Navigator.of(context).pop();
          SystemNavigator.pop();
        },
      ),
    );
  }

  void _navigateToNextScreen() {
    // Simulate authentication check
    final bool isAuthenticated = _checkAuthenticationStatus();
    final bool isFirstTime = _checkFirstTimeUser();

    String nextRoute;
    if (isFirstTime) {
      nextRoute = '/onboarding-flow';
    } else if (isAuthenticated) {
      nextRoute = '/dashboard-home';
    } else {
      nextRoute = '/login-screen';
    }

    Navigator.pushReplacementNamed(context, nextRoute);
  }

  bool _checkAuthenticationStatus() {
    // Mock authentication check - in real app, check stored tokens
    return false; // Simulate unauthenticated user
  }

  bool _checkFirstTimeUser() {
    // Mock first-time user check - in real app, check SharedPreferences
    return true; // Simulate first-time user
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GradientBackgroundWidget(
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Center(
                  child: AnimatedLogoWidget(
                    onAnimationComplete: () {
                      // Logo animation completed, continue with loading
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isLoading && !_hasError) ...[
                        LoadingIndicatorWidget(
                          loadingText: _loadingText,
                          progress: _loadingProgress,
                        ),
                      ] else if (_hasError) ...[
                        Container(
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: AppTheme.errorLight.withValues(alpha: 0.1),
                            borderRadius:
                                BorderRadius.circular(AppTheme.mediumRadius),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconWidget(
                                iconName: 'error_outline',
                                color: AppTheme.errorLight,
                                size: 5.w,
                              ),
                              SizedBox(width: 3.w),
                              Flexible(
                                child: Text(
                                  'Initialization failed',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: AppTheme.errorLight,
                                        fontWeight: FontWeight.w500,
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      SizedBox(height: 4.h),
                      Text(
                        'AI-Powered Skincare Analysis',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                              letterSpacing: 1.2,
                              fontSize: 2.8.w,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Reset system UI overlay
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    super.dispose();
  }
}
