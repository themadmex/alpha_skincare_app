// lib/core/config/app_config.dart
class AppConfig {
  // App Information
  static const String appName = 'SkinSense';
  static const String appVersion = '1.0.0';
  static const String buildNumber = '1';
  static const String appDescription = 'AI-Powered Skin Analysis & Personalized Skincare';

  // Environment Configuration
  static const String environment = String.fromEnvironment('ENV', defaultValue: 'development');
  static bool get isDevelopment => environment == 'development';
  static bool get isProduction => environment == 'production';
  static bool get isStaging => environment == 'staging';

  // API Configuration
  static String get baseUrl {
    switch (environment) {
      case 'production':
        return 'https://api.skinsense.com';
      case 'staging':
        return 'https://staging-api.skinsense.com';
      default:
        return 'https://dev-api.skinsense.com';
    }
  }

  static const String apiVersion = 'v1';
  static String get fullApiUrl => '$baseUrl/api/$apiVersion';
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
  static const int sendTimeout = 30000;
  static const String apiKey = String.fromEnvironment('API_KEY', defaultValue: 'dev_api_key');

  // ML Model Configuration
  static String get modelUrl {
    switch (environment) {
      case 'production':
        return 'https://models.skinsense.com/skin-analysis-v2.tflite';
      case 'staging':
        return 'https://staging-models.skinsense.com/skin-analysis-v2.tflite';
      default:
        return 'https://dev-models.skinsense.com/skin-analysis-v2.tflite';
    }
  }

  static const String modelPath = 'assets/models/skin_analysis_model.tflite';
  static const String fallbackModelPath = 'assets/models/skin_analysis_fallback.tflite';
  static const double confidenceThreshold = 0.7;
  static const double minConfidenceThreshold = 0.5;
  static const int modelInputSize = 224;
  static const List<String> supportedImageFormats = ['jpg', 'jpeg', 'png'];

  // Storage Configuration
  static const String dbName = 'skinsense.db';
  static const int dbVersion = 1;
  static const String prefsKey = 'skinsense_prefs';
  static const String secureStorageKey = 'skinsense_secure';
  static const int maxCacheSize = 100 * 1024 * 1024; // 100MB
  static const Duration cacheExpiration = Duration(days: 7);

  // Feature Flags
  static const bool enableOfflineMode = true;
  static bool enableCrashlytics = !isDevelopment;
  static bool enableAnalytics = !isDevelopment;
  static const bool enablePushNotifications = true;
  static const bool enableBiometricAuth = true;
  static const bool enableCloudSync = true;
  static const bool enableDarkMode = true;
  static const bool enableAdvancedAnalysis = true;
  static const bool enableProductRecommendations = true;
  static const bool enableProgressTracking = true;

  // Camera Configuration
  static const int imageQuality = 85;
  static const int maxImageSize = 1024;
  static const int minImageSize = 256;
  static const double faceDetectionThreshold = 0.8;
  static const Duration cameraTimeout = Duration(seconds: 30);
  static const int maxRetakeAttempts = 3;

  // UI Configuration
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration debounceDelay = Duration(milliseconds: 300);
  static const int maxRecentScans = 10;
  static const int itemsPerPage = 20;
  static const double borderRadius = 12.0;
  static const double cardElevation = 4.0;

  // Validation Rules
  static const int minAge = 13;
  static const int maxAge = 100;
  static const int maxConcerns = 5;
  static const int minPasswordLength = 8;
  static const int maxNameLength = 50;
  static const int maxBioLength = 500;
  static const Duration passwordResetTimeout = Duration(minutes: 15);

  // File & Upload Limits
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const int maxImageDimension = 2048;
  static const int minImageDimension = 256;
  static const int maxRecommendations = 20;
  static const int maxScanHistory = 100;
  static const int maxUploadRetries = 3;

  // URLs
  static const String privacyPolicyUrl = 'https://skinsense.com/privacy';
  static const String termsOfServiceUrl = 'https://skinsense.com/terms';
  static const String supportUrl = 'https://skinsense.com/support';
  static const String feedbackUrl = 'https://skinsense.com/feedback';
  static const String helpCenterUrl = 'https://help.skinsense.com';
  static const String appStoreUrl = 'https://apps.apple.com/app/skinsense';
  static const String playStoreUrl = 'https://play.google.com/store/apps/details?id=com.skinsense.app';

