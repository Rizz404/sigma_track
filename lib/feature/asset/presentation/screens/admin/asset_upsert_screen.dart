import 'dart:io';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/core/utils/toast_utils.dart';
import 'package:sigma_track/feature/asset/domain/entities/asset.dart';
import 'package:sigma_track/feature/asset/domain/usecases/create_asset_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/update_asset_usecase.dart';
import 'package:sigma_track/feature/asset/presentation/providers/asset_providers.dart';
import 'package:sigma_track/feature/asset/presentation/providers/state/assets_state.dart';
import 'package:sigma_track/feature/asset/presentation/validators/asset_upsert_validator.dart';
import 'package:sigma_track/feature/category/domain/entities/category.dart';
import 'package:sigma_track/feature/category/presentation/providers/category_providers.dart';
import 'package:sigma_track/feature/location/domain/entities/location.dart';
import 'package:sigma_track/feature/location/presentation/providers/location_providers.dart';
import 'package:sigma_track/shared/presentation/widgets/app_button.dart';
import 'package:sigma_track/shared/presentation/widgets/app_date_time_picker.dart';
import 'package:sigma_track/shared/presentation/widgets/app_dropdown.dart';
import 'package:sigma_track/shared/presentation/widgets/app_loader_overlay.dart';
import 'package:sigma_track/shared/presentation/widgets/app_search_field.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text_field.dart';
import 'package:sigma_track/shared/presentation/widgets/app_validation_errors.dart';
import 'package:sigma_track/shared/presentation/widgets/app_end_drawer.dart';
import 'package:sigma_track/shared/presentation/widgets/custom_app_bar.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';

class AssetUpsertScreen extends ConsumerStatefulWidget {
  final Asset? asset;
  final String? assetId;

  const AssetUpsertScreen({super.key, this.asset, this.assetId});

  @override
  ConsumerState<AssetUpsertScreen> createState() => _AssetUpsertScreenState();
}

