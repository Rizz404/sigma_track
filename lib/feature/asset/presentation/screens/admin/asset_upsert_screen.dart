import 'dart:io';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
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
import 'package:sigma_track/feature/asset/domain/entities/asset_image.dart'
    as entity;
import 'package:sigma_track/feature/asset/domain/usecases/bulk_create_assets_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/create_asset_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/update_asset_usecase.dart';
import 'package:sigma_track/feature/asset/presentation/providers/asset_providers.dart';
import 'package:sigma_track/feature/asset/presentation/providers/generate_bulk_asset_tags_notifier.dart';
import 'package:sigma_track/feature/asset/presentation/providers/state/bulk_asset_tags_state.dart';
import 'package:sigma_track/feature/asset/presentation/providers/state/bulk_data_matrix_state.dart';
import 'package:sigma_track/feature/asset/presentation/widgets/available_images_picker_dialog.dart';
import 'package:sigma_track/feature/asset/presentation/providers/state/upload_template_images_state.dart';
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
import 'package:sigma_track/shared/presentation/widgets/app_file_picker.dart';
import 'package:sigma_track/shared/presentation/widgets/app_image.dart';
import 'package:sigma_track/shared/presentation/widgets/app_loader_overlay.dart';
import 'package:sigma_track/shared/presentation/widgets/app_price_field_helper.dart';
import 'package:sigma_track/shared/presentation/widgets/app_searchable_dropdown.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text_field.dart';
import 'package:sigma_track/shared/presentation/widgets/app_validation_errors.dart';
import 'package:sigma_track/shared/presentation/widgets/app_end_drawer.dart';
import 'package:sigma_track/shared/presentation/widgets/custom_app_bar.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';

class AssetUpsertScreen extends ConsumerStatefulWidget {
  final Asset? asset;
  final String? assetId;
  final Asset? copyFromAsset;

  const AssetUpsertScreen({
    super.key,
    this.asset,
    this.assetId,
    this.copyFromAsset,
  });

  @override
  ConsumerState<AssetUpsertScreen> createState() => _AssetUpsertScreenState();
}

class _AssetUpsertScreenState extends ConsumerState<AssetUpsertScreen> {
  // * Bulk copy limits
  static const int maxBulkCopyWithoutImages = 100;
  static const int maxBulkCopyWithExistingImages = 50;
  static const int maxBulkCopyWithNewImages = 25;

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final ScreenshotController _screenshotController = ScreenshotController();
  List<ValidationError>? validationErrors;
  bool get _isEdit => widget.asset != null || widget.assetId != null;
  bool get _isCopyMode => widget.copyFromAsset != null;
  // * Helper to get source asset for initialization (copy or edit)
  Asset? get _sourceAsset => widget.copyFromAsset ?? widget.asset;
  File? _generatedDataMatrixFile;
  String? _dataMatrixPreviewData;
  String? _warrantyDurationPeriod = 'months';
  bool _enableBulkCopy = false;
  bool _isBulkProcessing = false;
  String _bulkProcessingStatus = '';
  double _bulkProcessingProgress = 0.0;

  // * Asset images state
  List<PlatformFile> _selectedImageFiles = [];
  List<String> _uploadedTemplateImageUrls = [];
  bool _enableReuseImages = false;
  final GlobalKey<AppFilePickerState> _filePickerKey =
      GlobalKey<AppFilePickerState>();

  @override
  void initState() {
    super.initState();
    // * Load data matrix preview di edit mode
    if (_isEdit && widget.asset?.assetTag != null) {
      _dataMatrixPreviewData = widget.asset!.assetTag;
    }
  }

