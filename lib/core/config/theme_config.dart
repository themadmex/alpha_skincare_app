// lib/core/config/theme_config.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThemeConfig {
  // Brand Colors
  static const Color primaryColor = Color(0xFF6C5CE7);
  static const Color primaryLightColor = Color(0xFF9F8FE8);
  static const Color primaryDarkColor = Color(0xFF4834D4);

  static const Color secondaryColor = Color(0xFF00B894);
  static const Color secondaryLightColor = Color(0xFF00CEC9);
  static const Color secondaryDarkColor = Color(0xFF00A085);

  static const Color accentColor = Color(0xFF00CEC9);
  static const Color errorColor = Color(0xFFE17055);
  static const Color warningColor = Color(0xFFFEBC2C);
  static const Color successColor = Color(0xFF00B894);
  static const Color infoColor = Color(0xFF74B9FF);

  // Background Colors
  static const Color backgroundColor = Color(0xFFFAFAFA);
  static const Color surfaceColor = Colors.white;
  static const Color cardColor = Colors.white;
  static const Color scaffoldBackgroundColor = Color(0xFFF8F9FA);

  // Text Colors
  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);
  static const Color textTertiary = Color(0xFFB2BEC3);
  static const Color textOnPrimary = Colors.white;
  static const Color textOnSurface = Color(0xFF2D3436);

  // Button Colors
  static const Color buttonPrimary = primaryColor;
  static const Color buttonSecondary = Color(0xFFDDD6FE);
  static const Color buttonDisabled = Color(0xFFB2BEC3);
  static const Color buttonText = Colors.white;

  // Border Colors
  static const Color borderColor = Color(0xFFE1E5E9);
  static const Color borderColorLight = Color(0xFFF1F3F4);
  static const Color borderColorDark = Color(0xFFD1D5DA);

  // Shadow Colors
  static const Color shadowColor = Color(0x1A000000);
  static const Color shadowColorLight = Color(0x0D000000);
  static const Color shadowColorDark = Color(0x26000000);

  // Status Colors
  static const Color statusOnline = Color(0xFF27AE60);
  static const Color statusOffline = Color(0xFF95A5A6);
  static const Color statusAway = Color(0xFFF39C12);
  static const Color statusBusy = Color(0xFFE74C3C);

  // Dark Theme Colors
  static const Color darkBackgroundColor = Color(0xFF121212);
  static const Color darkSurfaceColor = Color(0xFF1E1E1E);
  static const Color darkCardColor = Color(0xFF2D2D2D);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB3B3B3);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, primaryLightColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondaryColor, secondaryLightColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [successColor, Color(0xFF00D2A0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [warningColor, Color(0xFFFFD93D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient errorGradient = LinearGradient(
    colors: [errorColor, Color(0xFFFF7675)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Typography
  static const String fontFamily = 'Inter';
  static const String displayFontFamily = 'Poppins';

  // Font Weights
  static const FontWeight fontWeightLight = FontWeight.w300;
  static const FontWeight fontWeightRegular = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemiBold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;
  static const FontWeight fontWeightExtraBold = FontWeight.w800;

  // Spacing
  static const double spaceXXS = 2.0;
  static const double spaceXS = 4.0;
  static const double spaceSM = 8.0;
  static const double spaceMD = 16.0;
  static const double spaceLG = 24.0;
  static const double spaceXL = 32.0;
  static const double spaceXXL = 48.0;
  static const double spaceXXXL = 64.0;

  // Border Radius
  static const double radiusXS = 4.0;
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 20.0;
  static const double radiusXXL = 24.0;
  static const double radiusCircle = 999.0;

  // Elevation
  static const double elevationXS = 1.0;
  static const double elevationSM = 2.0;
  static const double elevationMD = 4.0;
  static const double elevationLG = 8.0;
  static const double elevationXL = 12.0;
  static const double elevationXXL = 16.0;

  // Icon Sizes
  static const double iconXS = 12.0;
  static const double iconSM = 16.0;
  static const double iconMD = 20.0;
  static const double iconLG = 24.0;
  static const double iconXL = 32.0;
  static const double iconXXL = 48.0;

  // Component Heights
  static const double buttonHeightSM = 36.0;
  static const double buttonHeightMD = 44.0;
  static const double buttonHeightLG = 52.0;
  static const double inputHeight = 48.0;
  static const double appBarHeight = 56.0;
  static const double tabBarHeight = 48.0;
  static const double bottomNavHeight = 60.0;

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color Scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        background: backgroundColor,
        error: errorColor,
        onPrimary: textOnPrimary,
        onSecondary: Colors.white,
        onSurface: textOnSurface,
        onBackground: textPrimary,
        onError: Colors.white,
      ),

      // Scaffold Background
      scaffoldBackgroundColor: scaffoldBackgroundColor,

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: fontWeightSemiBold,
          color: textPrimary,
          fontFamily: fontFamily,
        ),
        iconTheme: const IconThemeData(
          color: textPrimary,
          size: iconLG,
        ),
      ),

      // Card Theme
      cardTheme: CardTheme(
        color: cardColor,
        elevation: elevationMD,
        shadowColor: shadowColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMD),
        ),
        margin: const EdgeInsets.all(spaceSM),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMD),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMD),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMD),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMD),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMD),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spaceMD,
          vertical: spaceMD,
        ),
        labelStyle: TextStyle(
          color: textSecondary,
          fontSize: 14,
          fontWeight: fontWeightMedium,
        ),
        hintStyle: TextStyle(
          color: textTertiary,
          fontSize: 14,
          fontWeight: fontWeightRegular,
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonPrimary,
          foregroundColor: buttonText,
          padding: const EdgeInsets.symmetric(
            horizontal: spaceLG,
            vertical: spaceMD,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMD),
          ),
          elevation: elevationSM,
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: fontWeightSemiBold,
            fontFamily: fontFamily,
          ),
          minimumSize: const Size(double.infinity, buttonHeightMD),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(
            horizontal: spaceMD,
            vertical: spaceSM,
          ),
          textStyle: TextStyle(
            fontSize: 14,
            fontWeight: fontWeightSemiBold,
            fontFamily: fontFamily,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor),
          padding: const EdgeInsets.symmetric(
            horizontal: spaceLG,
            vertical: spaceMD,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMD),
          ),
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: fontWeightSemiBold,
            fontFamily: fontFamily,
          ),
          minimumSize: const Size(double.infinity, buttonHeightMD),
        ),
      ),

      // Tab Bar Theme
      tabBarTheme: TabBarTheme(
        labelColor: primaryColor,
        unselectedLabelColor: textSecondary,
        indicatorColor: primaryColor,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: TextStyle(
          fontSize: 14,
          fontWeight: fontWeightSemiBold,
          fontFamily: fontFamily,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 14,
          fontWeight: fontWeightMedium,
          fontFamily: fontFamily,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: elevationLG,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: fontWeightSemiBold,
          fontFamily: fontFamily,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: fontWeightMedium,
          fontFamily: fontFamily,
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: textOnPrimary,
        elevation: elevationMD,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLG),
        ),
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryColor,
        linearTrackColor: Color(0xFFE0E0E0),
        circularTrackColor: Color(0xFFE0E0E0),
      ),

      // Snack Bar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: textPrimary,
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSM),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: elevationMD,
      ),

      // Dialog Theme
      dialogTheme: DialogTheme(
        backgroundColor: surfaceColor,
        elevation: elevationXL,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLG),
        ),
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: fontWeightSemiBold,
          color: textPrimary,
          fontFamily: fontFamily,
        ),
        contentTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: fontWeightRegular,
          color: textSecondary,
          fontFamily: fontFamily,
        ),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: Colors.grey.withOpacity(0.1),
        selectedColor: primaryColor.withOpacity(0.2),
        checkmarkColor: primaryColor,
        labelStyle: TextStyle(
          fontSize: 14,
          fontWeight: fontWeightMedium,
          fontFamily: fontFamily,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusXL),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: spaceSM,
          vertical: spaceXS,
        ),
      ),

      // List Tile Theme
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spaceMD,
          vertical: spaceXS,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSM),
        ),
        titleTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: fontWeightMedium,
          color: textPrimary,
          fontFamily: fontFamily,
        ),
        subtitleTextStyle: TextStyle(
          fontSize: 14,
          fontWeight: fontWeightRegular,
          color: textSecondary,
          fontFamily: fontFamily,
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: textSecondary,
        size: iconLG,
      ),

      // Primary Icon Theme
      primaryIconTheme: const IconThemeData(
        color: textOnPrimary,
        size: iconLG,
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: fontWeightBold,
          color: textPrimary,
          fontFamily: displayFontFamily,
          height: 1.2,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: fontWeightBold,
          color: textPrimary,
          fontFamily: displayFontFamily,
          height: 1.2,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: fontWeightSemiBold,
          color: textPrimary,
          fontFamily: displayFontFamily,
          height: 1.3,
        ),
        headlineLarge: TextStyle(
          fontSize: 22,
          fontWeight: fontWeightSemiBold,
          color: textPrimary,
          fontFamily: fontFamily,
          height: 1.3,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: fontWeightSemiBold,
          color: textPrimary,
          fontFamily: fontFamily,
          height: 1.3,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: fontWeightSemiBold,
          color: textPrimary,
          fontFamily: fontFamily,
          height: 1.4,
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: fontWeightSemiBold,
          color: textPrimary,
          fontFamily: fontFamily,
          height: 1.4,
        ),
        titleMedium: TextStyle(
          fontSize: 14,
          fontWeight: fontWeightSemiBold,
          color: textPrimary,
          fontFamily: fontFamily,
          height: 1.4,
        ),
        titleSmall: TextStyle(
          fontSize: 12,
          fontWeight: fontWeightSemiBold,
          color: textPrimary,
          fontFamily: fontFamily,
          height: 1.4,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: fontWeightRegular,
          color: textPrimary,
          fontFamily: fontFamily,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: fontWeightRegular,
          color: textPrimary,
          fontFamily: fontFamily,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: fontWeightRegular,
          color: textSecondary,
          fontFamily: fontFamily,
          height: 1.5,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: fontWeightMedium,
          color: textPrimary,
          fontFamily: fontFamily,
          height: 1.4,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: fontWeightMedium,
          color: textSecondary,
          fontFamily: fontFamily,
          height: 1.4,
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: fontWeightMedium,
          color: textTertiary,
          fontFamily: fontFamily,
          height: 1.4,
        ),
      ),

      // Font Family
      fontFamily: fontFamily,
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color Scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
        primary: primaryLightColor,
        secondary: secondaryLightColor,
        surface: darkSurfaceColor,
        background: darkBackgroundColor,
        error: errorColor,
        onPrimary: darkTextPrimary,
        onSecondary: darkTextPrimary,
        onSurface: darkTextPrimary,
        onBackground: darkTextPrimary,
        onError: darkTextPrimary,
      ),

      // Scaffold Background
      scaffoldBackgroundColor: darkBackgroundColor,

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: darkTextPrimary,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: fontWeightSemiBold,
          color: darkTextPrimary,
          fontFamily: fontFamily,
        ),
        iconTheme: const IconThemeData(
          color: darkTextPrimary,
          size: iconLG,
        ),
      ),

      // Card Theme
      cardTheme: CardTheme(
        color: darkCardColor,
        elevation: elevationMD,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMD),
        ),
        margin: const EdgeInsets.all(spaceSM),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMD),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMD),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMD),
          borderSide: const BorderSide(color: primaryLightColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMD),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMD),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spaceMD,
          vertical: spaceMD,
        ),
        labelStyle: const TextStyle(
          color: darkTextSecondary,
          fontSize: 14,
          fontWeight: fontWeightMedium,
        ),
        hintStyle: TextStyle(
          color: darkTextSecondary.withOpacity(0.7),
          fontSize: 14,
          fontWeight: fontWeightRegular,
        ),
      ),

      // Text Theme for Dark Mode
      textTheme: TextTheme(
        displayLarge: const TextStyle(
          fontSize: 32,
          fontWeight: fontWeightBold,
          color: darkTextPrimary,
          fontFamily: displayFontFamily,
          height: 1.2,
        ),
        displayMedium: const TextStyle(
          fontSize: 28,
          fontWeight: fontWeightBold,
          color: darkTextPrimary,
          fontFamily: displayFontFamily,
          height: 1.2,
        ),
        displaySmall: const TextStyle(
          fontSize: 24,
          fontWeight: fontWeightSemiBold,
          color: darkTextPrimary,
          fontFamily: displayFontFamily,
          height: 1.3,
        ),
        headlineLarge: TextStyle(
          fontSize: 22,
          fontWeight: fontWeightSemiBold,
          color: darkTextPrimary,
          fontFamily: fontFamily,
          height: 1.3,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: fontWeightSemiBold,
          color: darkTextPrimary,
          fontFamily: fontFamily,
          height: 1.3,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: fontWeightSemiBold,
          color: darkTextPrimary,
          fontFamily: fontFamily,
          height: 1.4,
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: fontWeightSemiBold,
          color: darkTextPrimary,
          fontFamily: fontFamily,
          height: 1.4,
        ),
        titleMedium: TextStyle(
          fontSize: 14,
          fontWeight: fontWeightSemiBold,
          color: darkTextPrimary,
          fontFamily: fontFamily,
          height: 1.4,
        ),
        titleSmall: TextStyle(
          fontSize: 12,
          fontWeight: fontWeightSemiBold,
          color: darkTextPrimary,
          fontFamily: fontFamily,
          height: 1.4,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: fontWeightRegular,
          color: darkTextPrimary,
          fontFamily: fontFamily,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: fontWeightRegular,
          color: darkTextPrimary,
          fontFamily: fontFamily,
          height: 1.5,
        ),
        bodySmall: const TextStyle(
          fontSize: 12,
          fontWeight: fontWeightRegular,
          color: darkTextSecondary,
          fontFamily: fontFamily,
          height: 1.5,
        ),
        labelLarge: const TextStyle(
          fontSize: 14,
          fontWeight: fontWeightMedium,
          color: darkTextPrimary,
          fontFamily: fontFamily,
          height: 1.4,
        ),
        labelMedium: const TextStyle(
          fontSize: 12,
          fontWeight: fontWeightMedium,
          color: darkTextSecondary,
          fontFamily: fontFamily,
          height: 1.4,
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: fontWeightMedium,
          color: darkTextSecondary.withOpacity(0.7),
          fontFamily: fontFamily,
          height: 1.4,
        ),
      ),

      // Font Family
      fontFamily: fontFamily,
    );
  }

  // Custom Color Extensions
  static Map<String, Color> get skinConditionColors => {
    'acne': const Color(0xFFE74C3C),
    'dryness': const Color(0xFF3498DB),
    'oiliness': const Color(0xFFF39C12),
    'sensitivity': const Color(0xFFE67E22),
    'aging': const Color(0xFF9B59B6),
    'pigmentation': const Color(0xFF8B4513),
    'rosacea': const Color(0xFFDC143C),
    'eczema': const Color(0xFF20B2AA),
    'normal': successColor,
  };

  static Map<String, Color> get severityColors => {
    'mild': const Color(0xFF27AE60),
    'moderate': const Color(0xFFF39C12),
    'severe': const Color(0xFFE74C3C),
    'critical': const Color(0xFF8B0000),
  };

  static Map<String, Color> get progressColors => {
    'improving': successColor,
    'stable': warningColor,
    'worsening': errorColor,
    'excellent': const Color(0xFF00C851),
  };
}