// lib/presentation/screens/notifications/notifications_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/empty_state_widget.dart';
import '../../providers/notifications_provider.dart';
import '../../../domain/entities/app_notification.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/date_utils.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    // Load notifications when screen is initialized
    Future.microtask(() => ref.read(notificationsControllerProvider.notifier).loadNotifications());
  }

  @override
  Widget build(BuildContext context) {
    final notificationsState = ref.watch(notificationsControllerProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        actions: [
          // Mark all as read button
          if (notificationsState.notifications.any((n) => !n.isRead))
            TextButton(
              onPressed: () {
                ref.read(notificationsControllerProvider.notifier).markAllAsRead();
              },
              child: const Text('Mark all read'),
            ),
          // Settings button
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.go('/settings/notifications'),
          ),
        ],
      ),
      body: _buildBody(notificationsState),
    );
  }

  Widget _buildBody(NotificationsState state) {
    if (state.isLoading) {
      return const Center(child: LoadingWidget());
    }

    if (state.error != null) {
      return _buildErrorState(state.error!);
    }

    if (state.notifications.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.notifications_none_outlined,
        title: 'No notifications yet',
        message: 'When you receive notifications, they\'ll appear here.',
      );
    }

    return _buildNotificationsList(state.notifications);
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading notifications',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              ref.read(notificationsControllerProvider.notifier).loadNotifications();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(List<AppNotification> notifications) {
    // Group notifications by date
    final groupedNotifications = _groupNotificationsByDate(notifications);

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(notificationsControllerProvider.notifier).loadNotifications();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: groupedNotifications.length,
        itemBuilder: (context, index) {
          final entry = groupedNotifications.entries.elementAt(index);
          final date = entry.key;
          final dayNotifications = entry.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (index > 0) const SizedBox(height: 24),
              _buildDateHeader(date),
              const SizedBox(height: 12),
              ...dayNotifications.map((notification) =>
                  _buildNotificationItem(notification),
              ).toList(),
            ],
          );
        },
      ),
    );
  }

  Map<String, List<AppNotification>> _groupNotificationsByDate(
      List<AppNotification> notifications,
      ) {
    final Map<String, List<AppNotification>> grouped = {};

    for (final notification in notifications) {
      final dateKey = AppDateUtils.formatDateGrouping(notification.createdAt);
      grouped.putIfAbsent(dateKey, () => []).add(notification);
    }

    return grouped;
  }

  Widget _buildDateHeader(String date) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        date,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(AppNotification notification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: notification.isRead ? Colors.white : Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        elevation: 0.5,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _handleNotificationTap(notification),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNotificationIcon(notification.type),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            AppDateUtils.formatTimeAgo(notification.createdAt),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.body,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: notification.isRead ? Colors.grey[600] : Colors.grey[800],
                        ),
                      ),
                      if (notification.actionUrl != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Tap to view',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (!notification.isRead) ...[
                  const SizedBox(width: 8),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.grey[400],
                    size: 20,
                  ),
                  onSelected: (value) => _handleMenuAction(value, notification),
                  itemBuilder: (context) => [
                    if (!notification.isRead)
                      const PopupMenuItem(
                        value: 'mark_read',
                        child: Text('Mark as read'),
                      ),
                    if (notification.isRead)
                      const PopupMenuItem(
                        value: 'mark_unread',
                        child: Text('Mark as unread'),
                      ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(String type) {
    IconData icon;
    Color color;

    switch (type) {
      case AppConstants.notificationTypeReminder:
        icon = Icons.alarm_outlined;
        color = Colors.orange;
        break;
      case AppConstants.notificationTypeTip:
        icon = Icons.lightbulb_outline;
        color = Colors.amber;
        break;
      case AppConstants.notificationTypeProgress:
        icon = Icons.trending_up_outlined;
        color = Colors.green;
        break;
      case AppConstants.notificationTypePromotion:
        icon = Icons.local_offer_outlined;
        color = Colors.purple;
        break;
      case AppConstants.notificationTypeUpdate:
        icon = Icons.system_update_outlined;
        color = Colors.blue;
        break;
      default:
        icon = Icons.notifications_outlined;
        color = Colors.grey;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: color,
        size: 20,
      ),
    );
  }

  void _handleNotificationTap(AppNotification notification) {
    // Mark as read when tapped
    if (!notification.isRead) {
      ref.read(notificationsControllerProvider.notifier).markAsRead(notification.id);
    }

    // Handle navigation based on actionUrl
    if (notification.actionUrl != null) {
      final url = notification.actionUrl!;

      // Handle internal navigation
      if (url.startsWith('/')) {
        context.go(url);
      } else {
        // Handle external URLs or specific actions
        _handleExternalAction(url);
      }
    }
  }

  void _handleExternalAction(String url) {
    // Handle external URLs, deep links, or custom actions
    // This could involve launching URLs, opening specific screens, etc.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening: $url')),
    );
  }

  void _handleMenuAction(String action, AppNotification notification) {
    switch (action) {
      case 'mark_read':
        ref.read(notificationsControllerProvider.notifier).markAsRead(notification.id);
        break;
      case 'mark_unread':
        ref.read(notificationsControllerProvider.notifier).markAsUnread(notification.id);
        break;
      case 'delete':
        _showDeleteConfirmation(notification);
        break;
    }
  }

  void _showDeleteConfirmation(AppNotification notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Notification'),
        content: const Text('Are you sure you want to delete this notification?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(notificationsControllerProvider.notifier).deleteNotification(notification.id);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}