// lib/domain/repositories/auth_repository.dart
import '../../domain/entities/user.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> signUp(String email, String password, String name);
  Future<User> signIn(String email, String password);
  Future<void> signOut();
  Future<void> sendPasswordResetEmail(String email);
  Future<User?> getCurrentUser();
  Future<void> updateProfile(User user);  // Make sure this is User, not dynamic
  Future<void> deleteAccount();
  Stream<User?> get authStateChanges;
}