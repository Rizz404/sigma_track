import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/enums/language_enums.dart';
import 'package:sigma_track/core/extensions/localization_extension.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/core/utils/toast_utils.dart';
import 'package:sigma_track/feature/category/domain/entities/category.dart';
import 'package:sigma_track/feature/category/domain/usecases/create_category_usecase.dart';
import 'package:sigma_track/feature/category/domain/usecases/update_category_usecase.dart';
import 'package:sigma_track/feature/category/presentation/providers/category_providers.dart';
import 'package:sigma_track/feature/category/presentation/providers/state/categories_state.dart';
import 'package:sigma_track/feature/category/presentation/validators/category_upsert_validator.dart';
import 'package:sigma_track/shared/presentation/widgets/app_button.dart';
import 'package:sigma_track/shared/presentation/widgets/app_file_picker.dart';
import 'package:sigma_track/shared/presentation/widgets/app_image.dart';
import 'package:sigma_track/shared/presentation/widgets/app_loader_overlay.dart';
import 'package:sigma_track/shared/presentation/widgets/app_searchable_dropdown.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text_field.dart';
import 'package:sigma_track/shared/presentation/widgets/app_validation_errors.dart';
import 'package:sigma_track/shared/presentation/widgets/app_end_drawer.dart';
import 'package:sigma_track/shared/presentation/widgets/custom_app_bar.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';

class CategoryUpsertScreen extends ConsumerStatefulWidget {
  final Category? category;
  final String? categoryId;
  final Category? copyFromCategory;

  const CategoryUpsertScreen({
    super.key,
    this.category,
    this.categoryId,
    this.copyFromCategory,
  });

  @override
  ConsumerState<CategoryUpsertScreen> createState() =>
      _CategoryUpsertScreenState();
}