class _AssetUpsertScreenState extends ConsumerState<AssetUpsertScreen> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final ScreenshotController _screenshotController = ScreenshotController();
  List<ValidationError>? validationErrors;
  bool get _isEdit => widget.asset != null || widget.assetId != null;
  File? _generatedDataMatrixFile;
  String? _dataMatrixPreviewData;

  Future<List<Category>> _searchCategories(String query) async {
    final notifier = ref.read(categoriesSearchProvider.notifier);
    await notifier.search(query);

    final state = ref.read(categoriesSearchProvider);
    return state.categories;
  }

  Future<void> _generateDataMatrix(String assetTag) async {
    try {
      final imageBytes = await _screenshotController.captureFromWidget(
        Container(
          width: 420,
          height: 420,
          color: Colors.white,
          padding: const EdgeInsets.all(10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border.all(color: Colors.grey[300]!, width: 1),
            ),
            child: Center(
              child: BarcodeWidget(
                barcode: Barcode.dataMatrix(),
                data: assetTag,
                width: 380,
                height: 380,
                drawText: false,
              ),
            ),
          ),
        ),
      );

      final tempDir = await getTemporaryDirectory();
      final file = File(
        '${tempDir.path}/data_matrix_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(imageBytes);

      setState(() {
        _generatedDataMatrixFile = file;
        _dataMatrixPreviewData = assetTag;
      });

      this.logInfo('Data matrix generated: ${file.path}');
    } catch (e, s) {
      this.logError('Failed to generate data matrix', e, s);
      AppToast.error('Failed to generate data matrix');
    }
  }

  void _handleGenerateAssetTag() async {
    final categoryId =
        _formKey.currentState?.fields['categoryId']?.value as String?;

    if (categoryId == null || categoryId.isEmpty) {
      AppToast.warning('Please select a category first');
      return;
    }

    final tagState = ref.read(getAssetTagNotifier(categoryId).notifier);
    await tagState.refresh();

    final state = ref.read(getAssetTagNotifier(categoryId));

    if (state.generateAssetTagResponse != null) {
      final suggestedTag = state.generateAssetTagResponse!.suggestedTag;
      _formKey.currentState?.fields['assetTag']?.didChange(suggestedTag);

      // * Auto-generate data matrix based on asset tag
      await _generateDataMatrix(suggestedTag);

      AppToast.success('Asset tag generated: $suggestedTag');
    } else if (state.failure != null) {
      AppToast.error(state.failure?.message ?? 'Failed to generate asset tag');
    }
  }

  Future<List<Location>> _searchLocations(String query) async {
    final notifier = ref.read(locationsSearchProvider.notifier);
    await notifier.search(query);

    final state = ref.read(locationsSearchProvider);
    return state.locations;
  }

  void _handleSubmit() async {
    if (_formKey.currentState?.saveAndValidate() != true) {
      AppToast.warning('Please fill all required fields');
      return;
    }

    final formData = _formKey.currentState!.value;

    final assetTag = formData['assetTag'] as String;
    final assetName = formData['assetName'] as String;
    final categoryId = formData['categoryId'] as String?;
    final brand = formData['brand'] as String?;
    final model = formData['model'] as String?;
    final serialNumber = formData['serialNumber'] as String?;
    final purchaseDate = formData['purchaseDate'] as DateTime?;
    final purchasePrice = formData['purchasePrice'] as String?;
    final vendorName = formData['vendorName'] as String?;
    final warrantyEnd = formData['warrantyEnd'] as DateTime?;
    final status = formData['status'] as String?;
    final condition = formData['condition'] as String?;
    final locationId = formData['locationId'] as String?;

    if (categoryId == null || categoryId.isEmpty) {
      AppToast.warning('Please select a category');
      return;
    }

    // * Generate data matrix if not already generated or asset tag changed
    if (_generatedDataMatrixFile == null ||
        _dataMatrixPreviewData != assetTag) {
      await _generateDataMatrix(assetTag);
    }

    if (_isEdit) {
      final params = UpdateAssetUsecaseParams(
        id: widget.asset!.id,
        assetTag: assetTag,
        assetName: assetName,
        categoryId: categoryId,
        brand: brand,
        model: model,
        serialNumber: serialNumber,
        purchaseDate: purchaseDate,
        purchasePrice: purchasePrice != null
            ? double.tryParse(purchasePrice)
            : null,
        vendorName: vendorName,
        warrantyEnd: warrantyEnd,
        status: status != null ? AssetStatus.fromJson(status) : null,
        condition: condition != null
            ? AssetCondition.fromJson(condition)
            : null,
        locationId: locationId,
        dataMatrixImageFile: _generatedDataMatrixFile,
      );
      ref.read(assetsProvider.notifier).updateAsset(params);
    } else {
      final params = CreateAssetUsecaseParams(
        assetTag: assetTag,
        assetName: assetName,
        categoryId: categoryId,
        brand: brand,
        model: model,
        serialNumber: serialNumber,
        purchaseDate: purchaseDate,
        purchasePrice: purchasePrice != null
            ? double.tryParse(purchasePrice)
            : null,
        vendorName: vendorName,
        warrantyEnd: warrantyEnd,
        status: status != null
            ? AssetStatus.fromJson(status)
            : AssetStatus.active,
        condition: condition != null
            ? AssetCondition.fromJson(condition)
            : AssetCondition.good,
        locationId: locationId,
        dataMatrixImageFile: _generatedDataMatrixFile,
      );
      ref.read(assetsProvider.notifier).createAsset(params);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AssetsState>(assetsProvider, (previous, next) {
      if (next.isMutating) {
        context.loaderOverlay.show();
      } else {
        context.loaderOverlay.hide();
      }

      if (!next.isMutating && next.message != null && next.failure == null) {
        AppToast.success(next.message ?? 'Asset saved successfully');
        context.pop();
      } else if (next.failure != null) {
        if (next.failure is ValidationFailure) {
          setState(
            () => validationErrors = (next.failure as ValidationFailure).errors,
          );
        } else {
          this.logError('Asset mutation error', next.failure);
          AppToast.error(next.failure?.message ?? 'Operation failed');
        }
      }
    });

    return AppLoaderOverlay(
      child: Scaffold(
        appBar: CustomAppBar(title: _isEdit ? 'Edit Asset' : 'Create Asset'),
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
                        _buildBasicInfoSection(),
                        const SizedBox(height: 24),
                        _buildCategoryLocationSection(),
                        const SizedBox(height: 24),
                        _buildPurchaseInfoSection(),
                        const SizedBox(height: 24),
                        _buildStatusSection(),
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

  Widget _buildBasicInfoSection() {
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
              'Basic Information',
              style: AppTextStyle.titleMedium,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AppTextField(
                    name: 'assetTag',
                    label: 'Asset Tag',
                    placeHolder: 'Enter asset tag (e.g., AST-001)',
                    initialValue: widget.asset?.assetTag,
                    validator: (value) => AssetUpsertValidator.validateAssetTag(
                      value,
                      isUpdate: _isEdit,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: IconButton(
                    onPressed: _handleGenerateAssetTag,
                    icon: const Icon(Icons.auto_awesome),
                    tooltip: 'Auto-generate asset tag',
                    style: IconButton.styleFrom(
                      backgroundColor: context.colorScheme.primaryContainer,
                      foregroundColor: context.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AppTextField(
              name: 'assetName',
              label: 'Asset Name',
              placeHolder: 'Enter asset name',
              initialValue: widget.asset?.assetName,
              validator: (value) => AssetUpsertValidator.validateAssetName(
                value,
                isUpdate: _isEdit,
              ),
            ),
            const SizedBox(height: 16),
            AppTextField(
              name: 'brand',
              label: 'Brand (Optional)',
              placeHolder: 'Enter brand name',
              initialValue: widget.asset?.brand,
              validator: (value) =>
                  AssetUpsertValidator.validateBrand(value, isUpdate: _isEdit),
            ),
            const SizedBox(height: 16),
            AppTextField(
              name: 'model',
              label: 'Model (Optional)',
              placeHolder: 'Enter model',
              initialValue: widget.asset?.model,
              validator: (value) =>
                  AssetUpsertValidator.validateModel(value, isUpdate: _isEdit),
            ),
            const SizedBox(height: 16),
            AppTextField(
              name: 'serialNumber',
              label: 'Serial Number (Optional)',
              placeHolder: 'Enter serial number',
              initialValue: widget.asset?.serialNumber,
              validator: (value) => AssetUpsertValidator.validateSerialNumber(
                value,
                isUpdate: _isEdit,
              ),
            ),
            const SizedBox(height: 16),
            if (_dataMatrixPreviewData != null) ...[
              const AppText(
                'Data Matrix Preview',
                style: AppTextStyle.bodyMedium,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: context.colors.border),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      color: Colors.white,
                      padding: const EdgeInsets.all(5),
                      child: BarcodeWidget(
                        barcode: Barcode.dataMatrix(),
                        data: _dataMatrixPreviewData!,
                        width: 190,
                        height: 190,
                        drawText: false,
                      ),
                    ),
                    const SizedBox(height: 8),
                    AppText(
                      _dataMatrixPreviewData!,
                      style: AppTextStyle.bodySmall,
                      color: context.colors.textSecondary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              AppButton(
                text: 'Regenerate Data Matrix',
                variant: AppButtonVariant.outlined,
                size: AppButtonSize.small,
                onPressed: () async {
                  final assetTag =
                      _formKey.currentState?.fields['assetTag']?.value
                          as String?;
                  if (assetTag != null && assetTag.isNotEmpty) {
                    await _generateDataMatrix(assetTag);
                  } else {
                    AppToast.warning('Please enter asset tag first');
                  }
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryLocationSection() {
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
              'Category & Location',
              style: AppTextStyle.titleMedium,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 16),
            AppSearchField<Category>(
              name: 'categoryId',
              label: 'Category',
              hintText: 'Search category...',
              initialValue: widget.asset?.categoryId,
              initialDisplayText: widget.asset?.category?.categoryName,
              enableAutocomplete: true,
              onSearch: _searchCategories,
              itemDisplayMapper: (category) => category.categoryName,
              itemValueMapper: (category) => category.id,
              itemSubtitleMapper: (category) => category.categoryCode,
              itemIcon: Icons.category,
              validator: (value) => AssetUpsertValidator.validateCategoryId(
                value,
                isUpdate: _isEdit,
              ),
            ),
            const SizedBox(height: 16),
            AppSearchField<Location>(
              name: 'locationId',
              label: 'Location (Optional)',
              hintText: 'Search location...',
              initialValue: widget.asset?.locationId,
              initialDisplayText: widget.asset?.location?.locationName,
              enableAutocomplete: true,
              onSearch: _searchLocations,
              itemDisplayMapper: (location) => location.locationName,
              itemValueMapper: (location) => location.id,
              itemSubtitleMapper: (location) => location.locationCode,
              itemIcon: Icons.location_on,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPurchaseInfoSection() {
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
              'Purchase Information',
              style: AppTextStyle.titleMedium,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 16),
            AppDateTimePicker(
              name: 'purchaseDate',
              label: 'Purchase Date (Optional)',
              initialValue: widget.asset?.purchaseDate,
              inputType: InputType.date,
            ),
            const SizedBox(height: 16),
            AppTextField(
              name: 'purchasePrice',
              label: 'Purchase Price (Optional)',
              placeHolder: 'Enter purchase price',
              type: AppTextFieldType.number,
              initialValue: widget.asset?.purchasePrice?.toString(),
              validator: (value) => AssetUpsertValidator.validatePurchasePrice(
                value,
                isUpdate: _isEdit,
              ),
            ),
            const SizedBox(height: 16),
            AppTextField(
              name: 'vendorName',
              label: 'Vendor Name (Optional)',
              placeHolder: 'Enter vendor name',
              initialValue: widget.asset?.vendorName,
              validator: (value) => AssetUpsertValidator.validateVendorName(
                value,
                isUpdate: _isEdit,
              ),
            ),
            const SizedBox(height: 16),
            AppDateTimePicker(
              name: 'warrantyEnd',
              label: 'Warranty End Date (Optional)',
              initialValue: widget.asset?.warrantyEnd,
              inputType: InputType.date,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusSection() {
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
              'Status & Condition',
              style: AppTextStyle.titleMedium,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 16),
            AppDropdown(
              name: 'status',
              label: 'Status',
              hintText: 'Select status',
              items: AssetStatus.values
                  .map(
                    (status) => AppDropdownItem(
                      value: status.value,
                      label: status.label,
                      icon: Icon(status.icon, size: 18),
                    ),
                  )
                  .toList(),
              initialValue: widget.asset?.status.value,
            ),
            const SizedBox(height: 16),
            AppDropdown(
              name: 'condition',
              label: 'Condition',
              hintText: 'Select condition',
              items: AssetCondition.values
                  .map(
                    (condition) => AppDropdownItem(
                      value: condition.value,
                      label: condition.label,
                      icon: Icon(condition.icon, size: 18),
                    ),
                  )
                  .toList(),
              initialValue: widget.asset?.condition.value,
            ),
          ],
        ),
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
