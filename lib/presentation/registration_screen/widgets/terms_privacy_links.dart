import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class TermsPrivacyLinks extends StatelessWidget {
  const TermsPrivacyLinks({super.key});

  void _openTermsOfService(BuildContext context) {
    // In a real app, this would open a web view or navigate to terms screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Terms of Service would open here',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppTheme.backgroundLight,
          ),
        ),
        backgroundColor: AppTheme.onSurfaceLight,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
        ),
      ),
    );
  }

  void _openPrivacyPolicy(BuildContext context) {
    // In a real app, this would open a web view or navigate to privacy screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Privacy Policy would open here',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppTheme.backgroundLight,
          ),
        ),
        backgroundColor: AppTheme.onSurfaceLight,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.h),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: AppTheme.neutralLight,
          ),
          children: [
            const TextSpan(text: 'By creating an account, you agree to our '),
            WidgetSpan(
              child: GestureDetector(
                onTap: () => _openTermsOfService(context),
                child: Text(
                  'Terms of Service',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primaryLight,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            const TextSpan(text: ' and '),
            WidgetSpan(
              child: GestureDetector(
                onTap: () => _openPrivacyPolicy(context),
                child: Text(
                  'Privacy Policy',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primaryLight,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}