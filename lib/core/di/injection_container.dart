// lib/core/di/injection_container.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Repository implementations (simplified for now)
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../data/repositories/scan_repository_impl.dart';
import '../../data/repositories/recommendations_repository_impl.dart';

// Domain repositories
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/repositories/recommendation_repository.dart';
import '../../domain/repositories/scan_repository.dart';
import '../../domain/repositories/recommendations_repository.dart';

// Repository Providers using Riverpod
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl();
});

final scanRepositoryProvider = Provider<ScanRepository>((ref) {
  return ScanRepositoryImpl();
});

final recommendationsRepositoryProvider = Provider<RecommendationsRepository>((ref) {
  return RecommendationsRepositoryImpl();
});

// Use case providers
final loginUsecaseProvider = Provider<LoginUsecase>((ref) {
  return LoginUsecase(ref.watch(authRepositoryProvider));
});

final signupUsecaseProvider = Provider<SignupUsecase>((ref) {
  return SignupUsecase(ref.watch(authRepositoryProvider));
});

final logoutUsecaseProvider = Provider<LogoutUsecase>((ref) {
  return LogoutUsecase(ref.watch(authRepositoryProvider));
});

final forgotPasswordUsecaseProvider = Provider<ForgotPasswordUsecase>((ref) {
  return ForgotPasswordUsecase(ref.watch(authRepositoryProvider));
});

final getProfileUsecaseProvider = Provider<GetProfileUsecase>((ref) {
  return GetProfileUsecase(ref.watch(profileRepositoryProvider));
});

final updateProfileUsecaseProvider = Provider<UpdateProfileUsecase>((ref) {
  return UpdateProfileUsecase(ref.watch(profileRepositoryProvider));
});

final analyzeSkinUsecaseProvider = Provider<AnalyzeSkinUsecase>((ref) {
  return AnalyzeSkinUsecase(ref.watch(scanRepositoryProvider));
});

final getScanHistoryUsecaseProvider = Provider<GetScanHistoryUsecase>((ref) {
  return GetScanHistoryUsecase(ref.watch(scanRepositoryProvider));
});

final getRecommendationsUsecaseProvider = Provider<GetRecommendationsUsecase>((ref) {
  return GetRecommendationsUsecase(ref.watch(recommendationsRepositoryProvider));
});

// Simple use case implementations

// lib/domain/usecases/auth/login_usecase.dart
class LoginUsecase {
  final AuthRepository _repository;

  LoginUsecase(this._repository);

  Future<void> call(String email, String password) async {
    await _repository.signIn(email, password);
  }
}

// lib/domain/usecases/auth/signup_usecase.dart
class SignupUsecase {
  final AuthRepository _repository;

  SignupUsecase(this._repository);

  Future<void> call(String email, String password, String name) async {
    await _repository.signUp(email, password, name);
  }
}

// lib/domain/usecases/auth/logout_usecase.dart
class LogoutUsecase {
  final AuthRepository _repository;

  LogoutUsecase(this._repository);

  Future<void> call() async {
    await _repository.signOut();
  }
}

// lib/domain/usecases/auth/forgot_password_usecase.dart
class ForgotPasswordUsecase {
  final AuthRepository _repository;

  ForgotPasswordUsecase(this._repository);

  Future<void> call(String email) async {
    await _repository.sendPasswordResetEmail(email);
  }
}

// lib/domain/usecases/profile/get_profile_usecase.dart
class GetProfileUsecase {
  final ProfileRepository _repository;

  GetProfileUsecase(this._repository);

  Future<dynamic> call(String userId) async {
    return await _repository.getProfile(userId);
  }
}

// lib/domain/usecases/profile/update_profile_usecase.dart
class UpdateProfileUsecase {
  final ProfileRepository _repository;

  UpdateProfileUsecase(this._repository);

  Future<dynamic> call(dynamic profile) async {
    return await _repository.updateProfile(profile);
  }
}

// lib/domain/usecases/scan/analyze_skin_usecase.dart
class AnalyzeSkinUsecase {
  final ScanRepository _repository;

  AnalyzeSkinUsecase(this._repository);

  Future<dynamic> call(String imagePath) async {
    return await _repository.analyzeSkin(imagePath);
  }
}

// lib/domain/usecases/scan/get_scan_history_usecase.dart
class GetScanHistoryUsecase {
  final ScanRepository _repository;

  GetScanHistoryUsecase(this._repository);

  Future<List<dynamic>> call(String userId) async {
    return await _repository.getScanHistory(userId);
  }
}

// lib/domain/usecases/recommendations/get_recommendations_usecase.dart
class GetRecommendationsUsecase {
  final RecommendationsRepository _repository;

  GetRecommendationsUsecase(this._repository);

  Future<List<dynamic>> call(String userId) async {
    return await _repository.getRecommendations(userId);
  }
}

// Simple network info implementation (no external dependencies)
class NetworkInfo {
  Future<bool> get isConnected async {
    // Simple implementation - in real app you'd check actual connectivity
    return true;
  }
}

final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfo();
});

// Simple HTTP client wrapper (no external dependencies)
class SimpleHttpClient {
  Future<Map<String, dynamic>> get(String url) async {
    // Mock implementation - replace with actual HTTP calls when needed
    await Future.delayed(const Duration(milliseconds: 500));
    return {'success': true, 'data': []};
  }

  Future<Map<String, dynamic>> post(String url, Map<String, dynamic> data) async {
    // Mock implementation - replace with actual HTTP calls when needed
    await Future.delayed(const Duration(milliseconds: 800));
    return {'success': true, 'data': data};
  }

  Future<Map<String, dynamic>> put(String url, Map<String, dynamic> data) async {
    // Mock implementation - replace with actual HTTP calls when needed
    await Future.delayed(const Duration(milliseconds: 600));
    return {'success': true, 'data': data};
  }

  Future<Map<String, dynamic>> delete(String url) async {
    // Mock implementation - replace with actual HTTP calls when needed
    await Future.delayed(const Duration(milliseconds: 400));
    return {'success': true};
  }
}

final httpClientProvider = Provider<SimpleHttpClient>((ref) {
  return SimpleHttpClient();
});

// Simple storage implementation (no external dependencies)
class SimpleStorage {
  final Map<String, dynamic> _storage = {};

  Future<void> setString(String key, String value) async {
    _storage[key] = value;
  }

  Future<String?> getString(String key) async {
    return _storage[key] as String?;
  }

  Future<void> setBool(String key, bool value) async {
    _storage[key] = value;
  }

  Future<bool?> getBool(String key) async {
    return _storage[key] as bool?;
  }

  Future<void> remove(String key) async {
    _storage.remove(key);
  }

  Future<void> clear() async {
    _storage.clear();
  }
}

final storageProvider = Provider<SimpleStorage>((ref) {
  return SimpleStorage();
});

// Initialization function (no async needed now)
void initDependencies() {
  // All dependencies are now handled by Riverpod providers
  // No need for manual initialization
  print('✅ Dependencies initialized with Riverpod');
}