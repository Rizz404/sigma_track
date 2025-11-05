import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/core/extensions/localization_extension.dart';
import 'package:sigma_track/feature/asset_movement/domain/entities/asset_movement.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:intl/intl.dart';

class AssetMovementTile extends ConsumerWidget {
  final AssetMovement assetMovement;
  final bool isDisabled;
  final bool isSelected;
  final VoidCallback? onTap;
  final ValueChanged<bool?>? onSelect;
  final VoidCallback? onLongPress;

  const AssetMovementTile({
    super.key,
    required this.assetMovement,
    this.isDisabled = false,
    this.isSelected = false,
    this.onTap,
    this.onSelect,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                        assetMovement.asset?.assetName ??
                            context.l10n.assetMovementUnknownAsset,
                        style: AppTextStyle.titleMedium,
                        fontWeight: FontWeight.w600,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      AppText(
                        assetMovement.asset?.assetTag ??
                            context.l10n.assetMovementUnknownTag,
                        style: AppTextStyle.bodySmall,
                        color: context.colors.textSecondary,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: context.colors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: AppText(
                              _getMovementText(context),
                              style: AppTextStyle.bodySmall,
                              color: context.colors.textSecondary,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 16,
                            color: context.colors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: AppText(
                              _getUserMovementText(context),
                              style: AppTextStyle.bodySmall,
                              color: context.colors.textSecondary,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
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
                    AppText(
                      DateFormat(
                        'dd MMM yyyy',
                      ).format(assetMovement.movementDate),
                      style: AppTextStyle.bodySmall,
                      color: context.colors.textSecondary,
                    ),
                    const SizedBox(height: 4),
                    AppText(
                      DateFormat('HH:mm').format(assetMovement.movementDate),
                      style: AppTextStyle.labelSmall,
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

  String _getMovementText(BuildContext context) {
    final from =
        assetMovement.fromLocation?.locationName ??
        context.l10n.assetMovementUnknown;
    final to =
        assetMovement.toLocation?.locationName ??
        context.l10n.assetMovementUnknown;
    return '$from → $to';
  }

  String _getUserMovementText(BuildContext context) {
    final from =
        assetMovement.fromUser?.fullName ??
        context.l10n.assetMovementUnassigned;
    final to =
        assetMovement.toUser?.fullName ?? context.l10n.assetMovementUnassigned;
    return '$from → $to';
  }
}
