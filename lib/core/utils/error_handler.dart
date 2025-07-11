// lib/core/utils/error_handler.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../config/app_config.dart';
import '../constants/app_constant.dart';

class ErrorHandler {
  static void logError(dynamic error, StackTrace? stackTrace, {String? context}) {
    if (kDebugMode) {
      debugPrint('Error in $context: $error');
      debugPrint('Stack trace: $stackTrace');
    }

    // Log to crash reporting service if enabled
    if (AppConfig.enableCrashlytics) {
      // FirebaseCrashlytics.instance.recordError(error, stackTrace, context: context);
    }
  }

  static void handleError(dynamic error, StackTrace? stackTrace, {String? context}) {
    logError(error, stackTrace, context: context);

    // Show user-friendly error message
    final message = _getUserFriendlyMessage(error);
    _showErrorSnackBar(message);
  }

  static String _getUserFriendlyMessage(dynamic error) {
    if (error is NetworkException) {
      return AppConstants.errorNetworkConnection;
    } else if (error is ServerException) {
      return AppConstants.errorServerError;
    } else if (error is CameraException) {
      return AppConstants.errorCameraPermission;
    } else if (error is StorageException) {
      return AppConstants.errorStoragePermission;
    } else if (error is ImageProcessingException) {
      return AppConstants.errorImageProcessing;
    }

    return 'An unexpected error occurred. Please try again.';
  }

  static void _showErrorSnackBar(String message) {
    // This would need to be implemented with proper context
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text(message)),
    // );
  }

  static void handleNetworkError(dynamic error) {
    logError(error, null, context: 'Network');
    _showErrorSnackBar(AppConstants.errorNetworkConnection);
  }

  static void handleAuthError(dynamic error) {
    logError(error, null, context: 'Authentication');

    String message = AppConstants.errorInvalidCredentials;
    if (error.toString().contains('user-not-found')) {
      message = AppConstants.errorUserNotFound;
    } else if (error.toString().contains('email-already-in-use')) {
      message = AppConstants.errorEmailAlreadyExists;
    } else if (error.toString().contains('weak-password')) {
      message = AppConstants.errorWeakPassword;
    }

    _showErrorSnackBar(message);
  }

  static void handleScanError(dynamic error) {
    logError(error, null, context: 'Skin Scan');

    String message = AppConstants.errorImageProcessing;
    if (error.toString().contains('camera')) {
      message = AppConstants.errorCameraPermission;
    } else if (error.toString().contains('model')) {
      message = AppConstants.errorModelNotFound;
    }

    _showErrorSnackBar(message);
  }
}

// Custom Exception Classes
class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);

  @override
  String toString() => 'NetworkException: $message';
}

class ServerException implements Exception {
  final String message;
  final int? statusCode;
  ServerException(this.message, {this.statusCode});

  @override
  String toString() => 'ServerException: $message (Status: $statusCode)';
}

class CameraException implements Exception {
  final String message;
  CameraException(this.message);

  @override
  String toString() => 'CameraException: $message';
}

class StorageException implements Exception {
  final String message;
  StorageException(this.message);

  @override
  String toString() => 'StorageException: $message';
}

class ImageProcessingException implements Exception {
  final String message;
  ImageProcessingException(this.message);

  @override
  String toString() => 'ImageProcessingException: $message';
}

class AuthException implements Exception {
  final String message;
  final String? code;
  AuthException(this.message, {this.code});

  @override
  String toString() => 'AuthException: $message (Code: $code)';
}