// lib/core/theme/shadows.dart
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'colors.dart';

class AppShadows {
  // Light Shadows
  static const List<BoxShadow> light = [
    BoxShadow(
      color: AppColors.shadowLight,
      blurRadius: 4.0,
      offset: Offset(0, 2),
    ),
  ];

  // Medium Shadows
  static const List<BoxShadow> medium = [
    BoxShadow(
      color: AppColors.shadowMedium,
      blurRadius: 8.0,
      offset: Offset(0, 4),
    ),
  ];

  // Dark Shadows
  static const List<BoxShadow> dark = [
    BoxShadow(
      color: AppColors.shadowDark,
      blurRadius: 12.0,
      offset: Offset(0, 6),
    ),
  ];

  // Card Shadow
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 8.0,
      offset: Offset(0, 2),
    ),
  ];

  // Button Shadow
  static const List<BoxShadow> button = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 4.0,
      offset: Offset(0, 2),
    ),
  ];

  // Floating Action Button Shadow
  static const List<BoxShadow> fab = [
    BoxShadow(
      color: Color(0x1F000000),
      blurRadius: 8.0,
      offset: Offset(0, 4),
    ),
  ];

  // Modal Shadow
  static const List<BoxShadow> modal = [
    BoxShadow(
      color: Color(0x33000000),
      blurRadius: 16.0,
      offset: Offset(0, 8),
    ),
  ];

  // Dropdown Shadow
  static const List<BoxShadow> dropdown = [
    BoxShadow(
      color: Color(0x0F000000),
      blurRadius: 12.0,
      offset: Offset(0, 4),
    ),
  ];

  // Toast Shadow
  static const List<BoxShadow> toast = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 6.0,
      offset: Offset(0, 3),
    ),
  ];

  // Product Card Shadow
  static const List<BoxShadow> productCard = [
    BoxShadow(
      color: Color(0x08000000),
      blurRadius: 8.0,
      offset: Offset(0, 2),
    ),
  ];

  // Scan Result Shadow
  static const List<BoxShadow> scanResult = [
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 12.0,
      offset: Offset(0, 4),
    ),
  ];

  // Progress Card Shadow
  static const List<BoxShadow> progressCard = [
    BoxShadow(
      color: Color(0x0C000000),
      blurRadius: 10.0,
      offset: Offset(0, 3),
    ),
  ];

  // Navigation Shadow
  static const List<BoxShadow> navigation = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 8.0,
      offset: Offset(0, -2),
    ),
  ];

  // Helper Methods
  static List<BoxShadow> withColor(List<BoxShadow> shadows, Color color) {
    return shadows.map((shadow) => shadow.copyWith(color: color)).toList();
  }

  static List<BoxShadow> withOpacity(List<BoxShadow> shadows, double opacity) {
    return shadows.map((shadow) =>
        shadow.copyWith(color: shadow.color.withOpacity(opacity))
    ).toList();
  }

  static List<BoxShadow> withOffset(List<BoxShadow> shadows, Offset offset) {
    return shadows.map((shadow) => shadow.copyWith(offset: offset)).toList();
  }

  static List<BoxShadow> withBlur(List<BoxShadow> shadows, double blurRadius) {
    return shadows.map((shadow) =>
        shadow.copyWith(blurRadius: blurRadius)
    ).toList();
  }
}