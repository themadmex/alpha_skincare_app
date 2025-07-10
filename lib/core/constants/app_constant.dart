// lib/core/constants/app_constants.dart
class AppConstants {
  // Storage Keys
  static const String keyIsFirstLaunch = 'is_first_launch';
  static const String keyUserToken = 'user_token';
  static const String keyUserId = 'user_id';
  static const String keyUserProfile = 'user_profile';
  static const String keyRecentScans = 'recent_scans';
  static const String keySettings = 'app_settings';
  static const String keyThemeMode = 'theme_mode';
  static const String keyNotificationsEnabled = 'notifications_enabled';

  // Route Names
  static const String routeSplash = '/';
  static const String routeOnboarding = '/onboarding';
  static const String routeAuth = '/auth';
  static const String routeLogin = '/auth/login';
  static const String routeSignup = '/auth/signup';
  static const String routeForgotPassword = '/auth/forgot-password';
  static const String routeProfileSetup = '/profile-setup';
  static const String routeHome = '/home';
  static const String routeScan = '/scan';
  static const String routeScanResults = '/scan/results';
  static const String routeRecommendations = '/recommendations';
  static const String routeProgress = '/progress';
  static const String routeProfile = '/profile';
  static const String routeSettings = '/settings';
  static const String routeNotifications = '/notifications';

  // API Endpoints
  static const String endpointAuth = '/auth';
  static const String endpointLogin = '/auth/login';
  static const String endpointSignup = '/auth/signup';
  static const String endpointProfile = '/profile';
  static const String endpointScan = '/scan';
  static const String endpointRecommendations = '/recommendations';
  static const String endpointProducts = '/products';
  static const String endpointAnalyze = '/analyze';

  // Error Messages
  static const String errorNetworkConnection = 'No internet connection';
  static const String errorServerError = 'Server error occurred';
  static const String errorInvalidCredentials = 'Invalid email or password';
  static const String errorUserNotFound = 'User not found';
  static const String errorEmailAlreadyExists = 'Email already exists';
  static const String errorInvalidEmail = 'Invalid email address';
  static const String errorWeakPassword = 'Password is too weak';
  static const String errorPasswordMismatch = 'Passwords do not match';
  static const String errorCameraPermission = 'Camera permission required';
  static const String errorStoragePermission = 'Storage permission required';
  static const String errorImageProcessing = 'Error processing image';
  static const String errorModelNotFound = 'Analysis model not found';

  // Success Messages
  static const String successAccountCreated = 'Account created successfully';
  static const String successPasswordReset = 'Password reset email sent';
  static const String successProfileUpdated = 'Profile updated successfully';
  static const String successScanCompleted = 'Skin analysis completed';
  static const String successDataSaved = 'Data saved successfully';

  // Validation Messages
  static const String validationEmailRequired = 'Email is required';
  static const String validationPasswordRequired = 'Password is required';
  static const String validationNameRequired = 'Name is required';
  static const String validationAgeRequired = 'Age is required';
  static const String validationInvalidAge = 'Please enter a valid age';
  static const String validationGenderRequired = 'Please select gender';
  static const String validationSkinTypeRequired = 'Please select skin type';

  // Analysis Types
  static const String analysisAcne = 'acne';
  static const String analysisWrinkles = 'wrinkles';
  static const String analysisDarkSpots = 'dark_spots';
  static const String analysisSkinTone = 'skin_tone';
  static const String analysisTexture = 'texture';
  static const String analysisHydration = 'hydration';
  static const String analysisPores = 'pores';
  static const String analysisRedness = 'redness';

  // Product Categories
  static const String categoryCleanser = 'Cleanser';
  static const String categoryMoisturizer = 'Moisturizer';
  static const String categorySerum = 'Serum';
  static const String categorySunscreen = 'Sunscreen';
  static const String categoryTreatment = 'Treatment';
  static const String categoryExfoliant = 'Exfoliant';
  static const String categoryMask = 'Mask';
  static const String categoryToner = 'Toner';

  // Skin Types
  static const String skinTypeOily = 'Oily';
  static const String skinTypeDry = 'Dry';
  static const String skinTypeCombination = 'Combination';
  static const String skinTypeNormal = 'Normal';
  static const String skinTypeSensitive = 'Sensitive';

  // Skin Concerns
  static const String concernAcne = 'Acne';
  static const String concernDarkSpots = 'Dark Spots';
  static const String concernWrinkles = 'Wrinkles';
  static const String concernDryness = 'Dryness';
  static const String concernOiliness = 'Oiliness';
  static const String concernSensitivity = 'Sensitivity';
  static const String concernPores = 'Pores';
  static const String concernDullness = 'Dullness';
  static const String concernUnevenTone = 'Uneven Tone';
  static const String concernRedness = 'Redness';

  // Notification Types
  static const String notificationReminder = 'reminder';
  static const String notificationUpdate = 'update';
  static const String notificationTip = 'tip';
  static const String notificationProgress = 'progress';

  // File Extensions
  static const List<String> imageExtensions = ['.jpg', '.jpeg', '.png'];
  static const String modelExtension = '.tflite';

  // Limits
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const int maxImageDimension = 2048;
  static const int minImageDimension = 256;
  static const int maxRecommendations = 20;
  static const int maxScanHistory = 100;
}