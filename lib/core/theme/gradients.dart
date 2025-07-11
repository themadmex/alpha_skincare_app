// lib/core/theme/gradients.dart
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'colors.dart';

class AppGradients {
  // Primary Gradients
  static const LinearGradient primary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: AppColors.primaryGradient,
  );

  static const LinearGradient secondary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: AppColors.secondaryGradient,
  );

  static const LinearGradient accent = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: AppColors.accentGradient,
  );

  // Status Gradients
  static const LinearGradient success = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: AppColors.successGradient,
  );

  static const LinearGradient warning = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: AppColors.warningGradient,
  );

  static const LinearGradient error = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: AppColors.errorGradient,
  );

  // Special Gradients
  static const LinearGradient greeting = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.primary,
      AppColors.primaryLight,
    ],
  );

  static const LinearGradient scanResult = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.primary,
      AppColors.primaryDark,
    ],
  );

  static const LinearGradient cameraOverlay = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.transparent,
      Color(0x80000000),
    ],
  );

  // Radial Gradients
  static const RadialGradient spotlight = RadialGradient(
    center: Alignment.center,
    radius: 0.8,
    colors: [
      AppColors.primary,
      AppColors.primaryDark,
    ],
  );

  static const RadialGradient profileBackground = RadialGradient(
    center: Alignment.topCenter,
    radius: 1.2,
    colors: [
      AppColors.primaryLight,
      AppColors.primary,
    ],
  );

  // Sweep Gradients
  static const SweepGradient progressRing = SweepGradient(
    startAngle: 0,
    endAngle: 2 * 3.14159,
    colors: [
      AppColors.primary,
      AppColors.secondary,
      AppColors.accent,
      AppColors.primary,
    ],
  );

  // Skin Analysis Gradients
  static LinearGradient skinScoreGradient(int score) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: AppColors.getGradientForScore(score),
    );
  }

  // Category Gradients
  static const LinearGradient cleanser = LinearGradient(
    colors: [AppColors.categoryCleanser, Color(0xFF4F98FF)],
  );

  static const LinearGradient moisturizer = LinearGradient(
    colors: [AppColors.categoryMoisturizer, Color(0xFF00A085)],
  );

  static const LinearGradient serum = LinearGradient(
    colors: [AppColors.categorySerum, Color(0xFF4834D4)],
  );

  static const LinearGradient sunscreen = LinearGradient(
    colors: [AppColors.categorySunscreen, Color(0xFFE17055)],
  );

  // Helper Methods
  static LinearGradient withColors(List<Color> colors) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: colors,
    );
  }

  static LinearGradient withAlignment(
      List<Color> colors,
      Alignment begin,
      Alignment end,
      ) {
    return LinearGradient(
      begin: begin,
      end: end,
      colors: colors,
    );
  }

  static LinearGradient withStops(
      List<Color> colors,
      List<double> stops,
      ) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: colors,
      stops: stops,
    );
  }
}