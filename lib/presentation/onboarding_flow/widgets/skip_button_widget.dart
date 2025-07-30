import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class SkipButtonWidget extends StatelessWidget {
  final VoidCallback onSkip;

  const SkipButtonWidget({
    super.key,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 6.h,
      right: 4.w,
      child: SafeArea(
        child: TextButton(
          onPressed: onSkip,
          style: AppTheme.lightTheme.textButtonTheme.style?.copyWith(
            padding: WidgetStateProperty.all(
              EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            ),
            backgroundColor: WidgetStateProperty.all(
              AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.9),
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.extraLargeRadius),
              ),
            ),
          ),
          child: Text(
            'Skip',
            style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
