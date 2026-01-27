import 'package:flutter/material.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/feature/issue_report/domain/entities/issue_report.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:intl/intl.dart';

class IssueReportTile extends StatelessWidget {
  final IssueReport issueReport;
  final bool isDisabled;
  final bool isSelected;
  final VoidCallback? onTap;
  final ValueChanged<bool?>? onSelect;
  final VoidCallback? onLongPress;

  const IssueReportTile({
    super.key,
    required this.issueReport,
    this.isDisabled = false,
    this.isSelected = false,
    this.onTap,
    this.onSelect,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final Color borderColor = isSelected
        ? context.colorScheme.primary
        : context.colors.border;
    final Color? tileColor = isSelected
        ? context.colorScheme.primaryContainer.withValues(alpha: 0.3)
        : null;

    return Card(
      elevation: 0,
      color: tileColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor, width: 1.5),
      ),
      child: InkWell(
        onTap: isDisabled
            ? null
            : (onSelect != null ? () => onSelect!(!isSelected) : onTap),
        onLongPress: isDisabled ? null : onLongPress,
        borderRadius: BorderRadius.circular(12),
        child: Opacity(
          opacity: isDisabled ? 0.5 : 1.0,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                if (onSelect != null) ...[
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: isSelected,
                      onChanged: isDisabled ? null : onSelect,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: AppText(
                              issueReport.title,
                              style: AppTextStyle.titleMedium,
                              fontWeight: FontWeight.w600,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      AppText(
                        issueReport.asset?.assetName ?? 'Unknown Asset',
                        style: AppTextStyle.bodyMedium,
                        color: context.colors.textSecondary,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (issueReport.description != null) ...[
                        const SizedBox(height: 4),
                        AppText(
                          issueReport.description!,
                          style: AppTextStyle.bodySmall,
                          color: context.colors.textSecondary,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _getPriorityColor(
                                context,
                                issueReport.priority,
                              ).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: AppText(
                              issueReport.priority.label,
                              style: AppTextStyle.labelSmall,
                              color: _getPriorityColor(
                                context,
                                issueReport.priority,
                              ),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          AppText(
                            issueReport.issueType,
                            style: AppTextStyle.labelSmall,
                            color: context.colors.textSecondary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(
                          context,
                          issueReport.status,
                        ).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: AppText(
                        issueReport.status.label,
                        style: AppTextStyle.labelSmall,
                        color: _getStatusColor(context, issueReport.status),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    AppText(
                      DateFormat(
                        'dd MMM yyyy',
                      ).format(issueReport.reportedDate),
                      style: AppTextStyle.bodySmall,
                      color: context.colors.textSecondary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor(BuildContext context, IssuePriority priority) {
    switch (priority) {
      case IssuePriority.low:
        return context.semantic.info;
      case IssuePriority.medium:
        return context.semantic.warning;
      case IssuePriority.high:
      case IssuePriority.critical:
        return context.semantic.error;
    }
  }

  Color _getStatusColor(BuildContext context, IssueStatus status) {
    switch (status) {
      case IssueStatus.open:
        return context.semantic.warning;
      case IssueStatus.inProgress:
        return context.semantic.info;
      case IssueStatus.resolved:
        return context.semantic.success;
      case IssueStatus.closed:
        return context.colors.textSecondary;
    }
  }
}
