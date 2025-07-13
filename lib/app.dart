
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'presentation/router/app_router.dart';
import 'core/theme/app_theme.dart';

/// Main app widget for Alpha Skincare
/// Configures theme, routing, and global app settings
class AlphaSkincareApp extends ConsumerWidget {
  const AlphaSkincareApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the router provider for navigation state changes
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      // App identification
      title: 'Alpha Skincare',
      debugShowCheckedModeBanner: false,

      // Theme configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.lightTheme, // Using light theme only for consistent branding
      themeMode: ThemeMode.light,

      // Router configuration
      routerConfig: router,

      // Builder for global app configuration
      builder: (context, child) {
        // Ensure text scaling doesn't break layouts
        final mediaQuery = MediaQuery.of(context);
        final constrainedTextScaleFactor = mediaQuery.textScaleFactor.clamp(0.8, 1.2);

        return MediaQuery(
          data: mediaQuery.copyWith(
            textScaleFactor: constrainedTextScaleFactor,
          ),
          child: child!,
        );
      },
    );
  }
}

/// Temporary app theme class until we create the full theme file
/// This provides the elegant aesthetic inspired by the beauty salon design
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // Brand colors inspired by the beauty salon design
  static const Color primaryPurple = Color(0xFF6C5CE7);
  static const Color secondaryGreen = Color(0xFF00B894);
  static const Color warmWhite = Color(0xFFF8F5F2);
  static const Color lightBeige = Color(0xFFE8E2DC);
  static const Color darkGray = Color(0xFF2D2D2D);
  static const Color mediumGray = Color(0xFF666666);
  static const Color lightGray = Color(0xFF999999);

  // Light theme configuration
  static ThemeData get lightTheme {
    return ThemeData(
      // Use Material 3 design
      useMaterial3: true,

      // Color scheme
      colorScheme: ColorScheme.light(
        primary: primaryPurple,
        secondary: secondaryGreen,
        surface: warmWhite,
        background: warmWhite,
        error: const Color(0xFFE74C3C),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: darkGray,
        onBackground: darkGray,
      ),

      // Scaffold background
      scaffoldBackgroundColor: warmWhite,

      // App bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: warmWhite,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: darkGray),
        titleTextStyle: GoogleFonts.poppins(
          color: darkGray,
          fontSize: 18,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),

      // Text theme with elegant typography
      textTheme: TextTheme(
        // Display styles for headers
        displayLarge: GoogleFonts.poppins(
          fontSize: 48,
          fontWeight: FontWeight.w300,
          letterSpacing: 1.5,
          color: darkGray,
        ),
        displayMedium: GoogleFonts.poppins(
          fontSize: 36,
          fontWeight: FontWeight.w300,
          letterSpacing: 1.2,
          color: darkGray,
        ),
        displaySmall: GoogleFonts.poppins(
          fontSize: 28,
          fontWeight: FontWeight.w400,
          letterSpacing: 1.0,
          color: darkGray,
        ),

        // Headline styles
        headlineLarge: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: darkGray,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: darkGray,
        ),
        headlineSmall: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: darkGray,
        ),

        // Body text styles
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: mediumGray,
          height: 1.6,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: mediumGray,
          height: 1.5,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: lightGray,
          height: 1.4,
        ),

        // Label styles
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
          color: darkGray,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.0,
          color: darkGray,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
          color: mediumGray,
        ),
      ),

      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPurple,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
      ),

      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryPurple,
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkGray,
          side: const BorderSide(color: lightBeige, width: 1),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: lightBeige),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: lightBeige),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: primaryPurple, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.red.shade300),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.red.shade300, width: 2),
        ),
        labelStyle: GoogleFonts.inter(
          color: mediumGray,
          fontSize: 14,
        ),
        hintStyle: GoogleFonts.inter(
          color: lightGray,
          fontSize: 14,
        ),
      ),

      // Card theme
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.all(8),
      ),

      // Bottom navigation bar theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryPurple,
        unselectedItemColor: lightGray,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),

      // Divider theme
      dividerTheme: const DividerThemeData(
        color: lightBeige,
        thickness: 1,
        space: 1,
      ),

      // Page transitions
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  // Custom decoration methods for consistent UI elements
  static BoxDecoration get gradientDecoration {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [primaryPurple, Color(0xFF8B7FE8)],
      ),
    );
  }

  static BoxDecoration get cardDecoration {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }

  static BoxDecoration get circleDecoration {
    return BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }
}

// Temporary router provider until we create the full router file
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('Welcome to Alpha Skincare'),
          ),
        ),
      ),
    ],
  );
});

// Import placeholder for GoRouter (will be replaced when we create app_router.dart)
class GoRouter {
  GoRouter({required String initialLocation, required List<GoRoute> routes});
}

class GoRoute {
  GoRoute({required String path, required Function(BuildContext, dynamic) builder});
}