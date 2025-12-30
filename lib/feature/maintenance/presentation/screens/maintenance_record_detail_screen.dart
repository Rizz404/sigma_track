import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sigma_track/core/constants/route_constant.dart';
import 'package:sigma_track/core/enums/helper_enums.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/extensions/localization_extension.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/core/utils/toast_utils.dart';
import 'package:sigma_track/di/auth_providers.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_record.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/delete_maintenance_record_usecase.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/maintenance_providers.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/state/maintenance_records_state.dart';
import 'package:sigma_track/shared/presentation/widgets/app_detail_action_buttons.dart';
import 'package:sigma_track/shared/presentation/widgets/app_button.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:sigma_track/shared/presentation/widgets/app_end_drawer.dart';
import 'package:sigma_track/shared/presentation/widgets/custom_app_bar.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MaintenanceRecordDetailScreen extends ConsumerStatefulWidget {
  final MaintenanceRecord? maintenanceRecord;
  final String? id;

  const MaintenanceRecordDetailScreen({
    super.key,
    this.maintenanceRecord,
    this.id,
  });

  @override
  ConsumerState<MaintenanceRecordDetailScreen> createState() =>
      _MaintenanceRecordDetailScreenState();
}

class _MaintenanceRecordDetailScreenState
    extends ConsumerState<MaintenanceRecordDetailScreen> {
  void _handleEdit(MaintenanceRecord record) {
    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    if (isAdmin) {
      context.push(RouteConstant.adminMaintenanceRecordUpsert, extra: record);
    } else {
      AppToast.warning(context.l10n.maintenanceRecordOnlyAdminCanEdit);
    }
  }

  void _handleDelete(MaintenanceRecord record) async {
    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    if (!isAdmin) {
      AppToast.warning(context.l10n.maintenanceRecordOnlyAdminCanDelete);
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: AppText(
          context.l10n.maintenanceRecordDeleteRecord,
          style: AppTextStyle.titleMedium,
        ),
        content: AppText(
          context.l10n.maintenanceRecordDeleteConfirmation(record.title),
          style: AppTextStyle.bodyMedium,
        ),
        actionsAlignment: MainAxisAlignment.end,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: AppText(context.l10n.maintenanceRecordCancel),
          ),
          const SizedBox(width: 8),
          AppButton(
            text: context.l10n.maintenanceRecordDelete,
            color: AppButtonColor.error,
            isFullWidth: false,
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref
          .read(maintenanceRecordsProvider.notifier)
          .deleteMaintenanceRecord(
            DeleteMaintenanceRecordUsecaseParams(id: record.id),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    // * Determine record source: extra > fetch by id
    MaintenanceRecord? record = widget.maintenanceRecord;
    bool isLoading = false;
    String? errorMessage;

    // * If no record from extra, fetch by id
    if (record == null && widget.id != null) {
      final state = ref.watch(getMaintenanceRecordByIdProvider(widget.id!));
      record = state.maintenanceRecord;
      isLoading = state.isLoading;
      errorMessage = state.failure?.message;
    }

    // * Listen only for delete operation
    ref.listen<MaintenanceRecordsState>(maintenanceRecordsProvider, (
      previous,
      next,
    ) {
      if (next.mutation?.type == MutationType.delete) {
        if (next.hasMutationSuccess) {
          AppToast.success(
            next.mutationMessage ?? context.l10n.maintenanceRecordDeleted,
          );
          context.pop();
        } else if (next.hasMutationError) {
          this.logError('Delete error', next.mutationFailure);
          AppToast.error(
            next.mutationFailure?.message ??
                context.l10n.maintenanceRecordDeleteFailed,
          );
        }
      }
    });

    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    return Scaffold(
      appBar: CustomAppBar(
        title: record?.title ?? context.l10n.maintenanceRecordDetail,
      ),
      endDrawer: const AppEndDrawer(),
      body: _buildBody(
        record: record,
        isLoading: isLoading,
        isAdmin: isAdmin,
        errorMessage: errorMessage,
      ),
    );
  }

  Widget _buildBody({
    required MaintenanceRecord? record,
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
              text: context.l10n.maintenanceRecordCancel,
              onPressed: () => context.pop(),
            ),
          ],
        ),
      );
    }

    return Skeletonizer(
      enabled: isLoading || record == null,
      child: Column(
        children: [
          Expanded(
            child: ScreenWrapper(
              child: isLoading || record == null
                  ? _buildLoadingContent()
                  : _buildContent(record),
            ),
          ),
          if (!isLoading && record != null && isAdmin)
            AppDetailActionButtons(
              onEdit: () => _handleEdit(record),
              onDelete: () => _handleDelete(record),
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingContent() {
    final dummyRecord = MaintenanceRecord.dummy();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(context.l10n.maintenanceRecordInformation, [
            _buildInfoRow(
              context.l10n.maintenanceRecordTitle,
              dummyRecord.title,
            ),
            _buildInfoRow(
              context.l10n.maintenanceRecordNotes,
              dummyRecord.notes ?? '-',
            ),
            _buildInfoRow(
              context.l10n.maintenanceRecordAsset,
              dummyRecord.asset?.assetName ??
                  context.l10n.maintenanceRecordUnknownAsset,
            ),
            _buildInfoRow(
              context.l10n.maintenanceRecordMaintenanceDate,
              _formatDateTime(dummyRecord.maintenanceDate),
            ),
            _buildInfoRow(
              context.l10n.maintenanceRecordCompletionDate,
              dummyRecord.completionDate != null
                  ? _formatDateTime(dummyRecord.completionDate!)
                  : '-',
            ),
            _buildInfoRow(
              context.l10n.maintenanceRecordDuration,
              dummyRecord.durationMinutes != null
                  ? context.l10n.maintenanceRecordDurationMinutes(
                      dummyRecord.durationMinutes!,
                    )
                  : '-',
            ),
            _buildInfoRow(
              context.l10n.maintenanceRecordPerformedByUser,
              dummyRecord.performedByUser?.name ?? '-',
            ),
            _buildInfoRow(
              context.l10n.maintenanceRecordPerformedByVendor,
              dummyRecord.performedByVendor ?? '-',
            ),
            _buildInfoRow(
              context.l10n.maintenanceRecordResult,
              dummyRecord.result.label,
            ),
            _buildInfoRow(
              context.l10n.maintenanceRecordActualCost,
              dummyRecord.actualCost != null
                  ? context.l10n.maintenanceRecordActualCostValue(
                      dummyRecord.actualCost.toString(),
                    )
                  : '-',
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildContent(MaintenanceRecord record) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(context.l10n.maintenanceRecordInformation, [
            _buildInfoRow(context.l10n.maintenanceRecordTitle, record.title),
            _buildTextBlock(context.l10n.maintenanceRecordNotes, record.notes),
            _buildInfoRow(
              context.l10n.maintenanceRecordAsset,
              record.asset?.assetName ??
                  context.l10n.maintenanceRecordUnknownAsset,
            ),
            _buildInfoRow(
              context.l10n.maintenanceRecordMaintenanceDate,
              _formatDateTime(record.maintenanceDate),
            ),
            _buildInfoRow(
              context.l10n.maintenanceRecordCompletionDate,
              record.completionDate != null
                  ? _formatDateTime(record.completionDate!)
                  : '-',
            ),
            _buildInfoRow(
              context.l10n.maintenanceRecordDuration,
              record.durationMinutes != null
                  ? context.l10n.maintenanceRecordDurationMinutes(
                      record.durationMinutes!,
                    )
                  : '-',
            ),
            _buildInfoRow(
              context.l10n.maintenanceRecordPerformedByUser,
              record.performedByUser?.name ?? '-',
            ),
            _buildInfoRow(
              context.l10n.maintenanceRecordPerformedByVendor,
              record.performedByVendor ?? '-',
            ),
            _buildInfoRow(
              context.l10n.maintenanceRecordResult,
              record.result.label,
            ),
            _buildInfoRow(
              context.l10n.maintenanceRecordActualCost,
              record.actualCost != null
                  ? context.l10n.maintenanceRecordActualCostValue(
                      record.actualCost.toString(),
                    )
                  : '-',
            ),
          ]),
          const SizedBox(height: 16),
          _buildInfoCard(context.l10n.maintenanceRecordMetadata, [
            _buildInfoRow(
              context.l10n.maintenanceRecordCreatedAt,
              _formatDateTime(record.createdAt),
            ),
            _buildInfoRow(
              context.l10n.maintenanceRecordUpdatedAt,
              _formatDateTime(record.updatedAt),
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
