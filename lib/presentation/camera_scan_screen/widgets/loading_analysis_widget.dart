import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LoadingAnalysisWidget extends StatefulWidget {
  final List<String> skincareTips;

  const LoadingAnalysisWidget({
    super.key,
    required this.skincareTips,
  });

  @override
  State<LoadingAnalysisWidget> createState() => _LoadingAnalysisWidgetState();
}

class _LoadingAnalysisWidgetState extends State<LoadingAnalysisWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  int _currentTipIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
    _startTipRotation();
  }

  void _startTipRotation() {
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted && _currentTipIndex < widget.skincareTips.length - 1) {
        setState(() {
          _currentTipIndex++;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppTheme.lightTheme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // AI Analysis Icon
              Container(
                width: 30.w,
                height: 30.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryLight,
                      AppTheme.secondaryLight,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryLight.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'psychology',
                    color: Colors.white,
                    size: 12.w,
                  ),
                ),
              ),

              SizedBox(height: 6.h),

              // Title
              Text(
                'Analyzing Your Skin',
                style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 2.h),

              // Subtitle
              Text(
                'Our AI is processing your image using advanced machine learning algorithms',
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 6.h),

              // Progress bar
              Container(
                width: 80.w,
                height: 8,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    return Container(
                      width: 80.w * _progressAnimation.value,
                      height: 8,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.primaryLight,
                            AppTheme.secondaryLight,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 2.h),

              // Progress percentage
              AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return Text(
                    '${(_progressAnimation.value * 100).toInt()}%',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryLight,
                    ),
                  );
                },
              ),

              SizedBox(height: 8.h),

              // Skincare tip card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'lightbulb',
                          color: AppTheme.warningColor,
                          size: 5.w,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Skincare Tip',
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.warningColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: Text(
                        widget.skincareTips[_currentTipIndex],
                        key: ValueKey(_currentTipIndex),
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          height: 1.5,
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 4.h),

              // Processing indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'security',
                    color: AppTheme.successColor,
                    size: 4.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'On-device processing • Privacy protected',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
