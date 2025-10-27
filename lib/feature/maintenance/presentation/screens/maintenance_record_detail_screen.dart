import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sigma_track/core/constants/route_constant.dart';
import 'package:sigma_track/core/enums/helper_enums.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
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
  MaintenanceRecord? _maintenanceRecord;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _maintenanceRecord = widget.maintenanceRecord;
    if (_maintenanceRecord == null && widget.id != null) {
      _fetchMaintenanceRecord();
    }
  }

  Future<void> _fetchMaintenanceRecord() async {
    setState(() => _isLoading = true);

    try {
      if (widget.id != null) {
        // * Watch provider (build method akan fetch otomatis)
        final state = ref.read(getMaintenanceRecordByIdProvider(widget.id!));

        if (state.maintenanceRecord != null) {
          setState(() {
            _maintenanceRecord = state.maintenanceRecord;
            _isLoading = false;
          });
        } else if (state.failure != null) {
          this.logError(
            'Failed to fetch maintenance record by id',
            state.failure,
          );
          AppToast.error(
            state.failure?.message ?? 'Failed to load maintenance record',
          );
          setState(() => _isLoading = false);
        } else {
          // * State masih loading, tunggu dengan listen
          setState(() => _isLoading = false);
        }
      }
    } catch (e, s) {
      this.logError('Error fetching maintenance record', e, s);
      AppToast.error('Failed to load maintenance record');
      setState(() => _isLoading = false);
    }
  }

  void _handleEdit() {
    if (_maintenanceRecord == null) return;

    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    if (isAdmin) {
      context.push(
        RouteConstant.adminMaintenanceRecordUpsert,
        extra: _maintenanceRecord,
      );
    } else {
      AppToast.warning('Only admin can edit maintenance records');
    }
  }

  void _handleDelete() async {
    if (_maintenanceRecord == null) return;

    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    if (!isAdmin) {
      AppToast.warning('Only admin can delete maintenance records');
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const AppText(
          'Delete Maintenance Record',
          style: AppTextStyle.titleMedium,
        ),
        content: AppText(
          'Are you sure you want to delete "${_maintenanceRecord!.title}"?',
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
          .read(maintenanceRecordsProvider.notifier)
          .deleteMaintenanceRecord(
            DeleteMaintenanceRecordUsecaseParams(id: _maintenanceRecord!.id),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    // * Listen only for delete operation (not update)
    // ? Update handled by MaintenanceRecordUpsertScreen, delete needs navigation from here
    ref.listen<MaintenanceRecordsState>(maintenanceRecordsProvider, (
      previous,
      next,
    ) {
      // * Only handle delete mutation
      if (next.mutation?.type == MutationType.delete) {
        if (next.hasMutationSuccess) {
          AppToast.success(
            next.mutationMessage ?? 'Maintenance record deleted',
          );
          context.pop();
        } else if (next.hasMutationError) {
          this.logError('Delete error', next.mutationFailure);
          AppToast.error(next.mutationFailure?.message ?? 'Delete failed');
        }
      }
    });

    final isLoading = _isLoading || _maintenanceRecord == null;

    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    return Scaffold(
      appBar: CustomAppBar(
        title: isLoading
            ? 'Maintenance Record Detail'
            : _maintenanceRecord!.title,
      ),
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
              AppDetailActionButtons(
                onEdit: _handleEdit,
                onDelete: _handleDelete,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingContent() {
    final dummyRecord = MaintenanceRecord.dummy();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard('Maintenance Record Information', [
            _buildInfoRow('Title', dummyRecord.title),
            _buildInfoRow('Notes', dummyRecord.notes ?? '-'),
            _buildInfoRow(
              'Asset',
              dummyRecord.asset?.assetName ?? 'Unknown Asset',
            ),
            _buildInfoRow(
              'Maintenance Date',
              _formatDateTime(dummyRecord.maintenanceDate),
            ),
            _buildInfoRow(
              'Completion Date',
              dummyRecord.completionDate != null
                  ? _formatDateTime(dummyRecord.completionDate!)
                  : '-',
            ),
            _buildInfoRow(
              'Duration',
              dummyRecord.durationMinutes != null
                  ? '${dummyRecord.durationMinutes} minutes'
                  : '-',
            ),
            _buildInfoRow(
              'Performed By User',
              dummyRecord.performedByUser?.name ?? '-',
            ),
            _buildInfoRow(
              'Performed By Vendor',
              dummyRecord.performedByVendor ?? '-',
            ),
            _buildInfoRow('Result', dummyRecord.result.label),
            _buildInfoRow(
              'Actual Cost',
              dummyRecord.actualCost != null
                  ? '\$${dummyRecord.actualCost}'
                  : '-',
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
          _buildInfoCard('Maintenance Record Information', [
            _buildInfoRow('Title', _maintenanceRecord!.title),
            _buildTextBlock('Notes', _maintenanceRecord!.notes),
            _buildInfoRow(
              'Asset',
              _maintenanceRecord!.asset?.assetName ?? 'Unknown Asset',
            ),
            _buildInfoRow(
              'Maintenance Date',
              _formatDateTime(_maintenanceRecord!.maintenanceDate),
            ),
            _buildInfoRow(
              'Completion Date',
              _maintenanceRecord!.completionDate != null
                  ? _formatDateTime(_maintenanceRecord!.completionDate!)
                  : '-',
            ),
            _buildInfoRow(
              'Duration',
              _maintenanceRecord!.durationMinutes != null
                  ? '${_maintenanceRecord!.durationMinutes} minutes'
                  : '-',
            ),
            _buildInfoRow(
              'Performed By User',
              _maintenanceRecord!.performedByUser?.name ?? '-',
            ),
            _buildInfoRow(
              'Performed By Vendor',
              _maintenanceRecord!.performedByVendor ?? '-',
            ),
            _buildInfoRow('Result', _maintenanceRecord!.result.label),
            _buildInfoRow(
              'Actual Cost',
              _maintenanceRecord!.actualCost != null
                  ? '\$${_maintenanceRecord!.actualCost}'
                  : '-',
            ),
          ]),
          const SizedBox(height: 16),
          _buildInfoCard('Metadata', [
            _buildInfoRow(
              'Created At',
              _formatDateTime(_maintenanceRecord!.createdAt),
            ),
            _buildInfoRow(
              'Updated At',
              _formatDateTime(_maintenanceRecord!.updatedAt),
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
