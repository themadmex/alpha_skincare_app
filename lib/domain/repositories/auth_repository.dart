// lib/domain/repositories/auth_repository.dart
import 'package:firebase_auth/firebase_auth.dart';

import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> signUp(String email, String password, String name);
  Future<User> signIn(String email, String password);
  Future<void> signOut();
  Future<void> sendPasswordResetEmail(String email);
  Future<User?> getCurrentUser();
  Future<void> updateProfile(User user);
  Future<void> deleteAccount();
  Stream<User?> get authStateChanges;
}