  // Social Media URLs
  static const String websiteUrl = 'https://skinsense.com';
  static const String facebookUrl = 'https://facebook.com/skinsense';
  static const String instagramUrl = 'https://instagram.com/skinsense';
  static const String twitterUrl = 'https://twitter.com/skinsense';
  static const String youtubeUrl = 'https://youtube.com/skinsense';

  // Notification Configuration
  static const String notificationChannelId = 'skinsense_notifications';
  static const String notificationChannelName = 'SkinSense Notifications';
  static const String notificationChannelDescription = 'Notifications from SkinSense app';
  static const Duration reminderInterval = Duration(hours: 24);
  static const Duration tipInterval = Duration(days: 3);

  // Analytics Configuration
  static const String analyticsPropertyId = String.fromEnvironment('ANALYTICS_ID', defaultValue: 'dev_analytics');
  static bool enablePerformanceMonitoring = !isDevelopment;
  static const Duration sessionTimeout = Duration(minutes: 30);

  // Security Configuration
  static const Duration tokenRefreshThreshold = Duration(minutes: 15);
  static const int maxLoginAttempts = 5;
  static const Duration lockoutDuration = Duration(minutes: 15);
  static const bool enableBiometrics = true;
  static const Duration biometricTimeout = Duration(seconds: 30);

  // Subscription & Premium Features
  static const bool enablePremiumFeatures = true;
  static const int freeScanLimit = 5;
  static const Duration premiumTrialPeriod = Duration(days: 7);

  // Development & Debug Configuration
  static const bool enableDebugMode = bool.fromEnvironment('DEBUG', defaultValue: false);
  static const bool enableLogging = true;
  static bool enableNetworkLogging = isDevelopment;
  static const bool showPerformanceOverlay = bool.fromEnvironment('PERFORMANCE_OVERLAY', defaultValue: false);

  // Regional Configuration
  static const List<String> supportedLanguages = ['en', 'es', 'fr', 'de', 'it', 'pt', 'ja', 'ko', 'zh'];
  static const String defaultLanguage = 'en';
  static const String defaultCountry = 'US';
  static const String defaultCurrency = 'USD';

  // Rate Limiting
  static const int maxApiRequestsPerMinute = 60;
  static const int maxScanRequestsPerHour = 10;
  static const Duration rateLimitWindow = Duration(minutes: 1);

  // Backup & Sync Configuration
  static const Duration autoBackupInterval = Duration(days: 1);
  static const int maxBackupRetries = 3;
  static const Duration syncTimeout = Duration(seconds: 30);

  // Content Configuration
  static const int maxReviewLength = 500;
  static const int maxFeedbackLength = 1000;
  static const Duration contentCacheExpiry = Duration(hours: 6);

  // Helper Methods
  static Map<String, dynamic> get configInfo => {
    'appName': appName,
    'appVersion': appVersion,
    'buildNumber': buildNumber,
    'environment': environment,
    'apiUrl': fullApiUrl,
    'isDevelopment': isDevelopment,
    'isProduction': isProduction,
    'enabledFeatures': {
      'offlineMode': enableOfflineMode,
      'crashlytics': enableCrashlytics,
      'analytics': enableAnalytics,
      'pushNotifications': enablePushNotifications,
      'biometricAuth': enableBiometricAuth,
      'cloudSync': enableCloudSync,
      'premiumFeatures': enablePremiumFeatures,
    }
  };

  static bool isFeatureEnabled(String feature) {
    switch (feature) {
      case 'offline_mode':
        return enableOfflineMode;
      case 'crashlytics':
        return enableCrashlytics;
      case 'analytics':
        return enableAnalytics;
      case 'push_notifications':
        return enablePushNotifications;
      case 'biometric_auth':
        return enableBiometricAuth;
      case 'cloud_sync':
        return enableCloudSync;
      case 'premium_features':
        return enablePremiumFeatures;
      case 'advanced_analysis':
        return enableAdvancedAnalysis;
      default:
        return false;
    }
  }
}