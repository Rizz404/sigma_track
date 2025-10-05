import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/core/utils/toast_utils.dart';
import 'package:sigma_track/feature/category/domain/entities/category.dart';
import 'package:sigma_track/feature/category/domain/usecases/create_category_usecase.dart';
import 'package:sigma_track/feature/category/domain/usecases/update_category_usecase.dart';
import 'package:sigma_track/feature/category/presentation/providers/category_providers.dart';
import 'package:sigma_track/feature/category/presentation/providers/state/categories_state.dart';
import 'package:sigma_track/shared/presentation/widgets/app_button.dart';
import 'package:sigma_track/shared/presentation/widgets/app_loader_overlay.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text_field.dart';
import 'package:sigma_track/shared/presentation/widgets/custom_app_bar.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';

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
  bool get _isEdit => widget.category != null || widget.categoryId != null;

  @override
  Widget build(BuildContext context) {
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
        this.logError('Category mutation error', next.failure);
        AppToast.error(next.failure?.message ?? 'Operation failed');
      }
    });

    return AppLoaderOverlay(
      overlayImagePath: 'assets/images/splash.png',
      overlayImageSize: 120,
      child: Scaffold(
        appBar: CustomAppBar(
          title: _isEdit ? 'Edit Category' : 'Create Category',
        ),
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
                  const SizedBox(height: 32),
                  _buildActionButtons(),
                  const SizedBox(height: 16),
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
              'Category Information',
              style: AppTextStyle.titleMedium,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 16),
            AppTextField(
              name: 'parentId',
              label: 'Parent Category ID (Optional)',
              placeHolder: 'Enter parent category ID',
              initialValue: widget.category?.parentId,
            ),
            const SizedBox(height: 16),
            AppTextField(
              name: 'categoryCode',
              label: 'Category Code',
              placeHolder: 'Enter category code (e.g., CAT-001)',
              initialValue: widget.category?.categoryCode,
              validator: FormBuilderValidators.required(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTranslationsSection() {
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
              'Translations',
              style: AppTextStyle.titleMedium,
              fontWeight: FontWeight.bold,
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
    );
  }

  Widget _buildTranslationFields(String langCode, String langName) {
    final translation = widget.category?.translations?.firstWhere(
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
                ? FormBuilderValidators.required()
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
                ? FormBuilderValidators.required()
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
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
    );
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
      final params = UpdateCategoryUsecaseParams(
        id: widget.category!.id,
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
}
