// lib/core/config/app_config.dart
class AppConfig {
  static const String appName = 'Alpha Skin Care App';
  static const String appVersion = '1.0.0';
  static const String buildNumber = '1';

  // API Configuration
  static const String baseUrl = 'https://api.alphaskincareapp.com';
  static const String apiVersion = 'v1';
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;

  // ML Model Configuration
  static const String modelUrl = 'https://models.alphaskincareapp.com/skin-analysis-v2.tflite';
  static const String modelPath = 'assets/models/skin_analysis_model.tflite';
  static const double confidenceThreshold = 0.7;

  // Storage Configuration
  static const String dbName = 'alphaskincareapp.db';
  static const int dbVersion = 1;
  static const String prefsKey = 'alphaskincareapp_prefs';

  // Feature Flags
  static const bool enableOfflineMode = true;
  static const bool enableCrashlytics = true;
  static const bool enableAnalytics = true;
  static const bool enablePushNotifications = true;

  // Camera Configuration
  static const int imageQuality = 85;
  static const int maxImageSize = 1024;
  static const double faceDetectionThreshold = 0.8;

  // UI Configuration
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration splashDuration = Duration(seconds: 2);
  static const int maxRecentScans = 10;

  // Validation
  static const int minAge = 13;
  static const int maxAge = 100;
  static const int maxConcerns = 5;

  // URLs
  static const String privacyPolicyUrl = 'https://alphaskincareapp.com/privacy';
  static const String termsOfServiceUrl = 'https://alphaskincareapp.com/terms';
  static const String supportUrl = 'https://alphaskincareapp.com/support';
  static const String feedbackUrl = 'https://alphaskincareapp.com/feedback';
}