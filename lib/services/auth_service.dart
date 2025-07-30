import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';
import '../models/user_profile.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final SupabaseService _supabaseService = SupabaseService();

  // Get current user
  Future<User?> getCurrentUser() async {
    final auth = await _supabaseService.auth;
    return auth.currentUser;
  }

  // Get current user profile
  Future<UserProfile?> getCurrentUserProfile() async {
    final user = await getCurrentUser();
    if (user == null) return null;

    try {
      final response = await _supabaseService.from('user_profiles');
      final data = await response.select().eq('id', user.id).single();
      return UserProfile.fromJson(data);
    } catch (e) {
      throw Exception('Failed to fetch user profile: $e');
    }
  }

  // Sign up with email and password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final auth = await _supabaseService.auth;
      final response = await auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'role': 'free',
        },
      );
      return response;
    } catch (e) {
      throw Exception('Sign-up failed: $e');
    }
  }

  // Sign in with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final auth = await _supabaseService.auth;
      final response = await auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      throw Exception('Sign-in failed: $e');
    }
  }

  // Sign in with Google OAuth
  Future<bool> signInWithGoogle() async {
    try {
      final auth = await _supabaseService.auth;
      return await auth.signInWithOAuth(OAuthProvider.google);
    } catch (e) {
      throw Exception('Google sign-in failed: $e');
    }
  }

  // Sign in with Apple OAuth
  Future<bool> signInWithApple() async {
    try {
      final auth = await _supabaseService.auth;
      return await auth.signInWithOAuth(OAuthProvider.apple);
    } catch (e) {
      throw Exception('Apple sign-in failed: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      final auth = await _supabaseService.auth;
      await auth.signOut();
    } catch (e) {
      throw Exception('Sign-out failed: $e');
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      final auth = await _supabaseService.auth;
      await auth.resetPasswordForEmail(email);
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }

  // Update user profile
  Future<UserProfile> updateUserProfile({
    required String userId,
    String? fullName,
    SkinType? skinType,
    DateTime? dateOfBirth,
    String? profileImageUrl,
    Map<String, dynamic>? preferences,
  }) async {
    try {
      final updateData = <String, dynamic>{};

      if (fullName != null) updateData['full_name'] = fullName;
      if (skinType != null) updateData['skin_type'] = skinType.name;
      if (dateOfBirth != null)
        updateData['date_of_birth'] = dateOfBirth.toIso8601String();
      if (profileImageUrl != null)
        updateData['profile_image_url'] = profileImageUrl;
      if (preferences != null) updateData['preferences'] = preferences;

      updateData['updated_at'] = DateTime.now().toIso8601String();

      final response = await _supabaseService.from('user_profiles');
      final data =
          await response.update(updateData).eq('id', userId).select().single();

      return UserProfile.fromJson(data);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  // Update subscription status (admin function)
  Future<UserProfile> updateSubscriptionStatus({
    required String userId,
    required UserRole role,
    required SubscriptionStatus status,
    DateTime? expiresAt,
  }) async {
    try {
      final updateData = {
        'role': role.name,
        'subscription_status': status.name,
        'subscription_expires_at': expiresAt?.toIso8601String(),
        'scans_remaining': role == UserRole.premium ? 999 : 5,
        'updated_at': DateTime.now().toIso8601String(),
      };

      final response = await _supabaseService.from('user_profiles');
      final data =
          await response.update(updateData).eq('id', userId).select().single();

      return UserProfile.fromJson(data);
    } catch (e) {
      throw Exception('Failed to update subscription: $e');
    }
  }

  // Listen to auth state changes
  Stream<AuthState> get authStateChanges async* {
    final auth = await _supabaseService.auth;
    yield* auth.onAuthStateChange;
  }

  // Check if user is authenticated
  Future<bool> get isAuthenticated async {
    final user = await getCurrentUser();
    return user != null;
  }

  // Decrement scan count after successful analysis
  Future<void> decrementScanCount(String userId) async {
    try {
      final profile = await getCurrentUserProfile();
      if (profile != null && !profile.isPremium && profile.scansRemaining > 0) {
        final response = await _supabaseService.from('user_profiles');
        await response.update({
          'scans_remaining': profile.scansRemaining - 1,
          'total_scans_used': profile.totalScansUsed + 1,
          'updated_at': DateTime.now().toIso8601String(),
        }).eq('id', userId);
      }
    } catch (e) {
      throw Exception('Failed to update scan count: $e');
    }
  }
}
