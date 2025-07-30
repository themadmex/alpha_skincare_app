import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BiometricPromptDialog extends StatelessWidget {
  final String biometricType;
  final VoidCallback onAuthenticate;
  final VoidCallback onCancel;

  const BiometricPromptDialog({
    super.key,
    required this.biometricType,
    required this.onAuthenticate,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.largeRadius),
      ),
      child: Container(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: biometricType == 'face' ? 'face' : 'fingerprint',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 10.w,
                ),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              biometricType == 'face'
                  ? 'Face ID Authentication'
                  : 'Fingerprint Authentication',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              biometricType == 'face'
                  ? 'Look at your device to authenticate with Face ID'
                  : 'Place your finger on the sensor to authenticate',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      onCancel();
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      onAuthenticate();
                      Navigator.of(context).pop();
                    },
                    child: Text('Authenticate'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
