// lib/data/repositories/auth_repository_impl.dart
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final StreamController<User?> _authStateController = StreamController<User?>.broadcast();
  User? _currentUser;

  @override
  Stream<User?> get authStateChanges => _authStateController.stream;

  @override
  Future<User> signUp(String email, String password, String name) async {
    // Mock implementation - replace with actual authentication logic
    await Future.delayed(const Duration(seconds: 1));

    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      throw Exception('All fields are required');
    }

    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    final user = User(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      name: name,
      createdAt: DateTime.now(),
      isActive: true,
    );

    _currentUser = user;
    _authStateController.add(user);

    return user;
  }

  @override
  Future<User> signIn(String email, String password) async {
    // Mock implementation - replace with actual authentication logic
    await Future.delayed(const Duration(seconds: 1));

    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password are required');
    }

    // Mock validation
    if (email == 'test@example.com' && password == 'password123') {
      final user = User(
        id: 'user_mock_id',
        email: email,
        name: 'Test User',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        emailVerifiedAt: DateTime.now().subtract(const Duration(days: 29)),
        isActive: true,
      );

      _currentUser = user;
      _authStateController.add(user);

      return user;
    } else {
      throw Exception('Invalid email or password');
    }
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
    _authStateController.add(null);
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await Future.delayed(const Duration(seconds: 1));

    if (email.isEmpty) {
      throw Exception('Email is required');
    }

    // Mock implementation - in real app, this would send an email
    // For now, we'll just simulate success
  }

  @override
  Future<User?> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _currentUser;
  }

  @override
  Future<void> updateProfile(User user) async {
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
}
