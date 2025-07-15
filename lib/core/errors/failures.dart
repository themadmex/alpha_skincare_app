import 'package:equatable/equatable.dart';

// Base failure class
abstract class Failure extends Equatable {
  final String message;
  final String? code;
  final dynamic details;

  const Failure({
    required this.message,
    this.code,
    this.details,
  });

  @override
  List<Object?> get props => [message, code, details];

  @override
  String toString() => 'Failure: $message';
}

// Network related failures
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'NetworkFailure: $message';
}

class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({
    required super.message,
    super.code,
    super.details,
    this.statusCode,
  });

  @override
  List<Object?> get props => [message, code, details, statusCode];

  @override
  String toString() => 'ServerFailure: $message (Status: $statusCode)';
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'TimeoutFailure: $message';
}

class ConnectionFailure extends Failure {
  const ConnectionFailure({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'ConnectionFailure: $message';
}

// Authentication related failures
class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'AuthFailure: $message';
}

class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'InvalidCredentialsFailure: $message';
}

class UserNotFoundFailure extends AuthFailure {
  const UserNotFoundFailure({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'UserNotFoundFailure: $message';
}

class EmailAlreadyInUseFailure extends AuthFailure {
  const EmailAlreadyInUseFailure({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'EmailAlreadyInUseFailure: $message';
}

class WeakPasswordFailure extends AuthFailure {
  const WeakPasswordFailure({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'WeakPasswordFailure: $message';
}

class AccountDisabledFailure extends AuthFailure {
  const AccountDisabledFailure({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'AccountDisabledFailure: $message';
}

class EmailNotVerifiedFailure extends AuthFailure {
  const EmailNotVerifiedFailure({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'EmailNotVerifiedFailure: $message';
}

class TooManyRequestsFailure extends AuthFailure {
  const TooManyRequestsFailure({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'TooManyRequestsFailure: $message';
}

// Data related failures
class DataFailure extends Failure {
  const DataFailure({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'DataFailure: $message';
}

class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'CacheFailure: $message';
}

class DatabaseFailure extends Failure {
  const DatabaseFailure({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'DatabaseFailure: $message';
}

class SerializationFailure extends Failure {
  const SerializationFailure({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'SerializationFailure: $message';
}

// Camera and ML related failures
class CameraFailure extends Failure {
  const CameraFailure({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'CameraFailure: $message';
}

class CameraPermissionFailure extends CameraFailure {
  const CameraPermissionFailure({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'CameraPermissionFailure: $message';
}

class CameraInitializationFailure extends CameraFailure {
  const CameraInitializationFailure({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'CameraInitializationFailure: $message';
}

class ImageCaptureFailure extends CameraFailure {
  const ImageCaptureFailure({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'ImageCaptureFailure: $message';
}

class MLFailure extends Failure {
  const MLFailure({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'MLFailure: $message';
}

class ModelLoadFailure extends MLFailure {
  const ModelLoadFailure({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'ModelLoadFailure: $message';
}

class ImageProcessingFailure extends MLFailure {
  const ImageProcessingFailure({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'ImageProcessingFailure: $message';
}

class AnalysisFailure extends MLFailure {
  const AnalysisFailure({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'AnalysisFailure: $message';
}

class InferenceFailure extends MLFailure {
  const InferenceFailure({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'InferenceFailure: $message';
}

// Storage related failures
class StorageFailure extends Failure {
  const StorageFailure({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'StorageFailure: $message';
}

class SecureStorageFailure extends StorageFailure {
  const SecureStorageFailure({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'SecureStorageFailure: $message';
}

class FileStorageFailure extends StorageFailure {
  const FileStorageFailure({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'FileStorageFailure: $message';
}

class PermissionFailure extends Failure {
  const PermissionFailure({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'PermissionFailure: $message';
}

// Product related failures
class ProductFailure extends Failure {
  const ProductFailure({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'ProductFailure: $message';
}

class ProductNotFoundFailure extends ProductFailure {
  const ProductNotFoundFailure({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'ProductNotFoundFailure: $message';
}

class RecommendationFailure extends ProductFailure {
  const RecommendationFailure({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'RecommendationFailure: $message';
}

// Scan related failures
class ScanFailure extends Failure {
  const ScanFailure({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'ScanFailure: $message';
}

class ScanNotFoundFailure extends ScanFailure {
  const ScanNotFoundFailure({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'ScanNotFoundFailure: $message';
}

class ScanSaveFailure extends ScanFailure {
  const ScanSaveFailure({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'ScanSaveFailure: $message';
}

class ScanDeleteFailure extends ScanFailure {
  const ScanDeleteFailure({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'ScanDeleteFailure: $message';
}

// Validation related failures
class ValidationFailure extends Failure {
  final Map<String, List<String>>? fieldErrors;

  const ValidationFailure({
    required super.message,
    super.code,
    super.details,
    this.fieldErrors,
  });

  @override
  List<Object?> get props => [message, code, details, fieldErrors];

  @override
  String toString() => 'ValidationFailure: $message';
}

class InvalidInputFailure extends ValidationFailure {
  const InvalidInputFailure({
    required super.message,
    super.code,
    super.details,
    super.fieldErrors,
  });

  @override
  String toString() => 'InvalidInputFailure: $message';
}

class InvalidEmailFailure extends ValidationFailure {
  const InvalidEmailFailure({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'InvalidEmailFailure: $message';
}

class InvalidPasswordFailure extends ValidationFailure {
  const InvalidPasswordFailure({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'InvalidPasswordFailure: $message';
}

// Configuration related failures
class ConfigurationFailure extends Failure {
  const ConfigurationFailure({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'ConfigurationFailure: $message';
}

class FeatureNotAvailableFailure extends Failure {
  const FeatureNotAvailableFailure({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'FeatureNotAvailableFailure: $message';
}

// Platform specific failures
class PlatformFailure extends Failure {
  const PlatformFailure({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'PlatformFailure: $message';
}

class UnsupportedPlatformFailure extends PlatformFailure {
  const UnsupportedPlatformFailure({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'UnsupportedPlatformFailure: $message';
}

// Generic failures
class UnknownFailure extends Failure {
  const UnknownFailure({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'UnknownFailure: $message';
}

class NotImplementedFailure extends Failure {
  const NotImplementedFailure({
    required super.message,
    super.code,
    super.details,
  });

  @override
  String toString() => 'NotImplementedFailure: $message';
}

// Failure factory for creating failures from exceptions
class FailureFactory {
  static Failure fromException(Exception exception) {
    // You can add specific exception to failure mapping here
    if (exception.toString().contains('network')) {
      return NetworkFailure(message: exception.toString());
    }

    if (exception.toString().contains('timeout')) {
      return TimeoutFailure(message: exception.toString());
    }

    if (exception.toString().contains('auth')) {
      return AuthFailure(message: exception.toString());
    }

    if (exception.toString().contains('camera')) {
      return CameraFailure(message: exception.toString());
    }

    if (exception.toString().contains('storage')) {
      return StorageFailure(message: exception.toString());
    }

    return UnknownFailure(
      message: exception.toString(),
      details: exception,
    );
  }

  static Failure fromHttpError(int statusCode, String message) {
    switch (statusCode) {
      case 400:
        return ValidationFailure(message: message);
      case 401:
        return InvalidCredentialsFailure(message: message);
      case 403:
        return AuthFailure(message: message);
      case 404:
        return DataFailure(message: message);
      case 408:
        return TimeoutFailure(message: message);
      case 429:
        return TooManyRequestsFailure(message: message);
      case 500:
      case 502:
      case 503:
      case 504:
        return ServerFailure(
          message: message,
          statusCode: statusCode,
        );
      default:
        return NetworkFailure(message: message);
    }
  }

  static Failure fromString(String error) {
    return UnknownFailure(
      message: error,
      details: error,
    );
  }
}
