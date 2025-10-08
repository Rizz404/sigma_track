import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/core/utils/toast_utils.dart';
import 'package:sigma_track/di/auth_providers.dart';
import 'package:sigma_track/feature/notification/domain/entities/notification.dart'
    as notification_entity;
import 'package:sigma_track/feature/notification/domain/usecases/delete_notification_usecase.dart';
import 'package:sigma_track/feature/notification/presentation/providers/notification_providers.dart';
import 'package:sigma_track/feature/notification/presentation/providers/state/notifications_state.dart';
import 'package:sigma_track/shared/presentation/widgets/app_detail_action_buttons.dart';
import 'package:sigma_track/shared/presentation/widgets/app_button.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:sigma_track/shared/presentation/widgets/app_end_drawer.dart';
import 'package:sigma_track/shared/presentation/widgets/custom_app_bar.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NotificationDetailScreen extends ConsumerStatefulWidget {
  final notification_entity.Notification? notification;
  final String? id;

  const NotificationDetailScreen({super.key, this.notification, this.id});

  @override
  ConsumerState<NotificationDetailScreen> createState() =>
      _NotificationDetailScreenState();
}

class _NotificationDetailScreenState
    extends ConsumerState<NotificationDetailScreen> {
  notification_entity.Notification? _notification;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _notification = widget.notification;
    if (_notification == null && widget.id != null) {
      _fetchNotification();
    }
  }

  Future<void> _fetchNotification() async {
    setState(() => _isLoading = true);
    // TODO: Implement fetch notification logic
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
  }

  void _handleDelete() async {
    if (_notification == null) return;

    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    if (!isAdmin) {
      AppToast.warning('Only admin can delete notifications');
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const AppText(
          'Delete Notification',
          style: AppTextStyle.titleMedium,
        ),
        content: AppText(
          'Are you sure you want to delete this notification?',
          style: AppTextStyle.bodyMedium,
        ),
        actionsAlignment: MainAxisAlignment.end,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const AppText('Cancel'),
          ),
          const SizedBox(width: 8),
          AppButton(
            text: 'Delete',
            color: AppButtonColor.error,
            isFullWidth: false,
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref
          .read(notificationsProvider.notifier)
          .deleteNotification(
            DeleteNotificationUsecaseParams(id: _notification!.id),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<NotificationsState>(notificationsProvider, (previous, next) {
      if (!next.isMutating && next.message != null && next.failure == null) {
        AppToast.success(next.message ?? 'Operation successful');
        if (previous?.isMutating == true) {
          Navigator.pop(context);
        }
      } else if (next.failure != null) {
        this.logError('Notification mutation error', next.failure);
        AppToast.error(next.failure?.message ?? 'Operation failed');
      }
    });

    final isLoading = _isLoading || _notification == null;

    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    return Scaffold(
      appBar: CustomAppBar(title: 'Notification Detail'),
      endDrawer: const AppEndDrawer(),
      body: Skeletonizer(
        enabled: isLoading,
        child: Column(
          children: [
            Expanded(
              child: ScreenWrapper(
                child: isLoading ? _buildLoadingContent() : _buildContent(),
              ),
            ),
            if (!isLoading && isAdmin)
              AppDetailActionButtons(onDelete: _handleDelete),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingContent() {
    final dummyNotification = notification_entity.Notification.dummy();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard('Notification Information', [
            _buildInfoRow('Title', dummyNotification.title),
            _buildInfoRow('Message', dummyNotification.message),
            _buildInfoRow('Type', dummyNotification.type.name),
            _buildInfoRow('Is Read', dummyNotification.isRead ? 'Yes' : 'No'),
            _buildInfoRow(
              'Created At',
              _formatDateTime(dummyNotification.createdAt),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard('Notification Information', [
            _buildInfoRow('Title', _notification!.title),
            _buildInfoRow('Message', _notification!.message),
            _buildInfoRow('Type', _notification!.type.name),
            _buildInfoRow('Is Read', _notification!.isRead ? 'Yes' : 'No'),
            _buildInfoRow(
              'Created At',
              _formatDateTime(_notification!.createdAt),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      color: context.colors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: context.colors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              title,
              style: AppTextStyle.titleMedium,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: AppText(
              label,
              style: AppTextStyle.bodyMedium,
              color: context.colors.textSecondary,
            ),
          ),
          Expanded(
            flex: 3,
            child: AppText(
              value,
              style: AppTextStyle.bodyMedium,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
