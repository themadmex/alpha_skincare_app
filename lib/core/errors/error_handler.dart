import 'package:equatable/equatable.dart';

// Base error class that combines exception and failure concepts
abstract class AppError extends Equatable {
  final String message;
  final String? code;
  final dynamic details;
  final ErrorType type;

  const AppError({
    required this.message,
    required this.type,
    this.code,
    this.details,
  });

  @override
  List<Object?> get props => [message, code, details, type];

  @override
  String toString() => '${type.name}: $message';
}

// Error types for categorization
enum ErrorType {
  network,
  auth,
  validation,
  storage,
  camera,
  ml,
  data,
  platform,
  unknown,
}

// Specific error implementations
class NetworkError extends AppError {
  final int? statusCode;

  const NetworkError({
    required super.message,
    super.code,
    super.details,
    this.statusCode,
  }) : super(type: ErrorType.network);

  @override
  List<Object?> get props => [...super.props, statusCode];
}

class AuthError extends AppError {
  const AuthError({
    required super.message,
    super.code,
    super.details,
  }) : super(type: ErrorType.auth);
}

class ValidationError extends AppError {
  final Map<String, List<String>>? fieldErrors;

  const ValidationError({
    required super.message,
    super.code,
    super.details,
    this.fieldErrors,
  }) : super(type: ErrorType.validation);

  @override
  List<Object?> get props => [...super.props, fieldErrors];
}

class StorageError extends AppError {
  const StorageError({
    required super.message,
    super.code,
    super.details,
  }) : super(type: ErrorType.storage);
}

class CameraError extends AppError {
  const CameraError({
    required super.message,
    super.code,
    super.details,
  }) : super(type: ErrorType.camera);
}

class MLError extends AppError {
  const MLError({
    required super.message,
    super.code,
    super.details,
  }) : super(type: ErrorType.ml);
}

class DataError extends AppError {
  const DataError({
    required super.message,
    super.code,
    super.details,
  }) : super(type: ErrorType.data);
}

class PlatformError extends AppError {
  const PlatformError({
    required super.message,
    super.code,
    super.details,
  }) : super(type: ErrorType.platform);
}

class UnknownError extends AppError {
  const UnknownError({
    required super.message,
    super.code,
    super.details,
  }) : super(type: ErrorType.unknown);
}

// Error factory with intelligent error creation
class ErrorFactory {
  static const Map<String, ErrorType> _keywordToType = {
    'network': ErrorType.network,
    'internet': ErrorType.network,
    'connection': ErrorType.network,
    'timeout': ErrorType.network,
    'server': ErrorType.network,
    'http': ErrorType.network,
    'auth': ErrorType.auth,
    'login': ErrorType.auth,
    'password': ErrorType.auth,
    'token': ErrorType.auth,
    'permission': ErrorType.auth,
    'validation': ErrorType.validation,
    'invalid': ErrorType.validation,
    'required': ErrorType.validation,
    'format': ErrorType.validation,
    'storage': ErrorType.storage,
    'database': ErrorType.storage,
    'cache': ErrorType.storage,
    'file': ErrorType.storage,
    'camera': ErrorType.camera,
    'photo': ErrorType.camera,
    'image': ErrorType.camera,
    'ml': ErrorType.ml,
    'model': ErrorType.ml,
    'analysis': ErrorType.ml,
    'inference': ErrorType.ml,
    'data': ErrorType.data,
    'parse': ErrorType.data,
    'serialize': ErrorType.data,
    'platform': ErrorType.platform,
  };

  static AppError fromException(Exception exception) {
    final message = exception.toString();
    final type = _detectErrorType(message);

    switch (type) {
      case ErrorType.network:
        return NetworkError(message: message, details: exception);
      case ErrorType.auth:
        return AuthError(message: message, details: exception);
      case ErrorType.validation:
        return ValidationError(message: message, details: exception);
      case ErrorType.storage:
        return StorageError(message: message, details: exception);
      case ErrorType.camera:
        return CameraError(message: message, details: exception);
      case ErrorType.ml:
        return MLError(message: message, details: exception);
      case ErrorType.data:
        return DataError(message: message, details: exception);
      case ErrorType.platform:
        return PlatformError(message: message, details: exception);
      default:
        return UnknownError(message: message, details: exception);
    }
  }

  static AppError fromHttpError(int statusCode, String message) {
    final code = statusCode.toString();

    switch (statusCode) {
      case 400:
        return ValidationError(message: message, code: code);
      case 401:
      case 403:
        return AuthError(message: message, code: code);
      case 404:
        return DataError(message: message, code: code);
      case 408:
        return NetworkError(message: message, code: code, statusCode: statusCode);
      case 429:
        return AuthError(message: message, code: code);
      case 500:
      case 502:
      case 503:
      case 504:
        return NetworkError(message: message, code: code, statusCode: statusCode);
      default:
        return NetworkError(message: message, code: code, statusCode: statusCode);
    }
  }

