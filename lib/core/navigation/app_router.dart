// lib/core/navigation/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/signup_screen.dart';
import '../../presentation/screens/auth/forgot_password_screen.dart';
import '../../presentation/screens/onboarding/onboarding_screen.dart';
import '../../presentation/screens/profile/profile_setup_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/scan/scan_screen.dart';
import '../../presentation/screens/scan/scan_results_screen.dart';
import '../../presentation/screens/recommendations/recommendations_screen.dart';
import '../../presentation/screens/progress/progress_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/settings/settings_screen.dart';
import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/providers/auth_provider.dart';
import '../constants/app_constant.dart';
import '../constants/app_constants.dart';

// App Router Provider
final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: AppConstants.routeSplash,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      return authState.when(
        loading: () => null, // Stay on current route while loading
        error: (error, stackTrace) {
          // On auth error, redirect to login unless already on auth pages
          final isOnAuthPage = _isAuthPage(state.uri.toString());
          final isOnSplash = state.uri.toString() == AppConstants.routeSplash;
          final isOnOnboarding = state.uri.toString() == AppConstants.routeOnboarding;

          if (!isOnAuthPage && !isOnSplash && !isOnOnboarding) {
            return AppConstants.routeLogin;
          }
          return null;
        },
        data: (user) {
          final isLoggedIn = user != null;
          final currentLocation = state.uri.toString();

          // Authentication-based redirects
          if (!isLoggedIn) {
            // User not logged in
            if (_isProtectedRoute(currentLocation)) {
              return AppConstants.routeLogin;
            }
          } else {
            // User is logged in
            if (_isAuthPage(currentLocation)) {
              return AppConstants.routeHome;
            }

            // Redirect from splash to home if already logged in
            if (currentLocation == AppConstants.routeSplash) {
              return AppConstants.routeHome;
            }
          }

          return null; // No redirect needed
        },
      );
    },
    routes: [
      // Splash Screen
      GoRoute(
        path: AppConstants.routeSplash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Onboarding
      GoRoute(
        path: AppConstants.routeOnboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Authentication Routes
      GoRoute(
        path: '/auth',
        name: 'auth',
        redirect: (context, state) => AppConstants.routeLogin,
      ),
      GoRoute(
        path: AppConstants.routeLogin,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
        routes: [
          // Nested auth routes
          GoRoute(
            path: 'signup',
            name: 'signup',
            builder: (context, state) => const SignUpScreen(),
          ),
          GoRoute(
            path: 'forgot-password',
            name: 'forgotPassword',
            builder: (context, state) => const ForgotPasswordScreen(),
          ),
        ],
      ),
      GoRoute(
        path: AppConstants.routeSignup,
        name: 'signupDirect',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: AppConstants.routeForgotPassword,
        name: 'forgotPasswordDirect',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      // Profile Setup (Semi-protected - requires auth but not profile)
      GoRoute(
        path: AppConstants.routeProfileSetup,
        name: 'profileSetup',
        builder: (context, state) => const ProfileSetupScreen(),
      ),

      // Main App Routes (Protected)
      ShellRoute(
        builder: (context, state, child) {
          // You can add a shell here for bottom navigation or drawer
          return child;
        },
        routes: [
          GoRoute(
            path: AppConstants.routeHome,
            name: 'home',
            builder: (context, state) => const HomeScreen(),
            routes: [
              // Nested routes under home
              GoRoute(
                path: 'scan',
                name: 'scanFromHome',
                builder: (context, state) => const ScanScreen(),
                routes: [
                  GoRoute(
                    path: 'results',
                    name: 'scanResultsFromHome',
                    builder: (context, state) => const ScanResultsScreen(),
                  ),
                ],
              ),
            ],
          ),

          // Scan Routes
          GoRoute(
            path: AppConstants.routeScan,
            name: 'scan',
            builder: (context, state) => const ScanScreen(),
            routes: [
              GoRoute(
                path: 'results',
                name: 'scanResults',
                builder: (context, state) => const ScanResultsScreen(),
              ),
            ],
          ),

          // Recommendations
          GoRoute(
            path: AppConstants.routeRecommendations,
            name: 'recommendations',
            builder: (context, state) => const RecommendationsScreen(),
            routes: [
              GoRoute(
                path: 'product/:productId',
                name: 'productDetails',
                builder: (context, state) {
                  final productId = state.pathParameters['productId']!;
                  return ProductDetailsScreen(productId: productId);
                },
              ),
            ],
          ),

          // Progress Tracking
          GoRoute(
            path: AppConstants.routeProgress,
            name: 'progress',
            builder: (context, state) => const ProgressScreen(),
          ),

          // Profile Management
          GoRoute(
            path: AppConstants.routeProfile,
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),

          // Settings
          GoRoute(
            path: AppConstants.routeSettings,
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
            routes: [
              GoRoute(
                path: 'notifications',
                name: 'notificationSettings',
                builder: (context, state) => const NotificationSettingsScreen(),
              ),
              GoRoute(
                path: 'privacy',
                name: 'privacySettings',
                builder: (context, state) => const PrivacySettingsScreen(),
              ),
              GoRoute(
                path: 'theme',
                name: 'themeSettings',
                builder: (context, state) => const ThemeSettingsScreen(),
              ),
            ],
          ),

          // Notifications
          GoRoute(
            path: AppConstants.routeNotifications,
            name: 'notifications',
            builder: (context, state) => const NotificationsScreen(),
          ),
        ],
      ),
    ],

    // Error handling
    errorBuilder: (context, state) => AppErrorScreen(
      error: state.error,
      location: state.location,
    ),

    // Route information logging (only in debug mode)
    observers: [
      AppRouterObserver(),
    ],
  );
});