  Future<bool> _generateDataMatrix(String assetTag) async {
    try {
      final imageBytes = await _screenshotController.captureFromWidget(
        Container(
          width: 420,
          height: 420,
          color: Colors.white,
          padding: const EdgeInsets.all(10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300, width: 1),
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
      return true;
    } catch (e, s) {
      this.logError('Failed to generate data matrix', e, s);
      AppToast.error(context.l10n.assetFailedToGenerateDataMatrix);
      return false;
    }
  }

  void _handleGenerateAssetTag() async {
    final categoryId =
        _formKey.currentState?.fields['categoryId']?.value as String?;

    if (categoryId == null || categoryId.isEmpty) {
      AppToast.warning(context.l10n.assetSelectCategoryFirst);
      return;
    }

    // * Tampilkan loading toast
    AppToast.info('Generating asset tag dan data matrix...');

    final tagState = ref.read(getAssetTagNotifier(categoryId).notifier);
    await tagState.refresh();

    final state = ref.read(getAssetTagNotifier(categoryId));

    if (state.generateAssetTagResponse != null) {
      final suggestedTag = state.generateAssetTagResponse!.suggestedTag;
      _formKey.currentState?.fields['assetTag']?.didChange(suggestedTag);

      // * Auto-generate data matrix based on asset tag
      await _generateDataMatrix(suggestedTag);

      // * Trigger rebuild untuk tampilkan tag dan data matrix baru
      setState(() {});

      AppToast.success(context.l10n.assetTagGenerated(suggestedTag));
    } else if (state.failure != null) {
      AppToast.error(
        state.failure?.message ?? context.l10n.assetFailedToGenerateTag,
      );
    }
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

  void _clearSelectedImages() {
    setState(() {
      _selectedImageFiles.clear();
      _uploadedTemplateImageUrls.clear();
      _filePickerKey.currentState?.reset();
    });
  }

  Future<void> _showAvailableImagesPicker() async {
    final selectedUrls = await showDialog<List<String>>(
      context: context,
      builder: (context) => AvailableImagesPickerDialog(
        initialSelectedUrls: _uploadedTemplateImageUrls,
        lockedImageUrls: _uploadedTemplateImageUrls,
      ),
    );

    if (selectedUrls != null) {
      setState(() {
        _uploadedTemplateImageUrls = selectedUrls;
      });
      this.logInfo('Selected ${selectedUrls.length} images from pool');
    }
  }

  void _handleSubmit() async {
    if (_formKey.currentState?.saveAndValidate() != true) {
      AppToast.warning(context.l10n.assetFillRequiredFields);
      return;
    }

    final formData = _formKey.currentState!.value;

    final assetTag = formData['assetTag'] as String?;
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
        AppToast.warning(context.l10n.assetPleaseEnterCopyQuantity);
        return;
      }

      // * Validate bulk copy quantity using validator
      final hasNewImages = _selectedImageFiles.isNotEmpty;
      final hasExistingImages =
          _enableReuseImages && _uploadedTemplateImageUrls.isNotEmpty;
      final quantityError = AssetUpsertValidator.validateBulkCopyQuantity(
        context,
        quantity.toString(),
        maxWithoutImages: _AssetUpsertScreenState.maxBulkCopyWithoutImages,
        maxWithExistingImages:
            _AssetUpsertScreenState.maxBulkCopyWithExistingImages,
        maxWithNewImages: _AssetUpsertScreenState.maxBulkCopyWithNewImages,
        hasNewImages: hasNewImages,
        hasExistingImages: hasExistingImages,
      );
      if (quantityError != null) {
        AppToast.warning(quantityError);
        return;
      }

      // * Validate total image count (max 5)
      final totalImages =
          _uploadedTemplateImageUrls.length + _selectedImageFiles.length;
      final imageCountError = AssetUpsertValidator.validateImageCount(
        context,
        totalImages,
        maxImages: 5,
        context_label: 'images',
      );
      if (imageCountError != null) {
        AppToast.warning(imageCountError);
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

    // * Validate asset tag for single create
    if (assetTag == null || assetTag.isEmpty) {
      AppToast.warning(context.l10n.assetValidationTagRequired);
      return;
    }

    // * Generate data matrix if not already generated or asset tag changed
    // * In edit mode, we only regenerate if the tag actually changed (because _handleSubmit is called on every save)
    if ((!_isEdit && _generatedDataMatrixFile == null) ||
        _dataMatrixPreviewData != assetTag) {
      await _generateDataMatrix(assetTag);
    }

    // * Upload asset images if selected (for single create only, not edit)
    // * Skip upload if reuse mode enabled (imageUrls already set)
    if (!_isEdit && _selectedImageFiles.isNotEmpty && !_enableReuseImages) {
      context.loaderOverlay.show();
      try {
        final uploadNotifier = ref.read(uploadTemplateImagesProvider.notifier);
        final imagePaths = _selectedImageFiles
            .map((file) => file.path!)
            .where((path) => path.isNotEmpty)
            .toList();

        await uploadNotifier.uploadImages(imagePaths);

        final uploadState = ref.read(uploadTemplateImagesProvider);

        if (uploadState.status != UploadTemplateImagesStatus.success ||
            uploadState.data == null) {
          context.loaderOverlay.hide();
          AppToast.error(
            uploadState.failure?.message ??
                context.l10n.assetFailedToUploadTemplateImages('Unknown error'),
          );
          return;
        }

        _uploadedTemplateImageUrls = uploadState.data!.imageUrls;
        context.loaderOverlay.hide();
      } catch (e) {
        context.loaderOverlay.hide();
        AppToast.error(
          context.l10n.assetFailedToUploadTemplateImages(e.toString()),
        );
        return;
      }
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
            ? double.tryParse(purchasePrice.replaceAll('.', ''))
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
        dataMatrixImageFile: _generatedDataMatrixFile,
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
            ? double.tryParse(purchasePrice.replaceAll('.', ''))
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
        imageUrls: _uploadedTemplateImageUrls.isNotEmpty
            ? _uploadedTemplateImageUrls
            : null,
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
      _bulkProcessingStatus = context.l10n.assetGeneratingAssetTags;
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

      // * Step 2: Upload template images OR use reused images
      if (_enableReuseImages && _uploadedTemplateImageUrls.isNotEmpty) {
        // * Alur 4: Reuse existing images (skip upload)
        this.logPresentation(
          'Using ${_uploadedTemplateImageUrls.length} reused images',
        );
        setState(() {
          _bulkProcessingProgress = 0.15;
        });
      } else if (_selectedImageFiles.isNotEmpty) {
        // * Alur 3: Upload new template images
        setState(() {
          _bulkProcessingStatus = context.l10n.assetUploadingTemplateImages;
          _bulkProcessingProgress = 0.15;
        });

        this.logPresentation(
          'Uploading ${_selectedImageFiles.length} template images',
        );

        final uploadNotifier = ref.read(uploadTemplateImagesProvider.notifier);
        final imagePaths = _selectedImageFiles
            .map((file) => file.path!)
            .where((path) => path.isNotEmpty)
            .toList();

        await uploadNotifier.uploadImages(imagePaths);

        final uploadState = ref.read(uploadTemplateImagesProvider);

        if (uploadState.status != UploadTemplateImagesStatus.success ||
            uploadState.data == null) {
          throw Exception(
            uploadState.failure?.message ?? 'Failed to upload template images',
          );
        }

        // * Store uploaded URLs to be used for all assets
        _uploadedTemplateImageUrls = uploadState.data!.imageUrls;
        this.logData(
          'Uploaded ${_uploadedTemplateImageUrls.length} template images',
        );
      }

      setState(() {
        _bulkProcessingStatus = context.l10n.assetGeneratingDataMatrixImages;
        _bulkProcessingProgress = 0.2;
      });

      // * Step 3: Generate data matrix for each tag
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
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300, width: 1),
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
          _bulkProcessingStatus = context.l10n.assetGeneratedDataMatrix(
            i + 1,
            tags.length,
          );
        });
      }

      this.logData('Generated ${dataMatrixFiles.length} data matrix images');

      // * Step 3: Upload bulk data matrix with progress tracking
      this.logPresentation(
        'Uploading ${dataMatrixFiles.length} data matrix images',
      );

      setState(() {
        _bulkProcessingStatus = context.l10n.assetUploadingDataMatrix(
          0,
          dataMatrixFiles.length,
        );
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
          _bulkProcessingStatus = context.l10n.assetUploadingDataMatrixProgress(
            (simulatedProgress * 100).toInt(),
          );
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

      // * Map asset tags to their data matrix URLs
      final uploadedTags = uploadState.data!.assetTags;
      final uploadedUrls = uploadState.data!.urls;
      final tagToUrlMap = <String, String>{};
      for (int i = 0; i < uploadedTags.length; i++) {
        if (i < uploadedUrls.length) {
          tagToUrlMap[uploadedTags[i]] = uploadedUrls[i];
        }
      }

      this.logData('Mapped ${tagToUrlMap.length} data matrix URLs to tags');

      setState(() {
        _bulkProcessingStatus = context.l10n.assetCreatingAssets;
        _bulkProcessingProgress = 0.8;
      });

      // * Step 4: Create bulk assets with data matrix URLs
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
              ? double.tryParse(purchasePrice.replaceAll('.', ''))
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
          dataMatrixImageUrl: tagToUrlMap[tag],
          imageUrls: _uploadedTemplateImageUrls.isNotEmpty
              ? _uploadedTemplateImageUrls
              : null,
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
      if (_uploadedTemplateImageUrls.isNotEmpty) {
        ref.read(uploadTemplateImagesProvider.notifier).clearState();
      }
    } catch (e, s) {
      this.logError('Bulk copy failed', e, s);
      setState(() {
        _isBulkProcessing = false;
      });
      AppToast.error(context.l10n.assetFailedToCreateBulkAssets(e.toString()));
    }
  }

  Future<bool> _showCancelProcessingDialog() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: AppText(
            context.l10n.assetCancelBulkProcessingTitle,
            style: AppTextStyle.titleMedium,
            fontWeight: FontWeight.bold,
          ),
          content: AppText(
            context.l10n.assetCancelBulkProcessingMessage,
            style: AppTextStyle.bodyMedium,
          ),
          actions: [
            AppButton(
              text: context.l10n.assetContinueProcessing,
              variant: AppButtonVariant.text,
              onPressed: () => Navigator.of(dialogContext).pop(false),
            ),
            AppButton(
              text: context.l10n.assetCancelProcessing,
              variant: AppButtonVariant.filled,
              onPressed: () {
                setState(() => _isBulkProcessing = false);
                Navigator.of(dialogContext).pop(true);
              },
            ),
          ],
        );
      },
    );
    return result ?? false;
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
        context.pop(next.mutation!.updatedAsset);
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

    return PopScope(
      canPop: !_isBulkProcessing,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) {
          return;
        }
        if (_isBulkProcessing) {
          final shouldPop = await _showCancelProcessingDialog();
          if (shouldPop && context.mounted) {
            context.pop();
          }
        }
      },
      child: AppLoaderOverlay(
        child: Scaffold(
          appBar: CustomAppBar(
            title: _isEdit
                ? context.l10n.assetEditAsset
                : context.l10n.assetCreateAsset,
          ),
          endDrawer: const AppEndDrawer(),
          endDrawerEnableOpenDragGesture: false,
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
                            if (!_isEdit && !_enableBulkCopy)
                              _buildAssetImagesSection(),
                            if (!_isEdit && !_enableBulkCopy)
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
            AppTextField(
              name: 'assetName',
              label: context.l10n.assetName,
              placeHolder: context.l10n.assetEnterAssetName,
              initialValue: _sourceAsset?.assetName,
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
              initialValue: _sourceAsset?.brand,
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
              initialValue: _sourceAsset?.model,
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
              // * Don't copy serial number in copy mode
              initialValue: _isCopyMode ? null : widget.asset?.serialNumber,
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
              Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 280),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.colors.surface,
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
                    final success = await _generateDataMatrix(assetTag);
                    if (success && context.mounted) {
                      AppToast.success(
                        'Data matrix berhasil di-generate ulang',
                      );
                    }
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
    final categoriesState = ref.watch(categoriesChildSearchDropdownProvider);

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
            AppSearchableDropdown<Category>(
              name: 'categoryId',
              label: context.l10n.assetCategory,
              hintText: context.l10n.assetSearchCategory,
              initialValue: _sourceAsset?.category,
              items: categoriesState.categories,
              isLoading: categoriesState.isLoading,
              onSearch: (query) {
                ref
                    .read(categoriesChildSearchDropdownProvider.notifier)
                    .search(query);
              },
              onLoadMore: () {
                ref
                    .read(categoriesChildSearchDropdownProvider.notifier)
                    .loadMore();
              },
              hasMore: categoriesState.cursor?.hasNextPage ?? false,
              isLoadingMore: categoriesState.isLoadingMore,
              itemDisplayMapper: (category) => category.categoryName,
              itemValueMapper: (category) => category.id,
              itemSubtitleMapper: (category) =>
                  category.parent?.categoryName ??
                  context.l10n.assetRootCategory,
              itemIconMapper: (category) => Icons.category,
              validator: (value) => AssetUpsertValidator.validateCategoryId(
                context,
                value,
                isUpdate: _isEdit,
              ),
              onChanged: (category) async {
                // * Auto-generate asset tag saat kategori berubah (untuk edit mode)
                if (_isEdit && category != null) {
                  final originalCategoryId = widget.asset?.category?.id;
                  final newCategoryId = category.id;

                  // * Cek apakah kategori benar-benar berubah
                  if (originalCategoryId != newCategoryId) {
                    // * Auto-generate asset tag dengan kategori baru
                    final tagState = ref.read(
                      getAssetTagNotifier(newCategoryId).notifier,
                    );
                    await tagState.refresh();

                    final state = ref.read(getAssetTagNotifier(newCategoryId));

                    if (state.generateAssetTagResponse != null) {
                      final suggestedTag =
                          state.generateAssetTagResponse!.suggestedTag;
                      _formKey.currentState?.fields['assetTag']?.didChange(
                        suggestedTag,
                      );

                      // * Auto-generate data matrix based on new asset tag
                      await _generateDataMatrix(suggestedTag);

                      AppToast.success(
                        context.l10n.assetTagGenerated(suggestedTag),
                      );

                      // * Trigger rebuild untuk tampilkan tag baru
                      setState(() {});
                    } else if (state.failure != null) {
                      AppToast.error(
                        state.failure?.message ??
                            context.l10n.assetFailedToGenerateTag,
                      );
                    }
                  }
                }
              },
            ),
            const SizedBox(height: 16),
            // * Asset Tag Generator (after category selection)
            if (!_enableBulkCopy) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    context.l10n.assetTag,
                    style: AppTextStyle.bodyMedium,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 8),
                  if (_formKey.currentState?.fields['assetTag']?.value !=
                          null &&
                      (_formKey.currentState!.fields['assetTag']!.value
                              as String)
                          .isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: context.colors.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: context.colors.border),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.qr_code_2,
                            color: context.colors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: AppText(
                              _formKey.currentState!.fields['assetTag']!.value
                                  as String,
                              style: AppTextStyle.bodyMedium,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (!_isEdit) ...[
                    AppText(
                      context.l10n.assetSelectCategoryFirst,
                      style: AppTextStyle.bodySmall,
                      color: context.colors.textSecondary,
                    ),
                    const SizedBox(height: 8),
                    AppButton(
                      text: 'Generate Asset Tag dan Data Matrix',
                      variant: AppButtonVariant.outlined,
                      onPressed: _handleGenerateAssetTag,
                      leadingIcon: const Icon(Icons.auto_awesome, size: 20),
                      size: AppButtonSize.small,
                    ),
                  ] else ...[
                    AppText(
                      'Asset tag otomatis di-generate saat kategori berubah',
                      style: AppTextStyle.bodySmall,
                      color: context.colors.textSecondary,
                    ),
                  ],
                  // * Hidden field for asset tag value
                  AppTextField(
                    name: 'assetTag',
                    label: '',
                    type: AppTextFieldType.hidden,
                    initialValue: _isCopyMode ? null : widget.asset?.assetTag,
                    validator: (value) => AssetUpsertValidator.validateAssetTag(
                      context,
                      value,
                      isUpdate: _isEdit,
                      isBulkCopy: _enableBulkCopy,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 24),
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
              Builder(
                builder: (context) {
                  final locationsState = ref.watch(
                    locationsSearchDropdownProvider,
                  );

                  return AppSearchableDropdown<Location>(
                    name: 'locationId',
                    label: context.l10n.assetLocationOptional,
                    hintText: context.l10n.assetSearchLocation,
                    initialValue: _sourceAsset?.location,
                    items: locationsState.locations,
                    isLoading: locationsState.isLoading,
                    onSearch: (query) {
                      ref
                          .read(locationsSearchDropdownProvider.notifier)
                          .search(query);
                    },
                    onLoadMore: () {
                      ref
                          .read(locationsSearchDropdownProvider.notifier)
                          .loadMore();
                    },
                    hasMore: locationsState.cursor?.hasNextPage ?? false,
                    isLoadingMore: locationsState.isLoadingMore,
                    itemDisplayMapper: (location) => location.locationName,
                    itemValueMapper: (location) => location.id,
                    itemSubtitleMapper: (location) => location.locationCode,
                    itemIconMapper: (location) => Icons.location_on,
                  );
                },
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
              Builder(
                builder: (context) {
                  final usersState = ref.watch(usersSearchDropdownProvider);

                  return AppSearchableDropdown<User>(
                    name: 'assignedTo',
                    label: context.l10n.assetAssignedToOptional,
                    hintText: context.l10n.assetSearchUser,
                    initialValue: _sourceAsset?.assignedTo,
                    items: usersState.users,
                    isLoading: usersState.isLoading,
                    onSearch: (query) {
                      ref
                          .read(usersSearchDropdownProvider.notifier)
                          .search(query);
                    },
                    onLoadMore: () {
                      ref.read(usersSearchDropdownProvider.notifier).loadMore();
                    },
                    hasMore: usersState.cursor?.hasNextPage ?? false,
                    isLoadingMore: usersState.isLoadingMore,
                    itemDisplayMapper: (user) => user.name,
                    itemValueMapper: (user) => user.id,
                    itemSubtitleMapper: (user) => user.email,
                    itemIconMapper: (user) => Icons.person,
                  );
                },
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
              initialValue: _sourceAsset?.purchaseDate,
              inputType: InputType.date,
              onChanged: (_) => _calculateWarrantyEnd(),
            ),
            const SizedBox(height: 16),
            AppTextField(
              name: 'purchasePrice',
              label: context.l10n.assetPurchasePrice,
              placeHolder: context.l10n.assetEnterPurchasePrice,
              type: AppTextFieldType.price,
              initialValue: _sourceAsset?.purchasePrice?.toString(),
              validator: (value) => AssetUpsertValidator.validatePurchasePrice(
                context,
                value,
                isUpdate: _isEdit,
              ),
            ),
            AppPriceFieldHelper(
              onApply: (idrValue) {
                _formKey.currentState?.fields['purchasePrice']?.didChange(
                  idrValue,
                );
              },
            ),
            const SizedBox(height: 16),
            AppTextField(
              name: 'vendorName',
              label: context.l10n.assetVendorNameOptional,
              placeHolder: context.l10n.assetEnterVendorName,
              initialValue: _sourceAsset?.vendorName,
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
              initialValue: _sourceAsset?.warrantyEnd,
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
              initialValue: _sourceAsset?.status.value,
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
              initialValue: _sourceAsset?.condition.value,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssetImagesSection() {
    // * Get existing images from asset when in edit mode
    final existingImages = _isEdit && _sourceAsset?.images != null
        ? _sourceAsset!.images!
        : <entity.AssetImage>[];

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
                Icon(
                  Icons.image_outlined,
                  color: context.colors.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                AppText(
                  _isEdit
                      ? context.l10n.assetExistingImages
                      : context.l10n.assetSelectImages,
                  style: AppTextStyle.titleMedium,
                  fontWeight: FontWeight.bold,
                ),
                if (existingImages.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: context.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: AppText(
                      '${existingImages.length}',
                      style: AppTextStyle.labelSmall,
                      color: context.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            ),

            // * Show existing images in edit mode
            if (_isEdit && existingImages.isNotEmpty) ...[
              const SizedBox(height: 8),
              AppText(
                context.l10n.assetExistingImagesHint,
                style: AppTextStyle.bodySmall,
                color: context.colors.textSecondary,
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 120,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: existingImages.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final image = existingImages[index];
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: image.isPrimary
                                    ? context.colorScheme.primary
                                    : context.colors.border,
                                width: image.isPrimary ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: image.imageUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color:
                                    context.colorScheme.surfaceContainerHighest,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color:
                                    context.colorScheme.surfaceContainerHighest,
                                child: const Icon(Icons.broken_image),
                              ),
                            ),
                          ),
                        ),
                        if (image.isPrimary)
                          Positioned(
                            top: 4,
                            right: 4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: context.colorScheme.primary,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: AppText(
                                context.l10n.assetPrimaryImage,
                                style: AppTextStyle.labelSmall,
                                color: context.colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Divider(color: context.colors.border),
            ],

            const SizedBox(height: 8),
            AppText(
              _isEdit
                  ? context.l10n.assetUpdateImagesHint
                  : context.l10n.assetTemplateImagesHint,
              style: AppTextStyle.bodySmall,
              color: context.colors.textSecondary,
            ),
            if (!_isEdit) ...[
              const SizedBox(height: 16),
              SwitchListTile(
                title: const AppText(
                  'Reuse Existing Images',
                  style: AppTextStyle.bodyMedium,
                  fontWeight: FontWeight.w500,
                ),
                subtitle: AppText(
                  'Use images already uploaded to the system',
                  style: AppTextStyle.bodySmall,
                  color: context.colors.textSecondary,
                ),
                value: _enableReuseImages,
                onChanged: (value) {
                  setState(() {
                    _enableReuseImages = value;
                    if (value) {
                      _selectedImageFiles.clear();
                      _filePickerKey.currentState?.reset();
                    } else {
                      _uploadedTemplateImageUrls.clear();
                    }
                  });
                },
                activeTrackColor: context.colors.primary,
              ),
            ],
            const SizedBox(height: 16),
            if (_enableReuseImages) ...[
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: _uploadedTemplateImageUrls.isEmpty
                          ? context.l10n.assetSelectFromAvailableImages
                          : context.l10n.assetImagesSelectedCount(
                              _uploadedTemplateImageUrls.length,
                            ),
                      onPressed: _showAvailableImagesPicker,
                      variant: _uploadedTemplateImageUrls.isEmpty
                          ? AppButtonVariant.outlined
                          : AppButtonVariant.filled,
                      leadingIcon: Icon(
                        _uploadedTemplateImageUrls.isEmpty
                            ? Icons.cloud_download_outlined
                            : Icons.check_circle_outline,
                        size: 20,
                      ),
                    ),
                  ),
                  if (_uploadedTemplateImageUrls.isNotEmpty) ...[
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 140,
                      child: AppButton(
                        text: context.l10n.assetClearImages,
                        onPressed: _clearSelectedImages,
                        variant: AppButtonVariant.text,
                        leadingIcon: const Icon(Icons.clear, size: 20),
                      ),
                    ),
                  ],
                ],
              ),
            ] else ...[
              AppFilePicker(
                key: _filePickerKey,
                name: 'assetImages',
                label: null,
                hintText: context.l10n.assetSelectImages,
                fileType: FileType.image,
                allowMultiple: true,
                maxFiles: 5,
                maxSizeInMB: 10,
                onFilesChanged: (files) {
                  setState(() => _selectedImageFiles = files);
                },
                validator: (files) {
                  if (files == null || files.isEmpty) return null;
                  return AssetUpsertValidator.validateImageCount(
                    context,
                    files.length,
                    maxImages: 5,
                    context_label: 'images',
                  );
                },
              ),
            ],
            if (_enableReuseImages &&
                _uploadedTemplateImageUrls.isNotEmpty) ...[
              const SizedBox(height: 16),
              SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _uploadedTemplateImageUrls.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final imageUrl = _uploadedTemplateImageUrls[index];
                    return AppImage(
                      imageUrl: imageUrl,
                      size: ImageSize.xLarge,
                      fit: BoxFit.cover,
                      shape: ImageShape.rectangle,
                    );
                  },
                ),
              ),
            ],
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
                  context.l10n.assetBulkCopy,
                  style: AppTextStyle.titleMedium,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            const SizedBox(height: 8),
            AppText(
              context.l10n.assetBulkCopyDescription,
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
                AppText(
                  context.l10n.assetEnableBulkCopy,
                  style: AppTextStyle.bodyMedium,
                ),
              ],
            ),
            if (_enableBulkCopy) ...[
              const SizedBox(height: 16),
              AppTextField(
                name: 'copyQuantity',
                label: context.l10n.assetNumberOfCopies,
                placeHolder: context.l10n.assetEnterQuantity,
                type: AppTextFieldType.number,
                initialValue: '1',
                validator: (value) {
                  final hasNewImages = _selectedImageFiles.isNotEmpty;
                  final hasExistingImages =
                      _enableReuseImages &&
                      _uploadedTemplateImageUrls.isNotEmpty;
                  return AssetUpsertValidator.validateBulkCopyQuantity(
                    context,
                    value,
                    maxWithoutImages:
                        _AssetUpsertScreenState.maxBulkCopyWithoutImages,
                    maxWithExistingImages:
                        _AssetUpsertScreenState.maxBulkCopyWithExistingImages,
                    maxWithNewImages:
                        _AssetUpsertScreenState.maxBulkCopyWithNewImages,
                    hasNewImages: hasNewImages,
                    hasExistingImages: hasExistingImages,
                  );
                },
              ),
              const SizedBox(height: 16),
              AppTextField(
                name: 'bulkSerialNumbers',
                label: context.l10n.assetSerialNumbersOptional,
                placeHolder: context.l10n.assetEnterSerialNumbers,
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
                    return context.l10n.assetEnterExactlySerialNumbers(
                      quantity,
                    );
                  }

                  // * Check for duplicates
                  final uniqueSerials = serialNumbers.toSet();
                  if (uniqueSerials.length != serialNumbers.length) {
                    return context.l10n.assetDuplicateSerialNumbers;
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
                        context.l10n.assetSerialNumbersHint,
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
                        context.l10n.assetBulkAutoGenerateInfo,
                        style: AppTextStyle.bodySmall,
                        color: context.semantic.warning,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // * Asset Images Selection
              AppText(
                context.l10n.assetSelectTemplateImages,
                style: AppTextStyle.bodyMedium,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 8),
              AppText(
                context.l10n.assetTemplateImagesHint,
                style: AppTextStyle.bodySmall,
                color: context.colors.textSecondary,
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: AppText(
                  context.l10n.assetReuseExistingImages,
                  style: AppTextStyle.bodyMedium,
                  fontWeight: FontWeight.w500,
                ),
                subtitle: AppText(
                  context.l10n.assetReuseExistingImagesHint,
                  style: AppTextStyle.bodySmall,
                  color: context.colors.textSecondary,
                ),
                value: _enableReuseImages,
                onChanged: (value) {
                  setState(() {
                    _enableReuseImages = value;
                    if (value) {
                      _selectedImageFiles.clear();
                      _filePickerKey.currentState?.reset();
                    } else {
                      _uploadedTemplateImageUrls.clear();
                    }
                  });
                },
                activeTrackColor: context.colors.primary,
              ),
              const SizedBox(height: 16),
              if (_enableReuseImages) ...[
                // * Validate reused images count (max 5)
                if (_uploadedTemplateImageUrls.length > 5)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: context.colorScheme.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: context.colorScheme.error,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning_rounded,
                            color: context.colorScheme.error,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AppText(
                              context.l10n.assetMaxImagesWarning(
                                _uploadedTemplateImageUrls.length,
                              ),
                              style: AppTextStyle.bodySmall,
                              color: context.colorScheme.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        text: _uploadedTemplateImageUrls.isEmpty
                            ? context.l10n.assetSelectFromAvailableImages
                            : context.l10n.assetImagesSelectedCount(
                                _uploadedTemplateImageUrls.length,
                              ),
                        onPressed: _showAvailableImagesPicker,
                        variant: _uploadedTemplateImageUrls.isEmpty
                            ? AppButtonVariant.outlined
                            : AppButtonVariant.filled,
                        leadingIcon: Icon(
                          _uploadedTemplateImageUrls.isEmpty
                              ? Icons.cloud_download_outlined
                              : Icons.check_circle_outline,
                          size: 20,
                        ),
                      ),
                    ),
                    if (_uploadedTemplateImageUrls.isNotEmpty) ...[
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 140,
                        child: AppButton(
                          text: context.l10n.assetClearImages,
                          onPressed: _clearSelectedImages,
                          variant: AppButtonVariant.text,
                          leadingIcon: const Icon(Icons.clear, size: 20),
                        ),
                      ),
                    ],
                  ],
                ),
                if (_uploadedTemplateImageUrls.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 100,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _uploadedTemplateImageUrls.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final imageUrl = _uploadedTemplateImageUrls[index];
                        return AppImage(
                          imageUrl: imageUrl,
                          size: ImageSize.xLarge,
                          fit: BoxFit.cover,
                          shape: ImageShape.rectangle,
                        );
                      },
                    ),
                  ),
                ],
              ] else ...[
                AppFilePicker(
                  key: _filePickerKey,
                  name: 'bulkAssetImages',
                  label: null,
                  hintText: context.l10n.assetSelectImages,
                  fileType: FileType.image,
                  allowMultiple: true,
                  maxFiles: 5,
                  maxSizeInMB: 10,
                  onFilesChanged: (files) {
                    setState(() => _selectedImageFiles = files);
                  },
                  validator: (files) {
                    if (files == null || files.isEmpty) return null;
                    return AssetUpsertValidator.validateImageCount(
                      context,
                      files.length,
                      maxImages: 5,
                      context_label: 'images',
                    );
                  },
                ),
              ],
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
              context.l10n.assetCreatingBulkAssets,
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
            color: context.colors.divider,
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
                    ? context.l10n.assetCreateBulkAssets
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
