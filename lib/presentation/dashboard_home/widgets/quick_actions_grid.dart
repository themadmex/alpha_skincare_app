import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> quickActions = [
      {
        'title': 'Routine Builder',
        'subtitle': 'Create custom routine',
        'icon': 'schedule',
        'color': AppTheme.lightTheme.primaryColor,
        'onTap': () {}, // Navigate to routine builder
      },
      {
        'title': 'Product Recommendations',
        'subtitle': 'Find perfect products',
        'icon': 'shopping_bag',
        'color': AppTheme.secondaryLight,
        'onTap': () {}, // Navigate to product recommendations
      },
      {
        'title': 'Progress Comparison',
        'subtitle': 'Track improvements',
        'icon': 'trending_up',
        'color': AppTheme.successColor,
        'onTap': () {}, // Navigate to progress comparison
      },
      {
        'title': 'Educational Content',
        'subtitle': 'Learn skincare tips',
        'icon': 'school',
        'color': AppTheme.warningColor,
        'onTap': () {}, // Navigate to educational content
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Text(
            'Quick Actions',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 2.h,
              childAspectRatio: 1.2,
            ),
            itemCount: quickActions.length,
            itemBuilder: (context, index) {
              final action = quickActions[index];
              return GestureDetector(
                onTap: action['onTap'] as VoidCallback,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.cardColor,
                    borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.shadowLight,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            color: (action['color'] as Color).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppTheme.smallRadius),
                          ),
                          child: CustomIconWidget(
                            iconName: action['icon'] as String,
                            color: action['color'] as Color,
                            size: 24,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          action['title'] as String,
                          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          action['subtitle'] as String,
                          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}