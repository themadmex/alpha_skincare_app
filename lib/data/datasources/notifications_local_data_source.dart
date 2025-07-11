// lib/data/datasources/notifications_local_data_source.dart
import '../models/notification_model.dart';
import '../../domain/entities/notification_preferences.dart';

abstract class NotificationsLocalDataSource {
  Future<List<NotificationModel>> getCachedNotifications();
  Future<void> cacheNotifications(List<NotificationModel> notifications);
  Future<int> getCachedUnreadCount();
  Future<void> cacheUnreadCount(int count);
  Future<void> markAsRead(String notificationId);
  Future<void> markAsUnread(String notificationId);
  Future<void> markAllAsRead();
  Future<void> markAllAsReadByType(String type);
  Future<void> deleteNotification(String notificationId);
  Future<void> deleteAllNotifications();
  Future<void> deleteAllByType(String type);
  Future<NotificationModel?> getNotificationById(String notificationId);
  Stream<List<NotificationModel>> watchNotifications();
  Stream<int> watchUnreadCount();
  Future<void> updateNotificationPreferences(NotificationPreferences preferences);
  Future<NotificationPreferences> getNotificationPreferences();
  Future<void> saveDeviceToken(String token);
  Future<void> clearDeviceToken();
}