// lib/data/repositories/profile_repository_impl.dart
import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final Map<String, UserProfile> _profiles = {};

  @override
  Future<UserProfile> createProfile(UserProfile profile) async {
    await Future.delayed(const Duration(seconds: 1));
    _profiles[profile.userId] = profile;
    return profile;
  }

  @override
  Future<UserProfile> updateProfile(UserProfile profile) async {
    await Future.delayed(const Duration(seconds: 1));
    _profiles[profile.userId] = profile;
    return profile;
  }

  @override
  Future<UserProfile?> getProfile(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _profiles[userId];
  }

  @override
  Future<void> deleteProfile(String userId) async {
    await Future.delayed(const Duration(seconds: 1));
    _profiles.remove(userId);
  }
}