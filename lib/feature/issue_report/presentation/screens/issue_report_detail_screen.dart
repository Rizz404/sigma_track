import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sigma_track/core/constants/route_constant.dart';
import 'package:sigma_track/core/enums/helper_enums.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/core/extensions/localization_extension.dart';
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
            state.failure?.message ?? context.l10n.issueReportFailedToLoad,
          );
          setState(() => _isLoading = false);
        } else {
          // * State masih loading, tunggu dengan listen
          setState(() => _isLoading = false);
        }
      }
    } catch (e, s) {
      this.logError('Error fetching issue report', e, s);
      AppToast.error(context.l10n.issueReportFailedToLoad);
      setState(() => _isLoading = false);
    }
  }

  void _handleEdit() {
    if (_issueReport == null) return;

    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    if (isAdmin) {
      context.push(RouteConstant.issueReportUpsert, extra: _issueReport);
    } else {
      AppToast.warning(context.l10n.issueReportOnlyAdminCanEdit);
    }
  }

  void _handleDelete() async {
    if (_issueReport == null) return;

    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    if (!isAdmin) {
      AppToast.warning(context.l10n.issueReportOnlyAdminCanDelete);
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: AppText(
          context.l10n.issueReportDeleteIssueReport,
          style: AppTextStyle.titleMedium,
        ),
        content: AppText(
          context.l10n.issueReportDeleteConfirmation(_issueReport!.title),
          style: AppTextStyle.bodyMedium,
        ),
        actionsAlignment: MainAxisAlignment.end,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: AppText(context.l10n.issueReportCancel),
          ),
          const SizedBox(width: 8),
          AppButton(
            text: context.l10n.issueReportDelete,
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
      // * Only handle delete mutation
      if (next.mutation?.type == MutationType.delete) {
        if (next.hasMutationSuccess) {
          AppToast.success(
            next.mutationMessage ?? context.l10n.issueReportDeletedSuccess,
          );
          context.pop();
        } else if (next.hasMutationError) {
          this.logError('Delete error', next.mutationFailure);
          AppToast.error(
            next.mutationFailure?.message ??
                context.l10n.issueReportDeletedFailed,
          );
        }
      }
    });

    final isLoading = _isLoading || _issueReport == null;

    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    return Scaffold(
      appBar: CustomAppBar(
        title: isLoading ? context.l10n.issueReportDetail : _issueReport!.title,
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
          _buildInfoCard(context.l10n.issueReportInformation, [
            _buildInfoRow(context.l10n.issueReportTitle, dummyReport.title),
            _buildInfoRow(
              context.l10n.issueReportDescription,
              dummyReport.description ?? '-',
            ),
            _buildInfoRow(
              context.l10n.issueReportAsset,
              dummyReport.asset?.assetName ??
                  context.l10n.issueReportUnknownAsset,
            ),
            _buildInfoRow(
              context.l10n.issueReportIssueType,
              dummyReport.issueType,
            ),
            _buildInfoRow(
              context.l10n.issueReportPriority,
              dummyReport.priority.name,
            ),
            _buildInfoRow(
              context.l10n.issueReportStatus,
              dummyReport.status.name,
            ),
            _buildInfoRow(
              context.l10n.issueReportReportedBy,
              dummyReport.reportedBy?.fullName ??
                  context.l10n.issueReportUnknownUser,
            ),
            _buildInfoRow(
              context.l10n.issueReportReportedDate,
              _formatDateTime(dummyReport.reportedDate),
            ),
            _buildInfoRow(
              context.l10n.issueReportResolvedDate,
              dummyReport.resolvedDate != null
                  ? _formatDateTime(dummyReport.resolvedDate!)
                  : '-',
            ),
            _buildInfoRow(
              context.l10n.issueReportResolvedBy,
              dummyReport.resolvedBy?.fullName ?? '-',
            ),
            _buildInfoRow(
              context.l10n.issueReportResolutionNotes,
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
          _buildInfoCard(context.l10n.issueReportInformation, [
            _buildInfoRow(context.l10n.issueReportTitle, _issueReport!.title),
            _buildTextBlock(
              context.l10n.issueReportDescription,
              _issueReport!.description,
            ),
            _buildInfoRow(
              context.l10n.issueReportAsset,
              _issueReport!.asset?.assetName ??
                  context.l10n.issueReportUnknownAsset,
            ),
            _buildInfoRow(
              context.l10n.issueReportIssueType,
              _issueReport!.issueType,
            ),
            _buildInfoRow(
              context.l10n.issueReportPriority,
              _issueReport!.priority.name,
            ),
            _buildInfoRow(
              context.l10n.issueReportStatus,
              _issueReport!.status.name,
            ),
            _buildInfoRow(
              context.l10n.issueReportReportedBy,
              _issueReport!.reportedBy?.fullName ??
                  context.l10n.issueReportUnknownUser,
            ),
            _buildInfoRow(
              context.l10n.issueReportReportedDate,
              _formatDateTime(_issueReport!.reportedDate),
            ),
            _buildInfoRow(
              context.l10n.issueReportResolvedDate,
              _issueReport!.resolvedDate != null
                  ? _formatDateTime(_issueReport!.resolvedDate!)
                  : '-',
            ),
            _buildInfoRow(
              context.l10n.issueReportResolvedBy,
              _issueReport!.resolvedBy?.fullName ?? '-',
            ),
            _buildTextBlock(
              context.l10n.issueReportResolutionNotes,
              _issueReport!.resolutionNotes,
            ),
          ]),
          const SizedBox(height: 16),
          _buildInfoCard(context.l10n.issueReportMetadata, [
            _buildInfoRow(
              context.l10n.issueReportCreatedAt,
              _formatDateTime(_issueReport!.createdAt),
            ),
            _buildInfoRow(
              context.l10n.issueReportUpdatedAt,
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
