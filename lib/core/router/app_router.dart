// lib/core/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/onboarding/onboarding_screen.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/signup_screen.dart';
import '../../presentation/screens/auth/forgot_password_screen.dart';
import '../../presentation/screens/profile/profile_setup_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/scan/scan_screen.dart';
import '../../presentation/screens/scan/scan_results_screen.dart';
import '../../presentation/screens/recommendations/recommendations_screen.dart';
import '../../presentation/screens/progress/progress_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/settings/settings_screen.dart';
import '../../presentation/screens/notifications/notifications_screen.dart';
import '../../presentation/screens/product/product_detail_screen.dart';
import '../../presentation/providers/auth_provider.dart';
import '../constants/app_constant.dart';
import '../constants/app_constants.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: AppConstants.routeSplash,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isAuthenticated = authState.hasValue && authState.value != null;
      final isOnAuthPages = [
        AppConstants.routeLogin,
        AppConstants.routeSignup,
        AppConstants.routeForgotPassword,
      ].contains(state.uri.toString());

      // If not authenticated and not on auth pages, redirect to login
      if (!isAuthenticated && !isOnAuthPages) {
        return AppConstants.routeLogin;
      }

      // If authenticated and on auth pages, redirect to home
      if (isAuthenticated && isOnAuthPages) {
        return AppConstants.routeHome;
      }

      return null;
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
        path: AppConstants.routeAuth,
        name: 'auth',
        redirect: (context, state) => AppConstants.routeLogin,
      ),

      GoRoute(
        path: AppConstants.routeLogin,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      GoRoute(
        path: AppConstants.routeSignup,
        name: 'signup',
        builder: (context, state) => const SignupScreen(),
      ),

      GoRoute(
        path: AppConstants.routeForgotPassword,
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      // Profile Setup
      GoRoute(
        path: AppConstants.routeProfileSetup,
        name: 'profile-setup',
        builder: (context, state) => const ProfileSetupScreen(),
      ),

      // Main App Routes
      GoRoute(
        path: AppConstants.routeHome,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),

      GoRoute(
        path: AppConstants.routeScan,
        name: 'scan',
        builder: (context, state) => const ScanScreen(),
        routes: [
          GoRoute(
            path: 'results',
            name: 'scan-results',
            builder: (context, state) => const ScanResultsScreen(),
          ),
        ],
      ),

      GoRoute(
        path: AppConstants.routeRecommendations,
        name: 'recommendations',
        builder: (context, state) => const RecommendationsScreen(),
      ),

      GoRoute(
        path: AppConstants.routeProgress,
        name: 'progress',
        builder: (context, state) => const ProgressScreen(),
      ),

      GoRoute(
        path: AppConstants.routeProfile,
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),

      GoRoute(
        path: AppConstants.routeSettings,
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),

      GoRoute(
        path: AppConstants.routeNotifications,
        name: 'notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),

      // Product Detail
      GoRoute(
        path: '/product/:id',
        name: 'product-detail',
        builder: (context, state) {
          final productId = state.pathParameters['id']!;
          return ProductDetailScreen(productId: productId);
        },
      ),
    ],

    // Error handling
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
      ),
      body: Center(
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
              '404 - Page Not Found',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'The page "${state.location}" was not found.',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppConstants.routeHome),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});