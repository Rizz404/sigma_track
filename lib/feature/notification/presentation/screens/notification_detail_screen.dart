import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sigma_track/core/enums/helper_enums.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/extensions/localization_extension.dart';
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
    } else if (_notification != null && !_notification!.isRead) {
      // * Auto mark as read ketika notification detail screen dibuka
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _markNotificationAsRead();
      });
    }
  }

  Future<void> _markNotificationAsRead() async {
    if (_notification == null) return;

    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    if (isAdmin) {
      await ref
          .read(notificationsProvider.notifier)
          .markAsRead(_notification!.id);
    } else {
      await ref
          .read(myNotificationsProvider.notifier)
          .markAsRead(_notification!.id);
    }
  }

  Future<void> _fetchNotification() async {
    setState(() => _isLoading = true);

    try {
      if (widget.id != null) {
        // * Watch provider (build method akan fetch otomatis)
        final state = ref.read(getNotificationByIdProvider(widget.id!));

        if (state.notification != null) {
          setState(() {
            _notification = state.notification;
            _isLoading = false;
          });
        } else if (state.failure != null) {
          this.logError('Failed to fetch notification by id', state.failure);
          AppToast.error(
            state.failure?.message ?? 'Failed to load notification',
          );
          setState(() => _isLoading = false);
        } else {
          // * State masih loading, tunggu dengan listen
          setState(() => _isLoading = false);
        }
      }
    } catch (e, s) {
      this.logError('Error fetching notification', e, s);
      AppToast.error('Failed to load notification');
      setState(() => _isLoading = false);
    }
  }

  void _handleDelete() async {
    if (_notification == null) return;

    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    if (!isAdmin) {
      AppToast.warning(context.l10n.notificationOnlyAdminCanDelete);
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: AppText(
          context.l10n.notificationDeleteNotification,
          style: AppTextStyle.titleMedium,
        ),
        content: AppText(
          context.l10n.notificationDeleteConfirmation,
          style: AppTextStyle.bodyMedium,
        ),
        actionsAlignment: MainAxisAlignment.end,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: AppText(context.l10n.notificationCancel),
          ),
          const SizedBox(width: 8),
          AppButton(
            text: context.l10n.notificationDelete,
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
    // * Listen only for delete operation (notification detail doesn't have update)
    ref.listen<NotificationsState>(notificationsProvider, (previous, next) {
      // * Only handle delete mutation
      if (next.mutation?.type == MutationType.delete) {
        if (next.hasMutationSuccess) {
          AppToast.success(
            next.mutationMessage ?? context.l10n.notificationDeleted,
          );
          context.pop();
        } else if (next.hasMutationError) {
          this.logError('Delete error', next.mutationFailure);
          AppToast.error(
            next.mutationFailure?.message ??
                context.l10n.notificationDeleteFailed,
          );
        }
      }
    });

    final isLoading = _isLoading || _notification == null;

    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    return Scaffold(
      appBar: CustomAppBar(title: context.l10n.notificationDetail),
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
          _buildInfoCard(context.l10n.notificationInformation, [
            _buildInfoRow(
              context.l10n.notificationTitle,
              dummyNotification.title,
            ),
            _buildInfoRow(
              context.l10n.notificationMessage,
              dummyNotification.message,
            ),
            _buildInfoRow(
              context.l10n.notificationType,
              dummyNotification.type.name,
            ),
            _buildInfoRow(
              context.l10n.notificationPriority,
              dummyNotification.priority.name,
            ),
            _buildInfoRow(
              context.l10n.notificationIsRead,
              dummyNotification.isRead
                  ? context.l10n.notificationYes
                  : context.l10n.notificationNo,
            ),
            _buildInfoRow(
              context.l10n.notificationCreatedAt,
              _formatDateTime(dummyNotification.createdAt),
            ),
            if (dummyNotification.expiresAt != null)
              _buildInfoRow(
                context.l10n.notificationExpiresAt,
                _formatDateTime(dummyNotification.expiresAt!),
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
          _buildInfoCard(context.l10n.notificationInformation, [
            _buildInfoRow(context.l10n.notificationTitle, _notification!.title),
            _buildTextBlock(
              context.l10n.notificationMessage,
              _notification!.message,
            ),
            _buildInfoRow(
              context.l10n.notificationType,
              _notification!.type.name,
            ),
            _buildInfoRow(
              context.l10n.notificationPriority,
              _notification!.priority.name,
            ),
            _buildInfoRow(
              context.l10n.notificationIsRead,
              _notification!.isRead
                  ? context.l10n.notificationYes
                  : context.l10n.notificationNo,
            ),
            _buildInfoRow(
              context.l10n.notificationCreatedAt,
              _formatDateTime(_notification!.createdAt),
            ),
            if (_notification!.expiresAt != null)
              _buildInfoRow(
                context.l10n.notificationExpiresAt,
                _formatDateTime(_notification!.expiresAt!),
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

  Widget _buildTextBlock(String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            label,
            style: AppTextStyle.bodyMedium,
            color: context.colors.textSecondary,
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.colors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: context.colors.border),
            ),
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
