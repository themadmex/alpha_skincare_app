// Notifications Provider (if not already implemented)
// lib/presentation/providers/notifications_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/notifications_repository.dart';

// Mock repository for demonstration
final notificationsRepositoryProvider = Provider<NotificationsRepository>((ref) {
  return MockNotificationsRepository();
});

// Notifications State
class NotificationsState {
  final List<AppNotification> notifications;
  final bool isLoading;
  final String? error;

  const NotificationsState({
    this.notifications = const [],
    this.isLoading = false,
    this.error,
  });

  NotificationsState copyWith({
    List<AppNotification>? notifications,
    bool? isLoading,
    String? error,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// Notifications Controller
class NotificationsController extends StateNotifier<NotificationsState> {
  final NotificationsRepository _repository;

  NotificationsController(this._repository) : super(const NotificationsState());

  Future<void> loadNotifications() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final notifications = await _repository.getNotifications();
      state = state.copyWith(
        isLoading: false,
        notifications: notifications,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _repository.markAsRead(notificationId);
      final updatedNotifications = state.notifications.map((n) {
        if (n.id == notificationId) {
          return n.copyWith(isRead: true, readAt: DateTime.now());
        }
        return n;
      }).toList();

      state = state.copyWith(notifications: updatedNotifications);
    } catch (e) {
      // Handle error silently or show a snackbar
    }
  }

  Future<void> markAsUnread(String notificationId) async {
    try {
      await _repository.markAsUnread(notificationId);
      final updatedNotifications = state.notifications.map((n) {
        if (n.id == notificationId) {
          return n.copyWith(isRead: false, readAt: null);
        }
        return n;
      }).toList();

      state = state.copyWith(notifications: updatedNotifications);
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _repository.markAllAsRead();
      final updatedNotifications = state.notifications.map((n) {
        return n.copyWith(isRead: true, readAt: DateTime.now());
      }).toList();

      state = state.copyWith(notifications: updatedNotifications);
    } catch (e) {
      // Handle error
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      await _repository.deleteNotification(notificationId);
      final updatedNotifications = state.notifications
          .where((n) => n.id != notificationId)
          .toList();

      state = state.copyWith(notifications: updatedNotifications);
    } catch (e) {
      // Handle error
    }
  }
}

// Provider
final notificationsControllerProvider = StateNotifierProvider<NotificationsController, NotificationsState>((ref) {
  final repository = ref.watch(notificationsRepositoryProvider);
  return NotificationsController(repository);
});

// Mock Repository (replace with actual implementation)
abstract class NotificationsRepository {
  Future<List<AppNotification>> getNotifications();
  Future<void> markAsRead(String notificationId);
  Future<void> markAsUnread(String notificationId);
  Future<void> markAllAsRead();
  Future<void> deleteNotification(String notificationId);
}

class MockNotificationsRepository implements NotificationsRepository {
  final List<AppNotification> _notifications = [
    AppNotification(
      id: '1',
      userId: 'user123',
      type: AppConstants.notificationTypeReminder,
      title: 'Time for your skincare routine!',
      body: 'Don\'t forget your evening skincare routine. Your skin will thank you!',
      actionUrl: '/scan',
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    AppNotification(
      id: '2',
      userId: 'user123',
      type: AppConstants.notificationTypeTip,
      title: 'Weekly Skin Tip',
      body: 'Did you know that drinking plenty of water helps maintain skin hydration?',
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    AppNotification(
      id: '3',
      userId: 'user123',
      type: AppConstants.notificationTypeProgress,
      title: 'Great progress this week!',
      body: 'Your skin health score improved by 15% this week. Keep up the good work!',
      actionUrl: '/progress',
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      readAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  @override
  Future<List<AppNotification>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
    return List.from(_notifications);
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    // In real implementation, this would make an API call
  }

  @override
  Future<void> markAsUnread(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    // In real implementation, this would make an API call
  }

  @override
  Future<void> markAllAsRead() async {
    await Future.delayed(const Duration(milliseconds: 300));
    // In real implementation, this would make an API call
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _notifications.removeWhere((n) => n.id == notificationId);
  }
}