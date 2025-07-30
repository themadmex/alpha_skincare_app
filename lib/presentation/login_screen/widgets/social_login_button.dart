import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SocialLoginButton extends StatelessWidget {
  final String iconName;
  final String label;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;

  const SocialLoginButton({
    super.key,
    required this.iconName,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 12.h,
      margin: EdgeInsets.symmetric(vertical: 1.h),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor ?? Colors.transparent,
          foregroundColor:
              textColor ?? AppTheme.lightTheme.colorScheme.onSurface,
          side: BorderSide(
            color: AppTheme.lightTheme.colorScheme.outline,
            width: 1.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
          ),
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: textColor ?? AppTheme.lightTheme.colorScheme.onSurface,
              size: 5.w,
            ),
            SizedBox(width: 3.w),
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color:
                        textColor ?? AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
