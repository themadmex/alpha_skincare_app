import 'package:flutter/material.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/registration_screen/registration_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/dashboard_home/dashboard_home.dart';
import '../presentation/camera_scan_screen/camera_scan_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String onboardingFlow = '/onboarding-flow';
  static const String splashScreen = '/splash-screen';
  static const String registrationScreen = '/registration-screen';
  static const String loginScreen = '/login-screen';
  static const String dashboardHome = '/dashboard-home';
  static const String cameraScanScreen = '/camera-scan-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => SplashScreen(),
    onboardingFlow: (context) => OnboardingFlow(),
    splashScreen: (context) => SplashScreen(),
    registrationScreen: (context) => RegistrationScreen(),
    loginScreen: (context) => LoginScreen(),
    dashboardHome: (context) => DashboardHome(),
    cameraScanScreen: (context) => CameraScanScreen(),
    // TODO: Add your other routes here
  };
}
