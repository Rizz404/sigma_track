import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sigma_track/core/constants/route_constant.dart';
import 'package:sigma_track/core/enums/helper_enums.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/extensions/localization_extension.dart';
import 'package:sigma_track/core/extensions/num_extension.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/core/utils/toast_utils.dart';
import 'package:sigma_track/di/auth_providers.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_schedule.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/delete_maintenance_schedule_usecase.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/maintenance_providers.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/state/maintenance_schedules_state.dart';
import 'package:sigma_track/shared/presentation/widgets/app_detail_action_buttons.dart';
import 'package:sigma_track/shared/presentation/widgets/app_button.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:sigma_track/shared/presentation/widgets/app_end_drawer.dart';
import 'package:sigma_track/shared/presentation/widgets/custom_app_bar.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MaintenanceScheduleDetailScreen extends ConsumerStatefulWidget {
  final MaintenanceSchedule? maintenanceSchedule;
  final String? id;

  const MaintenanceScheduleDetailScreen({
    super.key,
    this.maintenanceSchedule,
    this.id,
  });

  @override
  ConsumerState<MaintenanceScheduleDetailScreen> createState() =>
      _MaintenanceScheduleDetailScreenState();
}

class _MaintenanceScheduleDetailScreenState
    extends ConsumerState<MaintenanceScheduleDetailScreen> {
  void _handleEdit(MaintenanceSchedule schedule) {
    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    if (isAdmin) {
      context.push(
        RouteConstant.adminMaintenanceScheduleUpsert,
        extra: schedule,
      );
    } else {
      AppToast.warning(context.l10n.maintenanceScheduleOnlyAdminCanEdit);
    }
  }

  void _handleDelete(MaintenanceSchedule schedule) async {
    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    if (!isAdmin) {
      AppToast.warning(context.l10n.maintenanceScheduleOnlyAdminCanDelete);
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: AppText(
          context.l10n.maintenanceScheduleDeleteSchedule,
          style: AppTextStyle.titleMedium,
        ),
        content: AppText(
          context.l10n.maintenanceScheduleDeleteConfirmation(schedule.title),
          style: AppTextStyle.bodyMedium,
        ),
        actionsAlignment: MainAxisAlignment.end,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: AppText(context.l10n.maintenanceScheduleCancel),
          ),
          const SizedBox(width: 8),
          AppButton(
            text: context.l10n.maintenanceScheduleDelete,
            color: AppButtonColor.error,
            isFullWidth: false,
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref
          .read(maintenanceSchedulesProvider.notifier)
          .deleteMaintenanceSchedule(
            DeleteMaintenanceScheduleUsecaseParams(id: schedule.id),
          );
    }
  }

  void _handleCopy(MaintenanceSchedule schedule) {
    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    if (isAdmin) {
      context.push(
        RouteConstant.adminMaintenanceScheduleUpsert,
        extra: {'copyFromSchedule': schedule},
      );
    } else {
      AppToast.warning(context.l10n.maintenanceScheduleOnlyAdminCanCopy);
    }
  }

  @override
  Widget build(BuildContext context) {
    // * Determine schedule source: extra > fetch by id
    MaintenanceSchedule? schedule = widget.maintenanceSchedule;
    bool isLoading = false;
    String? errorMessage;

    // * If no schedule from extra, fetch by id
    if (schedule == null && widget.id != null) {
      final state = ref.watch(getMaintenanceScheduleByIdProvider(widget.id!));
      schedule = state.maintenanceSchedule;
      isLoading = state.isLoading;
      errorMessage = state.failure?.message;
    }

    // * Listen only for delete operation
    ref.listen<MaintenanceSchedulesState>(maintenanceSchedulesProvider, (
      previous,
      next,
    ) {
      if (next.mutation?.type == MutationType.delete) {
        if (next.hasMutationSuccess) {
          AppToast.success(
            next.mutationMessage ?? context.l10n.maintenanceScheduleDeleted,
          );
          context.pop();
        } else if (next.hasMutationError) {
          this.logError('Delete error', next.mutationFailure);
          AppToast.error(
            next.mutationFailure?.message ??
                context.l10n.maintenanceScheduleDeleteFailed,
          );
        }
      }
    });

    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    return Scaffold(
      appBar: CustomAppBar(
        title: schedule?.title ?? context.l10n.maintenanceScheduleDetail,
      ),
      endDrawer: const AppEndDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: _buildBody(
        schedule: schedule,
        isLoading: isLoading,
        isAdmin: isAdmin,
        errorMessage: errorMessage,
      ),
    );
  }

  Widget _buildBody({
    required MaintenanceSchedule? schedule,
    required bool isLoading,
    required bool isAdmin,
    String? errorMessage,
  }) {
    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText(errorMessage, style: AppTextStyle.bodyMedium),
            const SizedBox(height: 16),
            AppButton(
              text: context.l10n.maintenanceScheduleCancel,
              onPressed: () => context.pop(),
            ),
          ],
        ),
      );
    }

    return Skeletonizer(
      enabled: isLoading || schedule == null,
      child: Column(
        children: [
          Expanded(
            child: ScreenWrapper(
              child: isLoading || schedule == null
                  ? _buildLoadingContent()
                  : _buildContent(schedule),
            ),
          ),
          if (!isLoading && schedule != null && isAdmin)
            AppDetailActionButtons(
              onEdit: () => _handleEdit(schedule),
              onDelete: () => _handleDelete(schedule),
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingContent() {
    final dummySchedule = MaintenanceSchedule.dummy();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(context.l10n.maintenanceScheduleInformation, [
            _buildInfoRow(
              context.l10n.maintenanceScheduleTitle,
              dummySchedule.title,
            ),
            _buildInfoRow(
              context.l10n.maintenanceScheduleDescription,
              dummySchedule.description ?? '-',
            ),
            _buildInfoRow(
              context.l10n.maintenanceScheduleAsset,
              dummySchedule.asset?.assetName ??
                  context.l10n.maintenanceScheduleUnknownAsset,
            ),
            _buildInfoRow(
              context.l10n.maintenanceScheduleMaintenanceType,
              dummySchedule.maintenanceType.name,
            ),
            _buildInfoRow(
              context.l10n.maintenanceScheduleIsRecurring,
              dummySchedule.isRecurring
                  ? context.l10n.maintenanceScheduleYes
                  : context.l10n.maintenanceScheduleNo,
            ),
            _buildInfoRow(
              context.l10n.maintenanceScheduleInterval,
              dummySchedule.intervalValue != null &&
                      dummySchedule.intervalUnit != null
                  ? '${dummySchedule.intervalValue} ${dummySchedule.intervalUnit!.label}'
                  : '-',
            ),
            _buildInfoRow(
              context.l10n.maintenanceScheduleScheduledTime,
              dummySchedule.scheduledTime ?? '-',
            ),
            _buildInfoRow(
              context.l10n.maintenanceScheduleNextScheduledDate,
              _formatDateTime(dummySchedule.nextScheduledDate),
            ),
            _buildInfoRow(
              context.l10n.maintenanceScheduleLastExecutedDate,
              dummySchedule.lastExecutedDate != null
                  ? _formatDateTime(dummySchedule.lastExecutedDate!)
                  : '-',
            ),
            _buildInfoRow(
              context.l10n.maintenanceScheduleState,
              dummySchedule.state.name,
            ),
            _buildInfoRow(
              context.l10n.maintenanceScheduleAutoComplete,
              dummySchedule.autoComplete
                  ? context.l10n.maintenanceScheduleYes
                  : context.l10n.maintenanceScheduleNo,
            ),
            _buildInfoRow(
              context.l10n.maintenanceScheduleEstimatedCost,
              dummySchedule.estimatedCost != null
                  ? dummySchedule.estimatedCost!.toRupiah()
                  : '-',
            ),
            _buildInfoRow(
              context.l10n.maintenanceScheduleCreatedBy,
              dummySchedule.createdBy?.name ??
                  context.l10n.maintenanceScheduleUnknownUser,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildContent(MaintenanceSchedule schedule) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(context.l10n.maintenanceScheduleInformation, [
            _buildInfoRow(
              context.l10n.maintenanceScheduleTitle,
              schedule.title,
            ),
            _buildTextBlock(
              context.l10n.maintenanceScheduleDescription,
              schedule.description,
            ),
            _buildInfoRow(
              context.l10n.maintenanceScheduleAsset,
              schedule.asset?.assetName ??
                  context.l10n.maintenanceScheduleUnknownAsset,
            ),
            _buildInfoRow(
              context.l10n.maintenanceScheduleMaintenanceType,
              schedule.maintenanceType.name,
            ),
            _buildInfoRow(
              context.l10n.maintenanceScheduleIsRecurring,
              schedule.isRecurring
                  ? context.l10n.maintenanceScheduleYes
                  : context.l10n.maintenanceScheduleNo,
            ),
            _buildInfoRow(
              context.l10n.maintenanceScheduleInterval,
              schedule.intervalValue != null && schedule.intervalUnit != null
                  ? '${schedule.intervalValue} ${schedule.intervalUnit!.label}'
                  : '-',
            ),
            _buildInfoRow(
              context.l10n.maintenanceScheduleScheduledTime,
              schedule.scheduledTime ?? '-',
            ),
            _buildInfoRow(
              context.l10n.maintenanceScheduleNextScheduledDate,
              _formatDateTime(schedule.nextScheduledDate),
            ),
            _buildInfoRow(
              context.l10n.maintenanceScheduleLastExecutedDate,
              schedule.lastExecutedDate != null
                  ? _formatDateTime(schedule.lastExecutedDate!)
                  : '-',
            ),
            _buildInfoRow(
              context.l10n.maintenanceScheduleState,
              schedule.state.name,
            ),
            _buildInfoRow(
              context.l10n.maintenanceScheduleAutoComplete,
              schedule.autoComplete
                  ? context.l10n.maintenanceScheduleYes
                  : context.l10n.maintenanceScheduleNo,
            ),
            _buildInfoRow(
              context.l10n.maintenanceScheduleEstimatedCost,
              schedule.estimatedCost != null
                  ? schedule.estimatedCost!.toRupiah()
                  : '-',
            ),
            _buildInfoRow(
              context.l10n.maintenanceScheduleCreatedBy,
              schedule.createdBy?.name ??
                  context.l10n.maintenanceScheduleUnknownUser,
            ),
          ]),
          const SizedBox(height: 16),
          // * Copy button (admin only)
          _buildCopyButton(schedule),
          const SizedBox(height: 16),
          _buildInfoCard(context.l10n.maintenanceScheduleMetadata, [
            _buildInfoRow(
              context.l10n.maintenanceScheduleCreatedAt,
              _formatDateTime(schedule.createdAt),
            ),
            _buildInfoRow(
              context.l10n.maintenanceScheduleUpdatedAt,
              _formatDateTime(schedule.updatedAt),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildCopyButton(MaintenanceSchedule schedule) {
    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    if (!isAdmin) return const SizedBox.shrink();

    return Card(
      color: context.colors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: context.colors.border),
      ),
      child: InkWell(
        onTap: () => _handleCopy(schedule),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.content_copy, color: context.colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      context.l10n.maintenanceScheduleCopyFromThis,
                      style: AppTextStyle.bodyMedium,
                      fontWeight: FontWeight.w600,
                    ),
                    AppText(
                      context.l10n.maintenanceScheduleCreateNewBasedOnThis,
                      style: AppTextStyle.bodySmall,
                      color: context.colors.textSecondary,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: context.colors.textSecondary,
              ),
            ],
          ),
        ),
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
