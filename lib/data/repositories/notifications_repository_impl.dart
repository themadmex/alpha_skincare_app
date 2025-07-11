// lib/data/repositories/notifications_repository_impl.dart
import 'dart:async';
import '../../domain/entities/notification.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/entities/notification_preferences.dart';
import '../datasources/notifications_local_data_source.dart';
import '../datasources/notifications_remote_data_source.dart';
import '../models/notification_model.dart';
import '../../core/services/connectivity_service.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource _remoteDataSource;
  final NotificationsLocalDataSource _localDataSource;
  final ConnectivityService _connectivityService;

  NotificationsRepositoryImpl({
    required NotificationsRemoteDataSource remoteDataSource,
    required NotificationsLocalDataSource localDataSource,
    required ConnectivityService connectivityService,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _connectivityService = connectivityService;

  @override
  Future<List<AppNotification>> getNotifications() async {
    try {
      // Try to fetch from remote first if connected
      if (await _connectivityService.isConnected()) {
        final remoteNotifications = await _remoteDataSource.getNotifications();

        // Cache notifications locally
        await _localDataSource.cacheNotifications(
          remoteNotifications.map((n) => NotificationModel.fromEntity(n)).toList(),
        );

        return remoteNotifications;
      }
    } catch (e) {
      // Fall back to local cache if remote fails
      print('Failed to fetch remote notifications: $e');
    }

    // Return cached notifications
    final cachedModels = await _localDataSource.getCachedNotifications();
    return cachedModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<AppNotification>> getNotificationsPaginated({
    int page = 1,
    int limit = 20,
    String? type,
    bool? isRead,
  }) async {
    try {
      if (await _connectivityService.isConnected()) {
        return await _remoteDataSource.getNotificationsPaginated(
          page: page,
          limit: limit,
          type: type,
          isRead: isRead,
        );
      }
    } catch (e) {
      print('Failed to fetch paginated notifications: $e');
    }

    // Fall back to local with basic filtering
    final cachedModels = await _localDataSource.getCachedNotifications();
    var notifications = cachedModels.map((model) => model.toEntity()).toList();

    // Apply filters
    if (type != null) {
      notifications = notifications.where((n) => n.type == type).toList();
    }
    if (isRead != null) {
      notifications = notifications.where((n) => n.isRead == isRead).toList();
    }

    // Apply pagination
    final startIndex = (page - 1) * limit;
    final endIndex = startIndex + limit;

    if (startIndex >= notifications.length) return [];

    return notifications.sublist(
      startIndex,
      endIndex > notifications.length ? notifications.length : endIndex,
    );
  }

  @override
  Future<int> getUnreadCount() async {
    try {
      if (await _connectivityService.isConnected()) {
        final count = await _remoteDataSource.getUnreadCount();
        await _localDataSource.cacheUnreadCount(count);
        return count;
      }
    } catch (e) {
      print('Failed to fetch unread count: $e');
    }

    return await _localDataSource.getCachedUnreadCount();
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    // Update locally first for immediate UI response
    await _localDataSource.markAsRead(notificationId);

    // Update remote if connected
    if (await _connectivityService.isConnected()) {
      try {
        await _remoteDataSource.markAsRead(notificationId);
      } catch (e) {
        print('Failed to mark as read remotely: $e');
        // Could implement retry logic here
      }
    }
  }

  @override
  Future<void> markAsUnread(String notificationId) async {
    await _localDataSource.markAsUnread(notificationId);

    if (await _connectivityService.isConnected()) {
      try {
        await _remoteDataSource.markAsUnread(notificationId);
      } catch (e) {
        print('Failed to mark as unread remotely: $e');
      }
    }
  }

  @override
  Future<void> markAllAsRead() async {
    await _localDataSource.markAllAsRead();

    if (await _connectivityService.isConnected()) {
      try {
        await _remoteDataSource.markAllAsRead();
      } catch (e) {
        print('Failed to mark all as read remotely: $e');
      }
    }
  }

  @override
  Future<void> markAllAsReadByType(String type) async {
    await _localDataSource.markAllAsReadByType(type);

    if (await _connectivityService.isConnected()) {
      try {
        await _remoteDataSource.markAllAsReadByType(type);
      } catch (e) {
        print('Failed to mark all as read by type remotely: $e');
      }
    }
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    await _localDataSource.deleteNotification(notificationId);

    if (await _connectivityService.isConnected()) {
      try {
        await _remoteDataSource.deleteNotification(notificationId);
      } catch (e) {
        print('Failed to delete notification remotely: $e');
      }
    }
  }

  @override
  Future<void> deleteAllNotifications() async {
    await _localDataSource.deleteAllNotifications();

    if (await _connectivityService.isConnected()) {
      try {
        await _remoteDataSource.deleteAllNotifications();
      } catch (e) {
        print('Failed to delete all notifications remotely: $e');
      }
    }
  }

  @override
  Future<void> deleteAllByType(String type) async {
    await _localDataSource.deleteAllByType(type);

    if (await _connectivityService.isConnected()) {
      try {
        await _remoteDataSource.deleteAllByType(type);
      } catch (e) {
        print('Failed to delete all by type remotely: $e');
      }
    }
  }

  @override
  Future<AppNotification> createNotification(AppNotification notification) async {
    if (await _connectivityService.isConnected()) {
      final createdNotification = await _remoteDataSource.createNotification(notification);

      // Cache the new notification locally
      await _localDataSource.cacheNotifications([
        NotificationModel.fromEntity(createdNotification),
      ]);

      return createdNotification;
    } else {
      throw Exception('Cannot create notification while offline');
    }
  }

  @override
  Future<AppNotification?> getNotificationById(String notificationId) async {
    try {
      if (await _connectivityService.isConnected()) {
        return await _remoteDataSource.getNotificationById(notificationId);
      }
    } catch (e) {
      print('Failed to fetch notification by ID remotely: $e');
    }

    final cachedModel = await _localDataSource.getNotificationById(notificationId);
    return cachedModel?.toEntity();
  }

  @override
  Stream<List<AppNotification>> watchNotifications() {
    // Combine local and remote streams
    return _localDataSource.watchNotifications().map(
          (models) => models.map((model) => model.toEntity()).toList(),
    );
  }

  @override
  Stream<int> watchUnreadCount() {
    return _localDataSource.watchUnreadCount();
  }

  @override
  Future<void> updateNotificationPreferences(NotificationPreferences preferences) async {
    await _localDataSource.updateNotificationPreferences(preferences);

    if (await _connectivityService.isConnected()) {
      try {
        await _remoteDataSource.updateNotificationPreferences(preferences);
      } catch (e) {
        print('Failed to update notification preferences remotely: $e');
      }
    }
  }

  @override
  Future<NotificationPreferences> getNotificationPreferences() async {
    try {
      if (await _connectivityService.isConnected()) {
        final remotePreferences = await _remoteDataSource.getNotificationPreferences();
        await _localDataSource.updateNotificationPreferences(remotePreferences);
        return remotePreferences;
      }
    } catch (e) {
      print('Failed to fetch notification preferences remotely: $e');
    }

    return await _localDataSource.getNotificationPreferences();
  }

  @override
  Future<void> registerDeviceToken(String token) async {
    await _localDataSource.saveDeviceToken(token);

    if (await _connectivityService.isConnected()) {
      try {
        await _remoteDataSource.registerDeviceToken(token);
      } catch (e) {
        print('Failed to register device token remotely: $e');
      }
    }
  }

  @override
  Future<void> unregisterDevice() async {
    await _localDataSource.clearDeviceToken();

    if (await _connectivityService.isConnected()) {
      try {
        await _remoteDataSource.unregisterDevice();
      } catch (e) {
        print('Failed to unregister device remotely: $e');
      }
    }
  }
}