class _CategoryUpsertScreenState extends ConsumerState<CategoryUpsertScreen> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final GlobalKey<AppFilePickerState> _filePickerKey =
      GlobalKey<AppFilePickerState>();

  List<ValidationError>? validationErrors;
  bool get _isEdit => widget.category != null || widget.categoryId != null;
  bool get _isCopyMode => widget.copyFromCategory != null;
  // * Helper to get source category for initialization (copy or edit)
  Category? get _sourceCategory => widget.copyFromCategory ?? widget.category;

  File? _imageFile;
  bool _showAllTranslations = false;

  void _handleSubmit() {
    if (_formKey.currentState?.saveAndValidate() != true) {
      AppToast.warning(context.l10n.categoryFillRequiredFields);
      return;
    }

    final formData = _formKey.currentState!.value;

    final translations = <dynamic>[];
    for (final langCode in Language.values.map((e) => e.backendCode)) {
      final categoryName = formData['${langCode}_categoryName'] as String?;
      final description = formData['${langCode}_description'] as String?;

      if (categoryName != null && categoryName.isNotEmpty) {
        if (_isEdit) {
          translations.add(
            UpdateCategoryTranslation(
              langCode: langCode,
              categoryName: categoryName,
              description: description,
            ),
          );
        } else {
          translations.add(
            CreateCategoryTranslation(
              langCode: langCode,
              categoryName: categoryName,
              description: description ?? '',
            ),
          );
        }
      }
    }

    // ! Validate translations - backend requires at least one translation
    if (!_isEdit && translations.isEmpty) {
      AppToast.warning(context.l10n.categoryFillRequiredFields);
      return;
    }

    final parentId = formData['parentId'] as String?;
    final categoryCode = formData['categoryCode'] as String;

    // * Handle image file selection (align with user profile screen)
    final imageFiles = formData['image'] as List<PlatformFile>?;

    File? selectedImageFile;
    if (imageFiles != null && imageFiles.isNotEmpty) {
      final filePath = imageFiles.first.path;

      if (filePath != null) {
        selectedImageFile = File(filePath);
      }
    }
    _imageFile = selectedImageFile;

    if (_isEdit) {
      final categoryId = widget.category!.id;

      final params = UpdateCategoryUsecaseParams.fromChanges(
        id: categoryId,
        original: widget.category!,
        parentId: parentId,
        categoryCode: categoryCode,
        translations: translations.cast<UpdateCategoryTranslation>(),
        imageFile: selectedImageFile,
      );

      ref.read(categoriesProvider.notifier).updateCategory(params);
    } else {
      final params = CreateCategoryUsecaseParams(
        parentId: parentId ?? '',
        categoryCode: categoryCode,
        translations: translations.cast<CreateCategoryTranslation>(),
        imageFile: selectedImageFile,
      );
      ref.read(categoriesProvider.notifier).createCategory(params);
    }
  }

  void _showFullImage(String imageUrl) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false, // Biar transisinya smooth di atas halaman sebelumnya
        barrierColor: Colors.black, // Background belakangnya hitam
        pageBuilder: (BuildContext context, _, __) {
          return Scaffold(
            backgroundColor: Colors.black, // Canvas hitam
            body: GestureDetector(
              // Klik di mana aja (gambar atau area hitam) langsung close
              onTap: () => Navigator.of(context).pop(),
              child: Stack(
                children: [
                  Center(
                    child: InteractiveViewer(
                      minScale: 0.5,
                      maxScale: 4.0,
                      // panEnabled true biar bisa geser-geser pas di-zoom
                      panEnabled: true,
                      child: AppImage(
                        imageUrl: imageUrl,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.contain, // Gambar utuh fit layar
                        shape: ImageShape.rectangle,
                        showBorder: false,
                      ),
                    ),
                  ),

                  // Tetap dikasih biar user tau bisa di-close
                ],
              ),
            ),
          );
        },
        // Custom Transition: Fade In / Fade Out
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // * Listen to mutation state
    ref.listen<CategoriesState>(categoriesProvider, (previous, next) {
      // * Handle loading state
      if (next.isMutating) {
        context.loaderOverlay.show();
        // * Clear validation errors when starting mutation
        if (validationErrors != null) {
          setState(() => validationErrors = null);
        }
      } else {
        context.loaderOverlay.hide();
      }

      // * Handle mutation success
      if (next.hasMutationSuccess) {
        AppToast.success(
          next.mutationMessage ?? context.l10n.categorySavedSuccessfully,
        );
        // * Clean up selected file and reset picker
        if (_imageFile != null) {
          _imageFile!.deleteSync();
          _imageFile = null;
        }
        _filePickerKey.currentState?.reset();

        // * Pop dengan membawa updated category dari mutation state
        // * Ini lebih efisien, detail screen tidak perlu fetch ulang
        if (_isEdit && next.mutation?.updatedCategory != null) {
          context.pop(next.mutation!.updatedCategory);
        } else {
          context.pop();
        }
      }

      // * Handle mutation error
      if (next.hasMutationError) {
        if (next.mutationFailure is ValidationFailure) {
          setState(
            () => validationErrors =
                (next.mutationFailure as ValidationFailure).errors,
          );
        } else {
          this.logError('Category mutation error', next.mutationFailure);
          AppToast.error(
            next.mutationFailure?.message ??
                context.l10n.categoryOperationFailed,
          );
        }
      }
    });

    return AppLoaderOverlay(
      child: Scaffold(
        appBar: CustomAppBar(
          title: _isEdit
              ? context.l10n.categoryEditCategory
              : context.l10n.categoryCreateCategory,
        ),
        endDrawer: const AppEndDrawer(),
        endDrawerEnableOpenDragGesture: false,
        body: ScreenWrapper(
          child: FormBuilder(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildCategoryInfoSection(),
                  const SizedBox(height: 24),
                  _buildTranslationsSection(),
                  const SizedBox(height: 24),
                  AppValidationErrors(errors: validationErrors),
                  if (validationErrors != null && validationErrors!.isNotEmpty)
                    const SizedBox(height: 16),
                  const SizedBox(height: 24),
                  _buildActionButtons(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryInfoSection() {
    return Card(
      color: context.colors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: context.colors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              context.l10n.categoryInformation,
              style: AppTextStyle.titleMedium,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 16),
            Builder(
              builder: (context) {
                final categoriesState = ref.watch(
                  categoriesParentSearchDropdownProvider,
                );
                final categoryData = _sourceCategory;

                return AppSearchableDropdown<Category>(
                  name: 'parentId',
                  label: context.l10n.categoryParentCategory,
                  hintText: context.l10n.categorySearchCategory,
                  initialValue: categoryData?.parent,
                  items: categoriesState.categories,
                  isLoading: categoriesState.isLoading,
                  onSearch: (query) {
                    ref
                        .read(categoriesParentSearchDropdownProvider.notifier)
                        .search(query);
                  },
                  onLoadMore: () {
                    ref
                        .read(categoriesParentSearchDropdownProvider.notifier)
                        .loadMore();
                  },
                  hasMore: categoriesState.cursor?.hasNextPage ?? false,
                  isLoadingMore: categoriesState.isLoadingMore,
                  itemDisplayMapper: (category) => category.categoryName,
                  itemValueMapper: (category) => category.id,
                  itemSubtitleMapper: (category) => category.categoryCode,
                  itemIconMapper: (category) => Icons.category,
                  validator: (value) =>
                      CategoryUpsertValidator.validateParentId(
                        context,
                        value,
                        isUpdate: _isEdit,
                      ),
                );
              },
            ),
            const SizedBox(height: 16),
            AppTextField(
              name: 'categoryCode',
              label: context.l10n.categoryCategoryCode,
              placeHolder: context.l10n.categoryEnterCategoryCode,
              // * Don't copy category code in copy mode (must be unique)
              initialValue: _isCopyMode ? null : widget.category?.categoryCode,
              validator: (value) =>
                  CategoryUpsertValidator.validateCategoryCode(
                    context,
                    value,
                    isUpdate: _isEdit,
                  ),
            ),
            const SizedBox(height: 16),
            // * Current image preview (edit mode only)
            if (_isEdit && widget.category?.imageUrl != null) ...[
              Center(
                child: Column(
                  children: [
                    AppText(
                      context.l10n.categoryCurrentImage,
                      style: AppTextStyle.labelMedium,
                      color: context.colors.textSecondary,
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () => _showFullImage(widget.category!.imageUrl!),
                      borderRadius: BorderRadius.circular(12),
                      child: AppImage(
                        imageUrl: widget.category?.imageUrl,
                        size: ImageSize.xxxLarge,
                        shape: ImageShape.rectangle,
                        showBorder: true,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            AppFilePicker(
              key: _filePickerKey,
              name: 'image',
              label: context.l10n.categoryImage,
              hintText: context.l10n.categoryChooseImage,
              fileType: FileType.image,
              allowMultiple: false,
              maxFiles: 1,
              maxSizeInMB: 10,
              validator: CategoryUpsertValidator.validateImage,
              allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'webp'],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTranslationsSection() {
    // * Get current language code in backend format (en-US, ja-JP, id-ID)
    final currentLangCode = context.backendLocaleCode;

    return Card(
      color: context.colors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: context.colors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        context.l10n.categoryTranslations,
                        style: AppTextStyle.titleMedium,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 4),
                      AppText(
                        _showAllTranslations
                            ? 'Edit all translations manually'
                            : 'Auto-translate enabled · Edit current language',
                        style: AppTextStyle.bodySmall,
                        color: context.colors.textSecondary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                InkWell(
                  onTap: () {
                    setState(() {
                      _showAllTranslations = !_showAllTranslations;
                    });
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _showAllTranslations
                          ? context.colorScheme.primary.withValues(alpha: 0.1)
                          : context.colors.surfaceVariant.withValues(
                              alpha: 0.5,
                            ),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _showAllTranslations
                            ? context.colorScheme.primary
                            : context.colors.border,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _showAllTranslations
                              ? Icons.translate
                              : Icons.translate_outlined,
                          size: 18,
                          color: _showAllTranslations
                              ? context.colorScheme.primary
                              : context.colors.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        AppText(
                          _showAllTranslations ? 'All' : 'Current',
                          style: AppTextStyle.labelSmall,
                          color: _showAllTranslations
                              ? context.colorScheme.primary
                              : context.colors.textSecondary,
                          fontWeight: _showAllTranslations
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_showAllTranslations) ...[
              _buildTranslationFields('en-US', context.l10n.categoryEnglish),
              const SizedBox(height: 16),
              _buildTranslationFields('ja-JP', context.l10n.categoryJapanese),
              const SizedBox(height: 16),
              _buildTranslationFields('id-ID', context.l10n.categoryIndonesian),
            ] else ...[
              _buildTranslationFields(
                currentLangCode,
                _getLanguageName(currentLangCode),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getLanguageName(String langCode) {
    switch (langCode) {
      case 'en-US':
        return context.l10n.categoryEnglish;
      case 'ja-JP':
        return context.l10n.categoryJapanese;
      case 'id-ID':
        return context.l10n.categoryIndonesian;
      default:
        return langCode;
    }
  }

  Widget _buildTranslationFields(String langCode, String langName) {
    // * Use fetched category translations in edit mode, or source category in copy mode
    final categoryData = _sourceCategory;
    final translation = categoryData?.translations?.firstWhere(
      (t) => t.langCode == langCode,
      orElse: () => CategoryTranslation(
        langCode: langCode,
        categoryName: '',
        description: '',
      ),
    );

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.colors.surfaceVariant.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            langName,
            style: AppTextStyle.titleSmall,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 12),
          AppTextField(
            name: '${langCode}_categoryName',
            label: context.l10n.categoryCategoryName,
            placeHolder: context.l10n.categoryEnterCategoryName,
            initialValue: translation?.categoryName,
            validator: (value) => CategoryUpsertValidator.validateCategoryName(
              context,
              value,
              isUpdate: _isEdit,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: AppButton(
                text: context.l10n.categoryCancel,
                variant: AppButtonVariant.outlined,
                onPressed: () => context.pop(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppButton(
                text: _isEdit
                    ? context.l10n.categoryUpdate
                    : context.l10n.categoryCreate,
                onPressed: _handleSubmit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
