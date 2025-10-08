import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sigma_track/core/domain/failure.dart';
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
  final _formKey = GlobalKey<FormBuilderState>();
  List<ValidationError>? validationErrors;
  bool get _isEdit => widget.category != null || widget.categoryId != null;
  Category? _fetchedCategory;
  bool _showTranslations = false;
  bool _isFetchingTranslations = false;

  @override
  void initState() {
    super.initState();
    // * Auto show translations in create mode
    if (!_isEdit) {
      _showTranslations = true;
    }
  }

  Future<List<Category>> _searchParentCategories(String query) async {
    final notifier = ref.read(categoriesSearchProvider.notifier);
    await notifier.search(query);

    final state = ref.read(categoriesSearchProvider);
    return state.categories;
  }

  void _handleSubmit() {
    if (_formKey.currentState?.saveAndValidate() != true) {
      AppToast.warning('Please fill all required fields');
      return;
    }

    final formData = _formKey.currentState!.value;

    final translations = <dynamic>[];
    for (final langCode in ['en', 'id', 'ja']) {
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
      final params = UpdateCategoryUsecaseParams(
        id: categoryId,
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

  Future<void> _fetchCategoryTranslations() async {
    if (!_isEdit || widget.category?.id == null) return;

    setState(() {
      _isFetchingTranslations = true;
      _showTranslations = true; // * Show immediately to display skeleton
    });

    try {
      // * Wait for provider to load data
      await Future.delayed(const Duration(milliseconds: 100));

      final categoryDetailState = ref.read(
        getCategoryByIdProvider(widget.category!.id),
      );

      if (categoryDetailState.category != null) {
        if (mounted) {
          setState(() {
            _fetchedCategory = categoryDetailState.category;
            _isFetchingTranslations = false;
          });
        }
      } else if (categoryDetailState.failure != null) {
        if (mounted) {
          setState(() {
            _showTranslations = false;
            _isFetchingTranslations = false;
          });
          AppToast.error(
            categoryDetailState.failure?.message ??
                'Failed to load translations',
          );
        }
      } else {
        // * Still loading, wait a bit more
        await Future.delayed(const Duration(seconds: 2));
        final newState = ref.read(getCategoryByIdProvider(widget.category!.id));

        if (mounted) {
          if (newState.category != null) {
            setState(() {
              _fetchedCategory = newState.category;
              _isFetchingTranslations = false;
            });
          } else {
            setState(() {
              _showTranslations = false;
              _isFetchingTranslations = false;
            });
            AppToast.error('Failed to load translations');
          }
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _showTranslations = false;
          _isFetchingTranslations = false;
        });
        this.logError('Error fetching translations', e);
        AppToast.error('Failed to load translations');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // * Watch category by id provider only when showing translations in edit mode
    if (_isEdit && _showTranslations && widget.category?.id != null) {
      final categoryDetailState = ref.watch(
        getCategoryByIdProvider(widget.category!.id),
      );

      // * Update fetched category when data loaded
      if (categoryDetailState.category != null &&
          _fetchedCategory?.id != categoryDetailState.category!.id) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _fetchedCategory = categoryDetailState.category;
              _isFetchingTranslations = false;
            });
          }
        });
      }
    }

    // * Listen to mutation state
    ref.listen<CategoriesState>(categoriesProvider, (previous, next) {
      if (next.isMutating) {
        context.loaderOverlay.show();
      } else {
        context.loaderOverlay.hide();
      }

      if (!next.isMutating && next.message != null && next.failure == null) {
        AppToast.success(next.message ?? 'Category saved successfully');
        context.pop();
      } else if (next.failure != null) {
        if (next.failure is ValidationFailure) {
          setState(
            () => validationErrors = (next.failure as ValidationFailure).errors,
          );
        } else {
          this.logError('Category mutation error', next.failure);
          AppToast.error(next.failure?.message ?? 'Operation failed');
        }
      }
    });

    return AppLoaderOverlay(
      child: Scaffold(
        appBar: CustomAppBar(
          title: _isEdit ? 'Edit Category' : 'Create Category',
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
                        // * Translation toggle for edit mode
                        if (_isEdit && !_showTranslations)
                          _buildShowTranslationsButton(),
                        if (_isEdit && !_showTranslations)
                          const SizedBox(height: 24),
                        // * Show translations section
                        if (!_isEdit || (_isEdit && _showTranslations))
                          _buildTranslationsSection(),
                        if (!_isEdit || (_isEdit && _showTranslations))
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
            const AppText(
              'Category Information',
              style: AppTextStyle.titleMedium,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 16),
            AppSearchField<Category>(
              name: 'parentId',
              label: 'Parent Category',
              hintText: 'Search category...',
              initialValue:
                  (_isEdit ? _fetchedCategory?.parentId : null) ??
                  widget.category?.parentId,
              enableAutocomplete: true,
              onSearch: _searchParentCategories,
              itemDisplayMapper: (category) => category.categoryName,
              itemValueMapper: (category) => category.id,
              itemSubtitleMapper: (category) => category.categoryCode,
              itemIcon: Icons.category,
              validator: CategoryUpsertValidator.validateParentId,
            ),

            const SizedBox(height: 16),
            AppTextField(
              name: 'categoryCode',
              label: 'Category Code',
              placeHolder: 'Enter category code (e.g., CAT-001)',
              initialValue:
                  (_isEdit ? _fetchedCategory?.categoryCode : null) ??
                  widget.category?.categoryCode,
              validator: CategoryUpsertValidator.validateCategoryCode,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShowTranslationsButton() {
    return Card(
      color: context.colors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: context.colors.border),
      ),
      child: InkWell(
        onTap: _isFetchingTranslations ? null : _fetchCategoryTranslations,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText(
                    'Translations',
                    style: AppTextStyle.titleMedium,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    'Click to load and edit translations',
                    style: AppTextStyle.bodySmall,
                    color: context.colors.textSecondary,
                  ),
                ],
              ),
              Icon(Icons.chevron_right, color: context.colors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTranslationsSection() {
    return Skeletonizer(
      enabled: _isFetchingTranslations,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AppText(
                    'Translations',
                    style: AppTextStyle.titleMedium,
                    fontWeight: FontWeight.bold,
                  ),
                  if (_isEdit && _showTranslations)
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          _showTranslations = false;
                          _fetchedCategory = null;
                        });
                      },
                      tooltip: 'Hide translations',
                    ),
                ],
              ),
              const SizedBox(height: 8),
              AppText(
                'Add translations for different languages',
                style: AppTextStyle.bodySmall,
                color: context.colors.textSecondary,
              ),
              const SizedBox(height: 16),
              _buildTranslationFields('en', 'English'),
              const SizedBox(height: 16),
              _buildTranslationFields('id', 'Indonesian'),
              const SizedBox(height: 16),
              _buildTranslationFields('ja', 'Japanese'),
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
        color: context.colors.surfaceVariant.withOpacity(0.3),
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
            label: 'Category Name',
            placeHolder: 'Enter category name',
            initialValue: translation?.categoryName,
            validator: langCode == 'en'
                ? CategoryUpsertValidator.validateCategoryName
                : null,
          ),
          const SizedBox(height: 12),
          AppTextField(
            name: '${langCode}_description',
            label: 'Description',
            placeHolder: 'Enter description',
            type: AppTextFieldType.multiline,
            maxLines: 3,
            initialValue: translation?.description,
            validator: langCode == 'en'
                ? CategoryUpsertValidator.validateDescription
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
            color: Colors.black.withOpacity(0.05),
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
                text: 'Cancel',
                variant: AppButtonVariant.outlined,
                onPressed: () => context.pop(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppButton(
                text: _isEdit ? 'Update' : 'Create',
                onPressed: _handleSubmit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
