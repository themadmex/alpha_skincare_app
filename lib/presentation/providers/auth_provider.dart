import 'package:firebase_auth/firebase_auth.dart' as app_user;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user.dart' as app_user;
import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';

/// Authentication state that extends ChangeNotifier for navigation reactivity
class AuthState extends ChangeNotifier {
  final bool isAuthenticated;
  final bool isProfileComplete;
  final bool isLoading;
  final app_user.User? user;
  final String? error;

  AuthState({
    this.isAuthenticated = false,
    this.isProfileComplete = false,
    this.isLoading = false,
    this.user,
    this.error,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isProfileComplete,
    bool? isLoading,
    app_user.User? user,
    String? error,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }
}

/// Main authentication state provider
final authStateProvider = ChangeNotifierProvider<AuthState>((ref) {
  return AuthState();
});

/// Authentication service provider
final authServiceProvider = Provider<AuthService>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final prefs = ref.watch(sharedPreferencesProvider);
  return AuthService(
    ref: ref,
    authRepository: authRepository,
    prefs: prefs,
  );
});

/// Authentication repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  // This will be replaced with actual implementation
  return AuthRepositoryImpl();
});

/// Firebase auth provider
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

/// Current Firebase user stream
final authUserStreamProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

/// Shared preferences provider (defined in main.dart)
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences not initialized');
});

/// Authentication service with business logic
class AuthService {
  final Ref _ref;
  final AuthRepository _authRepository;
  final SharedPreferences _prefs;

  static const String _firstTimeKey = 'is_first_time_user';
  static const String _profileCompleteKey = 'is_profile_complete';

  AuthService({
    required Ref ref,
    required AuthRepository authRepository,
    required SharedPreferences prefs,
  })  : _ref = ref,
        _authRepository = authRepository,
        _prefs = prefs {
    // Initialize auth state listener
    _initializeAuthListener();
  }

  /// Initialize Firebase auth state listener
  void _initializeAuthListener() {
    FirebaseAuth.instance.authStateChanges().listen((User? firebaseUser) async {
      final authState = _ref.read(authStateProvider);

      if (firebaseUser != null) {
        // User is signed in
        try {
          final user = await _authRepository.getCurrentUser();
          final isProfileComplete = _prefs.getBool(_profileCompleteKey) ?? false;

          authState
            ..isAuthenticated = true
            ..isProfileComplete = isProfileComplete
            ..user = user
            ..notifyListeners();
        } catch (e) {
          // Handle error fetching user data
          authState
            ..isAuthenticated = true
            ..isProfileComplete = false
            ..error = e.toString()
            ..notifyListeners();
        }
      } else {
        // User is signed out
        authState
          ..isAuthenticated = false
          ..isProfileComplete = false
          ..user = null
          ..notifyListeners();
      }
    });
  }

  /// Sign in with email and password
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    final authState = _ref.read(authStateProvider);

    authState
      ..isLoading = true
      ..error = null
      ..notifyListeners();

