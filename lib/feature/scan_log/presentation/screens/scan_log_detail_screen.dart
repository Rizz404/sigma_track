import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
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
      AppToast.warning('Only admin can delete scan logs');
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const AppText(
          'Delete Scan Log',
          style: AppTextStyle.titleMedium,
        ),
        content: const AppText(
          'Are you sure you want to delete this scan log?',
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
          .read(scanLogsProvider.notifier)
          .deleteScanLog(DeleteScanLogUsecaseParams(id: _scanLog!.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    // * Listen only for delete operation (scan log detail doesn't have update)
    ref.listen<ScanLogsState>(scanLogsProvider, (previous, next) {
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
        context.pop();
      } else if (next.failure != null && previous?.isMutating == true) {
        this.logError('ScanLog mutation error', next.failure);
        AppToast.error(next.failure?.message ?? 'Operation failed');
      }
    });

    final isLoading = _isLoading || _scanLog == null;

    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Scan Log Detail'),
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
          _buildInfoCard('Scan Information', [
            _buildInfoRow('Scanned Value', dummyScanLog.scannedValue),
            _buildInfoRow('Scan Method', dummyScanLog.scanMethod.name),
            _buildInfoRow('Scan Result', dummyScanLog.scanResult.name),
            _buildInfoRow(
              'Scan Timestamp',
              _formatDateTime(dummyScanLog.scanTimestamp),
            ),
            _buildInfoRow(
              'Location',
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
          _buildInfoCard('Scan Information', [
            _buildInfoRow('Scanned Value', _scanLog!.scannedValue),
            _buildInfoRow('Scan Method', _scanLog!.scanMethod.name),
            _buildInfoRow('Scan Result', _scanLog!.scanResult.name),
            _buildInfoRow(
              'Scan Timestamp',
              _formatDateTime(_scanLog!.scanTimestamp),
            ),
            _buildInfoRow(
              'Location',
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
