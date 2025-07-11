// lib/data/datasources/notifications_remote_data_source.dart
import '../../domain/entities/app_notification.dart';
import '../../domain/entities/notification.dart';
import '../../domain/entities/notification_preferences.dart';

abstract class NotificationsRemoteDataSource {
  Future<List<AppNotification>> getNotifications();
  Future<List<AppNotification>> getNotificationsPaginated({
    int page = 1,
    int limit = 20,
    String? type,
    bool? isRead,
  });
  Future<int> getUnreadCount();
  Future<void> markAsRead(String notificationId);
  Future<void> markAsUnread(String notificationId);
  Future<void> markAllAsRead();
  Future<void> markAllAsReadByType(String type);
  Future<void> deleteNotification(String notificationId);
  Future<void> deleteAllNotifications();
  Future<void> deleteAllByType(String type);
  Future<AppNotification> createNotification(AppNotification notification);
  Future<AppNotification?> getNotificationById(String notificationId);
  Future<void> updateNotificationPreferences(NotificationPreferences preferences);
  Future<NotificationPreferences> getNotificationPreferences();
  Future<void> registerDeviceToken(String token);
  Future<void> unregisterDevice();
}