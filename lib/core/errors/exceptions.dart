// Base exception class
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const AppException({
    required this.message,
    this.code,
    this.details,
  });

  @override
  String toString() => 'AppException: $message';
}

// Network related exceptions
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'NetworkException: $message';
}

class ServerException extends AppException {
  final int? statusCode;

  const ServerException({
    required super.message,
    super.code,
    super.details,
    this.statusCode,
  });

  @override
  String toString() => 'ServerException: $message (Status: $statusCode)';
}

class TimeoutException extends AppException {
  const TimeoutException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'TimeoutException: $message';
}

// Authentication related exceptions
class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'AuthException: $message';
}

class InvalidCredentialsException extends AuthException {
  const InvalidCredentialsException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'InvalidCredentialsException: $message';
}

class UserNotFoundException extends AuthException {
  const UserNotFoundException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'UserNotFoundException: $message';
}

class EmailAlreadyInUseException extends AuthException {
  const EmailAlreadyInUseException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'EmailAlreadyInUseException: $message';
}

class WeakPasswordException extends AuthException {
  const WeakPasswordException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'WeakPasswordException: $message';
}

class AccountDisabledException extends AuthException {
  const AccountDisabledException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'AccountDisabledException: $message';
}

class EmailNotVerifiedException extends AuthException {
  const EmailNotVerifiedException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'EmailNotVerifiedException: $message';
}

class TooManyRequestsException extends AuthException {
  const TooManyRequestsException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'TooManyRequestsException: $message';
}

// Data related exceptions
class DataException extends AppException {
  const DataException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'DataException: $message';
}

class CacheException extends AppException {
  const CacheException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'CacheException: $message';
}

class DatabaseException extends AppException {
  const DatabaseException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'DatabaseException: $message';
}

class SerializationException extends AppException {
  const SerializationException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'SerializationException: $message';
}

// Camera and ML related exceptions
class CameraException extends AppException {
  const CameraException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'CameraException: $message';
}

class CameraPermissionException extends CameraException {
  const CameraPermissionException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'CameraPermissionException: $message';
}

class CameraInitializationException extends CameraException {
  const CameraInitializationException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'CameraInitializationException: $message';
}

class ImageCaptureException extends CameraException {
  const ImageCaptureException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'ImageCaptureException: $message';
}

class MLException extends AppException {
  const MLException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'MLException: $message';
}

class ModelLoadException extends MLException {
  const ModelLoadException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'ModelLoadException: $message';
}

class ImageProcessingException extends MLException {
  const ImageProcessingException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'ImageProcessingException: $message';
}

class AnalysisException extends MLException {
  const AnalysisException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'AnalysisException: $message';
}

class InferenceException extends MLException {
  const InferenceException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'InferenceException: $message';
}

// Storage related exceptions
class StorageException extends AppException {
  const StorageException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'StorageException: $message';
}

class SecureStorageException extends StorageException {
  const SecureStorageException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'SecureStorageException: $message';
}

class FileStorageException extends StorageException {
  const FileStorageException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'FileStorageException: $message';
}

class PermissionException extends AppException {
  const PermissionException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'PermissionException: $message';
}

// Product related exceptions
class ProductException extends AppException {
  const ProductException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'ProductException: $message';
}

class ProductNotFoundException extends ProductException {
  const ProductNotFoundException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'ProductNotFoundException: $message';
}

class RecommendationException extends ProductException {
  const RecommendationException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'RecommendationException: $message';
}

// Scan related exceptions
class ScanException extends AppException {
  const ScanException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'ScanException: $message';
}

class ScanNotFoundException extends ScanException {
  const ScanNotFoundException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'ScanNotFoundException: $message';
}

class ScanSaveException extends ScanException {
  const ScanSaveException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'ScanSaveException: $message';
}

class ScanDeleteException extends ScanException {
  const ScanDeleteException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'ScanDeleteException: $message';
}

// Validation related exceptions
class ValidationException extends AppException {
  final Map<String, List<String>>? fieldErrors;

  const ValidationException({
    required super.message,
    super.code,
    super.details,
    this.fieldErrors,
  });

  @override
  String toString() => 'ValidationException: $message';
}

class InvalidInputException extends ValidationException {
  const InvalidInputException({
    required super.message,
    super.code,
    super.details,
    super.fieldErrors,
  });

  @override
  String toString() => 'InvalidInputException: $message';
}

class InvalidEmailException extends ValidationException {
  const InvalidEmailException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'InvalidEmailException: $message';
}

class InvalidPasswordException extends ValidationException {
  const InvalidPasswordException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'InvalidPasswordException: $message';
}

// Configuration related exceptions
class ConfigurationException extends AppException {
  const ConfigurationException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'ConfigurationException: $message';
}

class FeatureNotAvailableException extends AppException {
  const FeatureNotAvailableException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'FeatureNotAvailableException: $message';
}

// Platform specific exceptions
class PlatformException extends AppException {
  const PlatformException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'PlatformException: $message';
}

class UnsupportedPlatformException extends PlatformException {
  const UnsupportedPlatformException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'UnsupportedPlatformException: $message';
}

// Generic exceptions
class UnknownException extends AppException {
  const UnknownException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'UnknownException: $message';
}

class NotImplementedException extends AppException {
  const NotImplementedException({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'NotImplementedException: $message';
}

// Exception factory for creating exceptions from error responses
class ExceptionFactory {
  static AppException fromError(dynamic error) {
    if (error is AppException) {
      return error;
    }

    if (error is Exception) {
      return UnknownException(
        message: error.toString(),
        details: error,
      );
    }

    return UnknownException(
      message: 'An unknown error occurred',
      details: error,
    );
  }

  static AppException fromHttpError(int statusCode, String message) {
    switch (statusCode) {
      case 400:
        return ValidationException(message: message);
      case 401:
        return InvalidCredentialsException(message: message);
      case 403:
        return AuthException(message: message);
      case 404:
        return DataException(message: message);
      case 408:
        return TimeoutException(message: message);
      case 429:
        return TooManyRequestsException(message: message);
      case 500:
      case 502:
      case 503:
      case 504:
        return ServerException(
          message: message,
          statusCode: statusCode,
        );
      default:
        return NetworkException(message: message);
    }
  }
}
