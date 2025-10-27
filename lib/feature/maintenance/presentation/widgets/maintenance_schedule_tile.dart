import 'package:flutter/material.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_schedule.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:intl/intl.dart';

class MaintenanceScheduleTile extends StatelessWidget {
  final MaintenanceSchedule maintenanceSchedule;
  final bool isDisabled;
  final bool isSelected;
  final VoidCallback? onTap;
  final ValueChanged<bool?>? onSelect;
  final VoidCallback? onLongPress;

  const MaintenanceScheduleTile({
    super.key,
    required this.maintenanceSchedule,
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
                      AppText(
                        maintenanceSchedule.title,
                        style: AppTextStyle.titleMedium,
                        fontWeight: FontWeight.w600,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      AppText(
                        maintenanceSchedule.asset?.assetName ?? 'Unknown Asset',
                        style: AppTextStyle.bodyMedium,
                        color: context.colors.textSecondary,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (maintenanceSchedule.description != null) ...[
                        const SizedBox(height: 4),
                        AppText(
                          maintenanceSchedule.description!,
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
                              color: context.semantic.info.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: AppText(
                              maintenanceSchedule.maintenanceType.name
                                  .toUpperCase(),
                              style: AppTextStyle.labelSmall,
                              color: context.semantic.info,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (maintenanceSchedule.isRecurring &&
                              maintenanceSchedule.intervalValue != null &&
                              maintenanceSchedule.intervalUnit != null) ...[
                            const SizedBox(width: 8),
                            AppText(
                              'Every ${maintenanceSchedule.intervalValue} ${maintenanceSchedule.intervalUnit!.label}',
                              style: AppTextStyle.labelSmall,
                              color: context.colors.textSecondary,
                            ),
                          ],
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
                        color: _getStateColor(
                          context,
                          maintenanceSchedule.state,
                        ).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: AppText(
                        maintenanceSchedule.state.value.toUpperCase(),
                        style: AppTextStyle.labelSmall,
                        color: _getStateColor(
                          context,
                          maintenanceSchedule.state,
                        ),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    AppText(
                      DateFormat(
                        'dd MMM yyyy',
                      ).format(maintenanceSchedule.nextScheduledDate),
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

  Color _getStateColor(BuildContext context, ScheduleState state) {
    switch (state) {
      case ScheduleState.active:
        return context.semantic.success;
      case ScheduleState.paused:
        return context.semantic.warning;
      case ScheduleState.stopped:
        return context.colors.textSecondary;
      case ScheduleState.completed:
        return context.semantic.info;
    }
  }
}
