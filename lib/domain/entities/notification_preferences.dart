// lib/domain/entities/notification_preferences.dart
class NotificationPreferences {
  final String userId;
  final bool remindersEnabled;
  final bool tipsEnabled;
  final bool progressEnabled;
  final bool promotionsEnabled;
  final bool updatesEnabled;
  final bool pushNotificationsEnabled;
  final bool emailNotificationsEnabled;
  final String reminderTime;
  final List<String> reminderDays;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final DateTime updatedAt;

  const NotificationPreferences({
    required this.userId,
    this.remindersEnabled = true,
    this.tipsEnabled = true,
    this.progressEnabled = true,
    this.promotionsEnabled = false,
    this.updatesEnabled = true,
    this.pushNotificationsEnabled = true,
    this.emailNotificationsEnabled = false,
    this.reminderTime = "20:00",
    this.reminderDays = const ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"],
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    required this.updatedAt,
  });

  NotificationPreferences copyWith({
    String? userId,
    bool? remindersEnabled,
    bool? tipsEnabled,
    bool? progressEnabled,
    bool? promotionsEnabled,
    bool? updatesEnabled,
    bool? pushNotificationsEnabled,
    bool? emailNotificationsEnabled,
    String? reminderTime,
    List<String>? reminderDays,
    bool? soundEnabled,
    bool? vibrationEnabled,
    DateTime? updatedAt,
  }) {
    return NotificationPreferences(
      userId: userId ?? this.userId,
      remindersEnabled: remindersEnabled ?? this.remindersEnabled,
      tipsEnabled: tipsEnabled ?? this.tipsEnabled,
      progressEnabled: progressEnabled ?? this.progressEnabled,
      promotionsEnabled: promotionsEnabled ?? this.promotionsEnabled,
      updatesEnabled: updatesEnabled ?? this.updatesEnabled,
      pushNotificationsEnabled: pushNotificationsEnabled ?? this.pushNotificationsEnabled,
      emailNotificationsEnabled: emailNotificationsEnabled ?? this.emailNotificationsEnabled,
      reminderTime: reminderTime ?? this.reminderTime,
      reminderDays: reminderDays ?? this.reminderDays,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'remindersEnabled': remindersEnabled,
      'tipsEnabled': tipsEnabled,
      'progressEnabled': progressEnabled,
      'promotionsEnabled': promotionsEnabled,
      'updatesEnabled': updatesEnabled,
      'pushNotificationsEnabled': pushNotificationsEnabled,
      'emailNotificationsEnabled': emailNotificationsEnabled,
      'reminderTime': reminderTime,
      'reminderDays': reminderDays,
      'soundEnabled': soundEnabled,
      'vibrationEnabled': vibrationEnabled,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      userId: json['userId'] as String,
      remindersEnabled: json['remindersEnabled'] as bool? ?? true,
      tipsEnabled: json['tipsEnabled'] as bool? ?? true,
      progressEnabled: json['progressEnabled'] as bool? ?? true,
      promotionsEnabled: json['promotionsEnabled'] as bool? ?? false,
      updatesEnabled: json['updatesEnabled'] as bool? ?? true,
      pushNotificationsEnabled: json['pushNotificationsEnabled'] as bool? ?? true,
      emailNotificationsEnabled: json['emailNotificationsEnabled'] as bool? ?? false,
      reminderTime: json['reminderTime'] as String? ?? "20:00",
      reminderDays: List<String>.from(json['reminderDays'] as List? ??
          ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]),
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      vibrationEnabled: json['vibrationEnabled'] as bool? ?? true,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificationPreferences && other.userId == userId;
  }

  @override
  int get hashCode => userId.hashCode;
}