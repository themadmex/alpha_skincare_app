import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/onboarding_page_widget.dart';
import './widgets/page_indicator_widget.dart';
import './widgets/permission_request_widget.dart';
import './widgets/skip_button_widget.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _currentPage = 0;
  final int _totalPages = 4;

  // Mock onboarding data
  final List<Map<String, dynamic>> _onboardingData = [
    {
      "imageUrl":
          "https://images.unsplash.com/photo-1556228578-8c89e6adf883?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "title": "AI-Powered Skin Analysis",
      "description":
          "Get personalized insights about your skin health with our advanced AI technology. Simply take a photo and receive detailed analysis in seconds.",
    },
    {
      "imageUrl":
          "https://images.pexels.com/photos/3762879/pexels-photo-3762879.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
      "title": "Personalized Recommendations",
      "description":
          "Discover skincare products tailored specifically for your skin type and concerns. Our AI matches you with the perfect routine from thousands of products.",
    },
    {
      "imageUrl":
          "https://images.pixabay.com/photo/2020/02/06/20/01/university-4825366_1280.jpg",
      "title": "Track Your Progress",
      "description":
          "Monitor your skin improvement journey with before and after comparisons. See how your skin transforms over time with detailed progress tracking.",
    },
  ];

  final List<Map<String, dynamic>> _permissionData = [
    {
      "iconName": "camera_alt",
      "title": "Camera Access",
      "description": "Take photos for skin analysis",
      "benefit": "Essential for AI skin analysis",
    },
    {
      "iconName": "notifications",
      "title": "Notifications",
      "description": "Receive skincare reminders and tips",
      "benefit": "Stay consistent with your routine",
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: AppTheme.normalAnimation,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: AppTheme.normalAnimation,
        curve: Curves.easeInOut,
      );
      // Haptic feedback for iOS
      HapticFeedback.lightImpact();
    }
  }

  void _skipOnboarding() {
    Navigator.pushReplacementNamed(context, '/registration-screen');
  }

  void _getStarted() {
    Navigator.pushReplacementNamed(context, '/registration-screen');
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    // Haptic feedback for page transitions
    HapticFeedback.selectionClick();
  }

  Widget _buildOnboardingPage(int index) {
    if (index < _onboardingData.length) {
      final data = _onboardingData[index];
      return OnboardingPageWidget(
        imageUrl: data["imageUrl"] as String,
        title: data["title"] as String,
        description: data["description"] as String,
        onNext: _nextPage,
      );
    } else {
      // Permission request page
      return _buildPermissionPage();
    }
  }

  Widget _buildPermissionPage() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Permission icon
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(AppTheme.extraLargeRadius),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'security',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 10.w,
              ),
            ),
          ),

          SizedBox(height: 4.h),

          Text(
            'Enable Permissions',
            style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 2.h),

          Text(
            'To provide you with the best skincare experience, we need access to a few features on your device.',
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 4.h),

          // Permission cards
          Column(
            children: _permissionData.map((permission) {
              return PermissionRequestWidget(
                iconName: permission["iconName"] as String,
                title: permission["title"] as String,
                description: permission["description"] as String,
                benefit: permission["benefit"] as String,
              );
            }).toList(),
          ),

          SizedBox(height: 6.h),

          // Get started button
          SizedBox(
            width: double.infinity,
            height: 6.h,
            child: ElevatedButton(
              onPressed: _getStarted,
              style: AppTheme.lightTheme.elevatedButtonTheme.style?.copyWith(
                backgroundColor: WidgetStateProperty.all(
                  AppTheme.lightTheme.colorScheme.primary,
                ),
                foregroundColor: WidgetStateProperty.all(
                  AppTheme.lightTheme.colorScheme.onPrimary,
                ),
              ),
              child: Text(
                'Get Started',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                ),
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Skip text button
          TextButton(
            onPressed: _skipOnboarding,
            child: Text(
              'Skip for now',
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Stack(
          children: [
            // Main content
            Column(
              children: [
                // Page content
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: _totalPages,
                    itemBuilder: (context, index) =>
                        _buildOnboardingPage(index),
                  ),
                ),

                // Page indicator
                if (_currentPage < _totalPages - 1) ...[
                  PageIndicatorWidget(
                    currentPage: _currentPage,
                    totalPages: _totalPages -
                        1, // Exclude permission page from indicator
                  ),
                  SizedBox(height: 4.h),
                ],
              ],
            ),

            // Skip button (only show on first 3 pages)
            if (_currentPage < _totalPages - 1)
              SkipButtonWidget(
                onSkip: _skipOnboarding,
              ),
          ],
        ),
      ),
    );
  }
}
