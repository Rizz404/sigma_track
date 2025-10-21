import 'package:flutter/material.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/extensions/date_time_extension.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/feature/notification/domain/entities/notification.dart'
    as entity;

/// Notification item widget
class NotificationItem extends StatelessWidget {
  final entity.Notification notification;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  const NotificationItem({
    super.key,
    required this.notification,
    this.onTap,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss?.call(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        color: context.colorScheme.error,
        child: Icon(Icons.delete_outline, color: context.colorScheme.onError),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: notification.isRead
                ? context.colors.surface
                : context.colorScheme.primaryContainer.withValues(alpha: 0.1),
            border: Border(
              bottom: BorderSide(color: context.colors.border, width: 1),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // * Notification icon
              _buildIcon(context),
              const SizedBox(width: 12),

              // * Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // * Title
                    Text(
                      notification.title,
                      style: context.textTheme.titleSmall?.copyWith(
                        fontWeight: notification.isRead
                            ? FontWeight.normal
                            : FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // * Message
                    Text(
                      notification.message,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.colors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // * Time
                    Text(
                      notification.createdAt.timeAgo,
                      style: context.textTheme.labelSmall?.copyWith(
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // * Unread indicator
              if (!notification.isRead)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(left: 8, top: 6),
                  decoration: BoxDecoration(
                    color: context.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    final (icon, color) = _getIconAndColor(context);

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  (IconData, Color) _getIconAndColor(BuildContext context) {
    switch (notification.type) {
      case NotificationType.maintenance:
        return (Icons.build_outlined, context.colorScheme.primary);
      case NotificationType.warranty:
        return (Icons.verified_outlined, Colors.blue);
      case NotificationType.statusChange:
        return (Icons.swap_horiz_outlined, Colors.orange);
      case NotificationType.movement:
        return (Icons.local_shipping_outlined, Colors.purple);
      case NotificationType.issueReport:
        return (Icons.warning_amber_outlined, context.colorScheme.error);
    }
  }
}
