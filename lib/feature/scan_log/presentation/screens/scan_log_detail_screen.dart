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
import 'package:sigma_track/feature/scan_log/domain/entities/scan_log.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/delete_scan_log_usecase.dart';
import 'package:sigma_track/feature/scan_log/presentation/providers/scan_log_providers.dart';
import 'package:sigma_track/feature/scan_log/presentation/providers/state/scan_logs_state.dart';
import 'package:sigma_track/shared/presentation/widgets/app_detail_action_buttons.dart';
import 'package:sigma_track/shared/presentation/widgets/app_button.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:sigma_track/shared/presentation/widgets/app_end_drawer.dart';
import 'package:sigma_track/shared/presentation/widgets/custom_app_bar.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ScanLogDetailScreen extends ConsumerStatefulWidget {
  final ScanLog? scanLog;
  final String? id;

  const ScanLogDetailScreen({super.key, this.scanLog, this.id});

  @override
  ConsumerState<ScanLogDetailScreen> createState() =>
      _ScanLogDetailScreenState();
}

class _ScanLogDetailScreenState extends ConsumerState<ScanLogDetailScreen> {
  ScanLog? _scanLog;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scanLog = widget.scanLog;
    if (_scanLog == null && widget.id != null) {
      _fetchScanLog();
    }
  }

  Future<void> _fetchScanLog() async {
    setState(() => _isLoading = true);

    try {
      if (widget.id != null) {
        // * Watch provider (build method akan fetch otomatis)
        final state = ref.read(getScanLogByIdProvider(widget.id!));

        if (state.scanLog != null) {
          setState(() {
            _scanLog = state.scanLog;
            _isLoading = false;
          });
        } else if (state.failure != null) {
          this.logError('Failed to fetch scan log by id', state.failure);
          AppToast.error(state.failure?.message ?? 'Failed to load scan log');
          setState(() => _isLoading = false);
        } else {
          // * State masih loading, tunggu dengan listen
          setState(() => _isLoading = false);
        }
      }
    } catch (e, s) {
      this.logError('Error fetching scan log', e, s);
      AppToast.error('Failed to load scan log');
      setState(() => _isLoading = false);
    }
  }

  void _handleDelete() async {
    if (_scanLog == null) return;

    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    if (!isAdmin) {
      AppToast.warning(context.l10n.scanLogOnlyAdminCanDelete);
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: AppText(
          context.l10n.scanLogDeleteScanLog,
          style: AppTextStyle.titleMedium,
        ),
        content: AppText(
          context.l10n.scanLogDeleteConfirmation,
          style: AppTextStyle.bodyMedium,
        ),
        actionsAlignment: MainAxisAlignment.end,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: AppText(context.l10n.scanLogCancel),
          ),
          const SizedBox(width: 8),
          AppButton(
            text: context.l10n.scanLogDelete,
            color: AppButtonColor.error,
            isFullWidth: false,
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref
          .read(scanLogsProvider.notifier)
          .deleteScanLog(DeleteScanLogUsecaseParams(id: _scanLog!.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    // * Listen only for delete operation (scan log detail doesn't have update)
    ref.listen<ScanLogsState>(scanLogsProvider, (previous, next) {
      // * Only handle delete mutation
      if (next.mutation?.type == MutationType.delete) {
        if (next.hasMutationSuccess) {
          AppToast.success(next.mutationMessage ?? context.l10n.scanLogDeleted);
          context.pop();
        } else if (next.hasMutationError) {
          this.logError('Delete error', next.mutationFailure);
          AppToast.error(
            next.mutationFailure?.message ?? context.l10n.scanLogDeleteFailed,
          );
        }
      }
    });

    final isLoading = _isLoading || _scanLog == null;

    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    return Scaffold(
      appBar: CustomAppBar(title: context.l10n.scanLogDetail),
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
    final dummyScanLog = ScanLog.dummy();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(context.l10n.scanLogInformation, [
            _buildInfoRow(
              context.l10n.scanLogScannedValue,
              dummyScanLog.scannedValue,
            ),
            _buildInfoRow(
              context.l10n.scanLogScanMethod,
              dummyScanLog.scanMethod.name,
            ),
            _buildInfoRow(
              context.l10n.scanLogScanResult,
              dummyScanLog.scanResult.name,
            ),
            _buildInfoRow(
              context.l10n.scanLogScanTimestamp,
              _formatDateTime(dummyScanLog.scanTimestamp),
            ),
            _buildInfoRow(
              context.l10n.scanLogLocation,
              dummyScanLog.scanLocationLat != null &&
                      dummyScanLog.scanLocationLng != null
                  ? '${dummyScanLog.scanLocationLat}, ${dummyScanLog.scanLocationLng}'
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
          _buildInfoCard(context.l10n.scanLogInformation, [
            _buildInfoRow(
              context.l10n.scanLogScannedValue,
              _scanLog!.scannedValue,
            ),
            _buildInfoRow(
              context.l10n.scanLogScanMethod,
              _scanLog!.scanMethod.name,
            ),
            _buildInfoRow(
              context.l10n.scanLogScanResult,
              _scanLog!.scanResult.name,
            ),
            _buildInfoRow(
              context.l10n.scanLogScanTimestamp,
              _formatDateTime(_scanLog!.scanTimestamp),
            ),
            _buildInfoRow(
              context.l10n.scanLogLocation,
              _scanLog!.scanLocationLat != null &&
                      _scanLog!.scanLocationLng != null
                  ? '${_scanLog!.scanLocationLat}, ${_scanLog!.scanLocationLng}'
                  : '-',
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
