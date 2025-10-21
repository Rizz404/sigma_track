import 'package:flutter/material.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/feature/scan_log/domain/entities/scan_log.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:intl/intl.dart';

class ScanLogTile extends StatelessWidget {
  final ScanLog scanLog;
  final bool isDisabled;
  final bool isSelected;
  final VoidCallback? onTap;
  final ValueChanged<bool?>? onSelect;
  final VoidCallback? onLongPress;

  const ScanLogTile({
    super.key,
    required this.scanLog,
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
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getResultColor(
                      context,
                      scanLog.scanResult,
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getScanMethodIcon(scanLog.scanMethod),
                    color: _getResultColor(context, scanLog.scanResult),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        scanLog.scannedValue,
                        style: AppTextStyle.titleMedium,
                        fontWeight: FontWeight.w600,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
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
                              scanLog.scanMethod.name.toUpperCase(),
                              style: AppTextStyle.labelSmall,
                              color: context.semantic.info,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          AppText(
                            DateFormat('HH:mm').format(scanLog.scanTimestamp),
                            style: AppTextStyle.labelSmall,
                            color: context.colors.textSecondary,
                          ),
                        ],
                      ),
                      if (scanLog.scanLocationLat != null &&
                          scanLog.scanLocationLng != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 12,
                              color: context.colors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            AppText(
                              '${scanLog.scanLocationLat!.toStringAsFixed(6)}, ${scanLog.scanLocationLng!.toStringAsFixed(6)}',
                              style: AppTextStyle.labelSmall,
                              color: context.colors.textSecondary,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
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
                        color: _getResultColor(
                          context,
                          scanLog.scanResult,
                        ).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: AppText(
                        scanLog.scanResult.name.toUpperCase(),
                        style: AppTextStyle.labelSmall,
                        color: _getResultColor(context, scanLog.scanResult),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    AppText(
                      DateFormat('dd MMM yyyy').format(scanLog.scanTimestamp),
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

  IconData _getScanMethodIcon(dynamic method) {
    switch (method.toString().split('.').last) {
      case 'dataMatrix':
        return Icons.qr_code_2;
      case 'barcode':
        return Icons.barcode_reader;
      case 'rfid':
        return Icons.nfc;
      default:
        return Icons.qr_code_scanner;
    }
  }

  Color _getResultColor(BuildContext context, dynamic result) {
    switch (result.toString().split('.').last) {
      case 'success':
        return context.semantic.success;
      case 'failed':
        return context.semantic.error;
      case 'notFound':
        return context.semantic.warning;
      default:
        return context.colors.textPrimary;
    }
  }
}