    try {
      final user = await _authRepository.signInWithEmail(
        email: email,
        password: password,
      );

      final isProfileComplete = _prefs.getBool(_profileCompleteKey) ?? false;

      authState
        ..isAuthenticated = true
        ..isProfileComplete = isProfileComplete
        ..user = user
        ..isLoading = false
        ..notifyListeners();
    } catch (e) {
      authState
        ..isLoading = false
        ..error = _getErrorMessage(e)
        ..notifyListeners();
      rethrow;
    }
  }

  /// Sign up with email and password
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final authState = _ref.read(authStateProvider);

    authState
      ..isLoading = true
      ..error = null
      ..notifyListeners();

    try {
      final user = await _authRepository.signUpWithEmail(
        name: name,
        email: email,
        password: password,
      );

      // Mark as first time user
      await _prefs.setBool(_firstTimeKey, false);
      await _prefs.setBool(_profileCompleteKey, false);

      authState
        ..isAuthenticated = true
        ..isProfileComplete = false
        ..user = user
        ..isLoading = false
        ..notifyListeners();
    } catch (e) {
      authState
        ..isLoading = false
        ..error = _getErrorMessage(e)
        ..notifyListeners();
      rethrow;
    }
  }

  /// Sign in with Google
  Future<void> signInWithGoogle() async {
    final authState = _ref.read(authStateProvider);

    authState
      ..isLoading = true
      ..error = null
      ..notifyListeners();

    try {
      final user = await _authRepository.signInWithGoogle();

      // Check if profile is complete for social sign in
      final isProfileComplete = user.skinType != null && user.skinConcerns.isNotEmpty;
      await _prefs.setBool(_profileCompleteKey, isProfileComplete);

      authState
        ..isAuthenticated = true
        ..isProfileComplete = isProfileComplete
        ..user = user
        ..isLoading = false
        ..notifyListeners();
    } catch (e) {
      authState
        ..isLoading = false
        ..error = _getErrorMessage(e)
        ..notifyListeners();
      rethrow;
    }
  }

  /// Sign in with Apple
  Future<void> signInWithApple() async {
    final authState = _ref.read(authStateProvider);

    authState
      ..isLoading = true
      ..error = null
      ..notifyListeners();

    try {
      final user = await _authRepository.signInWithApple();

      // Check if profile is complete for social sign in
      final isProfileComplete = user.skinType != null && user.skinConcerns.isNotEmpty;
      await _prefs.setBool(_profileCompleteKey, isProfileComplete);

      authState
        ..isAuthenticated = true
        ..isProfileComplete = isProfileComplete
        ..user = user
        ..isLoading = false
        ..notifyListeners();
    } catch (e) {
      authState
        ..isLoading = false
        ..error = _getErrorMessage(e)
        ..notifyListeners();
      rethrow;
    }
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    final authState = _ref.read(authStateProvider);

    authState
      ..isLoading = true
      ..error = null
      ..notifyListeners();

    try {
      await _authRepository.resetPassword(email);

      authState
        ..isLoading = false
        ..notifyListeners();
    } catch (e) {
      authState
        ..isLoading = false
        ..error = _getErrorMessage(e)
        ..notifyListeners();
      rethrow;
    }
  }

  /// Update user profile
  Future<void> updateProfile({
    String? name,
    String? photoUrl,
    String? skinType,
    List<String>? skinConcerns,
    int? ageRange,
    String? gender,
  }) async {
    final authState = _ref.read(authStateProvider);

    authState
      ..isLoading = true
      ..error = null
      ..notifyListeners();

    try {
      final updatedUser = await _authRepository.updateUserProfile(
        name: name,
        photoUrl: photoUrl,
        skinType: skinType,
        skinConcerns: skinConcerns,
        ageRange: ageRange,
        gender: gender,
      );

      // Check if profile is now complete
      final isProfileComplete = updatedUser.skinType != null &&
          updatedUser.skinConcerns.isNotEmpty;
      await _prefs.setBool(_profileCompleteKey, isProfileComplete);

      authState
        ..user = updatedUser
        ..isProfileComplete = isProfileComplete
        ..isLoading = false
        ..notifyListeners();
    } catch (e) {
      authState
        ..isLoading = false
        ..error = _getErrorMessage(e)
        ..notifyListeners();
      rethrow;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    final authState = _ref.read(authStateProvider);

    authState
      ..isLoading = true
      ..notifyListeners();

    try {
      await _authRepository.signOut();

      // Clear local preferences
      await _prefs.remove(_profileCompleteKey);

      authState
        ..isAuthenticated = false
        ..isProfileComplete = false
        ..user = null
        ..isLoading = false
        ..error = null
        ..notifyListeners();
    } catch (e) {
      authState
        ..isLoading = false
        ..error = _getErrorMessage(e)
        ..notifyListeners();
      rethrow;
    }
  }

  /// Check if first time user
  Future<bool> isFirstTimeUser() async {
    return _prefs.getBool(_firstTimeKey) ?? true;
  }

  /// Mark user as not first time
  Future<void> markNotFirstTimeUser() async {
    await _prefs.setBool(_firstTimeKey, false);
  }

  /// Get error message from exception
  String _getErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'No user found with this email.';
        case 'wrong-password':
          return 'Wrong password provided.';
        case 'email-already-in-use':
          return 'An account already exists with this email.';
        case 'invalid-email':
          return 'Invalid email address.';
        case 'weak-password':
          return 'Password should be at least 6 characters.';
        case 'network-request-failed':
          return 'Network error. Please check your connection.';
        case 'too-many-requests':
          return 'Too many attempts. Please try again later.';
        default:
          return 'An error occurred. Please try again.';
      }
    }
    return error.toString();
  }
}

// Temporary model classes until we create proper entities
class AuthRepository {
  Future<app_user.User> getCurrentUser() async {
    throw UnimplementedError();
  }

  Future<app_user.User> signInWithEmail({
    required String email,
    required String password,
  }) async {
    throw UnimplementedError();
  }

  Future<app_user.User> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    throw UnimplementedError();
  }

  Future<app_user.User> signInWithGoogle() async {
    throw UnimplementedError();
  }

  Future<app_user.User> signInWithApple() async {
    throw UnimplementedError();
  }

  Future<void> resetPassword(String email) async {
    throw UnimplementedError();
  }

  Future<app_user.User> updateUserProfile({
    String? name,
    String? photoUrl,
    String? skinType,
    List<String>? skinConcerns,
    int? ageRange,
    String? gender,
  }) async {
    throw UnimplementedError();
  }

  Future<void> signOut() async {
    throw UnimplementedError();
  }
}

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<app_user.User> getCurrentUser() async {
    throw UnimplementedError();
  }

  @override
  Future<app_user.User> signInWithEmail({
    required String email,
    required String password,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<app_user.User> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<app_user.User> signInWithGoogle() async {
    throw UnimplementedError();
  }

  @override
  Future<app_user.User> signInWithApple() async {
    throw UnimplementedError();
  }

  @override
  Future<void> resetPassword(String email) async {
    throw UnimplementedError();
  }

  @override
  Future<app_user.User> updateUserProfile({
    String? name,
    String? photoUrl,
    String? skinType,
    List<String>? skinConcerns,
    int? ageRange,
    String? gender,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() async {
    throw UnimplementedError();
  }
}