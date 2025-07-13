/// Route constants for Alpha Skincare App
/// Centralizes all route paths for easy maintenance and type safety
class AppRoutes {
  // Private constructor to prevent instantiation
  AppRoutes._();

  // Initial route
  static const String splash = '/';

  // Authentication routes
  static const String signIn = '/auth/sign-in';
  static const String signUp = '/auth/sign-up';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyEmail = '/auth/verify-email';

  // Onboarding routes
  static const String onboarding = '/onboarding';
  static const String profileSetup = '/onboarding/profile-setup';

  // Main app routes (bottom navigation)
  static const String home = '/home';
  static const String scan = '/scan';
  static const String history = '/history';
  static const String products = '/products';
  static const String profile = '/profile';

  // Scan sub-routes
  static const String scanResults = '/scan/results/:scanId';
  static const String scanDetail = '/scan/detail/:scanId';
  static const String scanCompare = '/scan/compare';

  // Product sub-routes
  static const String productDetail = '/products/:productId';
  static const String productSearch = '/products/search';
  static const String productCategories = '/products/categories';
  static const String savedProducts = '/products/saved';

  // Profile sub-routes
  static const String editProfile = '/profile/edit';
  static const String skinProfile = '/profile/skin';
  static const String settings = '/profile/settings';
  static const String notifications = '/profile/notifications';
  static const String privacy = '/profile/privacy';
  static const String help = '/profile/help';
  static const String about = '/profile/about';
  static const String premium = '/profile/premium';

  // Progress and analytics routes
  static const String progress = '/progress';
  static const String goals = '/progress/goals';
  static const String insights = '/progress/insights';

  // Educational content routes
  static const String learn = '/learn';
  static const String ingredients = '/learn/ingredients';
  static const String routines = '/learn/routines';
  static const String tips = '/learn/tips';

  // Helper methods for dynamic routes
  static String scanResultsPath(String scanId) => '/scan/results/$scanId';
  static String scanDetailPath(String scanId) => '/scan/detail/$scanId';
  static String productDetailPath(String productId) => '/products/$productId';

  // Bottom navigation indices
  static const int homeTabIndex = 0;
  static const int scanTabIndex = 1;
  static const int historyTabIndex = 2;
  static const int productsTabIndex = 3;
  static const int profileTabIndex = 4;

  // Route groups for navigation guards
  static const List<String> authRoutes = [
    signIn,
    signUp,
    forgotPassword,
    resetPassword,
    verifyEmail,
  ];

  static const List<String> onboardingRoutes = [
    onboarding,
    profileSetup,
  ];

  static const List<String> authenticatedRoutes = [
    home,
    scan,
    history,
    products,
    profile,
    progress,
    learn,
  ];

  static const List<String> premiumRoutes = [
    '/progress/advanced-analytics',
    '/scan/unlimited',
    '/products/exclusive',
  ];

  // Check if route requires authentication
  static bool requiresAuth(String route) {
    return authenticatedRoutes.any((r) => route.startsWith(r)) ||
        premiumRoutes.any((r) => route.startsWith(r));
  }

  // Check if route is premium only
  static bool isPremiumRoute(String route) {
    return premiumRoutes.any((r) => route.startsWith(r));
  }

  // Check if route is part of onboarding flow
  static bool isOnboardingRoute(String route) {
    return onboardingRoutes.any((r) => route.startsWith(r));
  }

  // Check if route is auth related
  static bool isAuthRoute(String route) {
    return authRoutes.any((r) => route.startsWith(r));
  }
}
