import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sigma_track/core/constants/route_constant.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/core/utils/toast_utils.dart';
import 'package:sigma_track/di/auth_providers.dart';
import 'package:sigma_track/feature/issue_report/domain/entities/issue_report.dart';
import 'package:sigma_track/feature/issue_report/domain/usecases/delete_issue_report_usecase.dart';
import 'package:sigma_track/feature/issue_report/presentation/providers/issue_report_providers.dart';
import 'package:sigma_track/feature/issue_report/presentation/providers/state/issue_reports_state.dart';
import 'package:sigma_track/shared/presentation/widgets/app_detail_action_buttons.dart';
import 'package:sigma_track/shared/presentation/widgets/app_button.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:sigma_track/shared/presentation/widgets/app_end_drawer.dart';
import 'package:sigma_track/shared/presentation/widgets/custom_app_bar.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';
import 'package:skeletonizer/skeletonizer.dart';

class IssueReportDetailScreen extends ConsumerStatefulWidget {
  final IssueReport? issueReport;
  final String? id;

  const IssueReportDetailScreen({super.key, this.issueReport, this.id});

  @override
  ConsumerState<IssueReportDetailScreen> createState() =>
      _IssueReportDetailScreenState();
}

class _IssueReportDetailScreenState
    extends ConsumerState<IssueReportDetailScreen> {
  IssueReport? _issueReport;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _issueReport = widget.issueReport;
    if (_issueReport == null && widget.id != null) {
      _fetchIssueReport();
    }
  }

  Future<void> _fetchIssueReport() async {
    setState(() => _isLoading = true);

    try {
      if (widget.id != null) {
        // * Watch provider (build method akan fetch otomatis)
        final state = ref.read(getIssueReportByIdProvider(widget.id!));

        if (state.issueReport != null) {
          setState(() {
            _issueReport = state.issueReport;
            _isLoading = false;
          });
        } else if (state.failure != null) {
          this.logError('Failed to fetch issue report by id', state.failure);
          AppToast.error(
            state.failure?.message ?? 'Failed to load issue report',
          );
          setState(() => _isLoading = false);
        } else {
          // * State masih loading, tunggu dengan listen
          setState(() => _isLoading = false);
        }
      }
    } catch (e, s) {
      this.logError('Error fetching issue report', e, s);
      AppToast.error('Failed to load issue report');
      setState(() => _isLoading = false);
    }
  }

  void _handleEdit() {
    if (_issueReport == null) return;

    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    if (isAdmin) {
      context.push(RouteConstant.adminIssueReportUpsert, extra: _issueReport);
    } else {
      AppToast.warning('Only admin can edit issue reports');
    }
  }

  void _handleDelete() async {
    if (_issueReport == null) return;

    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    if (!isAdmin) {
      AppToast.warning('Only admin can delete issue reports');
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const AppText(
          'Delete Issue Report',
          style: AppTextStyle.titleMedium,
        ),
        content: AppText(
          'Are you sure you want to delete "${_issueReport!.title}"?',
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
          .read(issueReportsProvider.notifier)
          .deleteIssueReport(
            DeleteIssueReportUsecaseParams(id: _issueReport!.id),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    // * Listen only for delete operation (not update)
    // ? Update handled by IssueReportUpsertScreen, delete needs navigation from here
    ref.listen<IssueReportsState>(issueReportsProvider, (previous, next) {
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
        this.logError('IssueReport mutation error', next.failure);
        AppToast.error(next.failure?.message ?? 'Operation failed');
      }
    });

    final isLoading = _isLoading || _issueReport == null;

    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    return Scaffold(
      appBar: CustomAppBar(
        title: isLoading ? 'Issue Report Detail' : _issueReport!.title,
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
    final dummyReport = IssueReport.dummy();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard('Issue Report Information', [
            _buildInfoRow('Title', dummyReport.title),
            _buildInfoRow('Description', dummyReport.description ?? '-'),
            _buildInfoRow(
              'Asset',
              dummyReport.asset?.assetName ?? 'Unknown Asset',
            ),
            _buildInfoRow('Issue Type', dummyReport.issueType),
            _buildInfoRow('Priority', dummyReport.priority.name),
            _buildInfoRow('Status', dummyReport.status.name),
            _buildInfoRow(
              'Reported By',
              dummyReport.reportedBy?.fullName ?? 'Unknown User',
            ),
            _buildInfoRow(
              'Reported Date',
              _formatDateTime(dummyReport.reportedDate),
            ),
            _buildInfoRow(
              'Resolved Date',
              dummyReport.resolvedDate != null
                  ? _formatDateTime(dummyReport.resolvedDate!)
                  : '-',
            ),
            _buildInfoRow(
              'Resolved By',
              dummyReport.resolvedBy?.fullName ?? '-',
            ),
            _buildInfoRow(
              'Resolution Notes',
              dummyReport.resolutionNotes ?? '-',
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
          _buildInfoCard('Issue Report Information', [
            _buildInfoRow('Title', _issueReport!.title),
            _buildTextBlock('Description', _issueReport!.description),
            _buildInfoRow(
              'Asset',
              _issueReport!.asset?.assetName ?? 'Unknown Asset',
            ),
            _buildInfoRow('Issue Type', _issueReport!.issueType),
            _buildInfoRow('Priority', _issueReport!.priority.name),
            _buildInfoRow('Status', _issueReport!.status.name),
            _buildInfoRow(
              'Reported By',
              _issueReport!.reportedBy?.fullName ?? 'Unknown User',
            ),
            _buildInfoRow(
              'Reported Date',
              _formatDateTime(_issueReport!.reportedDate),
            ),
            _buildInfoRow(
              'Resolved Date',
              _issueReport!.resolvedDate != null
                  ? _formatDateTime(_issueReport!.resolvedDate!)
                  : '-',
            ),
            _buildInfoRow(
              'Resolved By',
              _issueReport!.resolvedBy?.fullName ?? '-',
            ),
            _buildTextBlock('Resolution Notes', _issueReport!.resolutionNotes),
          ]),
          const SizedBox(height: 16),
          _buildInfoCard('Metadata', [
            _buildInfoRow(
              'Created At',
              _formatDateTime(_issueReport!.createdAt),
            ),
            _buildInfoRow(
              'Updated At',
              _formatDateTime(_issueReport!.updatedAt),
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
