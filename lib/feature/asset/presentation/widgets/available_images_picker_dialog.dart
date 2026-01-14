import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/extensions/localization_extension.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/feature/asset/presentation/providers/asset_providers.dart';
import 'package:sigma_track/feature/asset/presentation/widgets/image_tile.dart';
import 'package:sigma_track/shared/presentation/widgets/app_button.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';

/// Fullscreen dialog untuk memilih gambar dari existing images
///
/// Widget ini menampilkan grid gambar yang tersedia dari server
/// dengan fitur infinite scroll dan multi-selection.
class AvailableImagesPickerDialog extends ConsumerStatefulWidget {
  final List<String> initialSelectedUrls;
  final List<String> lockedImageUrls;

  const AvailableImagesPickerDialog({
    super.key,
    this.initialSelectedUrls = const [],
    this.lockedImageUrls = const [],
  });

  @override
  ConsumerState<AvailableImagesPickerDialog> createState() =>
      _AvailableImagesPickerDialogState();
}

class _AvailableImagesPickerDialogState
    extends ConsumerState<AvailableImagesPickerDialog> {
  final ScrollController _scrollController = ScrollController();
  late List<String> _selectedUrls;

  @override
  void initState() {
    super.initState();
    _selectedUrls = List.from(widget.initialSelectedUrls);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        ref.read(availableAssetImagesProvider.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleSelection(String imageUrl) {
    setState(() {
      if (_selectedUrls.contains(imageUrl)) {
        _selectedUrls.remove(imageUrl);
      } else {
        _selectedUrls.add(imageUrl);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(availableAssetImagesProvider);

    // * MENGGUNAKAN DIALOG.FULLSCREEN AGAR LEGA
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
            tooltip: context.l10n.assetCancel,
          ),
          title: AppText(
            context.l10n.assetPickerTitle,
            style: AppTextStyle.titleMedium,
            fontWeight: FontWeight.bold,
          ),
          actions: [
            // Indikator jumlah yang dipilih di pojok kanan atas (opsional)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Center(
                child: AppText(
                  context.l10n.assetPickerCountSelected(_selectedUrls.length),
                  style: AppTextStyle.bodySmall,
                  color: context.colors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        // * Footer Action Button ditaruh di bottomNavigationBar agar aman
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.colors.surface,
            border: Border(top: BorderSide(color: context.colors.border)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            child: AppButton(
              text: _selectedUrls.isEmpty
                  ? context.l10n.assetPickerSelectButton
                  : context.l10n.assetPickerSelectWithCount(
                      _selectedUrls.length,
                    ),
              onPressed: _selectedUrls.isEmpty
                  ? null
                  : () => Navigator.pop(context, _selectedUrls),
              variant: AppButtonVariant.filled,
            ),
          ),
        ),
        body: state.isLoading && state.images.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : state.failure != null && state.images.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: context.colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    AppText(
                      context.l10n.assetFailedToLoadImages,
                      style: AppTextStyle.bodyLarge,
                      color: context.colorScheme.error,
                    ),
                    const SizedBox(height: 8),
                    AppButton(
                      text: context.l10n.assetRetry,
                      variant: AppButtonVariant.outlined,
                      onPressed: () => ref
                          .read(availableAssetImagesProvider.notifier)
                          .refresh(),
                    ),
                  ],
                ),
              )
            : state.images.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image_not_supported_outlined,
                      size: 64,
                      color: context.colors.textSecondary,
                    ),
                    const SizedBox(height: 16),
                    AppText(
                      context.l10n.assetNoImagesAvailable,
                      style: AppTextStyle.bodyLarge,
                      color: context.colors.textSecondary,
                    ),
                  ],
                ),
              )
            : GridView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3 Kolom biar gambar lebih JELAS
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemCount: state.images.length + (state.isLoadingMore ? 3 : 0),
                itemBuilder: (context, index) {
                  if (index >= state.images.length) {
                    return Card(
                      elevation: 0,
                      color: context.colors.surfaceVariant,
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  }

                  final image = state.images[index];
                  final isSelected = _selectedUrls.contains(image.imageUrl);

                  return ImageTile(
                    imageUrl: image.imageUrl,
                    isSelected: isSelected,
                    onTap: () => _toggleSelection(image.imageUrl),
                  );
                },
              ),
      ),
    );
  }
}