// Helper functions for route checking
bool _isAuthPage(String location) {
  return location.startsWith('/auth') ||
      location == AppConstants.routeLogin ||
      location == AppConstants.routeSignup ||
      location == AppConstants.routeForgotPassword;
}

bool _isProtectedRoute(String location) {
  const protectedRoutes = [
    AppConstants.routeHome,
    AppConstants.routeScan,
    AppConstants.routeScanResults,
    AppConstants.routeRecommendations,
    AppConstants.routeProgress,
    AppConstants.routeProfile,
    AppConstants.routeSettings,
    AppConstants.routeNotifications,
  ];

  return protectedRoutes.any((route) => location.startsWith(route)) ||
      location.startsWith('/home/') ||
      location.startsWith('/scan/') ||
      location.startsWith('/recommendations/') ||
      location.startsWith('/settings/');
}

// Custom Error Screen
class AppErrorScreen extends StatelessWidget {
  final Exception? error;
  final String location;

  const AppErrorScreen({
    super.key,
    this.error,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              const Text(
                'Oops! Page not found',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'The page "$location" could not be found.',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              if (error != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Error: ${error.toString()}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => context.go(AppConstants.routeHome),
                icon: const Icon(Icons.home),
                label: const Text('Go Home'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Router Observer for debugging and analytics
class AppRouterObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _logNavigation('PUSH', route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _logNavigation('POP', route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _logNavigation('REPLACE', newRoute, oldRoute);
  }

  void _logNavigation(String action, Route<dynamic>? route, Route<dynamic>? previousRoute) {
    if (route != null) {
      debugPrint('🚀 Router $action: ${route.settings.name ?? 'Unknown'}');
      if (previousRoute != null) {
        debugPrint('   From: ${previousRoute.settings.name ?? 'Unknown'}');
      }
    }
  }
}

// Navigation Extensions for easier routing
extension AppRouterExtension on BuildContext {
  /// Navigate to home screen
  void goHome() => go(AppConstants.routeHome);

  /// Navigate to login screen
  void goLogin() => go(AppConstants.routeLogin);

  /// Navigate to scan screen
  void goScan() => go(AppConstants.routeScan);

  /// Navigate to scan results
  void goScanResults() => go(AppConstants.routeScanResults);

  /// Navigate to recommendations
  void goRecommendations() => go(AppConstants.routeRecommendations);

  /// Navigate to progress screen
  void goProgress() => go(AppConstants.routeProgress);

  /// Navigate to profile screen
  void goProfile() => go(AppConstants.routeProfile);

  /// Navigate to settings screen
  void goSettings() => go(AppConstants.routeSettings);

  /// Navigate to product details
  void goProductDetails(String productId) =>
      go('${AppConstants.routeRecommendations}/product/$productId');

  /// Check if current route is protected
  bool get isOnProtectedRoute => _isProtectedRoute(GoRouter.of(this).location);

  /// Check if current route is auth page
  bool get isOnAuthPage => _isAuthPage(GoRouter.of(this).location);
}

// Placeholder screens for routes that aren't implemented yet
class ProductDetailsScreen extends StatelessWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_bag, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text('Product ID: $productId'),
            const SizedBox(height: 8),
            const Text('Product details coming soon!'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Settings')),
      body: const Center(
        child: Text('Notification settings coming soon!'),
      ),
    );
  }
}

class PrivacySettingsScreen extends StatelessWidget {
  const PrivacySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Settings')),
      body: const Center(
        child: Text('Privacy settings coming soon!'),
      ),
    );
  }
}

class ThemeSettingsScreen extends StatelessWidget {
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Theme Settings')),
      body: const Center(
        child: Text('Theme settings coming soon!'),
      ),
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: const Center(
        child: Text('Notifications screen coming soon!'),
      ),
    );
  }
}