// lib/data/repositories/profile_repository_impl.dart
import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  // In a real app, this would be stored in a database
  final Map<String, UserProfile> _profiles = {};

  @override
  Future<UserProfile> createProfile(UserProfile profile) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final newProfile = profile.copyWith(
      id: 'profile_${DateTime.now().millisecondsSinceEpoch}',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _profiles[newProfile.userId] = newProfile;
    return newProfile;
  }

  @override
  Future<UserProfile> updateProfile(UserProfile profile) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final updatedProfile = profile.copyWith(
      updatedAt: DateTime.now(),
    );

    _profiles[profile.userId] = updatedProfile;
    return updatedProfile;
  }

  @override
  Future<UserProfile?> getProfile(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    // Return mock profile for demonstration
    if (!_profiles.containsKey(userId)) {
      return UserProfile(
        id: 'profile_mock_id',
        userId: userId,
        age: 25,
        gender: 'Female',
        skinType: 'Combination',
        skinConcerns: ['Acne', 'Dark Spots'],
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now().subtract(const Duration(days: 5)),
      );
    }

    return _profiles[userId];
  }

  @override
  Future<void> deleteProfile(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _profiles.remove(userId);
  }
}