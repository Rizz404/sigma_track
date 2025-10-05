import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';

/// Reusable loader overlay widget dengan opsi custom image
class AppLoaderOverlay extends StatelessWidget {
  final Widget child;
  final String? overlayImagePath;
  final double? overlayImageSize;
  final Color? overlayColor;
  final double? overlayOpacity;

  const AppLoaderOverlay({
    super.key,
    required this.child,
    this.overlayImagePath,
    this.overlayImageSize,
    this.overlayColor,
    this.overlayOpacity,
  });

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: overlayImagePath == null,
      overlayColor:
          overlayColor ?? Colors.black.withOpacity(overlayOpacity ?? 0.6),
      overlayWidgetBuilder: overlayImagePath != null
          ? (progress) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    overlayImagePath!,
                    width: overlayImageSize ?? 100,
                    height: overlayImageSize ?? 100,
                  ),
                  const SizedBox(height: 16),
                  CircularProgressIndicator(color: context.colorScheme.primary),
                ],
              ),
            )
          : null,
      child: child,
    );
  }
}
