import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../presentation/navigation/main_navigation_shell.dart';
import '../presentation/screens/splash/splash_screen.dart';
import '../presentation/screens/onboarding/onboarding_screen.dart';
import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/auth/signup_screen.dart';
import '../presentation/screens/auth/forgot_password_screen.dart';
import '../presentation/screens/profile/profile_setup_screen.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/scan/scan_screen.dart';
import '../presentation/screens/scan/processing_screen.dart';
import '../presentation/screens/scan/scan_results_screen.dart';
import '../presentation/screens/results/results_screen.dart';
import '../presentation/screens/recommendations/recommendations_screen.dart';
import '../presentation/screens/progress/progress_screen.dart';
import '../presentation/screens/profile/profile_screen.dart';
import '../presentation/screens/settings/settings_screen.dart';
import '../presentation/providers/auth_provider.dart';
import '../presentation/screens/profile/history_screen.dart';

// Route Constants
class _Routes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/auth/login';
  static const String signup = '/auth/signup';
  static const String forgotPassword = '/auth/forgot-password';
  static const String profileSetup = '/profile-setup';
  static const String home = '/home';
  static const String scan = '/scan';
  static const String recommendations = '/recommendations';
  static const String progress = '/progress';
  static const String profile = '/profile';
  static const String settings = '/settings';
}

// Router Provider
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: _Routes.splash,
    debugLogDiagnostics: true,
    redirect: (BuildContext context, GoRouterState state) {
      return authState.when(
        loading: () => null,
        error: (error, stackTrace) {
          final currentPath = state.uri.path;
          final isOnAuthPage = currentPath.startsWith('/auth') ||
              currentPath == _Routes.login ||
              currentPath == _Routes.signup ||
              currentPath == _Routes.forgotPassword;
          final isOnSplash = currentPath == _Routes.splash;
          final isOnOnboarding = currentPath == _Routes.onboarding;

          if (!isOnAuthPage && !isOnSplash && !isOnOnboarding) {
            return _Routes.login;
          }
          return null;
        },
        data: (user) {
          final isLoggedIn = user != null;
          final currentPath = state.uri.path;

          bool isProtectedRoute(String path) {
            const protectedRoutes = [
              '/home',
              '/scan',
              '/recommendations',
              '/progress',
              '/profile',
              '/settings',
            ];
            return protectedRoutes.any((route) => path.startsWith(route)) ||
                path.startsWith('/home/') ||
                path.startsWith('/scan/') ||
                path.startsWith('/recommendations/') ||
                path.startsWith('/settings/') ||
                path.startsWith('/results/');
          }

          bool isAuthPage(String path) {
            return path.startsWith('/auth') ||
                path == _Routes.login ||
                path == _Routes.signup ||
                path == _Routes.forgotPassword;
          }

          if (!isLoggedIn) {
            if (isProtectedRoute(currentPath)) {
              return _Routes.login;
            }
          } else {
            if (isAuthPage(currentPath)) {
              return _Routes.home;
            }
            if (currentPath == _Routes.splash) {
              return _Routes.home;
            }
          }
          return null;
        },
      );
    },
    routes: [
      GoRoute(
        path: _Routes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: _Routes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/auth',
        name: 'auth',
        redirect: (context, state) => _Routes.login,
      ),
      GoRoute(
        path: _Routes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
        routes: [
          GoRoute(
            path: 'signup',
            name: 'signup',
            builder: (context, state) => const SignupScreen(),
          ),
          GoRoute(
            path: 'forgot-password',
            name: 'forgotPassword',
            builder: (context, state) => const ForgotPasswordScreen(),
          ),
        ],
      ),
      GoRoute(
        path: _Routes.signup,
        name: 'signupDirect',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: _Routes.forgotPassword,
        name: 'forgotPasswordDirect',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: _Routes.profileSetup,
        name: 'profileSetup',
        builder: (context, state) => const ProfileSetupScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return MainNavigationShell(child: child);
        },
        routes: [
          GoRoute(
            path: _Routes.home,
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: _Routes.scan,
            name: 'scan',
            builder: (context, state) => const ScanScreen(),
            routes: [
              GoRoute(
                path: 'processing',
                name: 'processing',
                builder: (context, state) {
                  final imagePath = state.extra is String ? state.extra as String? : null;
                  return ProcessingScreen(imagePath: imagePath);
                },
              ),
              GoRoute(
                path: 'results',
                name: 'scanResults',
                builder: (context, state) => const ScanResultsScreen(),
              ),
              GoRoute(
                path: 'result/:scanId',
                name: 'scanResult',
                builder: (context, state) {
                  final scanId = state.pathParameters['scanId']!;
                  return ScanResultDetailScreen(scanId: scanId);
                },
              ),
            ],
          ),
          GoRoute(
            path: _Routes.recommendations,
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
          GoRoute(
            path: _Routes.progress,
            name: 'progress',
            builder: (context, state) => const ProgressScreen(),
          ),
          GoRoute(
            path: _Routes.profile,
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
            routes: [
              GoRoute(
                path: 'history',
                name: 'history',
                builder: (context, state) => const HistoryScreen(),
              ),
            ],
          ),
          GoRoute(
            path: _Routes.settings,
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => AppErrorScreen(
      error: state.error,
      location: state.uri.path,
    ),
  );
});

// Placeholder ProductDetailsScreen
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
          ],
        ),
      ),
    );
  }
}

// Placeholder ScanResultDetailScreen
class ScanResultDetailScreen extends StatelessWidget {
  final String scanId;

  const ScanResultDetailScreen({super.key, required this.scanId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Result Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.analytics, size: 64, color: Colors.blue),
            const SizedBox(height: 16),
            Text('Scan ID: $scanId'),
            const SizedBox(height: 8),
            const Text('Detailed scan results coming soon!'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(_Routes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
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
        title: const Text('Error'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Navigation Error',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Could not navigate to: $location'),
            if (error != null) ...[
              const SizedBox(height: 8),
              Text(
                'Error: ${error.toString()}',
                style: const TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(_Routes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}