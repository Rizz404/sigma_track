import 'package:flutter/material.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/feature/category/domain/entities/category.dart';
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
        ? context.colorScheme.primaryContainer.withOpacity(0.3)
        : null;

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
              // Background Icon - hanya tampil jika bukan dummy/skeleton
              if (category.id.isNotEmpty)
                Positioned(
                  right: -10,
                  top: -10,
                  child: Icon(
                    Icons.category_rounded,
                    size: 80,
                    color: context.colorScheme.primary.withOpacity(0.15),
                  ),
                ),
              // Content
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Checkbox di kanan atas
                    if (onSelect != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
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
                    // Spacer untuk mendorong konten ke bawah
                    const Spacer(),
                    // Text content di bawah
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
