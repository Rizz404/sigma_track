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
import 'package:sigma_track/core/extensions/localization_extension.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/core/utils/toast_utils.dart';
import 'package:sigma_track/feature/asset/domain/entities/asset.dart';
import 'package:sigma_track/feature/asset/domain/usecases/bulk_create_assets_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/create_asset_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/update_asset_usecase.dart';
import 'package:sigma_track/feature/asset/presentation/providers/asset_providers.dart';
import 'package:sigma_track/feature/asset/presentation/providers/generate_bulk_asset_tags_notifier.dart';
import 'package:sigma_track/feature/asset/presentation/providers/state/bulk_asset_tags_state.dart';
import 'package:sigma_track/feature/asset/presentation/providers/state/bulk_data_matrix_state.dart';
import 'package:sigma_track/feature/asset/presentation/providers/upload_bulk_data_matrix_notifier.dart';
import 'package:sigma_track/feature/asset/presentation/providers/state/assets_state.dart';
import 'package:sigma_track/feature/asset/presentation/validators/asset_upsert_validator.dart';
import 'package:sigma_track/feature/category/domain/entities/category.dart';
import 'package:sigma_track/feature/category/presentation/providers/category_providers.dart';
import 'package:sigma_track/feature/location/domain/entities/location.dart';
import 'package:sigma_track/feature/location/presentation/providers/location_providers.dart';
import 'package:sigma_track/feature/user/domain/entities/user.dart';
import 'package:sigma_track/feature/user/presentation/providers/user_providers.dart';
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
  String? _warrantyDurationPeriod = 'months';
  bool _enableBulkCopy = false;
  bool _isBulkProcessing = false;
  String _bulkProcessingStatus = '';
  double _bulkProcessingProgress = 0.0;

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
      AppToast.error(context.l10n.assetFailedToGenerateDataMatrix);
    }
  }

  void _handleGenerateAssetTag() async {
    final categoryId =
        _formKey.currentState?.fields['categoryId']?.value as String?;

    if (categoryId == null || categoryId.isEmpty) {
      AppToast.warning(context.l10n.assetSelectCategoryFirst);
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

      AppToast.success(context.l10n.assetTagGenerated(suggestedTag));
    } else if (state.failure != null) {
      AppToast.error(
        state.failure?.message ?? context.l10n.assetFailedToGenerateTag,
      );
    }
  }

  Future<List<Location>> _searchLocations(String query) async {
    final notifier = ref.read(locationsSearchProvider.notifier);
    await notifier.search(query);

    final state = ref.read(locationsSearchProvider);
    return state.locations;
  }

  Future<List<User>> _searchUsers(String query) async {
    final notifier = ref.read(usersSearchProvider.notifier);
    await notifier.search(query);

    final state = ref.read(usersSearchProvider);
    return state.users;
  }

  void _calculateWarrantyEnd() {
    final purchaseDate =
        _formKey.currentState?.fields['purchaseDate']?.value as DateTime?;
    final durationStr =
        _formKey.currentState?.fields['warrantyDuration']?.value as String?;

    if (purchaseDate == null || durationStr == null || durationStr.isEmpty) {
      return;
    }

    final duration = int.tryParse(durationStr);
    if (duration == null || duration <= 0) {
      return;
    }

    DateTime warrantyEndDate;
    if (_warrantyDurationPeriod == 'months') {
      warrantyEndDate = DateTime(
        purchaseDate.year,
        purchaseDate.month + duration,
        purchaseDate.day,
      );
    } else {
      warrantyEndDate = DateTime(
        purchaseDate.year + duration,
        purchaseDate.month,
        purchaseDate.day,
      );
    }

    _formKey.currentState?.fields['warrantyEnd']?.didChange(warrantyEndDate);
  }

  void _handleSubmit() async {
    if (_formKey.currentState?.saveAndValidate() != true) {
      AppToast.warning(context.l10n.assetFillRequiredFields);
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
    final assignedTo = formData['assignedTo'] as String?;

    if (categoryId == null || categoryId.isEmpty) {
      AppToast.warning(context.l10n.assetSelectCategory);
      return;
    }

    // * Check if bulk copy enabled
    if (_enableBulkCopy && !_isEdit) {
      final copyQuantity = formData['copyQuantity'] as String?;
      final quantity = int.tryParse(copyQuantity ?? '0') ?? 0;

      if (quantity < 1) {
        AppToast.warning('Please enter copy quantity (minimum 1)');
        return;
      }

      // * Parse bulk serial numbers
      final bulkSerialNumbersStr = formData['bulkSerialNumbers'] as String?;
      List<String>? bulkSerialNumbers;
      if (bulkSerialNumbersStr != null &&
          bulkSerialNumbersStr.trim().isNotEmpty) {
        bulkSerialNumbers = bulkSerialNumbersStr
            .split(RegExp(r'[,\n]'))
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
      }

      await _handleBulkCopy(
        categoryId: categoryId,
        assetName: assetName,
        brand: brand,
        model: model,
        bulkSerialNumbers: bulkSerialNumbers,
        purchaseDate: purchaseDate,
        purchasePrice: purchasePrice,
        vendorName: vendorName,
        warrantyEnd: warrantyEnd,
        status: status,
        condition: condition,
        locationId: locationId,
        assignedTo: assignedTo,
        quantity: quantity,
      );
      return;
    }

    // * Generate data matrix if not already generated or asset tag changed
    if (_generatedDataMatrixFile == null ||
        _dataMatrixPreviewData != assetTag) {
      await _generateDataMatrix(assetTag);
    }

    if (_isEdit) {
      // * Use factory method to only include changed fields
      final params = UpdateAssetUsecaseParams.fromChanges(
        id: widget.asset!.id,
        original: widget.asset!,
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
            ? AssetStatus.values.firstWhere((e) => e.value == status)
            : null,
        condition: condition != null
            ? AssetCondition.values.firstWhere((e) => e.value == condition)
            : null,
        locationId: locationId,
        dataMatrixImageFile: _dataMatrixPreviewData != widget.asset!.assetTag
            ? _generatedDataMatrixFile
            : null,
        assignedTo: assignedTo,
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
            ? AssetStatus.values.firstWhere((e) => e.value == status)
            : AssetStatus.active,
        condition: condition != null
            ? AssetCondition.values.firstWhere((e) => e.value == condition)
            : AssetCondition.good,
        locationId: locationId,
        dataMatrixImageFile: _generatedDataMatrixFile,
        assignedTo: assignedTo,
      );
      ref.read(assetsProvider.notifier).createAsset(params);
    }
  }

  Future<void> _handleBulkCopy({
    required String categoryId,
    required String assetName,
    String? brand,
    String? model,
    List<String>? bulkSerialNumbers,
    DateTime? purchaseDate,
    String? purchasePrice,
    String? vendorName,
    DateTime? warrantyEnd,
    String? status,
    String? condition,
    String? locationId,
    String? assignedTo,
    required int quantity,
  }) async {
    setState(() {
      _isBulkProcessing = true;
      _bulkProcessingStatus = 'Generating asset tags...';
      _bulkProcessingProgress = 0.0;
    });

    try {
      // * Step 1: Generate bulk asset tags
      this.logPresentation('Generating $quantity asset tags');
      final tagsNotifier = ref.read(
        generateBulkAssetTagsNotifierProvider.notifier,
      );
      await tagsNotifier.generateTags(categoryId, quantity);

      final tagsState = ref.read(generateBulkAssetTagsNotifierProvider);
      if (tagsState.status != BulkAssetTagsStatus.success ||
          tagsState.data == null) {
        throw Exception(
          tagsState.failure?.message ?? 'Failed to generate tags',
        );
      }

      final tags = tagsState.data!.tags;
      this.logData('Generated ${tags.length} tags');

      setState(() {
        _bulkProcessingStatus = 'Generating data matrix images...';
        _bulkProcessingProgress = 0.2;
      });

      // * Step 2: Generate data matrix for each tag
      final List<File> dataMatrixFiles = [];
      for (int i = 0; i < tags.length; i++) {
        final tag = tags[i];
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
                  data: tag,
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
          '${tempDir.path}/data_matrix_${tag}_${DateTime.now().millisecondsSinceEpoch}.png',
        );
        await file.writeAsBytes(imageBytes);
        dataMatrixFiles.add(file);

        // * Update progress
        final progress = 0.2 + (0.3 * (i + 1) / tags.length);
        setState(() {
          _bulkProcessingProgress = progress;
          _bulkProcessingStatus =
              'Generated ${i + 1}/${tags.length} data matrix images';
        });
      }

      this.logData('Generated ${dataMatrixFiles.length} data matrix images');

      // * Step 3: Upload bulk data matrix with progress tracking
      this.logPresentation(
        'Uploading ${dataMatrixFiles.length} data matrix images',
      );

      setState(() {
        _bulkProcessingStatus =
            'Uploading 0/${dataMatrixFiles.length} data matrix images...';
        _bulkProcessingProgress = 0.5;
      });

      final uploadNotifier = ref.read(
        uploadBulkDataMatrixNotifierProvider.notifier,
      );

      // * Listen to upload completion (simulated progress since API doesn't support it yet)
      final uploadStartProgress = 0.5;
      final uploadEndProgress = 0.8;

      // * Start upload
      final uploadFuture = uploadNotifier.uploadImages(
        tags,
        dataMatrixFiles.map((f) => f.path).toList(),
      );

      // * Simulate progress while uploading (since API doesn't report progress)
      bool uploadComplete = false;
      uploadFuture.then((_) => uploadComplete = true);

      int progressSteps = 0;
      while (!uploadComplete && progressSteps < 30) {
        await Future.delayed(const Duration(milliseconds: 100));
        progressSteps++;
        final simulatedProgress =
            uploadStartProgress +
            ((uploadEndProgress - uploadStartProgress) * (progressSteps / 30));
        setState(() {
          _bulkProcessingProgress = simulatedProgress;
          _bulkProcessingStatus =
              'Uploading data matrix images... ${(simulatedProgress * 100).toInt()}%';
        });
      }

      await uploadFuture;

      final uploadState = ref.read(uploadBulkDataMatrixNotifierProvider);
      if (uploadState.status != BulkDataMatrixStatus.success ||
          uploadState.data == null) {
        throw Exception(
          uploadState.failure?.message ?? 'Failed to upload data matrix',
        );
      }

      this.logData('Uploaded ${uploadState.data!.count} data matrix images');

      setState(() {
        _bulkProcessingStatus = 'Creating assets...';
        _bulkProcessingProgress = 0.8;
      });

      // * Step 4: Create bulk assets
      final assetParams = tags.asMap().entries.map((entry) {
        final index = entry.key;
        final tag = entry.value;

        // * Map serial number from bulk input if provided
        String? finalSerialNumber;
        if (bulkSerialNumbers != null && index < bulkSerialNumbers.length) {
          finalSerialNumber = bulkSerialNumbers[index];
        }

        return CreateAssetUsecaseParams(
          assetTag: tag,
          assetName: assetName,
          categoryId: categoryId,
          brand: brand,
          model: model,
          serialNumber: finalSerialNumber,
          purchaseDate: purchaseDate,
          purchasePrice: purchasePrice != null
              ? double.tryParse(purchasePrice)
              : null,
          vendorName: vendorName,
          warrantyEnd: warrantyEnd,
          status: status != null
              ? AssetStatus.values.firstWhere((e) => e.value == status)
              : AssetStatus.active,
          condition: condition != null
              ? AssetCondition.values.firstWhere((e) => e.value == condition)
              : AssetCondition.good,
          locationId: locationId,
          assignedTo: assignedTo,
        );
      }).toList();

      ref
          .read(assetsProvider.notifier)
          .createManyAssets(BulkCreateAssetsParams(assets: assetParams));

      setState(() {
        _bulkProcessingProgress = 1.0;
      });

      // * Clean up temp files
      for (final file in dataMatrixFiles) {
        if (await file.exists()) {
          await file.delete();
        }
      }

      // * Clear notifier states
      tagsNotifier.clearState();
      uploadNotifier.clearState();
    } catch (e, s) {
      this.logError('Bulk copy failed', e, s);
      setState(() {
        _isBulkProcessing = false;
      });
      AppToast.error('Failed to create bulk assets: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AssetsState>(assetsProvider, (previous, next) {
      // * Handle loading state
      if (next.isMutating && !_isBulkProcessing) {
        context.loaderOverlay.show();
      } else if (!_isBulkProcessing) {
        context.loaderOverlay.hide();
      }

      // * Handle mutation success
      if (next.hasMutationSuccess) {
        AppToast.success(
          next.mutationMessage ?? context.l10n.assetSavedSuccessfully,
        );
        setState(() => _isBulkProcessing = false);
        context.pop();
      }

      // * Handle mutation error
      if (next.hasMutationError) {
        setState(() => _isBulkProcessing = false);
        if (next.mutationFailure is ValidationFailure) {
          setState(
            () => validationErrors =
                (next.mutationFailure as ValidationFailure).errors,
          );
        } else {
          this.logError('Asset mutation error', next.mutationFailure);
          AppToast.error(
            next.mutationFailure?.message ?? context.l10n.assetOperationFailed,
          );
        }
      }
    });

    return AppLoaderOverlay(
      child: Scaffold(
        appBar: CustomAppBar(
          title: _isEdit
              ? context.l10n.assetEditAsset
              : context.l10n.assetCreateAsset,
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
                        if (_isBulkProcessing) _buildBulkProgressSection(),
                        if (!_isBulkProcessing) ...[
                          _buildBasicInfoSection(),
                          const SizedBox(height: 24),
                          if (!_isEdit) _buildBulkCopySection(),
                          if (!_isEdit) const SizedBox(height: 24),
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
                        ],
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
            AppText(
              context.l10n.assetBasicInformation,
              style: AppTextStyle.titleMedium,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: AppTextField(
                    name: 'assetTag',
                    label: context.l10n.assetTag,
                    placeHolder: context.l10n.assetEnterAssetTag,
                    initialValue: widget.asset?.assetTag,
                    enabled: !_enableBulkCopy,
                    validator: (value) => AssetUpsertValidator.validateAssetTag(
                      context,
                      value,
                      isUpdate: _isEdit,
                      isBulkCopy: _enableBulkCopy,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _enableBulkCopy ? null : _handleGenerateAssetTag,
                  icon: const Icon(Icons.auto_awesome),
                  tooltip: _enableBulkCopy
                      ? 'Auto-generation disabled in bulk copy mode'
                      : 'Auto-generate asset tag',
                  style: IconButton.styleFrom(
                    backgroundColor: context.colorScheme.primaryContainer,
                    foregroundColor: context.colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AppTextField(
              name: 'assetName',
              label: context.l10n.assetName,
              placeHolder: context.l10n.assetEnterAssetName,
              initialValue: widget.asset?.assetName,
              validator: (value) => AssetUpsertValidator.validateAssetName(
                context,
                value,
                isUpdate: _isEdit,
              ),
            ),
            const SizedBox(height: 16),
            AppTextField(
              name: 'brand',
              label: context.l10n.assetBrandOptional,
              placeHolder: context.l10n.assetEnterBrand,
              initialValue: widget.asset?.brand,
              validator: (value) => AssetUpsertValidator.validateBrand(
                context,
                value,
                isUpdate: _isEdit,
              ),
            ),
            const SizedBox(height: 16),
            AppTextField(
              name: 'model',
              label: context.l10n.assetModelOptional,
              placeHolder: context.l10n.assetEnterModel,
              initialValue: widget.asset?.model,
              validator: (value) => AssetUpsertValidator.validateModel(
                context,
                value,
                isUpdate: _isEdit,
              ),
            ),
            const SizedBox(height: 16),
            AppTextField(
              name: 'serialNumber',
              label: context.l10n.assetSerialNumberOptional,
              placeHolder: context.l10n.assetEnterSerialNumber,
              initialValue: widget.asset?.serialNumber,
              validator: (value) => AssetUpsertValidator.validateSerialNumber(
                context,
                value,
                isUpdate: _isEdit,
              ),
            ),
            const SizedBox(height: 16),
            if (_dataMatrixPreviewData != null) ...[
              AppText(
                context.l10n.assetDataMatrixPreview,
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
                text: context.l10n.assetRegenerateDataMatrix,
                variant: AppButtonVariant.outlined,
                size: AppButtonSize.small,
                onPressed: () async {
                  final assetTag =
                      _formKey.currentState?.fields['assetTag']?.value
                          as String?;
                  if (assetTag != null && assetTag.isNotEmpty) {
                    await _generateDataMatrix(assetTag);
                  } else {
                    AppToast.warning(context.l10n.assetEnterAssetTagFirst);
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
            AppText(
              context.l10n.assetCategoryAndLocation,
              style: AppTextStyle.titleMedium,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 16),
            AppSearchField<Category>(
              name: 'categoryId',
              label: context.l10n.assetCategory,
              hintText: context.l10n.assetSearchCategory,
              initialValue: widget.asset?.categoryId,
              initialDisplayText: widget.asset?.category?.categoryName,
              enableAutocomplete: true,
              onSearch: _searchCategories,
              itemDisplayMapper: (category) => category.categoryName,
              itemValueMapper: (category) => category.id,
              itemSubtitleMapper: (category) => category.categoryCode,
              itemIcon: Icons.category,
              validator: (value) => AssetUpsertValidator.validateCategoryId(
                context,
                value,
                isUpdate: _isEdit,
              ),
            ),
            const SizedBox(height: 16),
            if (_isEdit) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    context.l10n.assetLocation,
                    style: AppTextStyle.bodyMedium,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 8),
                  AppText(
                    widget.asset?.location?.locationName ??
                        context.l10n.assetNotSet,
                    style: AppTextStyle.bodyMedium,
                    color: context.colors.textSecondary,
                  ),
                  const SizedBox(height: 8),
                  AppText(
                    context.l10n.assetChangeLocationInstruction,
                    style: AppTextStyle.bodySmall,
                    color: context.colors.textSecondary,
                  ),
                ],
              ),
            ] else ...[
              AppSearchField<Location>(
                name: 'locationId',
                label: context.l10n.assetLocationOptional,
                hintText: context.l10n.assetSearchLocation,
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
            const SizedBox(height: 16),
            if (_isEdit) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    context.l10n.assetAssignedTo,
                    style: AppTextStyle.bodyMedium,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 8),
                  AppText(
                    widget.asset?.assignedTo?.fullName ??
                        context.l10n.assetNotAssigned,
                    style: AppTextStyle.bodyMedium,
                    color: context.colors.textSecondary,
                  ),
                  const SizedBox(height: 8),
                  AppText(
                    context.l10n.assetChangeAssignmentInstruction,
                    style: AppTextStyle.bodySmall,
                    color: context.colors.textSecondary,
                  ),
                ],
              ),
            ] else ...[
              AppSearchField<User>(
                name: 'assignedTo',
                label: context.l10n.assetAssignedToOptional,
                hintText: context.l10n.assetSearchUser,
                initialValue: widget.asset?.assignedToId,
                initialDisplayText: widget.asset?.assignedTo?.fullName,
                enableAutocomplete: true,
                onSearch: _searchUsers,
                itemDisplayMapper: (user) => user.name,
                itemValueMapper: (user) => user.id,
                itemSubtitleMapper: (user) => user.email,
                itemIcon: Icons.person,
              ),
            ],
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
            AppText(
              context.l10n.assetPurchaseInformation,
              style: AppTextStyle.titleMedium,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 16),
            AppDateTimePicker(
              name: 'purchaseDate',
              label: context.l10n.assetPurchaseDateOptional,
              initialValue: widget.asset?.purchaseDate,
              inputType: InputType.date,
              onChanged: (_) => _calculateWarrantyEnd(),
            ),
            const SizedBox(height: 16),
            AppTextField(
              name: 'purchasePrice',
              label: context.l10n.assetPurchasePrice,
              placeHolder: context.l10n.assetEnterPurchasePrice,
              type: AppTextFieldType.number,
              initialValue: widget.asset?.purchasePrice?.toString(),
              validator: (value) => AssetUpsertValidator.validatePurchasePrice(
                context,
                value,
                isUpdate: _isEdit,
              ),
            ),
            const SizedBox(height: 16),
            AppTextField(
              name: 'vendorName',
              label: context.l10n.assetVendorNameOptional,
              placeHolder: context.l10n.assetEnterVendorName,
              initialValue: widget.asset?.vendorName,
              validator: (value) => AssetUpsertValidator.validateVendorName(
                context,
                value,
                isUpdate: _isEdit,
              ),
            ),
            const SizedBox(height: 16),
            AppText(
              context.l10n.assetWarrantyDuration,
              style: AppTextStyle.bodyMedium,
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(height: 4),
            AppText(
              context.l10n.assetWarrantyDurationHelper,
              style: AppTextStyle.bodySmall,
              color: context.colors.textSecondary,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: AppTextField(
                    name: 'warrantyDuration',
                    label: '',
                    placeHolder: context.l10n.assetEnterDuration,
                    type: AppTextFieldType.number,
                    onChanged: (_) => _calculateWarrantyEnd(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: AppDropdown<String>(
                    name: 'warrantyPeriod',
                    hintText: context.l10n.assetSelectPeriod,
                    initialValue: _warrantyDurationPeriod,
                    items: [
                      AppDropdownItem(
                        value: 'months',
                        label: context.l10n.assetMonths,
                      ),
                      AppDropdownItem(
                        value: 'years',
                        label: context.l10n.assetYears,
                      ),
                    ],
                    onChanged: (value) {
                      setState(() => _warrantyDurationPeriod = value);
                      _calculateWarrantyEnd();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AppDateTimePicker(
              name: 'warrantyEnd',
              label: context.l10n.assetWarrantyEndDateOptional,
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
            AppText(
              context.l10n.assetStatusAndCondition,
              style: AppTextStyle.titleMedium,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 16),
            AppDropdown(
              name: 'status',
              label: context.l10n.assetStatus,
              hintText: context.l10n.assetSelectStatus,
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
              label: context.l10n.assetCondition,
              hintText: context.l10n.assetSelectCondition,
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

  Widget _buildBulkCopySection() {
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
              children: [
                Icon(Icons.copy_all, color: context.colors.primary, size: 20),
                const SizedBox(width: 8),
                AppText(
                  'Bulk Copy',
                  style: AppTextStyle.titleMedium,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            const SizedBox(height: 8),
            AppText(
              'Create multiple assets with the same data. Only asset tag, data matrix, and serial number will be different.',
              style: AppTextStyle.bodySmall,
              color: context.colors.textSecondary,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Switch(
                  value: _enableBulkCopy,
                  onChanged: (value) {
                    setState(() {
                      _enableBulkCopy = value;
                      // * Clear data matrix preview when enabling bulk copy
                      if (value) {
                        _generatedDataMatrixFile = null;
                        _dataMatrixPreviewData = null;
                      }
                    });
                  },
                ),
                const SizedBox(width: 12),
                AppText('Enable bulk copy', style: AppTextStyle.bodyMedium),
              ],
            ),
            if (_enableBulkCopy) ...[
              const SizedBox(height: 16),
              AppTextField(
                name: 'copyQuantity',
                label: 'Number of copies',
                placeHolder: 'Enter quantity',
                type: AppTextFieldType.number,
                initialValue: '1',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter quantity';
                  }
                  final num = int.tryParse(value);
                  if (num == null || num < 1) {
                    return 'Minimum 1 copy';
                  }
                  if (num > 100) {
                    return 'Maximum 100 copies';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppTextField(
                name: 'bulkSerialNumbers',
                label: 'Serial Numbers (Optional)',
                placeHolder:
                    'Enter serial numbers separated by comma or newline',
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return null; // * Optional field
                  }

                  final quantity =
                      int.tryParse(
                        _formKey.currentState?.fields['copyQuantity']?.value ??
                            '0',
                      ) ??
                      0;

                  if (quantity <= 0) return null;

                  final serialNumbers = value
                      .split(RegExp(r'[,\n]'))
                      .map((e) => e.trim())
                      .where((e) => e.isNotEmpty)
                      .toList();

                  if (serialNumbers.length != quantity) {
                    return 'Please enter exactly $quantity serial numbers';
                  }

                  // * Check for duplicates
                  final uniqueSerials = serialNumbers.toSet();
                  if (uniqueSerials.length != serialNumbers.length) {
                    return 'Duplicate serial numbers found';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.colorScheme.primaryContainer.withValues(
                    alpha: 0.3,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: context.colorScheme.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.tips_and_updates_outlined,
                      color: context.colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: AppText(
                        'Enter one serial number per line or separated by comma. Leave empty to skip serial numbers.',
                        style: AppTextStyle.bodySmall,
                        color: context.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.semantic.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: context.semantic.warning.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: context.semantic.warning,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: AppText(
                        'Asset tags and data matrix will be auto-generated for each copy.',
                        style: AppTextStyle.bodySmall,
                        color: context.semantic.warning,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBulkProgressSection() {
    return Card(
      color: context.colors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: context.colors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(Icons.cloud_upload, size: 64, color: context.colors.primary),
            const SizedBox(height: 24),
            AppText(
              'Creating Bulk Assets',
              style: AppTextStyle.headlineSmall,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            AppText(
              _bulkProcessingStatus,
              style: AppTextStyle.bodyMedium,
              color: context.colors.textSecondary,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: _bulkProcessingProgress,
                minHeight: 8,
                backgroundColor: context.colors.border,
                valueColor: AlwaysStoppedAnimation(context.colors.primary),
              ),
            ),
            const SizedBox(height: 8),
            AppText(
              '${(_bulkProcessingProgress * 100).toStringAsFixed(0)}%',
              style: AppTextStyle.bodyMedium,
              fontWeight: FontWeight.w600,
              color: context.colors.primary,
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
                text: context.l10n.assetCancel,
                variant: AppButtonVariant.outlined,
                onPressed: _isBulkProcessing ? null : () => context.pop(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppButton(
                text: _enableBulkCopy && !_isEdit
                    ? 'Create Bulk Assets'
                    : _isEdit
                    ? context.l10n.assetUpdate
                    : context.l10n.assetCreate,
                onPressed: _isBulkProcessing ? null : _handleSubmit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
