import 'package:flutter/material.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';

/// Widget card untuk menampilkan pilihan tipe export
///
/// Digunakan dalam dialog/bottom sheet untuk memilih antara berbagai
/// tipe export (list, data matrix, dll).
class ExportTypeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const ExportTypeCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: context.colors.border),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: context.colorScheme.primary, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    title,
                    style: AppTextStyle.titleMedium,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    subtitle,
                    style: AppTextStyle.bodySmall,
                    color: context.colors.textSecondary,
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: context.colors.textTertiary),
          ],
        ),
      ),
    );
  }
}
