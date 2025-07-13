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
