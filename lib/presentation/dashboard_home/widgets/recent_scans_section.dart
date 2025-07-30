import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentScansSection extends StatelessWidget {
  final List<Map<String, dynamic>> recentScans;

  const RecentScansSection({
    super.key,
    required this.recentScans,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Scans',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to full scan history
                },
                child: Text(
                  'View All',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        recentScans.isEmpty
            ? _buildEmptyState()
            : Container(
                height: 25.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  itemCount: recentScans.length,
                  itemBuilder: (context, index) {
                    final scan = recentScans[index];
                    return GestureDetector(
                      onTap: () {
                        // Navigate to detailed scan results
                      },
                      child: Container(
                        width: 45.w,
                        margin: EdgeInsets.only(right: 3.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.cardColor,
                          borderRadius:
                              BorderRadius.circular(AppTheme.mediumRadius),
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.2),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.shadowLight,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(AppTheme.mediumRadius),
                                topRight:
                                    Radius.circular(AppTheme.mediumRadius),
                              ),
                              child: CustomImageWidget(
                                imageUrl: scan['thumbnail'] as String,
                                width: double.infinity,
                                height: 12.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(3.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    scan['date'] as String,
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                    ),
                                  ),
                                  SizedBox(height: 1.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Score: ${scan['score']}',
                                        style: AppTheme.dataTextTheme(
                                                isLight: true)
                                            .titleMedium
                                            ?.copyWith(
                                              color: AppTheme
                                                  .lightTheme.primaryColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 2.w, vertical: 0.5.h),
                                        decoration: BoxDecoration(
                                          color: _getScoreColor(
                                                  scan['score'] as int)
                                              .withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(
                                              AppTheme.smallRadius),
                                        ),
                                        child: Text(
                                          _getScoreLabel(scan['score'] as int),
                                          style: AppTheme
                                              .lightTheme.textTheme.labelSmall
                                              ?.copyWith(
                                            color: _getScoreColor(
                                                scan['score'] as int),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 1.h),
                                  LinearProgressIndicator(
                                    value: (scan['score'] as int) / 100,
                                    backgroundColor: AppTheme
                                        .lightTheme.colorScheme.outline
                                        .withValues(alpha: 0.2),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      _getScoreColor(scan['score'] as int),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 25.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'camera_alt',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'No scans yet',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Start your first skin analysis to track your progress',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return AppTheme.successColor;
    if (score >= 60) return AppTheme.warningColor;
    return AppTheme.errorLight;
  }

  String _getScoreLabel(int score) {
    if (score >= 80) return 'Excellent';
    if (score >= 60) return 'Good';
    return 'Needs Work';
  }
}
