import 'package:flutter/material.dart';
import 'package:sigma_track/core/extensions/localization_extension.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/feature/notification/domain/entities/notification.dart'
    as app_notif;
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:intl/intl.dart';

class NotificationTile extends StatelessWidget {
  final app_notif.Notification notification;
  final bool isDisabled;
  final bool isSelected;
  final VoidCallback? onTap;
  final ValueChanged<bool?>? onSelect;
  final VoidCallback? onLongPress;

  const NotificationTile({
    super.key,
    required this.notification,
    this.isDisabled = false,
    this.isSelected = false,
    this.onTap,
    this.onSelect,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final Color borderColor = isSelected
        ? context.colorScheme.primary
        : context.colors.border;
    final Color? tileColor = isSelected
        ? context.colorScheme.primaryContainer.withValues(alpha: 0.3)
        : notification.isRead
        ? null
        : context.colorScheme.primaryContainer.withValues(alpha: 0.05);

    return Card(
      elevation: 0,
      color: tileColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor, width: 1.5),
      ),
      child: InkWell(
        onTap: isDisabled
            ? null
            : (onSelect != null ? () => onSelect!(!isSelected) : onTap),
        onLongPress: isDisabled ? null : onLongPress,
        borderRadius: BorderRadius.circular(12),
        child: Opacity(
          opacity: isDisabled ? 0.5 : 1.0,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                if (onSelect != null) ...[
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: isSelected,
                      onChanged: isDisabled ? null : onSelect,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getTypeColor(
                      context,
                      notification.type,
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getTypeIcon(notification.type),
                    color: _getTypeColor(context, notification.type),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (!notification.isRead)
                            Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: context.colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          Expanded(
                            child: AppText(
                              notification.title,
                              style: AppTextStyle.titleMedium,
                              fontWeight: notification.isRead
                                  ? FontWeight.w500
                                  : FontWeight.w600,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      AppText(
                        notification.message,
                        style: AppTextStyle.bodySmall,
                        color: context.colors.textSecondary,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      AppText(
                        _getTimeAgo(context, notification.createdAt),
                        style: AppTextStyle.labelSmall,
                        color: context.colors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getTypeIcon(dynamic type) {
    switch (type.toString().split('.').last) {
      case 'maintenance':
        return Icons.build_outlined;
      case 'issue':
        return Icons.warning_amber_outlined;
      case 'movement':
        return Icons.move_to_inbox_outlined;
      case 'assignment':
        return Icons.assignment_outlined;
      case 'warranty':
        return Icons.verified_user_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _getTypeColor(BuildContext context, dynamic type) {
    switch (type.toString().split('.').last) {
      case 'maintenance':
        return context.semantic.info;
      case 'issue':
        return context.semantic.error;
      case 'movement':
        return context.semantic.warning;
      case 'assignment':
        return context.semantic.success;
      case 'warranty':
        return context.colorScheme.primary;
      default:
        return context.colors.textPrimary;
    }
  }

  String _getTimeAgo(BuildContext context, DateTime dateTime) {
    final Duration difference = DateTime.now().difference(dateTime);

    if (difference.inDays > 7) {
      return DateFormat('dd MMM yyyy').format(dateTime);
    } else if (difference.inDays > 0) {
      return context.l10n.notificationDaysAgo(difference.inDays);
    } else if (difference.inHours > 0) {
      return context.l10n.notificationHoursAgo(difference.inHours);
    } else if (difference.inMinutes > 0) {
      return context.l10n.notificationMinutesAgo(difference.inMinutes);
    } else {
      return context.l10n.notificationJustNow;
    }
  }
}
