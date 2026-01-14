import 'package:flutter/material.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/shared/presentation/widgets/app_image.dart';

/// Widget untuk menampilkan image tile dengan selection state
///
/// Widget ini digunakan untuk menampilkan gambar dalam grid dengan fitur:
/// - Selection overlay saat gambar dipilih
/// - Deselect button saat gambar sudah dipilih
/// - Loading & error handling untuk network images
class ImageTile extends StatelessWidget {
  final String imageUrl;
  final bool isSelected;
  final VoidCallback onTap;

  const ImageTile({
    super.key,
    required this.imageUrl,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: isSelected ? 4 : 0,
        color: context.colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isSelected ? context.colors.primary : context.colors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Stack(
          children: [
            // * Image
            AppImage(
              imageUrl: imageUrl,
              size: ImageSize.fullWidth,
              fit: BoxFit.cover,
              shape: ImageShape.rectangle,
            ),

            // * Selection overlay
            if (isSelected)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: context.colors.primary.withValues(alpha: 0.3),
                  ),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: context.colors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),

            // * Deselect button (hanya muncul jika selected)
            if (isSelected)
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: onTap,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: context.colorScheme.error,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.close,
                      color: context.colors.surface,
                      size: 16,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
