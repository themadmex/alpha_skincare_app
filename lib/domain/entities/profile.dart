// lib/domain/entities/profile.dart
class UserProfile {
  final String id;
  final String userId;
  final int age;
  final String gender;
  final String skinType;
  final List<String> skinConcerns;
  final String? skinTone;
  final List<String>? allergies;
  final List<String>? currentProducts;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserProfile({
    required this.id,
    required this.userId,
    required this.age,
    required this.gender,
    required this.skinType,
    required this.skinConcerns,
    this.skinTone,
    this.allergies,
    this.currentProducts,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  UserProfile copyWith({
    String? id,
    String? userId,
    int? age,
    String? gender,
    String? skinType,
    List<String>? skinConcerns,
    String? skinTone,
    List<String>? allergies,
    List<String>? currentProducts,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      skinType: skinType ?? this.skinType,
      skinConcerns: skinConcerns ?? this.skinConcerns,
      skinTone: skinTone ?? this.skinTone,
      allergies: allergies ?? this.allergies,
      currentProducts: currentProducts ?? this.currentProducts,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'age': age,
      'gender': gender,
      'skinType': skinType,
      'skinConcerns': skinConcerns,
      'skinTone': skinTone,
      'allergies': allergies,
      'currentProducts': currentProducts,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      userId: json['userId'] as String,
      age: json['age'] as int,
      gender: json['gender'] as String,
      skinType: json['skinType'] as String,
      skinConcerns: List<String>.from(json['skinConcerns'] as List),
      skinTone: json['skinTone'] as String?,
      allergies: json['allergies'] != null
          ? List<String>.from(json['allergies'] as List)
          : null,
      currentProducts: json['currentProducts'] != null
          ? List<String>.from(json['currentProducts'] as List)
          : null,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'UserProfile(id: $id, userId: $userId, age: $age, skinType: $skinType)';
  }
}