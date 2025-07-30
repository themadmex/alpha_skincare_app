import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';

class SocialSignupButton extends StatelessWidget {
  final String iconName;
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;

  const SocialSignupButton({
    super.key,
    required this.iconName,
    required this.text,
    required this.onPressed,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 12.h,
      margin: EdgeInsets.symmetric(vertical: 1.h),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 1,
          shadowColor: AppTheme.shadowLight,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
            side: BorderSide(
              color: AppTheme.borderLight,
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: textColor,
              size: 5.w,
            ),
            SizedBox(width: 3.w),
            Flexible(
              child: Text(
                text,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}