import 'package:flutter/material.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';

/// Badge widget untuk notification icon
class NotificationBadge extends StatelessWidget {
  final int count;
  final Widget child;
  final Color? badgeColor;

  const NotificationBadge({
    super.key,
    required this.count,
    required this.child,
    this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (count > 0)
          Positioned(
            right: -4,
            top: -4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: badgeColor ?? context.colorScheme.error,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: context.colors.surface, width: 2),
              ),
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              child: Text(
                count > 99 ? '99+' : count.toString(),
                style: context.textTheme.labelSmall?.copyWith(
                  color: context.colorScheme.onError,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
