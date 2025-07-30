import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PermissionRequestWidget extends StatelessWidget {
  final VoidCallback onRequestPermission;
  final VoidCallback onCancel;

  const PermissionRequestWidget({
    super.key,
    required this.onRequestPermission,
    required this.onCancel,
  });

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
              // Camera icon
              Container(
                width: 25.w,
                height: 25.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primaryLight.withValues(alpha: 0.1),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'camera_alt',
                    color: AppTheme.primaryLight,
                    size: 10.w,
                  ),
                ),
              ),

              SizedBox(height: 4.h),

              // Title
              Text(
                'Camera Access Required',
                style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 2.h),

              // Description
              Text(
                'Alpha Skincare needs camera access to capture your facial image for AI-powered skin analysis. Your privacy is protected with on-device processing.',
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 6.h),

              // Benefits list
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'What you\'ll get:',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    _buildBenefitItem(
                      'Personalized skin analysis with AI technology',
                      'analytics',
                    ),
                    SizedBox(height: 1.5.h),
                    _buildBenefitItem(
                      'Tailored product recommendations',
                      'recommend',
                    ),
                    SizedBox(height: 1.5.h),
                    _buildBenefitItem(
                      'Track your skin progress over time',
                      'trending_up',
                    ),
                    SizedBox(height: 1.5.h),
                    _buildBenefitItem(
                      'Complete privacy with on-device processing',
                      'security',
                    ),
                  ],
                ),
              ),

              SizedBox(height: 6.h),

              // Action buttons
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onRequestPermission,
                      child: Text('Allow Camera Access'),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: onCancel,
                      child: Text('Not Now'),
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

  Widget _buildBenefitItem(String text, String iconName) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: AppTheme.successColor,
          size: 5.w,
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Text(
            text,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
