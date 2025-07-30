import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class LoadingButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final bool isEnabled;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;

  const LoadingButton({
    super.key,
    required this.text,
    this.isLoading = false,
    this.isEnabled = true,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 12.h,
      child: ElevatedButton(
        onPressed: (isEnabled && !isLoading) ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              backgroundColor ?? AppTheme.lightTheme.colorScheme.primary,
          foregroundColor:
              textColor ?? AppTheme.lightTheme.colorScheme.onPrimary,
          disabledBackgroundColor: AppTheme
              .lightTheme.colorScheme.onSurfaceVariant
              .withValues(alpha: 0.12),
          disabledForegroundColor: AppTheme
              .lightTheme.colorScheme.onSurfaceVariant
              .withValues(alpha: 0.38),
          elevation: isEnabled ? AppTheme.mediumElevation : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
          ),
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
        ),
        child: isLoading
            ? SizedBox(
                width: 5.w,
                height: 5.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    textColor ?? AppTheme.lightTheme.colorScheme.onPrimary,
                  ),
                ),
              )
            : Text(
                text,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: textColor ??
                          AppTheme.lightTheme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
      ),
    );
  }
}
