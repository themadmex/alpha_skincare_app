import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MetricsCarousel extends StatelessWidget {
  final List<Map<String, dynamic>> metrics;

  const MetricsCarousel({
    super.key,
    required this.metrics,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: metrics.length,
        itemBuilder: (context, index) {
          final metric = metrics[index];
          return Container(
            width: 40.w,
            margin: EdgeInsets.only(right: 3.w),
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.cardColor,
              borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomIconWidget(
                      iconName: metric['icon'] as String,
                      color: _getMetricColor(metric['improvement'] as String),
                      size: 24,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: _getMetricColor(metric['improvement'] as String)
                            .withValues(alpha: 0.1),
                        borderRadius:
                            BorderRadius.circular(AppTheme.smallRadius),
                      ),
                      child: Text(
                        metric['improvement'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color:
                              _getMetricColor(metric['improvement'] as String),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  metric['name'] as String,
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 1.h),
                Text(
                  '${metric['score']}/100',
                  style: AppTheme.dataTextTheme(isLight: true)
                      .titleMedium
                      ?.copyWith(
                        color: AppTheme.lightTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 1.h),
                LinearProgressIndicator(
                  value: (metric['score'] as int) / 100,
                  backgroundColor: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getMetricColor(metric['improvement'] as String),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _getMetricColor(String improvement) {
    switch (improvement.toLowerCase()) {
      case 'improved':
        return AppTheme.successColor;
      case 'stable':
        return AppTheme.warningColor;
      case 'declined':
        return AppTheme.errorLight;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }
}
