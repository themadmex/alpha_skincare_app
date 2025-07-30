import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SubscriptionStatusCard extends StatelessWidget {
  final bool isPremium;
  final int scansRemaining;
  final int totalScans;

  const SubscriptionStatusCard({
    super.key,
    required this.isPremium,
    required this.scansRemaining,
    required this.totalScans,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: isPremium
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.successColor,
                  AppTheme.successColor.withValues(alpha: 0.8),
                ],
              )
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.1),
                  AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.05),
                ],
              ),
        borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
        border: isPremium
            ? null
            : Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
              ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: isPremium
                  ? Colors.white.withValues(alpha: 0.2)
                  : AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppTheme.smallRadius),
            ),
            child: CustomIconWidget(
              iconName: isPremium ? 'star' : 'lock',
              color:
                  isPremium ? Colors.white : AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isPremium ? 'Premium Active' : 'Free Plan',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: isPremium
                        ? Colors.white
                        : AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  isPremium
                      ? 'Unlimited scans & advanced analytics'
                      : '$scansRemaining of $totalScans scans remaining this month',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: isPremium
                        ? Colors.white.withValues(alpha: 0.8)
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (!isPremium) ...[
                  SizedBox(height: 1.h),
                  LinearProgressIndicator(
                    value: scansRemaining / totalScans,
                    backgroundColor: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      scansRemaining > 2
                          ? AppTheme.successColor
                          : scansRemaining > 0
                              ? AppTheme.warningColor
                              : AppTheme.errorLight,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (!isPremium)
            TextButton(
              onPressed: () {
                // Navigate to subscription upgrade
              },
              style: TextButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.smallRadius),
                ),
              ),
              child: Text(
                'Upgrade',
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
