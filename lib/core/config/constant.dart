// lib/core/config/constants.dart
class AppConstants {
  // App Information
  static const String packageName = 'com.skinsense.app';
  static const String appId = 'skinsense_mobile_app';
  static const String companyName = 'SkinSense Technologies';
  static const String supportEmail = 'support@skinsense.com';
  static const String feedbackEmail = 'feedback@skinsense.com';
  static const String contactEmail = 'contact@skinsense.com';

  // Shared Preferences Keys
  static const String keyIsFirstLaunch = 'is_first_launch';
  static const String keyUserToken = 'user_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserId = 'user_id';
  static const String keyUserEmail = 'user_email';
  static const String keyUserProfile = 'user_profile';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguage = 'selected_language';
  static const String keyNotificationsEnabled = 'notifications_enabled';
  static const String keyBiometricEnabled = 'biometric_enabled';
  static const String keyPrivacyAccepted = 'privacy_accepted';
  static const String keyTermsAccepted = 'terms_accepted';
  static const String keyOnboardingCompleted = 'onboarding_completed';
  static const String keySkinProfile = 'skin_profile';
  static const String keyLastSyncTime = 'last_sync_time';
  static const String keyAppVersion = 'app_version';
  static const String keyDeviceId = 'device_id';
  static const String keyAnalyticsEnabled = 'analytics_enabled';
  static const String keySkipTutorial = 'skip_tutorial';
  static const String keyAutoBackup = 'auto_backup';
  static const String keyOfflineMode = 'offline_mode';

  // Secure Storage Keys
  static const String secureKeyAuthToken = 'secure_auth_token';
  static const String secureKeyRefreshToken = 'secure_refresh_token';
  static const String secureKeyBiometricKey = 'secure_biometric_key';
  static const String secureKeyEncryptionKey = 'secure_encryption_key';
  static const String secureKeyApiKey = 'secure_api_key';

  // Database Tables
  static const String tableUsers = 'users';
  static const String tableScanResults = 'scan_results';
  static const String tableAnalysisHistory = 'analysis_history';
  static const String tableRecommendations = 'recommendations';
  static const String tableProducts = 'products';
  static const String tableRoutines = 'routines';
  static const String tableProgress = 'progress';
  static const String tableReminders = 'reminders';
  static const String tableSettings = 'settings';
  static const String tableFavorites = 'favorites';
  static const String tableCache = 'cache';

  // API Endpoints
  static const String endpointAuth = '/auth';
  static const String endpointLogin = '/auth/login';
  static const String endpointRegister = '/auth/register';
  static const String endpointRefreshToken = '/auth/refresh';
  static const String endpointLogout = '/auth/logout';
  static const String endpointProfile = '/user/profile';
  static const String endpointAnalyze = '/analysis/scan';
  static const String endpointRecommendations = '/recommendations';
  static const String endpointProducts = '/products';
  static const String endpointRoutines = '/routines';
  static const String endpointProgress = '/progress';
  static const String endpointReminders = '/reminders';
  static const String endpointFeedback = '/feedback';
  static const String endpointSupport = '/support';
  static const String endpointSubscription = '/subscription';
  static const String endpointUpload = '/upload';
  static const String endpointSync = '/sync';

  // File Paths
  static const String pathImages = 'images';
  static const String pathScans = 'scans';
  static const String pathThumbnails = 'thumbnails';
  static const String pathModels = 'models';
  static const String pathCache = 'cache';
  static const String pathBackups = 'backups';
  static const String pathLogs = 'logs';
  static const String pathTempFiles = 'temp';

  // Image Quality Settings
  static const int imageQualityHigh = 95;
  static const int imageQualityMedium = 85;
  static const int imageQualityLow = 70;
  static const int thumbnailQuality = 60;
  static const int thumbnailSize = 150;
  static const int previewSize = 300;
  static const int maxImageSize = 1024;

  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  static const Duration animationVerySlow = Duration(milliseconds: 800);
  static const Duration pageTransition = Duration(milliseconds: 350);
  static const Duration modalTransition = Duration(milliseconds: 400);

  // Error Messages
  static const String errorNetworkConnection = 'No internet connection. Please check your network settings.';
  static const String errorServerConnection = 'Unable to connect to server. Please try again later.';
  static const String errorInvalidCredentials = 'Invalid email or password. Please try again.';
  static const String errorSessionExpired = 'Your session has expired. Please log in again.';
  static const String errorImageProcessing = 'Error processing image. Please try again with a different image.';
  static const String errorModelLoading = 'Error loading analysis model. Please try again.';
  static const String errorCameraPermission = 'Camera permission is required to take photos.';
  static const String errorStoragePermission = 'Storage permission is required to save images.';
  static const String errorBiometricNotAvailable = 'Biometric authentication is not available on this device.';
  static const String errorBiometricNotEnrolled = 'No biometric credentials are enrolled on this device.';
  static const String errorInvalidImageFormat = 'Invalid image format. Please use JPG or PNG images.';
  static const String errorFileSizeExceeded = 'File size too large. Please use an image smaller than 10MB.';
  static const String errorInvalidEmail = 'Please enter a valid email address.';
  static const String errorWeakPassword = 'Password must be at least 8 characters long with letters and numbers.';
  static const String errorGeneric = 'Something went wrong. Please try again.';

