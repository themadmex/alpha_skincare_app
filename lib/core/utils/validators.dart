// lib/core/utils/validators.dart
import '../../config/app_config.dart';
import '../config/constant.dart';

class Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return AppConstants.validationEmailRequired;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return AppConstants.errorInvalidEmail;
    }

    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return AppConstants.validationPasswordRequired;
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }

    return null;
  }

  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != password) {
      return AppConstants.errorPasswordMismatch;
    }

    return null;
  }

  static String? name(String? value) {
    if (value == null || value.isEmpty) {
      return AppConstants.validationNameRequired;
    }

    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }

    if (value.length > 50) {
      return 'Name must be less than 50 characters';
    }

    return null;
  }

  static String? age(String? value) {
    if (value == null || value.isEmpty) {
      return AppConstants.validationAgeRequired;
    }

    final age = int.tryParse(value);
    if (age == null) {
      return AppConstants.validationInvalidAge;
    }

    if (age < AppConfig.minAge || age > AppConfig.maxAge) {
      return 'Age must be between ${AppConfig.minAge} and ${AppConfig.maxAge}';
    }

    return null;
  }

  static String? required(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    return null;
  }

  static String? phoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Phone number is optional
    }

    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]{10,}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  static String? url(String? value) {
    if (value == null || value.isEmpty) {
      return null; // URL is optional
    }

    try {
      Uri.parse(value);
      return null;
    } catch (e) {
      return 'Please enter a valid URL';
    }
  }
}