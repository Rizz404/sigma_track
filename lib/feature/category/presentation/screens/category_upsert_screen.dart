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
import 'package:sigma_track/shared/presentation/widgets/app_loader_overlay.dart';
import 'package:sigma_track/shared/presentation/widgets/app_search_field.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text_field.dart';
import 'package:sigma_track/shared/presentation/widgets/app_validation_errors.dart';
import 'package:sigma_track/shared/presentation/widgets/app_end_drawer.dart';
import 'package:sigma_track/shared/presentation/widgets/custom_app_bar.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CategoryUpsertScreen extends ConsumerStatefulWidget {
  final Category? category;
  final String? categoryId;

  const CategoryUpsertScreen({super.key, this.category, this.categoryId});

  @override
  ConsumerState<CategoryUpsertScreen> createState() =>
      _CategoryUpsertScreenState();
}

class _CategoryUpsertScreenState extends ConsumerState<CategoryUpsertScreen> {
  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  List<ValidationError>? validationErrors;
  bool get _isEdit => widget.category != null || widget.categoryId != null;
  Category? _fetchedCategory;
  bool _isLoadingTranslations = false;

  Future<List<Category>> _searchParentCategories(String query) async {
    final notifier = ref.read(categoriesSearchProvider.notifier);
    await notifier.search(query);

    final state = ref.read(categoriesSearchProvider);
    return state.categories;
  }

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

    final parentId = formData['parentId'] as String?;
    final categoryCode = formData['categoryCode'] as String;

    if (_isEdit) {
      final categoryId = _fetchedCategory?.id ?? widget.category!.id;
      final params = UpdateCategoryUsecaseParams.fromChanges(
        id: categoryId,
        original: _fetchedCategory ?? widget.category!,
        parentId: parentId,
        categoryCode: categoryCode,
        translations: translations.cast<UpdateCategoryTranslation>(),
      );
      ref.read(categoriesProvider.notifier).updateCategory(params);
    } else {
      final params = CreateCategoryUsecaseParams(
        parentId: parentId ?? '',
        categoryCode: categoryCode,
        translations: translations.cast<CreateCategoryTranslation>(),
      );
      ref.read(categoriesProvider.notifier).createCategory(params);
    }
  }

  @override
  Widget build(BuildContext context) {
    // * Auto load translations in edit mode
    if (_isEdit && widget.category?.id != null) {
      final categoryDetailState = ref.watch(
        getCategoryByIdProvider(widget.category!.id),
      );

      // ? Update fetched category when data changes
      if (categoryDetailState.isLoading) {
        if (!_isLoadingTranslations) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() => _isLoadingTranslations = true);
            }
          });
        }
      } else if (categoryDetailState.category != null) {
        if (_fetchedCategory?.id != categoryDetailState.category!.id) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _fetchedCategory = categoryDetailState.category;
                _isLoadingTranslations = false;
                // ! Recreate form key to rebuild form with new data
                _formKey = GlobalKey<FormBuilderState>();
              });
            }
          });
        }
      } else if (categoryDetailState.failure != null &&
          _isLoadingTranslations) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() => _isLoadingTranslations = false);
            AppToast.error(
              categoryDetailState.failure?.message ??
                  context.l10n.categoryFailedToLoadTranslations,
            );
          }
        });
      }
    }

    // * Listen to mutation state
    ref.listen<CategoriesState>(categoriesProvider, (previous, next) {
      // * Handle loading state
      if (next.isMutating) {
        context.loaderOverlay.show();
      } else {
        context.loaderOverlay.hide();
      }

      // * Handle mutation success
      if (next.hasMutationSuccess) {
        AppToast.success(
          next.mutationMessage ?? context.l10n.categorySavedSuccessfully,
        );
        context.pop();
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
        body: Column(
          children: [
            Expanded(
              child: ScreenWrapper(
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
                        if (validationErrors != null &&
                            validationErrors!.isNotEmpty)
                          const SizedBox(height: 16),
                        const SizedBox(
                          height: 80,
                        ), // * Space for sticky buttons
                      ],
                    ),
                  ),
                ),
              ),
            ),
            _buildStickyActionButtons(),
          ],
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
            AppSearchField<Category>(
              name: 'parentId',
              label: context.l10n.categoryParentCategory,
              hintText: context.l10n.categorySearchCategory,
              initialValue:
                  (_isEdit ? _fetchedCategory?.parentId : null) ??
                  widget.category?.parentId,
              enableAutocomplete: true,
              onSearch: _searchParentCategories,
              itemDisplayMapper: (category) => category.categoryName,
              itemValueMapper: (category) => category.id,
              itemSubtitleMapper: (category) => category.categoryCode,
              itemIcon: Icons.category,
              validator: (value) => CategoryUpsertValidator.validateParentId(
                context,
                value,
                isUpdate: _isEdit,
              ),
            ),

            const SizedBox(height: 16),
            AppTextField(
              name: 'categoryCode',
              label: context.l10n.categoryCategoryCode,
              placeHolder: context.l10n.categoryEnterCategoryCode,
              initialValue:
                  (_isEdit ? _fetchedCategory?.categoryCode : null) ??
                  widget.category?.categoryCode,
              validator: (value) =>
                  CategoryUpsertValidator.validateCategoryCode(
                    context,
                    value,
                    isUpdate: _isEdit,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTranslationsSection() {
    return Skeletonizer(
      enabled: _isLoadingTranslations,
      child: Card(
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
                context.l10n.categoryTranslations,
                style: AppTextStyle.titleMedium,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 8),
              AppText(
                context.l10n.categoryAddTranslations,
                style: AppTextStyle.bodySmall,
                color: context.colors.textSecondary,
              ),
              const SizedBox(height: 16),
              _buildTranslationFields('en-US', context.l10n.categoryEnglish),
              const SizedBox(height: 16),
              _buildTranslationFields('ja-JP', context.l10n.categoryJapanese),
              const SizedBox(height: 16),
              _buildTranslationFields('id-ID', context.l10n.categoryIndonesian),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTranslationFields(String langCode, String langName) {
    // * Use fetched category translations in edit mode
    final categoryData = _isEdit ? _fetchedCategory : widget.category;
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
            validator: langCode == 'en-US'
                ? (value) => CategoryUpsertValidator.validateCategoryName(
                    context,
                    value,
                    isUpdate: _isEdit,
                  )
                : null,
          ),
          const SizedBox(height: 12),
          AppTextField(
            name: '${langCode}_description',
            label: context.l10n.categoryDescription,
            placeHolder: context.l10n.categoryEnterDescription,
            type: AppTextFieldType.multiline,
            maxLines: 3,
            initialValue: translation?.description,
            validator: langCode == 'en-US'
                ? (value) => CategoryUpsertValidator.validateDescription(
                    context,
                    value,
                    isUpdate: _isEdit,
                  )
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildStickyActionButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border(top: BorderSide(color: context.colors.border, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
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
