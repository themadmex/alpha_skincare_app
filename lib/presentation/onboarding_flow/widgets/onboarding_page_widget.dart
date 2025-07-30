import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OnboardingPageWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final bool isLastPage;
  final VoidCallback? onNext;
  final VoidCallback? onGetStarted;

  const OnboardingPageWidget({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    this.isLastPage = false,
    this.onNext,
    this.onGetStarted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Hero illustration
          Container(
            width: 80.w,
            height: 35.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.largeRadius),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow
                      .withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.largeRadius),
              child: CustomImageWidget(
                imageUrl: imageUrl,
                width: 80.w,
                height: 35.h,
                fit: BoxFit.cover,
              ),
            ),
          ),

          SizedBox(height: 6.h),

          // Title
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 2.h),

          // Description
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              description,
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(height: 8.h),

          // Action button
          SizedBox(
            width: double.infinity,
            height: 6.h,
            child: ElevatedButton(
              onPressed: isLastPage ? onGetStarted : onNext,
              style: AppTheme.lightTheme.elevatedButtonTheme.style?.copyWith(
                backgroundColor: WidgetStateProperty.all(
                  AppTheme.lightTheme.colorScheme.primary,
                ),
                foregroundColor: WidgetStateProperty.all(
                  AppTheme.lightTheme.colorScheme.onPrimary,
                ),
              ),
              child: Text(
                isLastPage ? 'Get Started' : 'Next',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
