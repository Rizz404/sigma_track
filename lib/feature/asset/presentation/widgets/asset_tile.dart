import 'package:flutter/material.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/feature/asset/domain/entities/asset.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';

class AssetTile extends StatelessWidget {
  final Asset asset;
  final bool isDisabled;
  final bool isSelected;
  final VoidCallback? onTap;
  final ValueChanged<bool?>? onSelect;
  final VoidCallback? onLongPress;

  const AssetTile({
    super.key,
    required this.asset,
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
        ? context.colorScheme.primaryContainer.withOpacity(0.3)
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
          child: Stack(
            children: [
              // Background Icon - hanya tampil jika bukan dummy/skeleton
              if (asset.id.isNotEmpty)
                Positioned(
                  right: -15,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Icon(
                      Icons.inventory_2_rounded,
                      size: 100,
                      color: context.colorScheme.primary.withOpacity(0.08),
                    ),
                  ),
                ),
              // Content
              Padding(
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
                            asset.assetName,
                            style: AppTextStyle.titleMedium,
                            fontWeight: FontWeight.w600,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          AppText(
                            asset.assetTag,
                            style: AppTextStyle.bodyMedium,
                            color: context.colors.textSecondary,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              if (asset.brand != null) ...[
                                AppText(
                                  asset.brand!,
                                  style: AppTextStyle.bodySmall,
                                  color: context.colors.textSecondary,
                                ),
                                if (asset.model != null) ...[
                                  AppText(
                                    ' • ',
                                    style: AppTextStyle.bodySmall,
                                    color: context.colors.textSecondary,
                                  ),
                                  AppText(
                                    asset.model!,
                                    style: AppTextStyle.bodySmall,
                                    color: context.colors.textSecondary,
                                  ),
                                ],
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
                            color: _getStatusColor(
                              context,
                              asset.status,
                            ).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: AppText(
                            asset.status.name.toUpperCase(),
                            style: AppTextStyle.labelSmall,
                            color: _getStatusColor(context, asset.status),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getConditionColor(
                              context,
                              asset.condition,
                            ).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: AppText(
                            asset.condition.name.toUpperCase(),
                            style: AppTextStyle.labelSmall,
                            color: _getConditionColor(context, asset.condition),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(BuildContext context, dynamic status) {
    switch (status.toString().split('.').last) {
      case 'available':
        return context.semantic.success;
      case 'inUse':
        return context.semantic.info;
      case 'inMaintenance':
        return context.semantic.warning;
      case 'retired':
      case 'disposed':
        return context.colors.textSecondary;
      default:
        return context.colors.textPrimary;
    }
  }

  Color _getConditionColor(BuildContext context, dynamic condition) {
    switch (condition.toString().split('.').last) {
      case 'excellent':
        return context.semantic.success;
      case 'good':
        return context.semantic.info;
      case 'fair':
        return context.semantic.warning;
      case 'poor':
      case 'broken':
        return context.semantic.error;
      default:
        return context.colors.textPrimary;
    }
  }
}
