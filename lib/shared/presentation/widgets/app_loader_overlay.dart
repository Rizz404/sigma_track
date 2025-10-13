import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/shared/presentation/widgets/app_image.dart';

/// Reusable loader overlay widget
class AppLoaderOverlay extends StatelessWidget {
  final Widget child;
  final Color? overlayColor;
  final double? overlayOpacity;

  const AppLoaderOverlay({
    super.key,
    required this.child,
    this.overlayColor,
    this.overlayOpacity,
  });

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      overlayColor: (overlayColor ?? Colors.black).withValues(
        alpha: overlayOpacity ?? 0.6,
      ),
      overlayWidgetBuilder: (progress) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppImage(
              assetPath: 'assets/images/splash.png',
              size: ImageSize.xxxLarge,
            ),
            const SizedBox(height: 16),
            CircularProgressIndicator(color: context.colorScheme.primary),
          ],
        ),
      ),
      child: child,
    );
  }
}
