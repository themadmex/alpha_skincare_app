// lib/core/theme/colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF6C5CE7);
  static const Color primaryLight = Color(0xFF9C88FF);
  static const Color primaryDark = Color(0xFF4834D4);
  static const Color primaryVariant = Color(0xFF5F4FCF);

  // Secondary Colors
  static const Color secondary = Color(0xFF00B894);
  static const Color secondaryLight = Color(0xFF55EFC4);
  static const Color secondaryDark = Color(0xFF00A085);
  static const Color secondaryVariant = Color(0xFF00CEC9);

  // Accent Colors
  static const Color accent = Color(0xFF00CEC9);
  static const Color accentLight = Color(0xFF74B9FF);
  static const Color accentDark = Color(0xFF0984E3);

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);

  // Grey Scale
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // Background Colors
  static const Color background = Color(0xFFFAFAFA);
  static const Color backgroundDark = Color(0xFF1A1A1A);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF2D2D2D);
  static const Color card = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF2D2D2D);

  // Text Colors
  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);
  static const Color textTertiary = Color(0xFFB2BEC3);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnSecondary = Color(0xFFFFFFFF);
  static const Color textOnSurface = Color(0xFF2D3436);
  static const Color textOnBackground = Color(0xFF2D3436);

  // Dark Theme Text Colors
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFB3B3B3);
  static const Color textTertiaryDark = Color(0xFF808080);

  // Status Colors
  static const Color success = Color(0xFF00B894);
  static const Color successLight = Color(0xFF55EFC4);
  static const Color successDark = Color(0xFF00A085);

  static const Color warning = Color(0xFFFEBC2C);
  static const Color warningLight = Color(0xFFFDCB6E);
  static const Color warningDark = Color(0xFFE17055);

  static const Color error = Color(0xFFE17055);
  static const Color errorLight = Color(0xFFFF7675);
  static const Color errorDark = Color(0xFFD63031);

  static const Color info = Color(0xFF74B9FF);
  static const Color infoLight = Color(0xFF81ECEC);
  static const Color infoDark = Color(0xFF0984E3);

  // Skin Analysis Colors
  static const Color skinExcellent = Color(0xFF00B894);
  static const Color skinGood = Color(0xFF00CEC9);
  static const Color skinFair = Color(0xFFFEBC2C);
  static const Color skinPoor = Color(0xFFE17055);
  static const Color skinCritical = Color(0xFFD63031);

  // Product Category Colors
  static const Color categoryCleanser = Color(0xFF74B9FF);
  static const Color categoryMoisturizer = Color(0xFF00B894);
  static const Color categorySerum = Color(0xFF6C5CE7);
  static const Color categorySunscreen = Color(0xFFFEBC2C);
  static const Color categoryTreatment = Color(0xFFE17055);
  static const Color categoryExfoliant = Color(0xFF00CEC9);
  static const Color categoryMask = Color(0xFFFF7675);
  static const Color categoryToner = Color(0xFFA29BFE);

  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFF6C5CE7),
    Color(0xFF9C88FF),
  ];

  static const List<Color> secondaryGradient = [
    Color(0xFF00B894),
    Color(0xFF55EFC4),
  ];

  static const List<Color> accentGradient = [
    Color(0xFF00CEC9),
    Color(0xFF74B9FF),
  ];

  static const List<Color> successGradient = [
    Color(0xFF00B894),
    Color(0xFF55EFC4),
  ];

  static const List<Color> warningGradient = [
    Color(0xFFFEBC2C),
    Color(0xFFFDCB6E),
  ];

  static const List<Color> errorGradient = [
    Color(0xFFE17055),
    Color(0xFFFF7675),
  ];

  // Skin Type Colors
  static const Color skinTypeOily = Color(0xFF74B9FF);
  static const Color skinTypeDry = Color(0xFFFEBC2C);
  static const Color skinTypeCombination = Color(0xFF00CEC9);
  static const Color skinTypeNormal = Color(0xFF00B894);
  static const Color skinTypeSensitive = Color(0xFFFF7675);

  // Progress Colors
  static const Color progressTrack = Color(0xFFE0E0E0);
  static const Color progressIndicator = Color(0xFF6C5CE7);
  static const Color progressBackground = Color(0xFFF5F5F5);

  // Shadow Colors
  static const Color shadowLight = Color(0x0F000000);
  static const Color shadowMedium = Color(0x1F000000);
  static const Color shadowDark = Color(0x3F000000);

  // Border Colors
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color borderMedium = Color(0xFFBDBDBD);
  static const Color borderDark = Color(0xFF757575);

  // Helper Methods
  static Color getSkinScoreColor(int score) {
    if (score >= 80) return skinExcellent;
    if (score >= 60) return skinGood;
    if (score >= 40) return skinFair;
    if (score >= 20) return skinPoor;
    return skinCritical;
  }

  static Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'cleanser':
        return categoryCleanser;
      case 'moisturizer':
        return categoryMoisturizer;
      case 'serum':
        return categorySerum;
      case 'sunscreen':
        return categorySunscreen;
      case 'treatment':
        return categoryTreatment;
      case 'exfoliant':
        return categoryExfoliant;
      case 'mask':
        return categoryMask;
      case 'toner':
        return categoryToner;
      default:
        return primary;
    }
  }

  static Color getSkinTypeColor(String skinType) {
    switch (skinType.toLowerCase()) {
      case 'oily':
        return skinTypeOily;
      case 'dry':
        return skinTypeDry;
      case 'combination':
        return skinTypeCombination;
      case 'normal':
        return skinTypeNormal;
      case 'sensitive':
        return skinTypeSensitive;
      default:
        return primary;
    }
  }

  static List<Color> getGradientForScore(int score) {
    if (score >= 80) return successGradient;
    if (score >= 60) return accentGradient;
    if (score >= 40) return warningGradient;
    return errorGradient;
  }

  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }

  static Color lighten(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }

  static Color darken(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }
}