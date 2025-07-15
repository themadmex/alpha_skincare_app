class AppRoutes {
  AppRoutes._();

  // Root Routes
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String profileSetup = '/profile-setup';

  // Auth Routes
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static const String forgotPassword = '/forgot-password';

  // Main App Routes
  static const String home = '/home';
  static const String scan = '/scan';
  static const String scanHistory = '/scan-history';
  static const String scanResults = '/scan-results';
  static const String camera = '/camera';
  static const String profile = '/profile';
  static const String recommendations = '/recommendations';
  static const String productDetails = '/product-details';

  // Nested Routes (for navigation shell)
  static const String homeTab = '/home-tab';
  static const String scanTab = '/scan-tab';
  static const String historyTab = '/history-tab';
  static const String profileTab = '/profile-tab';

  // Settings Routes
  static const String settings = '/settings';
  static const String notifications = '/notifications';
  static const String privacy = '/privacy';
  static const String support = '/support';
  static const String about = '/about';
  static const String termsOfService = '/terms-of-service';
  static const String privacyPolicy = '/privacy-policy';

  // Route Parameters
  static const String scanIdParam = 'scanId';
  static const String productIdParam = 'productId';
  static const String userIdParam = 'userId';

  // Route Patterns
  static const String scanResultsPattern = '/scan-results/:$scanIdParam';
  static const String productDetailsPattern = '/product-details/:$productIdParam';

  // Route Names (for analytics and navigation)
  static const String splashName = 'splash';
  static const String onboardingName = 'onboarding';
  static const String profileSetupName = 'profile-setup';
  static const String signInName = 'sign-in';
  static const String signUpName = 'sign-up';
  static const String forgotPasswordName = 'forgot-password';
  static const String homeName = 'home';
  static const String scanName = 'scan';
  static const String scanHistoryName = 'scan-history';
  static const String scanResultsName = 'scan-results';
  static const String cameraName = 'camera';
  static const String profileName = 'profile';
  static const String recommendationsName = 'recommendations';
  static const String productDetailsName = 'product-details';
  static const String settingsName = 'settings';
  static const String notificationsName = 'notifications';
  static const String privacyName = 'privacy';
  static const String supportName = 'support';
  static const String aboutName = 'about';
  static const String termsOfServiceName = 'terms-of-service';
  static const String privacyPolicyName = 'privacy-policy';

  // Tab Routes for Bottom Navigation
  static const List<String> bottomNavRoutes = [
    homeTab,
    scanTab,
    historyTab,
    profileTab,
  ];

  // Auth Required Routes
  static const List<String> authRequiredRoutes = [
    home,
    scan,
    scanHistory,
    scanResults,
    camera,
    profile,
    recommendations,
    productDetails,
    settings,
    notifications,
    privacy,
    support,
    about,
    termsOfService,
    privacyPolicy,
  ];

  // Public Routes (no auth required)
  static const List<String> publicRoutes = [
    splash,
    onboarding,
    signIn,
    signUp,
    forgotPassword,
    profileSetup,
  ];
}