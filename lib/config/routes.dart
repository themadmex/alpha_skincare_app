// lib/config/routes.dart
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../presentation/screens/splash/splash_screen.dart';
import '../presentation/screens/onboarding/onboarding_screen.dart';
import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/auth/signup_screen.dart';
import '../presentation/screens/auth/forgot_password_screen.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/scan/scan_screen.dart';
import '../presentation/screens/scan/processing_screen.dart';
import '../presentation/screens/results/results_screen.dart';
import '../presentation/screens/recommendations/recommendations_screen.dart';
import '../presentation/screens/profile/profile_screen.dart';
import '../presentation/screens/profile/history_screen.dart';
import '../presentation/screens/settings/settings_screen.dart';
import '../presentation/providers/auth_provider.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final container = ProviderContainer();
      final authState = container.read(authStateProvider);

      // Check if user is authenticated
      final isAuthenticated = authState.when(
        data: (user) => user != null,
        loading: () => false,
        error: (_, __) => false,
      );

      // Redirect logic
      if (!isAuthenticated &&
          !state.matchedLocation.startsWith('/auth') &&
          !state.matchedLocation.startsWith('/splash') &&
          !state.matchedLocation.startsWith('/onboarding')) {
        return '/auth/login';
      }

      return null;
    },
    routes: [
      // Splash Screen
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Onboarding
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Authentication Routes
      GoRoute(
        path: '/auth',
        redirect: (context, state) {
          if (state.matchedLocation == '/auth') {
            return '/auth/login';
          }
          return null;
        },
        routes: [
          GoRoute(
            path: '/login',
            name: 'login',
            builder: (context, state) => const LoginScreen(),
          ),
          GoRoute(
            path: '/signup',
            name: 'signup',
            builder: (context, state) => const SignupScreen(),
          ),
          GoRoute(
            path: '/forgot-password',
            name: 'forgot-password',
            builder: (context, state) => const ForgotPasswordScreen(),
          ),
        ],
      ),

      // Main App Navigation
      ShellRoute(
        builder: (context, state, child) {
          return MainNavigationShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/scan',
            name: 'scan',
            builder: (context, state) => const ScanScreen(),
            routes: [
              GoRoute(
                path: '/processing',
                name: 'processing',
                builder: (context, state) {
                  final imagePath = state.extra as String?;
                  return ProcessingScreen(imagePath: imagePath);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/results/:scanId',
            name: 'results',
            builder: (context, state) {
              final scanId = state.pathParameters['scanId']!;
              return ResultsScreen(scanId: scanId);
            },
          ),
          GoRoute(
            path: '/recommendations',
            name: 'recommendations',
            builder: (context, state) => const RecommendationsScreen(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
            routes: [
              GoRoute(
                path: '/history',
                name: 'history',
                builder: (context, state) => const HistoryScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );
}