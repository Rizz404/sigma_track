import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sigma_track/core/constants/route_constant.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
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
  MaintenanceSchedule? _maintenanceSchedule;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _maintenanceSchedule = widget.maintenanceSchedule;
    if (_maintenanceSchedule == null && widget.id != null) {
      _fetchMaintenanceSchedule();
    }
  }

  Future<void> _fetchMaintenanceSchedule() async {
    setState(() => _isLoading = true);

    try {
      if (widget.id != null) {
        // * Watch provider (build method akan fetch otomatis)
        final state = ref.read(getMaintenanceScheduleByIdProvider(widget.id!));

        if (state.maintenanceSchedule != null) {
          setState(() {
            _maintenanceSchedule = state.maintenanceSchedule;
            _isLoading = false;
          });
        } else if (state.failure != null) {
          this.logError(
            'Failed to fetch maintenance schedule by id',
            state.failure,
          );
          AppToast.error(
            state.failure?.message ?? 'Failed to load maintenance schedule',
          );
          setState(() => _isLoading = false);
        } else {
          // * State masih loading, tunggu dengan listen
          setState(() => _isLoading = false);
        }
      }
    } catch (e, s) {
      this.logError('Error fetching maintenance schedule', e, s);
      AppToast.error('Failed to load maintenance schedule');
      setState(() => _isLoading = false);
    }
  }

  void _handleEdit() {
    if (_maintenanceSchedule == null) return;

    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    if (isAdmin) {
      context.push(
        RouteConstant.adminMaintenanceScheduleUpsert,
        extra: _maintenanceSchedule,
      );
    } else {
      AppToast.warning('Only admin can edit maintenance schedules');
    }
  }

  void _handleDelete() async {
    if (_maintenanceSchedule == null) return;

    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    if (!isAdmin) {
      AppToast.warning('Only admin can delete maintenance schedules');
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const AppText(
          'Delete Maintenance Schedule',
          style: AppTextStyle.titleMedium,
        ),
        content: AppText(
          'Are you sure you want to delete "${_maintenanceSchedule!.title}"?',
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
          .read(maintenanceSchedulesProvider.notifier)
          .deleteMaintenanceSchedule(
            DeleteMaintenanceScheduleUsecaseParams(
              id: _maintenanceSchedule!.id,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    // * Listen only for delete operation (not update)
    // ? Update handled by MaintenanceScheduleUpsertScreen, delete needs navigation from here
    ref.listen<MaintenanceSchedulesState>(maintenanceSchedulesProvider, (
      previous,
      next,
    ) {
      // * Only handle delete success
      final wasDeleting =
          previous?.isMutating == true && previous?.message == null;
      final isDeleteSuccess =
          !next.isMutating &&
          next.message != null &&
          next.failure == null &&
          wasDeleting;

      if (isDeleteSuccess) {
        AppToast.success(next.message ?? 'Operation successful');
        Navigator.pop(context);
      } else if (next.failure != null && previous?.isMutating == true) {
        this.logError('Maintenance schedule mutation error', next.failure);
        AppToast.error(next.failure?.message ?? 'Operation failed');
      }
    });

    final isLoading = _isLoading || _maintenanceSchedule == null;

    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    return Scaffold(
      appBar: CustomAppBar(
        title: isLoading
            ? 'Maintenance Schedule Detail'
            : _maintenanceSchedule!.title,
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
    final dummySchedule = MaintenanceSchedule.dummy();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard('Maintenance Schedule Information', [
            _buildInfoRow('Title', dummySchedule.title),
            _buildInfoRow('Description', dummySchedule.description ?? '-'),
            _buildInfoRow(
              'Asset',
              dummySchedule.asset?.assetName ?? 'Unknown Asset',
            ),
            _buildInfoRow(
              'Maintenance Type',
              dummySchedule.maintenanceType.name,
            ),
            _buildInfoRow(
              'Scheduled Date',
              _formatDateTime(dummySchedule.scheduledDate),
            ),
            _buildInfoRow(
              'Frequency (Months)',
              dummySchedule.frequencyMonths?.toString() ?? '-',
            ),
            _buildInfoRow('Status', dummySchedule.status.name),
            _buildInfoRow(
              'Created By',
              dummySchedule.createdBy?.fullName ?? 'Unknown User',
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
          _buildInfoCard('Maintenance Schedule Information', [
            _buildInfoRow('Title', _maintenanceSchedule!.title),
            _buildTextBlock('Description', _maintenanceSchedule!.description),
            _buildInfoRow(
              'Asset',
              _maintenanceSchedule!.asset?.assetName ?? 'Unknown Asset',
            ),
            _buildInfoRow(
              'Maintenance Type',
              _maintenanceSchedule!.maintenanceType.name,
            ),
            _buildInfoRow(
              'Scheduled Date',
              _formatDateTime(_maintenanceSchedule!.scheduledDate),
            ),
            _buildInfoRow(
              'Frequency (Months)',
              _maintenanceSchedule!.frequencyMonths?.toString() ?? '-',
            ),
            _buildInfoRow('Status', _maintenanceSchedule!.status.name),
            _buildInfoRow(
              'Created By',
              _maintenanceSchedule!.createdBy?.fullName ?? 'Unknown User',
            ),
          ]),
          const SizedBox(height: 16),
          _buildInfoCard('Metadata', [
            _buildInfoRow(
              'Created At',
              _formatDateTime(_maintenanceSchedule!.createdAt),
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
