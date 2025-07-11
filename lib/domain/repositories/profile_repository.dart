// lib/domain/repositories/profile_repository.dart
import '../entities/profile.dart';

abstract class ProfileRepository {
  Future<UserProfile> createProfile(UserProfile profile);
  Future<UserProfile> updateProfile(UserProfile profile);
  Future<UserProfile?> getProfile(String userId);
  Future<void> deleteProfile(String userId);
}