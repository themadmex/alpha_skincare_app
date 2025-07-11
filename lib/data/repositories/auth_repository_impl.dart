// lib/data/repositories/auth_repository_impl.dart
import 'dart:async';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final StreamController<User?> _authStateController = StreamController<User?>.broadcast();
  User? _currentUser;

  @override
  Future<User> signUp(String email, String password, String name) async {
    await Future.delayed(const Duration(seconds: 2));

    if (email.isEmpty || password.length < 6) {
      throw Exception('Invalid email or password too short');
    }

    _currentUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      name: name,
      createdAt: DateTime.now(),
      isActive: true,
    );

    _authStateController.add(_currentUser);
    return _currentUser!;
  }

  @override
  Future<User> signIn(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));

    // Mock credentials check
    if (email == 'demo@skinsense.com' && password == 'password123') {
      _currentUser = User(
        id: '1',
        email: email,
        name: 'Demo User',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        isActive: true,
      );
      _authStateController.add(_currentUser);
      return _currentUser!;
    }

    throw Exception('Invalid credentials');
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(seconds: 1));
    _currentUser = null;
    _authStateController.add(null);
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await Future.delayed(const Duration(seconds: 2));

    if (email.isEmpty) {
      throw Exception('Email is required');
    }

    if (!email.contains('@')) {
      throw Exception('Invalid email address');
    }

    // Mock implementation - in real app, this would send an email
  }

  @override
  Future<User?> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _currentUser;
  }

  @override
  Future<void> updateProfile(User user) async {  // Explicitly typed as User
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = user;
    _authStateController.add(user);
  }

  @override
  Future<void> deleteAccount() async {
    await Future.delayed(const Duration(seconds: 1));
    _currentUser = null;
    _authStateController.add(null);
  }

  @override
  Stream<User?> get authStateChanges {
    return _authStateController.stream;
  }

  // Clean up resources
  void dispose() {
    _authStateController.close();
  }
}