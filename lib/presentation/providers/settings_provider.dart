// lib/presentation/providers/settings_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final settingsProvider = NotifierProvider<SettingsController, AppSettings>(() {
  return SettingsController();
});

class AppSettings {
  final ThemeMode themeMode;
  final bool notificationsEnabled;
  final bool scanReminders;
  final bool routineReminders;
  final TimeOfDay reminderTime;
  final bool soundEnabled;
  final String language;

  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.notificationsEnabled = true,
    this.scanReminders = true,
    this.routineReminders = true,
    this.reminderTime = const TimeOfDay(hour: 20, minute: 0),
    this.soundEnabled = true,
    this.language = 'en',
  });

  AppSettings copyWith({
    ThemeMode? themeMode,
    bool? notificationsEnabled,
    bool? scanReminders,
    bool? routineReminders,
    TimeOfDay? reminderTime,
    bool? soundEnabled,
    String? language,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      scanReminders: scanReminders ?? this.scanReminders,
      routineReminders: routineReminders ?? this.routineReminders,
      reminderTime: reminderTime ?? this.reminderTime,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      language: language ?? this.language,
    );
  }
}

class SettingsController extends Notifier<AppSettings> {
  @override
  AppSettings build() {
    _loadSettings();
    return const AppSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final themeIndex = prefs.getInt('theme_mode') ?? 0;
    final themeMode = ThemeMode.values[themeIndex];

    state = AppSettings(
      themeMode: themeMode,
      notificationsEnabled: prefs.getBool('notifications_enabled') ?? true,
      scanReminders: prefs.getBool('scan_reminders') ?? true,
      routineReminders: prefs.getBool('routine_reminders') ?? true,
      reminderTime: TimeOfDay(
        hour: prefs.getInt('reminder_hour') ?? 20,
        minute: prefs.getInt('reminder_minute') ?? 0,
      ),
      soundEnabled: prefs.getBool('sound_enabled') ?? true,
      language: prefs.getString('language') ?? 'en',
    );
  }

  Future<void> updateThemeMode(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme_mode', themeMode.index);
    state = state.copyWith(themeMode: themeMode);
  }

  Future<void> updateNotificationSettings({
    bool? notificationsEnabled,
    bool? scanReminders,
    bool? routineReminders,
    TimeOfDay? reminderTime,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    if (notificationsEnabled != null) {
      await prefs.setBool('notifications_enabled', notificationsEnabled);
    }
    if (scanReminders != null) {
      await prefs.setBool('scan_reminders', scanReminders);
    }
    if (routineReminders != null) {
      await prefs.setBool('routine_reminders', routineReminders);
    }
    if (reminderTime != null) {
      await prefs.setInt('reminder_hour', reminderTime.hour);
      await prefs.setInt('reminder_minute', reminderTime.minute);
    }

    state = state.copyWith(
      notificationsEnabled: notificationsEnabled,
      scanReminders: scanReminders,
      routineReminders: routineReminders,
      reminderTime: reminderTime,
    );
  }
}