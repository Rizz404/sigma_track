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
  void _handleEdit(IssueReport issueReport) {
    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    if (isAdmin) {
      context.push(RouteConstant.issueReportUpsert, extra: issueReport);
    } else {
      AppToast.warning(context.l10n.issueReportOnlyAdminCanEdit);
    }
  }

  void _handleDelete(IssueReport issueReport) async {
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
          context.l10n.issueReportDeleteConfirmation(issueReport.title),
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
            DeleteIssueReportUsecaseParams(id: issueReport.id),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    // * Determine issueReport source: extra > fetch by id
    IssueReport? issueReport = widget.issueReport;
    bool isLoading = false;
    String? errorMessage;

    // * If no issueReport from extra, fetch by id
    if (issueReport == null && widget.id != null) {
      final state = ref.watch(getIssueReportByIdProvider(widget.id!));
      issueReport = state.issueReport;
      isLoading = state.isLoading;
      errorMessage = state.failure?.message;
    }

    // * Listen only for delete operation
    ref.listen<IssueReportsState>(issueReportsProvider, (previous, next) {
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

    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    return Scaffold(
      appBar: CustomAppBar(
        title: issueReport?.title ?? context.l10n.issueReportDetail,
      ),
      endDrawer: const AppEndDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: _buildBody(
        issueReport: issueReport,
        isLoading: isLoading,
        isAdmin: isAdmin,
        errorMessage: errorMessage,
      ),
    );
  }

  Widget _buildBody({
    required IssueReport? issueReport,
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
              text: context.l10n.issueReportCancel,
              onPressed: () => context.pop(),
            ),
          ],
        ),
      );
    }

    return Skeletonizer(
      enabled: isLoading || issueReport == null,
      child: Column(
        children: [
          Expanded(
            child: ScreenWrapper(
              child: isLoading || issueReport == null
                  ? _buildLoadingContent()
                  : _buildContent(issueReport),
            ),
          ),
          if (!isLoading && issueReport != null && isAdmin)
            AppDetailActionButtons(
              onEdit: () => _handleEdit(issueReport),
              onDelete: () => _handleDelete(issueReport),
            ),
        ],
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

  Widget _buildContent(IssueReport issueReport) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(context.l10n.issueReportInformation, [
            _buildInfoRow(context.l10n.issueReportTitle, issueReport.title),
            _buildTextBlock(
              context.l10n.issueReportDescription,
              issueReport.description,
            ),
            _buildInfoRow(
              context.l10n.issueReportAsset,
              issueReport.asset?.assetName ??
                  context.l10n.issueReportUnknownAsset,
            ),
            _buildInfoRow(
              context.l10n.issueReportIssueType,
              issueReport.issueType,
            ),
            _buildInfoRow(
              context.l10n.issueReportPriority,
              issueReport.priority.name,
            ),
            _buildInfoRow(
              context.l10n.issueReportStatus,
              issueReport.status.name,
            ),
            _buildInfoRow(
              context.l10n.issueReportReportedBy,
              issueReport.reportedBy?.fullName ??
                  context.l10n.issueReportUnknownUser,
            ),
            _buildInfoRow(
              context.l10n.issueReportReportedDate,
              _formatDateTime(issueReport.reportedDate),
            ),
            _buildInfoRow(
              context.l10n.issueReportResolvedDate,
              issueReport.resolvedDate != null
                  ? _formatDateTime(issueReport.resolvedDate!)
                  : '-',
            ),
            _buildInfoRow(
              context.l10n.issueReportResolvedBy,
              issueReport.resolvedBy?.fullName ?? '-',
            ),
            _buildTextBlock(
              context.l10n.issueReportResolutionNotes,
              issueReport.resolutionNotes,
            ),
          ]),
          const SizedBox(height: 16),
          _buildInfoCard(context.l10n.issueReportMetadata, [
            _buildInfoRow(
              context.l10n.issueReportCreatedAt,
              _formatDateTime(issueReport.createdAt),
            ),
            _buildInfoRow(
              context.l10n.issueReportUpdatedAt,
              _formatDateTime(issueReport.updatedAt),
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
