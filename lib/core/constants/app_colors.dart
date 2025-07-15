import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryLight = Color(0xFF8B82FF);
  static const Color primaryDark = Color(0xFF5A52E5);

  // Secondary Colors
  static const Color secondary = Color(0xFFFF6B9D);
  static const Color secondaryLight = Color(0xFFFF8BB5);
  static const Color secondaryDark = Color(0xFFE5578A);

  // Accent Colors
  static const Color accent = Color(0xFF4ECDC4);
  static const Color accentLight = Color(0xFF6FD4CD);
  static const Color accentDark = Color(0xFF3CB5AD);

  // Background Colors
  static const Color background = Color(0xFFF8F9FA);
  static const Color backgroundDark = Color(0xFF1A1A1A);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF2C2C2C);

  // Text Colors
  static const Color textPrimary = Color(0xFF2D3748);
  static const Color textSecondary = Color(0xFF718096);
  static const Color textLight = Color(0xFFA0AEC0);
  static const Color textDark = Color(0xFF1A202C);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Status Colors
  static const Color success = Color(0xFF48BB78);
  static const Color warning = Color(0xFFED8936);
  static const Color error = Color(0xFFE53E3E);
  static const Color info = Color(0xFF3182CE);

  // Border Colors
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderLight = Color(0xFFF7FAFC);
  static const Color borderDark = Color(0xFFCBD5E0);

  // Skin Analysis Colors
  static const Color skinExcellent = Color(0xFF48BB78);
  static const Color skinGood = Color(0xFF68D391);
  static const Color skinAverage = Color(0xFFED8936);
  static const Color skinPoor = Color(0xFFE53E3E);
  static const Color skinVeryPoor = Color(0xFFBB2E2E);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Skin tone colors for analysis
  static const Color skinTone1 = Color(0xFFF7E7CE);
  static const Color skinTone2 = Color(0xFFE6B887);
  static const Color skinTone3 = Color(0xFFD1975A);
  static const Color skinTone4 = Color(0xFFB8734D);
  static const Color skinTone5 = Color(0xFFA0563B);
  static const Color skinTone6 = Color(0xFF7A4023);
}
