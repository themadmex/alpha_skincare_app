// lib/core/utils/analytics_utils.dart
import 'package:flutter/foundation.dart';
import '../../config/app_config.dart';

class AnalyticsUtils {
  static void logEvent(String eventName, {Map<String, dynamic>? parameters}) {
    if (!AppConfig.enableAnalytics || kDebugMode) {
      debugPrint('Analytics Event: $eventName, Parameters: $parameters');
      return;
    }

    // Implementation for Firebase Analytics or other analytics service
    // FirebaseAnalytics.instance.logEvent(name: eventName, parameters: parameters);
  }

  static void logScreenView(String screenName) {
    logEvent('screen_view', parameters: {'screen_name': screenName});
  }

  static void logUserAction(String action, {Map<String, dynamic>? data}) {
    logEvent('user_action', parameters: {
      'action': action,
      ...?data,
    });
  }

  static void logSkinScan({
    required String scanType,
    required double duration,
    required bool success,
  }) {
    logEvent('skin_scan', parameters: {
      'scan_type': scanType,
      'duration_seconds': duration,
      'success': success,
    });
  }

  static void logProductRecommendation({
    required String productId,
    required String category,
    required int matchPercentage,
  }) {
    logEvent('product_recommendation', parameters: {
      'product_id': productId,
      'category': category,
      'match_percentage': matchPercentage,
    });
  }

  static void logProgressTracking({
    required int scansCount,
    required double averageScore,
    required List<String> improvements,
  }) {
    logEvent('progress_tracking', parameters: {
      'scans_count': scansCount,
      'average_score': averageScore,
      'improvements': improvements.join(','),
    });
  }

  static void setUserProperties({
    String? userId,
    int? age,
    String? skinType,
    List<String>? concerns,
  }) {
    if (!AppConfig.enableAnalytics || kDebugMode) {
      debugPrint('User Properties: userId=$userId, age=$age, skinType=$skinType');
      return;
    }

    // Implementation for setting user properties
    // FirebaseAnalytics.instance.setUserId(id: userId);
    // FirebaseAnalytics.instance.setUserProperty(name: 'age', value: age?.toString());
  }
}