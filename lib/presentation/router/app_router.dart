
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_routes.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/auth/sign_in_screen.dart';
import '../screens/auth/sign_up_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/onboarding/profile_setup_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/scan/camera_screen.dart';
import '../screens/scan/scan_results_screen.dart';
import '../screens/scan/scan_history_screen.dart';
import '../screens/product/recommendations_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../widgets/common/main_navigation_shell.dart';
import '../providers/auth_provider.dart';

/// Main router provider for the app
final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    refreshListenable: authState,
    redirect: (context, state) => _handleRedirect(context, state, authState),
    routes: _routes,
    errorBuilder: (context, state) => _ErrorScreen(error: state.error),
  );
});

/// Handles navigation redirects based on auth state
String? _handleRedirect(BuildContext context, GoRouterState state, AuthState authState) {
  final isAuthRoute = state.matchedLocation.startsWith('/auth');
  final isOnboardingRoute = state.matchedLocation.startsWith('/onboarding');
  final isSplashRoute = state.matchedLocation == AppRoutes.splash;

  // Allow splash screen to load
  if (isSplashRoute) return null;

  // Handle unauthenticated users
  if (!authState.isAuthenticated) {
    // If already on auth route, don't redirect
    if (isAuthRoute) return null;
    // Otherwise, redirect to sign in
    return AppRoutes.signIn;
  }

  // Handle authenticated users
  if (authState.isAuthenticated) {
    // Check if profile is complete
    if (!authState.isProfileComplete && !isOnboardingRoute) {
      return AppRoutes.profileSetup;
    }

    // If on auth or onboarding routes and profile is complete, go home
    if ((isAuthRoute || isOnboardingRoute) && authState.isProfileComplete) {
      return AppRoutes.home;
    }
  }

  return null;
}

/// App routes configuration
final List<RouteBase> _routes = [
  // Splash screen
  GoRoute(
    path: AppRoutes.splash,
    name: 'splash',
    builder: (context, state) => const SplashScreen(),
  ),

  // Auth routes
  GoRoute(
    path: AppRoutes.signIn,
    name: 'signIn',
    builder: (context, state) => const SignInScreen(),
    routes: [
      GoRoute(
        path: 'sign-up',
        name: 'signUp',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: 'forgot-password',
        name: 'forgotPassword',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
    ],
  ),

  // Onboarding routes
  GoRoute(
    path: AppRoutes.onboarding,
    name: 'onboarding',
    builder: (context, state) => const OnboardingScreen(),
    routes: [
      GoRoute(
        path: 'profile-setup',
        name: 'profileSetup',
        builder: (context, state) => const ProfileSetupScreen(),
      ),
    ],
  ),

  // Main app with bottom navigation
  ShellRoute(
    builder: (context, state, child) => MainNavigationShell(child: child),
    routes: [
      // Home tab
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: HomeScreen(),
        ),
      ),

      // Scan tab
      GoRoute(
        path: AppRoutes.scan,
        name: 'scan',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: CameraScreen(),
        ),
        routes: [
          GoRoute(
            path: 'results/:scanId',
            name: 'scanResults',
            builder: (context, state) {
              final scanId = state.pathParameters['scanId']!;
              return ScanResultsScreen(scanId: scanId);
            },
          ),
        ],
      ),

      // History tab
      GoRoute(
        path: AppRoutes.history,
        name: 'history',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: ScanHistoryScreen(),
        ),
      ),

      // Products tab
      GoRoute(
        path: AppRoutes.products,
        name: 'products',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: RecommendationsScreen(),
        ),
      ),

      // Profile tab
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: ProfileScreen(),
        ),
      ),
    ],
  ),
];

/// Error screen for navigation errors
class _ErrorScreen extends StatelessWidget {
  final Exception? error;

  const _ErrorScreen({this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF8F5F2), // Warm white
              Color(0xFFE8E2DC), // Light beige
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Error icon
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.error_outline,
                      size: 50,
                      color: Color(0xFF6C5CE7),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Error message
                  Text(
                    'Page Not Found',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'The page you\'re looking for doesn\'t exist.',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Go back button
                  ElevatedButton(
                    onPressed: () => context.go(AppRoutes.home),
                    child: const Text('GO HOME'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Extension methods for navigation
extension NavigationExtension on BuildContext {
  /// Navigate to scan results with scanId
  void goToScanResults(String scanId) {
    go('${AppRoutes.scan}/results/$scanId');
  }

  /// Navigate to a specific tab in the bottom navigation
  void goToTab(int index) {
    switch (index) {
      case 0:
        go(AppRoutes.home);
        break;
      case 1:
        go(AppRoutes.scan);
        break;
      case 2:
        go(AppRoutes.history);
        break;
      case 3:
        go(AppRoutes.products);
        break;
      case 4:
        go(AppRoutes.profile);
        break;
    }
  }
}

// Temporary route constants until we create app_routes.dart
class AppRoutes {
  static const String splash = '/';
  static const String signIn = '/auth/sign-in';
  static const String signUp = '/auth/sign-up';
  static const String forgotPassword = '/auth/forgot-password';
  static const String onboarding = '/onboarding';
  static const String profileSetup = '/onboarding/profile-setup';
  static const String home = '/home';
  static const String scan = '/scan';
  static const String history = '/history';
  static const String products = '/products';
  static const String profile = '/profile';
}

// Temporary auth state model until we create auth_provider.dart
class AuthState extends ChangeNotifier {
  bool isAuthenticated = false;
  bool isProfileComplete = false;
}

// Temporary auth provider until we create the real one
final authStateProvider = ChangeNotifierProvider<AuthState>((ref) {
  return AuthState();
});