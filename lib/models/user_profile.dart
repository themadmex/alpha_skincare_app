enum UserRole { free, premium, admin }

enum SubscriptionStatus { active, inactive, cancelled, expired }

enum SkinType { oily, dry, combination, normal, sensitive }

class UserProfile {
  final String id;
  final String email;
  final String fullName;
  final UserRole role;
  final SkinType? skinType;
  final DateTime? dateOfBirth;
  final String? profileImageUrl;
  final SubscriptionStatus subscriptionStatus;
  final DateTime? subscriptionExpiresAt;
  final int scansRemaining;
  final int totalScansUsed;
  final Map<String, dynamic> preferences;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserProfile({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    this.skinType,
    this.dateOfBirth,
    this.profileImageUrl,
    required this.subscriptionStatus,
    this.subscriptionExpiresAt,
    required this.scansRemaining,
    required this.totalScansUsed,
    required this.preferences,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String,
      role: UserRole.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => UserRole.free,
      ),
      skinType: json['skin_type'] != null
          ? SkinType.values.firstWhere(
              (e) => e.name == json['skin_type'],
              orElse: () => SkinType.normal,
            )
          : null,
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'])
          : null,
      profileImageUrl: json['profile_image_url'],
      subscriptionStatus: SubscriptionStatus.values.firstWhere(
        (e) => e.name == json['subscription_status'],
        orElse: () => SubscriptionStatus.inactive,
      ),
      subscriptionExpiresAt: json['subscription_expires_at'] != null
          ? DateTime.parse(json['subscription_expires_at'])
          : null,
      scansRemaining: json['scans_remaining'] ?? 0,
      totalScansUsed: json['total_scans_used'] ?? 0,
      preferences: Map<String, dynamic>.from(json['preferences'] ?? {}),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'role': role.name,
      'skin_type': skinType?.name,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'profile_image_url': profileImageUrl,
      'subscription_status': subscriptionStatus.name,
      'subscription_expires_at': subscriptionExpiresAt?.toIso8601String(),
      'scans_remaining': scansRemaining,
      'total_scans_used': totalScansUsed,
      'preferences': preferences,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  UserProfile copyWith({
    String? id,
    String? email,
    String? fullName,
    UserRole? role,
    SkinType? skinType,
    DateTime? dateOfBirth,
    String? profileImageUrl,
    SubscriptionStatus? subscriptionStatus,
    DateTime? subscriptionExpiresAt,
    int? scansRemaining,
    int? totalScansUsed,
    Map<String, dynamic>? preferences,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      skinType: skinType ?? this.skinType,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
      subscriptionExpiresAt:
          subscriptionExpiresAt ?? this.subscriptionExpiresAt,
      scansRemaining: scansRemaining ?? this.scansRemaining,
      totalScansUsed: totalScansUsed ?? this.totalScansUsed,
      preferences: preferences ?? this.preferences,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isPremium =>
      role == UserRole.premium &&
      subscriptionStatus == SubscriptionStatus.active;
  bool get canScan => isPremium || scansRemaining > 0;
}