  static AppError fromString(String error) {
    final type = _detectErrorType(error);

    switch (type) {
      case ErrorType.network:
        return NetworkError(message: error);
      case ErrorType.auth:
        return AuthError(message: error);
      case ErrorType.validation:
        return ValidationError(message: error);
      case ErrorType.storage:
        return StorageError(message: error);
      case ErrorType.camera:
        return CameraError(message: error);
      case ErrorType.ml:
        return MLError(message: error);
      case ErrorType.data:
        return DataError(message: error);
      case ErrorType.platform:
        return PlatformError(message: error);
      default:
        return UnknownError(message: error);
    }
  }

  static ErrorType _detectErrorType(String message) {
    final lowerMessage = message.toLowerCase();

    for (final entry in _keywordToType.entries) {
      if (lowerMessage.contains(entry.key)) {
        return entry.value;
      }
    }

    return ErrorType.unknown;
  }

  // Specific error creators
  static NetworkError networkError(String message, {int? statusCode, String? code}) {
    return NetworkError(message: message, statusCode: statusCode, code: code);
  }

  static AuthError authError(String message, {String? code}) {
    return AuthError(message: message, code: code);
  }

  static ValidationError validationError(String message, {Map<String, List<String>>? fieldErrors}) {
    return ValidationError(message: message, fieldErrors: fieldErrors);
  }

  static CameraError cameraError(String message, {String? code}) {
    return CameraError(message: message, code: code);
  }

  static MLError mlError(String message, {String? code}) {
    return MLError(message: message, code: code);
  }

  static StorageError storageError(String message, {String? code}) {
    return StorageError(message: message, code: code);
  }

  static DataError dataError(String message, {String? code}) {
    return DataError(message: message, code: code);
  }
}

// Error handler utility class
class ErrorHandler {
  static String getDisplayMessage(AppError error) {
    switch (error.type) {
      case ErrorType.network:
        return _getNetworkErrorMessage(error as NetworkError);
      case ErrorType.auth:
        return _getAuthErrorMessage(error);
      case ErrorType.validation:
        return _getValidationErrorMessage(error as ValidationError);
      case ErrorType.storage:
        return 'Storage error occurred. Please try again.';
      case ErrorType.camera:
        return 'Camera error occurred. Please check permissions.';
      case ErrorType.ml:
        return 'Analysis error occurred. Please try again.';
      case ErrorType.data:
        return 'Data error occurred. Please try again.';
      case ErrorType.platform:
        return 'Platform error occurred. Please try again.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }

  static String _getNetworkErrorMessage(NetworkError error) {
    if (error.statusCode != null) {
      switch (error.statusCode!) {
        case 400:
          return 'Bad request. Please check your input.';
        case 401:
          return 'Authentication required. Please sign in.';
        case 403:
          return 'Access denied. Please check permissions.';
        case 404:
          return 'Resource not found.';
        case 408:
          return 'Request timeout. Please try again.';
        case 429:
          return 'Too many requests. Please try again later.';
        case 500:
          return 'Server error. Please try again later.';
        case 502:
        case 503:
        case 504:
          return 'Server is temporarily unavailable.';
        default:
          return 'Network error occurred. Please check your connection.';
      }
    }
    return 'Network error occurred. Please check your connection.';
  }

  static String _getAuthErrorMessage(AppError error) {
    final message = error.message.toLowerCase();

    if (message.contains('invalid') || message.contains('wrong')) {
      return 'Invalid credentials. Please check your email and password.';
    } else if (message.contains('not found')) {
      return 'User not found. Please check your email address.';
    } else if (message.contains('disabled')) {
      return 'Account has been disabled. Please contact support.';
    } else if (message.contains('verified')) {
      return 'Please verify your email address.';
    } else if (message.contains('weak')) {
      return 'Password is too weak. Please choose a stronger password.';
    } else if (message.contains('exists')) {
      return 'Email already in use. Please use a different email.';
    }

    return 'Authentication error occurred. Please try again.';
  }

  static String _getValidationErrorMessage(ValidationError error) {
    if (error.fieldErrors != null && error.fieldErrors!.isNotEmpty) {
      final firstError = error.fieldErrors!.values.first.first;
      return firstError;
    }
    return error.message;
  }

  static bool isRetryable(AppError error) {
    switch (error.type) {
      case ErrorType.network:
        final networkError = error as NetworkError;
        return networkError.statusCode == null ||
            networkError.statusCode! >= 500 ||
            networkError.statusCode == 408 ||
            networkError.statusCode == 429;
      case ErrorType.storage:
      case ErrorType.camera:
      case ErrorType.ml:
      case ErrorType.data:
        return true;
      default:
        return false;
    }
  }
}