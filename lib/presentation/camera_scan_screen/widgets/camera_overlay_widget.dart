import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CameraOverlayWidget extends StatelessWidget {
  final String feedbackMessage;
  final bool isOptimalPosition;
  final VoidCallback onClose;

  const CameraOverlayWidget({
    super.key,
    required this.feedbackMessage,
    required this.isOptimalPosition,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          // Semi-transparent overlay
          Container(
            width: double.infinity,
            height: double.infinity,
            color: AppTheme.primaryLight.withValues(alpha: 0.6),
          ),

          // Face guide cutout
          Center(
            child: Container(
              width: 70.w,
              height: 35.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isOptimalPosition
                      ? AppTheme.successColor
                      : AppTheme.lightTheme.colorScheme.onPrimary,
                  width: 3,
                ),
              ),
              child: ClipOval(
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
          ),

          // Top header with close button and progress
          Positioned(
            top: 8.h,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: onClose,
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: CustomIconWidget(
                        iconName: 'close',
                        color: Colors.white,
                        size: 6.w,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Step 1 of 3',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w), // Balance the layout
                ],
              ),
            ),
          ),

          // Feedback message
          Positioned(
            top: 20.h,
            left: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.w),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  CustomIconWidget(
                    iconName: isOptimalPosition ? 'check_circle' : 'info',
                    color: isOptimalPosition
                        ? AppTheme.successColor
                        : AppTheme.warningColor,
                    size: 6.w,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    feedbackMessage,
                    textAlign: TextAlign.center,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Privacy message
          Positioned(
            bottom: 25.h,
            left: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.w),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'security',
                    color: AppTheme.successColor,
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'Your image is processed on-device only. No data is uploaded to the cloud.',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontSize: 11.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
