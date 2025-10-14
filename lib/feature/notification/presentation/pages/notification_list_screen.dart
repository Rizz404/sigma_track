import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/feature/notification/presentation/widgets/notification_item.dart';

class NotificationListScreen extends ConsumerWidget {
  const NotificationListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Replace dengan provider notifikasi dari backend
    final notifications = <String>[]; // Empty for now

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          // * Mark all as read
          if (notifications.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.done_all),
              tooltip: 'Mark all as read',
              onPressed: () {
                // TODO: Implement mark all as read
              },
            ),
        ],
      ),
      body: notifications.isEmpty
          ? _buildEmptyState(context)
          : _buildNotificationList(context, notifications),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none_outlined,
            size: 80,
            color: context.colors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications yet',
            style: context.textTheme.titleMedium?.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'ll see notifications here when they arrive',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colors.textSecondary.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationList(
    BuildContext context,
    List<String> notifications,
  ) {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        // TODO: Replace dengan notifikasi sebenarnya
        // final notification = notifications[index];
        // return NotificationItem(
        //   notification: notification,
        //   onTap: () {
        //     // TODO: Mark as read & handle tap
        //   },
        //   onDismiss: () {
        //     // TODO: Delete notification
        //   },
        // );
        return const SizedBox();
      },
    );
  }
}
