import 'package:flutter/material.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';

class StatTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const StatTile({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: context.colorScheme.outlineVariant),
      ),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    title,
                    style: AppTextStyle.bodyMedium,
                    color: context.colorScheme.onSurface.withOpacity(0.7),
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    value,
                    style: AppTextStyle.headlineSmall,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),
            CircleAvatar(
              backgroundColor: color,
              child: Icon(icon, color: context.colorScheme.primary),
            ),
          ],
        ),
      ),
    );
  }
}
