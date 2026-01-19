import 'package:flutter/material.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/feature/category/domain/entities/category.dart';
import 'package:sigma_track/shared/presentation/widgets/app_image.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final bool isDisabled;
  final bool isSelected;
  final VoidCallback? onTap;
  final ValueChanged<bool?>? onSelect;
  final VoidCallback? onLongPress;

  const CategoryCard({
    super.key,
    required this.category,
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

    final Color? cardColor = isSelected
        ? context.colorScheme.primaryContainer.withValues(alpha: 0.3)
        : null;

    final bool hasBackgroundImage =
        category.imageUrl != null && category.imageUrl!.isNotEmpty;

    return Card(
      elevation: 0,
      color: cardColor,
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
              // * BACKGROUND LAYER (Image atau Flutter Icon)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (hasBackgroundImage)
                        AppImage(
                          imageUrl: category.imageUrl,
                          size: ImageSize.fullWidth,
                          shape: ImageShape.rectangle,
                          fit: BoxFit.cover,
                        )
                      else
                        Container(
                          color: context.colorScheme.surfaceContainer,
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.grid_view_rounded,
                            size: 64,
                            color: context.colorScheme.primary.withValues(
                              alpha: 0.2,
                            ),
                          ),
                        ),

                      // * Gradient Overlay (Tetap dipasang biar style konsisten)
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              context.colors.surface.withValues(alpha: 0.1),
                              context.colors.surface.withValues(alpha: 0.9),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // * CONTENT LAYER
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Checkbox
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (onSelect != null)
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: isSelected,
                              onChanged: isDisabled ? null : onSelect,
                            ),
                          ),
                      ],
                    ),
                    const Spacer(),
                    // Texts
                    AppText(
                      category.categoryName,
                      style: AppTextStyle.titleMedium,
                      fontWeight: FontWeight.w600,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    AppText(
                      category.categoryCode,
                      style: AppTextStyle.bodySmall,
                      color: context.colors.textSecondary,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
}