  // Success Messages
  static const String successLogin = 'Welcome back! You have successfully logged in.';
  static const String successRegister = 'Account created successfully! Welcome to SkinSense.';
  static const String successProfileUpdate = 'Profile updated successfully.';
  static const String successImageUpload = 'Image uploaded successfully.';
  static const String successAnalysisComplete = 'Skin analysis completed successfully.';
  static const String successPasswordChange = 'Password changed successfully.';
  static const String successEmailVerification = 'Email verified successfully.';
  static const String successDataSync = 'Data synchronized successfully.';
  static const String successBackupCreated = 'Backup created successfully.';
  static const String successSettingsSaved = 'Settings saved successfully.';

  // Validation Rules
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 30;
  static const int maxEmailLength = 254;
  static const int maxNameLength = 50;
  static const int maxBioLength = 500;
  static const int maxFeedbackLength = 1000;
  static const int maxReviewLength = 500;

// Regular Expressions
  static const String regexEmail = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String regexPassword = r'^(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$';
  static const String regexPhoneNumber = r'^\+?[1-9]\d{1,14}$';
  static const String regexUsername = r'^[a-zA-Z0-9_]{3,30}$';
  static const String regexName = r'^[a-zA-Z\s]{2,50}$';
  // Date Formats
  static const String dateFormatDisplay = 'MMM dd, yyyy';
  static const String dateFormatShort = 'MM/dd/yyyy';
  static const String dateFormatLong = 'EEEE, MMMM dd, yyyy';
  static const String timeFormatDisplay = 'hh:mm a';
  static const String dateTimeFormatISO = "yyyy-MM-ddTHH:mm:ss.SSSZ";
  static const String dateTimeFormatDisplay = 'MMM dd, yyyy at hh:mm a';

  // Skin Condition Types
  static const List<String> skinConditions = [
    'acne',
    'dryness',
    'oiliness',
    'sensitivity',
    'aging',
    'pigmentation',
    'rosacea',
    'eczema',
    'blackheads',
    'whiteheads',
    'dark_spots',
    'fine_lines',
    'wrinkles',
    'pores',
    'redness',
    'irritation',
  ];

  // Skin Types
  static const List<String> skinTypes = [
    'normal',
    'oily',
    'dry',
    'combination',
    'sensitive',
  ];

  // Analysis Confidence Levels
  static const List<String> confidenceLevels = [
    'very_low',
    'low',
    'medium',
    'high',
    'very_high',
  ];

  // Severity Levels
  static const List<String> severityLevels = [
    'none',
    'mild',
    'moderate',
    'severe',
    'critical',
  ];

  // Product Categories
  static const List<String> productCategories = [
    'cleanser',
    'moisturizer',
    'serum',
    'sunscreen',
    'toner',
    'exfoliant',
    'mask',
    'treatment',
    'eye_cream',
    'spot_treatment',
  ];

  // Routine Steps
  static const List<String> routineSteps = [
    'cleanse',
    'tone',
    'treat',
    'moisturize',
    'protect',
  ];

  // Time of Day
  static const List<String> timeOfDay = [
    'morning',
    'evening',
    'both',
  ];

  // Notification Types
  static const String notificationTypeReminder = 'reminder';
  static const String notificationTypeTip = 'tip';
  static const String notificationTypeProgress = 'progress';
  static const String notificationTypePromotion = 'promotion';
  static const String notificationTypeUpdate = 'update';

  // Social Login Providers
  static const String providerGoogle = 'google';
  static const String providerApple = 'apple';
  static const String providerFacebook = 'facebook';

  // Subscription Plans
  static const String planFree = 'free';
  static const String planPremium = 'premium';
  static const String planPremiumPlus = 'premium_plus';

  // Analytics Events
  static const String eventAppOpen = 'app_open';
  static const String eventUserRegister = 'user_register';
  static const String eventUserLogin = 'user_login';
  static const String eventScanCompleted = 'scan_completed';
  static const String eventRecommendationViewed = 'recommendation_viewed';
  static const String eventProductPurchased = 'product_purchased';
  static const String eventSubscriptionUpgrade = 'subscription_upgrade';
  static const String eventFeedbackSubmitted = 'feedback_submitted';
  static const String eventTutorialCompleted = 'tutorial_completed';
  static const String eventShareContent = 'share_content';

  // Deep Link Paths
  static const String deepLinkScan = '/scan';
  static const String deepLinkProfile = '/profile';
  static const String deepLinkRecommendations = '/recommendations';
  static const String deepLinkProgress = '/progress';
  static const String deepLinkSettings = '/settings';
  static const String deepLinkSupport = '/support';

  // File Extensions
  static const List<String> supportedImageExtensions = ['jpg', 'jpeg', 'png'];
  static const List<String> supportedVideoExtensions = ['mp4', 'mov', 'avi'];
  static const List<String> supportedDocumentExtensions = ['pdf', 'doc', 'docx'];

  // Cache Keys
  static const String cacheKeyUserProfile = 'cache_user_profile';
  static const String cacheKeyRecommendations = 'cache_recommendations';
  static const String cacheKeyProducts = 'cache_products';
  static const String cacheKeyAnalysisHistory = 'cache_analysis_history';
  static const String cacheKeySettings = 'cache_settings';

  // Biometric Types
  static const String biometricTypeFingerprint = 'fingerprint';
  static const String biometricTypeFaceId = 'face_id';
  static const String biometricTypeIris = 'iris';
  static const String biometricTypeVoice = 'voice';

  // Tutorial Steps
  static const List<String> tutorialSteps = [
    'welcome',
    'camera_setup',
    'skin_analysis',
    'recommendations',
    'progress_tracking',
    'routine_building',
    'completion',
  ];
}