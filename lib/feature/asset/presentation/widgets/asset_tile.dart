import 'package:flutter/material.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/feature/asset/domain/entities/asset.dart';
// Pastikan path import AppImage ini sesuai dengan struktur project kamu ya!
import 'package:sigma_track/shared/presentation/widgets/app_image.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';

class AssetTile extends StatelessWidget {
  final Asset asset;
  final bool isDisabled;
  final bool isSelected;
  final VoidCallback? onTap;
  final ValueChanged<bool?>? onSelect;
  final VoidCallback? onLongPress;

  const AssetTile({
    super.key,
    required this.asset,
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

    // ✨ LOGIC BARU: Cari gambar primary atau fallback ke gambar pertama
    String? displayImageUrl;
    if (asset.images != null && asset.images!.isNotEmpty) {
      // Dart 3: Menggunakan firstWhere atau fallback null, lalu ambil yang pertama jika null
      final primaryImg = asset.images!
          .where((img) => img.isPrimary)
          .firstOrNull;

      displayImageUrl = primaryImg?.imageUrl ?? asset.images!.first.imageUrl;
    }

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
          child: Stack(
            children: [
              // Background Icon - Tetap dipertahankan buat estetika kalau gak ada gambar
              // Tapi kalau ada gambar, mungkin kita hide biar gak too much, atau biarin aja?
              // Aku biarin aja tapi lebih tipis opacity-nya biar tetep kece.
              if (asset.id.isNotEmpty)
                Positioned(
                  right: -15,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Icon(
                      Icons.inventory_2_rounded,
                      size: 100,
                      color: context.colorScheme.primary.withValues(
                        alpha:
                            0.05, // Sedikit lebih tipis biar gak tabrakan sama foto
                      ),
                    ),
                  ),
                ),

              // Main Content
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // Center vertical alignment
                  children: [
                    // Checkbox Section
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

                    // ✨ IMAGE SECTION ✨
                    // Kita tampilkan AppImage hanya jika URL-nya ada
                    if (displayImageUrl != null) ...[
                      AppImage(
                        imageUrl: displayImageUrl,
                        size: ImageSize
                            .large, // Ukuran 48px pas banget buat list tile
                        shape: ImageShape.rectangle,
                        fit: BoxFit.cover,
                        showBorder: true, // Biar rapi ada bordernya dikit
                        borderColor: context.colors.border,
                        borderWidth: 1,
                        // Placeholder simple kalau loading
                        placeholder: Container(
                          color: context.colorScheme.surfaceContainerHighest,
                          child: const Center(
                            child: Icon(
                              Icons.image,
                              size: 20,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ] else ...[
                      // Kalau gak ada gambar, kita kasih Placeholder Icon standar yang rapi
                      // Biar align text-nya tetep enak dilihat (opsional, bisa dihapus kalau mau text mentok kiri)
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: context.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.inventory_2_outlined,
                          color: context.colors.textSecondary.withValues(
                            alpha: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],

                    // Text Info Section
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppText(
                            asset.assetName,
                            style: AppTextStyle.titleMedium,
                            fontWeight: FontWeight.w600,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          AppText(
                            asset.assetTag,
                            style: AppTextStyle.bodyMedium,
                            color: context.colors.textSecondary,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),

                          // Brand & Model Row
                          Row(
                            children: [
                              if (asset.brand != null)
                                Flexible(
                                  child: AppText(
                                    asset.brand!,
                                    style: AppTextStyle.bodySmall,
                                    color: context.colors.textSecondary,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              if (asset.brand != null && asset.model != null)
                                AppText(
                                  ' • ',
                                  style: AppTextStyle.bodySmall,
                                  color: context.colors.textSecondary,
                                ),
                              if (asset.model != null)
                                Flexible(
                                  child: AppText(
                                    asset.model!,
                                    style: AppTextStyle.bodySmall,
                                    color: context.colors.textSecondary,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Badges Section (Status & Condition)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildBadge(
                          context,
                          label: asset.status.name.toUpperCase(),
                          color: _getStatusColor(context, asset.status),
                        ),
                        const SizedBox(height: 6),
                        _buildBadge(
                          context,
                          label: asset.condition.name.toUpperCase(),
                          color: _getConditionColor(context, asset.condition),
                        ),
                      ],
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

  // Helper widget biar kodingan di atas gak kepanjangan
  Widget _buildBadge(
    BuildContext context, {
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ), // Tambah border tipis biar pop!
      ),
      child: AppText(
        label,
        style: AppTextStyle.labelSmall,
        color: color,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Color _getStatusColor(BuildContext context, AssetStatus status) {
    switch (status) {
      case AssetStatus.active:
        return context.semantic.success;
      case AssetStatus.maintenance:
        return context.semantic.warning;
      case AssetStatus.disposed:
      case AssetStatus.lost:
        return context.colors.textSecondary;
    }
  }

  Color _getConditionColor(BuildContext context, AssetCondition condition) {
    switch (condition) {
      case AssetCondition.good:
        return context.semantic.success;
      case AssetCondition.fair:
        return context.semantic.warning;
      case AssetCondition.poor:
      case AssetCondition.damaged:
        return context.semantic.error;
    }
  }
}
