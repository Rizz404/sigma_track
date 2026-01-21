// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class L10nEn extends L10n {
  L10nEn([String locale = 'en']) : super(locale);

  @override
  String get assetDeleteAsset => 'Delete Asset';

  @override
  String assetDeleteConfirmation(String assetName) {
    return 'Are you sure you want to delete \"$assetName\"?';
  }

  @override
  String get assetCancel => 'Cancel';

  @override
  String get assetDelete => 'Delete';

  @override
  String get assetDetail => 'Asset Detail';

  @override
  String get assetInformation => 'Asset Information';

  @override
  String get assetTag => 'Asset Tag';

  @override
  String get assetName => 'Asset Name';

  @override
  String get assetCategory => 'Category';

  @override
  String get assetBrand => 'Brand';

  @override
  String get assetBrandLabel => 'Brand';

  @override
  String get assetModel => 'Model';

  @override
  String get assetModelLabel => 'Model';

  @override
  String get assetSerialNumber => 'Serial Number';

  @override
  String get assetStatus => 'Status';

  @override
  String get assetCondition => 'Condition';

  @override
  String get assetLocation => 'Location';

  @override
  String get assetAssignedTo => 'Assigned To';

  @override
  String get assetPurchaseInformation => 'Purchase Information';

  @override
  String get assetPurchaseDate => 'Purchase Date';

  @override
  String get assetPurchasePrice => 'Purchase Price';

  @override
  String get assetVendorName => 'Vendor Name';

  @override
  String get assetWarrantyEnd => 'Warranty End';

  @override
  String get assetMetadata => 'Metadata';

  @override
  String get assetCreatedAt => 'Created At';

  @override
  String get assetUpdatedAt => 'Updated At';

  @override
  String get assetDataMatrixImage => 'Data Matrix Image';

  @override
  String get assetOnlyAdminCanEdit => 'Only admin can edit assets';

  @override
  String get assetOnlyAdminCanDelete => 'Only admin can delete assets';

  @override
  String get assetFailedToLoad => 'Failed to load asset';

  @override
  String get assetLocationPermissionRequired => 'Location Permission Required';

  @override
  String get assetLocationPermissionMessage =>
      'Location access is needed to track scan logs. Please enable it in settings.';

  @override
  String get assetOpenSettings => 'Open Settings';

  @override
  String get assetLocationPermissionNeeded =>
      'Location permission needed for scan logs';

  @override
  String get assetInvalidBarcode => 'Invalid barcode data';

  @override
  String assetFound(String assetName) {
    return 'Asset found: $assetName';
  }

  @override
  String get assetNotFound => 'Asset not found';

  @override
  String get assetFailedToProcessBarcode => 'Failed to process barcode';

  @override
  String get assetCameraError => 'Camera Error';

  @override
  String get assetAlignDataMatrix => 'Align data matrix within frame';

  @override
  String get assetProcessing => 'Processing...';

  @override
  String get assetFlash => 'Flash';

  @override
  String get assetFlip => 'Flip';

  @override
  String get assetEditAsset => 'Edit Asset';

  @override
  String get assetCreateAsset => 'Create Asset';

  @override
  String get assetFillRequiredFields => 'Please fill all required fields';

  @override
  String get assetSelectCategory => 'Please select a category';

  @override
  String get assetSavedSuccessfully => 'Asset saved successfully';

  @override
  String get assetOperationFailed => 'Operation failed';

  @override
  String get assetDeletedSuccess => 'Asset deleted';

  @override
  String get assetDeletedFailed => 'Delete failed';

  @override
  String get assetFailedToGenerateDataMatrix =>
      'Failed to generate data matrix';

  @override
  String get assetSelectCategoryFirst => 'Please select a category first';

  @override
  String assetTagGenerated(String tag) {
    return 'Asset tag generated: $tag';
  }

  @override
  String get assetFailedToGenerateTag => 'Failed to generate asset tag';

  @override
  String get assetSelectImages => 'Select Images';

  @override
  String get assetTemplateImagesHint =>
      'Upload images that will be used for this asset';

  @override
  String assetImagesSelected(int count) {
    return '$count images selected';
  }

  @override
  String get assetClearImages => 'Clear';

  @override
  String get assetSelectTemplateImages => 'Select Template Images';

  @override
  String get assetEnterAssetTagFirst => 'Please enter asset tag first';

  @override
  String get assetBasicInformation => 'Basic Information';

  @override
  String get assetEnterAssetTag => 'Enter asset tag (e.g., AST-001)';

  @override
  String get assetAutoGenerateTag => 'Auto-generate asset tag';

  @override
  String get assetEnterAssetName => 'Enter asset name';

  @override
  String get assetBrandOptional => 'Brand (Optional)';

  @override
  String get assetEnterBrand => 'Enter brand name';

  @override
  String get assetModelOptional => 'Model (Optional)';

  @override
  String get assetEnterModel => 'Enter model';

  @override
  String get assetSerialNumberOptional => 'Serial Number (Optional)';

  @override
  String get assetEnterSerialNumber => 'Enter serial number';

  @override
  String get assetDataMatrixPreview => 'Data Matrix Preview';

  @override
  String get assetRegenerateDataMatrix => 'Regenerate Data Matrix';

  @override
  String get assetCategoryAndLocation => 'Category & Location';

  @override
  String get assetSearchCategory => 'Search category...';

  @override
  String get assetNotSet => 'Not set';

  @override
  String get assetChangeLocationInstruction =>
      'To change location, use Asset Movement screen';

  @override
  String get assetLocationOptional => 'Location (Optional)';

  @override
  String get assetSearchLocation => 'Search location...';

  @override
  String get assetNotAssigned => 'Not assigned';

  @override
  String get assetChangeAssignmentInstruction =>
      'To change assignment, use Asset Movement screen';

  @override
  String get assetAssignedToOptional => 'Assigned To (Optional)';

  @override
  String get assetSearchUser => 'Search user...';

  @override
  String get assetPurchaseDateOptional => 'Purchase Date (Optional)';

  @override
  String get assetEnterPurchasePrice => 'Enter purchase price';

  @override
  String get assetVendorNameOptional => 'Vendor Name (Optional)';

  @override
  String get assetEnterVendorName => 'Enter vendor name';

  @override
  String get assetWarrantyEndDateOptional => 'Warranty End Date (Optional)';

  @override
  String get assetWarrantyDuration => 'Warranty Duration (Auto-calculate)';

  @override
  String get assetWarrantyDurationHelper =>
      'Auto-calculate warranty end from purchase date';

  @override
  String get assetEnterDuration => 'Enter duration';

  @override
  String get assetMonth => 'Month';

  @override
  String get assetMonths => 'Months';

  @override
  String get assetYear => 'Year';

  @override
  String get assetYears => 'Years';

  @override
  String get assetSelectPeriod => 'Select period';

  @override
  String get assetStatusAndCondition => 'Status & Condition';

  @override
  String get assetSelectStatus => 'Select status';

  @override
  String get assetSelectCondition => 'Select condition';

  @override
  String get assetUpdate => 'Update';

  @override
  String get assetCreate => 'Create';

  @override
  String get assetCreateAssetTitle => 'Create Asset';

  @override
  String get assetCreateAssetSubtitle => 'Add a new asset';

  @override
  String get assetSelectManyTitle => 'Select Many';

  @override
  String get assetSelectManySubtitle => 'Select multiple assets to delete';

  @override
  String get assetFilterAndSortTitle => 'Filter & Sort';

  @override
  String get assetFilterAndSortSubtitle => 'Customize asset display';

  @override
  String get assetFilterByCategory => 'Filter by Category';

  @override
  String get assetFilterByLocation => 'Filter by Location';

  @override
  String get assetFilterByAssignedTo => 'Filter by Assigned To';

  @override
  String get assetEnterBrandFilter => 'Enter brand...';

  @override
  String get assetEnterModelFilter => 'Enter model...';

  @override
  String get assetSortBy => 'Sort By';

  @override
  String get assetSortOrder => 'Sort Order';

  @override
  String get assetReset => 'Reset';

  @override
  String get assetApply => 'Apply';

  @override
  String get assetFilterReset => 'Filter reset';

  @override
  String get assetFilterApplied => 'Filter applied';

  @override
  String get assetManagement => 'Asset Management';

  @override
  String get assetSelectAssetsToDelete => 'Select assets to delete';

  @override
  String get assetDeleteAssets => 'Delete Assets';

  @override
  String assetDeleteMultipleConfirmation(int count) {
    return 'Are you sure you want to delete $count assets?';
  }

  @override
  String get assetNoAssetsSelected => 'No assets selected';

  @override
  String get assetNotImplementedYet => 'Not implemented yet';

  @override
  String assetSelectedCount(int count) {
    return '$count selected';
  }

  @override
  String get assetSearchAssets => 'Search assets...';

  @override
  String get assetNoAssetsFound => 'No assets found';

  @override
  String get assetCreateFirstAsset => 'Create your first asset to get started';

  @override
  String get assetLongPressToSelect => 'Long press to select more assets';

  @override
  String get assetFiltersAndSorting => 'Filters & Sorting';

  @override
  String get assetApplyFilters => 'Apply Filters';

  @override
  String get assetMyAssets => 'My Assets';

  @override
  String get assetSearchMyAssets => 'Search my assets...';

  @override
  String get assetFiltersApplied => 'Filters Applied';

  @override
  String get assetNoAssignedAssets => 'You have no assigned assets';

  @override
  String get assetExportAssets => 'Export Assets';

  @override
  String get assetExportFormat => 'Export Format';

  @override
  String get assetIncludeDataMatrixImages => 'Include Data Matrix Images';

  @override
  String get assetExportReady => 'Export Ready';

  @override
  String assetExportSize(String size) {
    return 'Size: $size KB';
  }

  @override
  String assetExportFormatDisplay(String format) {
    return 'Format: $format';
  }

  @override
  String get assetExportShareInstruction =>
      'File will open share menu. Choose app to open or save directly.';

  @override
  String get assetShareAndSave => 'Save';

  @override
  String get assetExportSubject => 'Assets Export';

  @override
  String get assetSaveToDownloads => 'Save to Downloads?';

  @override
  String get assetSaveToDownloadsMessage =>
      'File has been shared. Would you like to save a copy to Downloads folder?';

  @override
  String get assetNo => 'No';

  @override
  String get assetSave => 'Save';

  @override
  String get assetFileSharedSuccessfully => 'File shared successfully';

  @override
  String get assetShareCancelled => 'Share cancelled';

  @override
  String assetFailedToShareFile(String error) {
    return 'Failed to share file: $error';
  }

  @override
  String get assetFileSavedSuccessfully =>
      'File saved successfully to Downloads';

  @override
  String assetFailedToSaveFile(String error) {
    return 'Failed to save file: $error';
  }

  @override
  String get assetValidationTagRequired => 'Asset tag is required';

  @override
  String get assetValidationTagMinLength =>
      'Asset tag must be at least 3 characters';

  @override
  String get assetValidationTagMaxLength =>
      'Asset tag must not exceed 50 characters';

  @override
  String get assetValidationTagAlphanumeric =>
      'Asset tag can only contain letters, numbers, and dashes';

  @override
  String get assetValidationNameRequired => 'Asset name is required';

  @override
  String get assetValidationNameMinLength =>
      'Asset name must be at least 3 characters';

  @override
  String get assetValidationNameMaxLength =>
      'Asset name must not exceed 100 characters';

  @override
  String get assetValidationCategoryRequired => 'Category is required';

  @override
  String get assetValidationBrandMaxLength =>
      'Brand must not exceed 50 characters';

  @override
  String get assetValidationModelMaxLength =>
      'Model must not exceed 50 characters';

  @override
  String get assetValidationSerialMaxLength =>
      'Serial number must not exceed 50 characters';

  @override
  String get assetValidationPriceInvalid =>
      'Purchase price must be a valid number';

  @override
  String get assetValidationPriceNegative =>
      'Purchase price cannot be negative';

  @override
  String get assetValidationVendorMaxLength =>
      'Vendor name must not exceed 100 characters';

  @override
  String get assetExport => 'Export';

  @override
  String get assetSelectExportType => 'Select export type';

  @override
  String get assetExportList => 'Export List';

  @override
  String get assetExportListSubtitle => 'Export assets as a list';

  @override
  String get assetExportDataMatrix => 'Export Data Matrix';

  @override
  String get assetExportDataMatrixSubtitle =>
      'Export data matrix codes for assets';

  @override
  String get assetDataMatrixPdfOnly =>
      'Data matrix export is only available in PDF format';

  @override
  String get assetQuickActions => 'Quick Actions';

  @override
  String get assetReportIssue => 'Report\nIssue';

  @override
  String get assetMoveToUser => 'Move to\nUser';

  @override
  String get assetMoveToLocation => 'Move to\nLocation';

  @override
  String get assetScheduleMaintenance => 'Schedule\nMaint.';

  @override
  String get assetRecordMaintenance => 'Record\nMaint.';

  @override
  String get assetCopyAsset => 'Copy\nAsset';

  @override
  String get assetExportTitle => 'Export';

  @override
  String get assetExportSubtitle => 'Export data to file';

  @override
  String get assetBulkCopy => 'Bulk Copy';

  @override
  String get assetBulkCopyDescription =>
      'Create multiple assets with the same data. Only asset tag, data matrix, and serial number will be different.';

  @override
  String get assetEnableBulkCopy => 'Enable bulk copy';

  @override
  String get assetNumberOfCopies => 'Number of copies';

  @override
  String get assetEnterQuantity => 'Enter quantity';

  @override
  String get assetPleaseEnterQuantity => 'Please enter quantity';

  @override
  String get assetMinimumOneCopy => 'Minimum 1 copy';

  @override
  String get assetMaximumCopies => 'Maximum 100 copies';

  @override
  String get assetSerialNumbersOptional => 'Serial Numbers (Optional)';

  @override
  String get assetEnterSerialNumbers =>
      'Enter serial numbers separated by comma or newline';

  @override
  String get assetPleaseEnterCopyQuantity =>
      'Please enter copy quantity (minimum 1)';

  @override
  String assetEnterExactlySerialNumbers(int quantity) {
    return 'Please enter exactly $quantity serial numbers';
  }

  @override
  String get assetDuplicateSerialNumbers => 'Duplicate serial numbers found';

  @override
  String get assetSerialNumbersHint =>
      'Enter one serial number per line or separated by comma. Leave empty to skip serial numbers.';

  @override
  String get assetBulkAutoGenerateInfo =>
      'Asset tags and data matrix will be auto-generated for each copy.';

  @override
  String get assetCreatingBulkAssets => 'Creating Bulk Assets';

  @override
  String get assetCreateBulkAssets => 'Create Bulk Assets';

  @override
  String get assetGeneratingAssetTags => 'Generating asset tags...';

  @override
  String get assetUploadingTemplateImages => 'Uploading template images...';

  @override
  String assetFailedToUploadTemplateImages(String error) {
    return 'Failed to upload template images: $error';
  }

  @override
  String get assetGeneratingDataMatrixImages =>
      'Generating data matrix images...';

  @override
  String assetGeneratedDataMatrix(int current, int total) {
    return 'Generated $current/$total data matrix images';
  }

  @override
  String assetUploadingDataMatrix(int current, int total) {
    return 'Uploading $current/$total data matrix images...';
  }

  @override
  String assetUploadingDataMatrixProgress(int progress) {
    return 'Uploading data matrix images... $progress%';
  }

  @override
  String get assetCreatingAssets => 'Creating assets...';

  @override
  String assetFailedToCreateBulkAssets(String error) {
    return 'Failed to create bulk assets: $error';
  }

  @override
  String get assetAutoGenerationDisabled =>
      'Auto-generation disabled in bulk copy mode';

  @override
  String get assetAutoGenerateAssetTag => 'Auto-generate asset tag';

  @override
  String get assetCancelBulkProcessingTitle => 'Cancel Bulk Processing?';

  @override
  String get assetCancelBulkProcessingMessage =>
      'Bulk asset creation is in progress. If you cancel now, all progress will be lost. Are you sure you want to cancel?';

  @override
  String get assetContinueProcessing => 'Continue';

  @override
  String get assetCancelProcessing => 'Cancel Processing';

  @override
  String get assetRootCategory => 'Root Category';

  @override
  String get assetReuseExistingImages => 'Reuse Existing Images';

  @override
  String get assetReuseExistingImagesHint =>
      'Use images already uploaded to the system';

  @override
  String get assetSelectFromAvailableImages => 'Select from Available Images';

  @override
  String assetImagesSelectedCount(int count) {
    return 'Images Selected ($count)';
  }

  @override
  String assetMaxImagesWarning(int count) {
    return 'Maximum 5 images allowed ($count selected)';
  }

  @override
  String get assetPickerTitle => 'Select Images';

  @override
  String assetPickerCountSelected(int count) {
    return '$count selected';
  }

  @override
  String get assetPickerSelectButton => 'Select Images';

  @override
  String assetPickerSelectWithCount(int count) {
    return 'Select ($count)';
  }

  @override
  String get assetFailedToLoadImages => 'Failed to load images';

  @override
  String get assetRetry => 'Retry';

  @override
  String get assetNoImagesAvailable => 'No images available';

  @override
  String get assetExistingImages => 'Existing Images';

  @override
  String get assetExistingImagesHint => 'Images already attached to this asset';

  @override
  String get assetPrimaryImage => 'Primary';

  @override
  String get assetUpdateImagesHint =>
      'Select new images to update (existing images will remain)';

  @override
  String get assetImages => 'Asset Images';

  @override
  String get assetMovementDeleteAssetMovement => 'Delete Asset Movement';

  @override
  String get assetMovementDeleteConfirmation =>
      'Are you sure you want to delete this asset movement record?';

  @override
  String get assetMovementCancel => 'Cancel';

  @override
  String get assetMovementDelete => 'Delete';

  @override
  String get assetMovementDetail => 'Asset Movement Detail';

  @override
  String get assetMovementInformation => 'Movement Information';

  @override
  String get assetMovementId => 'Movement ID';

  @override
  String get assetMovementAsset => 'Asset';

  @override
  String get assetMovementMovementType => 'Movement Type';

  @override
  String get assetMovementFromLocation => 'From Location';

  @override
  String get assetMovementToLocation => 'To Location';

  @override
  String get assetMovementFromUser => 'From User';

  @override
  String get assetMovementToUser => 'To User';

  @override
  String get assetMovementMovedBy => 'Moved By';

  @override
  String get assetMovementMovementDate => 'Movement Date';

  @override
  String get assetMovementNotes => 'Notes';

  @override
  String get assetMovementStatus => 'Status';

  @override
  String get assetMovementMetadata => 'Metadata';

  @override
  String get assetMovementCreatedAt => 'Created At';

  @override
  String get assetMovementUpdatedAt => 'Updated At';

  @override
  String get assetMovementOnlyAdminCanEdit =>
      'Only admin can edit asset movements';

  @override
  String get assetMovementOnlyAdminCanDelete =>
      'Only admin can delete asset movements';

  @override
  String get assetMovementFailedToLoad => 'Failed to load asset movement';

  @override
  String get assetMovementEditAssetMovement => 'Edit Asset Movement';

  @override
  String get assetMovementCreateAssetMovement => 'Create Asset Movement';

  @override
  String get assetMovementFillRequiredFields =>
      'Please fill all required fields';

  @override
  String get assetMovementSelectAsset => 'Please select an asset';

  @override
  String get assetMovementSavedSuccessfully =>
      'Asset movement saved successfully';

  @override
  String get assetMovementOperationFailed => 'Operation failed';

  @override
  String get assetMovementBasicInformation => 'Basic Information';

  @override
  String get assetMovementSelectAssetPlaceholder => 'Select asset';

  @override
  String get assetMovementSearchAsset => 'Search asset...';

  @override
  String get assetMovementSelectMovementType => 'Select movement type';

  @override
  String get assetMovementLocationDetails => 'Location Details';

  @override
  String get assetMovementFromLocationLabel => 'From Location';

  @override
  String get assetMovementSearchFromLocation => 'Search from location...';

  @override
  String get assetMovementToLocationLabel => 'To Location';

  @override
  String get assetMovementSearchToLocation => 'Search to location...';

  @override
  String get assetMovementUserDetails => 'User Details';

  @override
  String get assetMovementFromUserLabel => 'From User';

  @override
  String get assetMovementSearchFromUser => 'Search from user...';

  @override
  String get assetMovementToUserLabel => 'To User';

  @override
  String get assetMovementSearchToUser => 'Search to user...';

  @override
  String get assetMovementMovementDateLabel => 'Movement Date';

  @override
  String get assetMovementNotesLabel => 'Notes (Optional)';

  @override
  String get assetMovementEnterNotes => 'Enter notes...';

  @override
  String get assetMovementUpdate => 'Update';

  @override
  String get assetMovementCreate => 'Create';

  @override
  String get assetMovementManagement => 'Asset Movement Management';

  @override
  String get assetMovementSearchAssetMovements => 'Search asset movements...';

  @override
  String get assetMovementNoMovementsFound => 'No asset movements found';

  @override
  String get assetMovementCreateFirstMovement =>
      'Create your first asset movement to get started';

  @override
  String get assetMovementFilterAndSortTitle => 'Filter & Sort';

  @override
  String get assetMovementFilterAndSortSubtitle =>
      'Customize asset movement display';

  @override
  String get assetMovementFilterByAsset => 'Filter by Asset';

  @override
  String get assetMovementFilterByMovementType => 'Filter by Movement Type';

  @override
  String get assetMovementFilterByLocation => 'Filter by Location';

  @override
  String get assetMovementFilterByUser => 'Filter by User';

  @override
  String get assetMovementSortBy => 'Sort By';

  @override
  String get assetMovementSortOrder => 'Sort Order';

  @override
  String get assetMovementReset => 'Reset';

  @override
  String get assetMovementApply => 'Apply';

  @override
  String get assetMovementFilterReset => 'Filter reset';

  @override
  String get assetMovementFilterApplied => 'Filter applied';

  @override
  String get assetMovementStatistics => 'Movement Statistics';

  @override
  String get assetMovementTotalMovements => 'Total Movements';

  @override
  String get assetMovementByType => 'Movements by Type';

  @override
  String get assetMovementByStatus => 'Movements by Status';

  @override
  String get assetMovementRecentActivity => 'Recent Activity';

  @override
  String get assetMovementValidationAssetRequired => 'Asset is required';

  @override
  String get assetMovementValidationMovementTypeRequired =>
      'Movement type is required';

  @override
  String get assetMovementValidationLocationRequired =>
      'Location is required for this movement type';

  @override
  String get assetMovementValidationUserRequired =>
      'User is required for this movement type';

  @override
  String get assetMovementValidationMovementDateRequired =>
      'Movement date is required';

  @override
  String get assetMovementValidationNotesMaxLength =>
      'Notes must not exceed 500 characters';

  @override
  String get assetMovementValidationToLocationRequired =>
      'To location is required';

  @override
  String get assetMovementValidationToUserRequired => 'To user is required';

  @override
  String get assetMovementValidationMovedByRequired => 'Moved by is required';

  @override
  String get assetMovementValidationMovementDateFuture =>
      'Movement date cannot be in the future';

  @override
  String get assetMovementTranslations => 'Translations';

  @override
  String get assetMovementUnknownAsset => 'Unknown Asset';

  @override
  String get assetMovementUnknownTag => 'Unknown Tag';

  @override
  String get assetMovementUnknown => 'Unknown';

  @override
  String get assetMovementUnassigned => 'Unassigned';

  @override
  String get assetMovementNotSet => 'Not set';

  @override
  String get assetMovementLocationMovement => 'Location Movement';

  @override
  String get assetMovementUserMovement => 'User Movement';

  @override
  String get assetMovementCreateAssetMovementTitle => 'Create Asset Movement';

  @override
  String get assetMovementCreateAssetMovementSubtitle =>
      'Record a new asset movement';

  @override
  String get assetMovementForLocation => 'Asset Movement for Location';

  @override
  String get assetMovementForUser => 'Asset Movement for User';

  @override
  String get assetMovementCurrentLocation => 'Current Location';

  @override
  String get assetMovementNewLocation => 'New Location';

  @override
  String get assetMovementCurrentUser => 'Current User';

  @override
  String get assetMovementNewUser => 'New User';

  @override
  String get assetMovementMovementHistory => 'Movement History';

  @override
  String get assetMovementNoHistory => 'No movement history available';

  @override
  String get assetMovementViewAll => 'View All';

  @override
  String get assetMovementMovedTo => 'Moved to';

  @override
  String get assetMovementAssignedTo => 'Assigned to';

  @override
  String get assetMovementSelectMany => 'Select Many';

  @override
  String get assetMovementSelectManySubtitle =>
      'Select multiple asset movements to delete';

  @override
  String get assetMovementSelectAssetMovementsToDelete =>
      'Select asset movements to delete';

  @override
  String get assetMovementChooseMovementType => 'Choose movement type:';

  @override
  String get assetMovementFilterByFromLocation => 'Filter by From Location';

  @override
  String get assetMovementFilterByToLocation => 'Filter by To Location';

  @override
  String get assetMovementFilterByFromUser => 'Filter by From User';

  @override
  String get assetMovementFilterByToUser => 'Filter by To User';

  @override
  String get assetMovementFilterByMovedBy => 'Filter by Moved By';

  @override
  String get assetMovementDateFrom => 'Date From';

  @override
  String get assetMovementDateTo => 'Date To';

  @override
  String get assetMovementSearchAssetPlaceholder => 'Search asset...';

  @override
  String get assetMovementSearchFromLocationPlaceholder =>
      'Search from location...';

  @override
  String get assetMovementSearchToLocationPlaceholder =>
      'Search to location...';

  @override
  String get assetMovementSearchFromUserPlaceholder => 'Search from user...';

  @override
  String get assetMovementSearchToUserPlaceholder => 'Search to user...';

  @override
  String get assetMovementSearchMovedByPlaceholder => 'Search moved by user...';

  @override
  String get assetMovementDeleteAssetMovements => 'Delete Asset Movements';

  @override
  String assetMovementDeleteManyConfirmation(int count) {
    return 'Are you sure you want to delete $count asset movements?';
  }

  @override
  String get assetMovementNoAssetMovementsSelected =>
      'No asset movements selected';

  @override
  String get assetMovementNotImplementedYet => 'Not implemented yet';

  @override
  String assetMovementSelectedCount(int count) {
    return '$count selected';
  }

  @override
  String get assetMovementLongPressToSelectMore =>
      'Long press to select more asset movements';

  @override
  String get assetMovementForLocationShort => 'For Location';

  @override
  String get assetMovementForUserShort => 'For User';

  @override
  String get authWelcomeBack => 'Welcome Back';

  @override
  String get authSignInToContinue => 'Sign in to continue';

  @override
  String get authEmail => 'Email';

  @override
  String get authEnterYourEmail => 'Enter your email';

  @override
  String get authPassword => 'Password';

  @override
  String get authEnterYourPassword => 'Enter your password';

  @override
  String get authForgotPassword => 'Forgot Password?';

  @override
  String get authLogin => 'Login';

  @override
  String get authDontHaveAccount => 'Don\'t have an account? ';

  @override
  String get authRegister => 'Register';

  @override
  String get authLoginSuccessful => 'Login successful';

  @override
  String get authCreateAccount => 'Create Account';

  @override
  String get authSignUpToGetStarted => 'Sign up to get started';

  @override
  String get authName => 'Name';

  @override
  String get authEnterYourName => 'Enter your name';

  @override
  String get authConfirmPassword => 'Confirm Password';

  @override
  String get authReEnterYourPassword => 'Re-enter your password';

  @override
  String get authPasswordMustContain => 'Password must contain:';

  @override
  String get authPasswordRequirementPlaceholder =>
      'Just make the password man!';

  @override
  String get authRegistrationSuccessful => 'Registration successful';

  @override
  String get authAlreadyHaveAccount => 'Already have an account? ';

  @override
  String get authForgotPasswordTitle => 'Forgot Password';

  @override
  String get authEnterEmailToResetPassword =>
      'Enter your email to reset your password';

  @override
  String get authSendResetLink => 'Send Reset Link';

  @override
  String get authEmailSentSuccessfully => 'Email sent successfully';

  @override
  String get authRememberPassword => 'Remember your password? ';

  @override
  String get authValidationEmailRequired => 'Email is required';

  @override
  String get authValidationEmailInvalid => 'Please enter a valid email address';

  @override
  String get authValidationPasswordRequired => 'Password is required';

  @override
  String get authValidationNameRequired => 'Name is required';

  @override
  String get authValidationNameMinLength =>
      'Name must be at least 3 characters';

  @override
  String get authValidationNameMaxLength =>
      'Name must not exceed 20 characters';

  @override
  String get authValidationNameAlphanumeric =>
      'Name can only contain letters, numbers, and underscores';

  @override
  String get authValidationConfirmPasswordRequired =>
      'Please confirm your password';

  @override
  String get authValidationPasswordsDoNotMatch => 'Passwords do not match';

  @override
  String get authVerifyResetCode => 'Verify Reset Code';

  @override
  String get authEnterResetCode => 'Enter the reset code sent to your email';

  @override
  String get authResetCode => 'Reset Code';

  @override
  String get authEnterResetCodePlaceholder => 'Enter reset code';

  @override
  String get authVerifyCode => 'Verify Code';

  @override
  String get authResetPasswordTitle => 'Reset Password';

  @override
  String get authEnterNewPassword => 'Enter your new password';

  @override
  String get authNewPassword => 'New Password';

  @override
  String get authEnterNewPasswordPlaceholder => 'Enter new password';

  @override
  String get authConfirmNewPassword => 'Confirm New Password';

  @override
  String get authReEnterNewPassword => 'Re-enter new password';

  @override
  String get authResetPasswordButton => 'Reset Password';

  @override
  String get authCodeVerifiedSuccessfully => 'Code verified successfully';

  @override
  String get authPasswordResetSuccessfully => 'Password reset successfully';

  @override
  String get authValidationResetCodeRequired => 'Reset code is required';

  @override
  String get authValidationResetCodeLength => 'Reset code must be 6 characters';

  @override
  String get authValidationNewPasswordRequired => 'New password is required';

  @override
  String get categoryDetail => 'Category Detail';

  @override
  String get categoryInformation => 'Category Information';

  @override
  String get categoryCategoryCode => 'Category Code';

  @override
  String get categoryCategoryName => 'Category Name';

  @override
  String get categoryDescription => 'Description';

  @override
  String get categoryParentCategory => 'Parent Category';

  @override
  String get categoryMetadata => 'Metadata';

  @override
  String get categoryCreatedAt => 'Created At';

  @override
  String get categoryUpdatedAt => 'Updated At';

  @override
  String get categoryOnlyAdminCanEdit => 'Only admin can edit categories';

  @override
  String get categoryOnlyAdminCanDelete => 'Only admin can delete categories';

  @override
  String get categoryOnlyAdminCanCopy => 'Only admin can copy categories';

  @override
  String get categoryCopyFromThisCategory => 'Copy from this category';

  @override
  String get categoryCreateNewBasedOnThis =>
      'Create new category based on this one';

  @override
  String get categoryDeleteCategory => 'Delete Category';

  @override
  String categoryDeleteConfirmation(String categoryName) {
    return 'Are you sure you want to delete \"$categoryName\"?';
  }

  @override
  String get categoryCancel => 'Cancel';

  @override
  String get categoryDelete => 'Delete';

  @override
  String get categoryCategoryDeleted => 'Category deleted';

  @override
  String get categoryDeleteFailed => 'Delete failed';

  @override
  String get categoryEditCategory => 'Edit Category';

  @override
  String get categoryCreateCategory => 'Create Category';

  @override
  String get categorySearchCategory => 'Search category...';

  @override
  String get categoryEnterCategoryCode => 'Enter category code (e.g., CAT-001)';

  @override
  String get categoryTranslations => 'Translations';

  @override
  String get categoryAddTranslations =>
      'Add translations for different languages';

  @override
  String get categoryEnglish => 'English';

  @override
  String get categoryJapanese => 'Japanese';

  @override
  String get categoryIndonesian => 'Indonesian';

  @override
  String get categoryEnterCategoryName => 'Enter category name';

  @override
  String get categoryEnterDescription => 'Enter description';

  @override
  String get categoryUpdate => 'Update';

  @override
  String get categoryCreate => 'Create';

  @override
  String get categoryFillRequiredFields => 'Please fill all required fields';

  @override
  String get categorySavedSuccessfully => 'Category saved successfully';

  @override
  String get categoryOperationFailed => 'Operation failed';

  @override
  String get categoryFailedToLoadTranslations => 'Failed to load translations';

  @override
  String get categoryManagement => 'Category Management';

  @override
  String get categorySearchCategories => 'Search categories...';

  @override
  String get categoryCreateCategoryTitle => 'Create Category';

  @override
  String get categoryCreateCategorySubtitle => 'Add a new category';

  @override
  String get categorySelectManyTitle => 'Select Many';

  @override
  String get categorySelectManySubtitle =>
      'Select multiple categories to delete';

  @override
  String get categoryFilterAndSortTitle => 'Filter & Sort';

  @override
  String get categoryFilterAndSortSubtitle => 'Customize category display';

  @override
  String get categorySelectCategoriesToDelete => 'Select categories to delete';

  @override
  String get categorySortBy => 'Sort By';

  @override
  String get categorySortOrder => 'Sort Order';

  @override
  String get categoryHasParent => 'Has Parent';

  @override
  String get categoryFilterByParent => 'Filter by Parent Category';

  @override
  String get categorySearchParentCategory => 'Search parent category...';

  @override
  String get categoryReset => 'Reset';

  @override
  String get categoryApply => 'Apply';

  @override
  String get categoryFilterReset => 'Filter reset';

  @override
  String get categoryFilterApplied => 'Filter applied';

  @override
  String get categoryDeleteCategories => 'Delete Categories';

  @override
  String categoryDeleteMultipleConfirmation(int count) {
    return 'Are you sure you want to delete $count categories?';
  }

  @override
  String get categoryNoCategoriesSelected => 'No categories selected';

  @override
  String get categoryNotImplementedYet => 'Not implemented yet';

  @override
  String categorySelectedCount(int count) {
    return '$count selected';
  }

  @override
  String get categoryNoCategoriesFound => 'No categories found';

  @override
  String get categoryCreateFirstCategory =>
      'Create your first category to get started';

  @override
  String get categoryLongPressToSelect =>
      'Long press to select more categories';

  @override
  String get categoryValidationCodeRequired => 'Category code is required';

  @override
  String get categoryValidationCodeMinLength =>
      'Category code must be at least 2 characters';

  @override
  String get categoryValidationCodeMaxLength =>
      'Category code must not exceed 20 characters';

  @override
  String get categoryValidationCodeAlphanumeric =>
      'Category code can only contain letters, numbers, and underscores';

  @override
  String get categoryValidationNameRequired => 'Category name is required';

  @override
  String get categoryValidationNameMinLength =>
      'Category name must be at least 3 characters';

  @override
  String get categoryValidationNameMaxLength =>
      'Category name must not exceed 100 characters';

  @override
  String get categoryValidationDescriptionRequired => 'Description is required';

  @override
  String get categoryValidationDescriptionMinLength =>
      'Description must be at least 10 characters';

  @override
  String get categoryValidationDescriptionMaxLength =>
      'Description must not exceed 500 characters';

  @override
  String get categoryImage => 'Category Image';

  @override
  String get categoryChooseImage => 'Choose Image';

  @override
  String get dashboardTotalUsers => 'Total Users';

  @override
  String get dashboardTotalAssets => 'Total Assets';

  @override
  String get dashboardAssetStatusOverview => 'Asset Status Overview';

  @override
  String get dashboardActive => 'Active';

  @override
  String get dashboardMaintenance => 'Maintenance';

  @override
  String get dashboardDisposed => 'Disposed';

  @override
  String get dashboardLost => 'Lost';

  @override
  String get dashboardUserRoleDistribution => 'User Role Distribution';

  @override
  String get dashboardAdmin => 'Admin';

  @override
  String get dashboardStaff => 'Staff';

  @override
  String get dashboardEmployee => 'Employee';

  @override
  String get dashboardAssetStatusBreakdown => 'Asset Status Breakdown';

  @override
  String get dashboardAssetConditionOverview => 'Asset Condition Overview';

  @override
  String get dashboardGood => 'Good';

  @override
  String get dashboardFair => 'Fair';

  @override
  String get dashboardPoor => 'Poor';

  @override
  String get dashboardDamaged => 'Damaged';

  @override
  String get dashboardUserRegistrationTrends => 'User Registration Trends';

  @override
  String get dashboardAssetCreationTrends => 'Asset Creation Trends';

  @override
  String get dashboardCategories => 'Categories';

  @override
  String get dashboardLocations => 'Locations';

  @override
  String get dashboardActivityOverview => 'Activity Overview';

  @override
  String get dashboardScanLogs => 'Scan Logs';

  @override
  String get dashboardNotifications => 'Notifications';

  @override
  String get dashboardAssetMovements => 'Asset Movements';

  @override
  String get dashboardIssueReports => 'Issue Reports';

  @override
  String get dashboardMaintenanceSchedules => 'Maintenance Schedules';

  @override
  String get dashboardMaintenanceRecords => 'Maintenance Records';

  @override
  String get homeScreen => 'Home';

  @override
  String get issueReportDeleteIssueReport => 'Delete Issue Report';

  @override
  String issueReportDeleteConfirmation(String title) {
    return 'Are you sure you want to delete \"$title\"?';
  }

  @override
  String get issueReportCancel => 'Cancel';

  @override
  String get issueReportDelete => 'Delete';

  @override
  String get issueReportDetail => 'Issue Report Detail';

  @override
  String get issueReportInformation => 'Issue Report Information';

  @override
  String get issueReportTitle => 'Title';

  @override
  String get issueReportDescription => 'Description';

  @override
  String get issueReportAsset => 'Asset';

  @override
  String get issueReportIssueType => 'Issue Type';

  @override
  String get issueReportPriority => 'Priority';

  @override
  String get issueReportStatus => 'Status';

  @override
  String get issueReportReportedBy => 'Reported By';

  @override
  String get issueReportReportedDate => 'Reported Date';

  @override
  String get issueReportResolvedDate => 'Resolved Date';

  @override
  String get issueReportResolvedBy => 'Resolved By';

  @override
  String get issueReportResolutionNotes => 'Resolution Notes';

  @override
  String get issueReportMetadata => 'Metadata';

  @override
  String get issueReportCreatedAt => 'Created At';

  @override
  String get issueReportUpdatedAt => 'Updated At';

  @override
  String get issueReportOnlyAdminCanEdit => 'Only admin can edit issue reports';

  @override
  String get issueReportOnlyAdminCanDelete =>
      'Only admin can delete issue reports';

  @override
  String get issueReportFailedToLoad => 'Failed to load issue report';

  @override
  String get issueReportDeletedSuccess => 'Issue report deleted';

  @override
  String get issueReportDeletedFailed => 'Delete failed';

  @override
  String get issueReportUnknownAsset => 'Unknown Asset';

  @override
  String get issueReportUnknownUser => 'Unknown User';

  @override
  String get issueReportEditIssueReport => 'Edit Issue Report';

  @override
  String get issueReportCreateIssueReport => 'Create Issue Report';

  @override
  String get issueReportFillRequiredFields => 'Please fill all required fields';

  @override
  String get issueReportSavedSuccessfully => 'Issue report saved successfully';

  @override
  String get issueReportOperationFailed => 'Operation failed';

  @override
  String get issueReportFailedToLoadTranslations =>
      'Failed to load translations';

  @override
  String get issueReportSearchAsset => 'Search and select asset';

  @override
  String get issueReportSearchReportedBy =>
      'Search and select user who reported the issue';

  @override
  String get issueReportEnterIssueType =>
      'Enter issue type (e.g., Hardware, Software)';

  @override
  String get issueReportSelectPriority => 'Select priority';

  @override
  String get issueReportSelectStatus => 'Select status';

  @override
  String get issueReportSearchResolvedBy =>
      'Search and select user who resolved the issue';

  @override
  String get issueReportTranslations => 'Translations';

  @override
  String get issueReportEnglish => 'English';

  @override
  String get issueReportJapanese => 'Japanese';

  @override
  String get issueReportIndonesian => 'Indonesian';

  @override
  String issueReportEnterTitleIn(String language) {
    return 'Enter title in $language';
  }

  @override
  String issueReportEnterDescriptionIn(String language) {
    return 'Enter description in $language';
  }

  @override
  String issueReportEnterResolutionNotesIn(String language) {
    return 'Enter resolution notes in $language';
  }

  @override
  String get issueReportUpdate => 'Update';

  @override
  String get issueReportCreate => 'Create';

  @override
  String get issueReportManagement => 'IssueReport Management';

  @override
  String get issueReportCreateIssueReportTitle => 'Create IssueReport';

  @override
  String get issueReportCreateIssueReportSubtitle => 'Add a new issueReport';

  @override
  String get issueReportSelectManyTitle => 'Select Many';

  @override
  String get issueReportSelectManySubtitle =>
      'Select multiple issueReports to delete';

  @override
  String get issueReportFilterAndSortTitle => 'Filter & Sort';

  @override
  String get issueReportFilterAndSortSubtitle =>
      'Customize issueReport display';

  @override
  String get issueReportSelectIssueReportsToDelete =>
      'Select issueReports to delete';

  @override
  String get issueReportDeleteIssueReports => 'Delete IssueReports';

  @override
  String issueReportDeleteMultipleConfirmation(int count) {
    return 'Are you sure you want to delete $count issueReports?';
  }

  @override
  String get issueReportNoIssueReportsSelected => 'No issueReports selected';

  @override
  String get issueReportNotImplementedYet => 'Not implemented yet';

  @override
  String issueReportSelectedCount(int count) {
    return '$count selected';
  }

  @override
  String get issueReportSearchIssueReports => 'Search issueReports...';

  @override
  String get issueReportNoIssueReportsFound => 'No issueReports found';

  @override
  String get issueReportCreateFirstIssueReport =>
      'Create your first issueReport to get started';

  @override
  String get issueReportLongPressToSelect =>
      'Long press to select more issueReports';

  @override
  String get issueReportFilterByAsset => 'Filter by Asset';

  @override
  String get issueReportFilterByReportedBy => 'Filter by Reported By';

  @override
  String get issueReportFilterByResolvedBy => 'Filter by Resolved By';

  @override
  String get issueReportSearchAssetFilter => 'Search asset...';

  @override
  String get issueReportSearchUserFilter => 'Search user...';

  @override
  String get issueReportEnterIssueTypeFilter => 'Enter issue type...';

  @override
  String get issueReportSortBy => 'Sort By';

  @override
  String get issueReportSortOrder => 'Sort Order';

  @override
  String get issueReportIsResolved => 'Is Resolved';

  @override
  String get issueReportDateFrom => 'Date From';

  @override
  String get issueReportDateTo => 'Date To';

  @override
  String get issueReportReset => 'Reset';

  @override
  String get issueReportApply => 'Apply';

  @override
  String get issueReportFilterReset => 'Filter reset';

  @override
  String get issueReportFilterApplied => 'Filter applied';

  @override
  String get issueReportMyIssueReports => 'My Issue Reports';

  @override
  String get issueReportSearchMyIssueReports => 'Search my issue reports...';

  @override
  String get issueReportFiltersAndSorting => 'Filters & Sorting';

  @override
  String get issueReportApplyFilters => 'Apply Filters';

  @override
  String get issueReportFiltersApplied => 'Filters Applied';

  @override
  String get issueReportFilterAndSort => 'Filter & Sort';

  @override
  String get issueReportNoIssueReportsFoundEmpty => 'No issue reports found';

  @override
  String get issueReportYouHaveNoReportedIssues =>
      'You have no reported issues';

  @override
  String get issueReportCreateIssueReportTooltip => 'Create Issue Report';

  @override
  String get issueReportValidationAssetRequired => 'Asset is required';

  @override
  String get issueReportValidationReportedByRequired =>
      'Reported by is required';

  @override
  String get issueReportValidationIssueTypeRequired => 'Issue type is required';

  @override
  String get issueReportValidationIssueTypeMaxLength =>
      'Issue type must not exceed 100 characters';

  @override
  String get issueReportValidationPriorityRequired => 'Priority is required';

  @override
  String get issueReportValidationStatusRequired => 'Status is required';

  @override
  String get issueReportValidationTitleRequired => 'Title is required';

  @override
  String get issueReportValidationTitleMaxLength =>
      'Title must not exceed 200 characters';

  @override
  String get issueReportValidationDescriptionMaxLength =>
      'Description must not exceed 1000 characters';

  @override
  String get issueReportValidationResolutionNotesMaxLength =>
      'Resolution notes must not exceed 1000 characters';

  @override
  String get locationDeleteLocation => 'Delete Location';

  @override
  String locationDeleteConfirmation(String locationName) {
    return 'Are you sure you want to delete \"$locationName\"?';
  }

  @override
  String get locationCancel => 'Cancel';

  @override
  String get locationDelete => 'Delete';

  @override
  String get locationDetail => 'Location Detail';

  @override
  String get locationInformation => 'Location Information';

  @override
  String get locationCode => 'Location Code';

  @override
  String get locationName => 'Location Name';

  @override
  String get locationBuilding => 'Building';

  @override
  String get locationFloor => 'Floor';

  @override
  String get locationLatitude => 'Latitude';

  @override
  String get locationLongitude => 'Longitude';

  @override
  String get locationMetadata => 'Metadata';

  @override
  String get locationCreatedAt => 'Created At';

  @override
  String get locationUpdatedAt => 'Updated At';

  @override
  String get locationOnlyAdminCanEdit => 'Only admin can edit locations';

  @override
  String get locationOnlyAdminCanDelete => 'Only admin can delete locations';

  @override
  String get locationOnlyAdminCanCopy => 'Only admin can copy locations';

  @override
  String get locationCopyFromThisLocation => 'Copy from this location';

  @override
  String get locationCreateNewBasedOnThis =>
      'Create new location based on this one';

  @override
  String get locationFailedToLoad => 'Failed to load location';

  @override
  String get locationDeleted => 'Location deleted';

  @override
  String get locationDeleteFailed => 'Delete failed';

  @override
  String get locationEditLocation => 'Edit Location';

  @override
  String get locationCreateLocation => 'Create Location';

  @override
  String get locationFillRequiredFields => 'Please fill all required fields';

  @override
  String get locationSavedSuccessfully => 'Location saved successfully';

  @override
  String get locationOperationFailed => 'Operation failed';

  @override
  String get locationFailedToLoadTranslations => 'Failed to load translations';

  @override
  String get locationEnterLocationCode => 'Enter location code (e.g., LOC-001)';

  @override
  String get locationBuildingOptional => 'Building (Optional)';

  @override
  String get locationEnterBuilding => 'Enter building name';

  @override
  String get locationFloorOptional => 'Floor (Optional)';

  @override
  String get locationEnterFloor => 'Enter floor number';

  @override
  String get locationLatitudeOptional => 'Latitude (Optional)';

  @override
  String get locationEnterLatitude => 'Enter latitude';

  @override
  String get locationLongitudeOptional => 'Longitude (Optional)';

  @override
  String get locationEnterLongitude => 'Enter longitude';

  @override
  String get locationGettingLocation => 'Getting Location...';

  @override
  String get locationUseCurrentLocation => 'Use Current Location';

  @override
  String get locationServicesDisabled => 'Location services are disabled';

  @override
  String get locationServicesDialogTitle => 'Location Services Disabled';

  @override
  String get locationServicesDialogMessage =>
      'Location services are required to get your current location. Would you like to enable them?';

  @override
  String get locationOpenSettings => 'Open Settings';

  @override
  String get locationPermissionDenied => 'Location permission denied';

  @override
  String get locationPermissionPermanentlyDenied =>
      'Location permission permanently denied';

  @override
  String get locationPermissionRequired => 'Permission Required';

  @override
  String get locationPermissionDialogMessage =>
      'Location permission is permanently denied. Please enable it in app settings.';

  @override
  String get locationRetrievedSuccessfully =>
      'Current location retrieved successfully';

  @override
  String get locationFailedToGetCurrent => 'Failed to get current location';

  @override
  String get locationTranslations => 'Translations';

  @override
  String get locationTranslationsSubtitle =>
      'Add translations for different languages';

  @override
  String get locationEnglish => 'English';

  @override
  String get locationJapanese => 'Japanese';

  @override
  String get locationIndonesian => 'Indonesian';

  @override
  String get locationEnterLocationName => 'Enter location name';

  @override
  String get locationUpdate => 'Update';

  @override
  String get locationCreate => 'Create';

  @override
  String get locationManagement => 'Location Management';

  @override
  String get locationCreateLocationTitle => 'Create Location';

  @override
  String get locationCreateLocationSubtitle => 'Add a new location';

  @override
  String get locationSelectManyTitle => 'Select Many';

  @override
  String get locationSelectManySubtitle =>
      'Select multiple locations to delete';

  @override
  String get locationFilterAndSortTitle => 'Filter & Sort';

  @override
  String get locationFilterAndSortSubtitle => 'Customize location display';

  @override
  String get locationSelectLocationsToDelete => 'Select locations to delete';

  @override
  String get locationSortBy => 'Sort By';

  @override
  String get locationSortOrder => 'Sort Order';

  @override
  String get locationReset => 'Reset';

  @override
  String get locationApply => 'Apply';

  @override
  String get locationFilterReset => 'Filter reset';

  @override
  String get locationFilterApplied => 'Filter applied';

  @override
  String get locationDeleteLocations => 'Delete Locations';

  @override
  String locationDeleteMultipleConfirmation(int count) {
    return 'Are you sure you want to delete $count locations?';
  }

  @override
  String get locationNoLocationsSelected => 'No locations selected';

  @override
  String get locationNotImplementedYet => 'Not implemented yet';

  @override
  String locationSelectedCount(int count) {
    return '$count selected';
  }

  @override
  String get locationSearchLocations => 'Search locations...';

  @override
  String get locationNoLocationsFound => 'No locations found';

  @override
  String get locationCreateFirstLocation =>
      'Create your first location to get started';

  @override
  String get locationLongPressToSelect => 'Long press to select more locations';

  @override
  String locationFloorPrefix(String floor) {
    return 'Floor $floor';
  }

  @override
  String get locationValidationCodeRequired => 'Location code is required';

  @override
  String get locationValidationCodeMinLength =>
      'Location code must be at least 2 characters';

  @override
  String get locationValidationCodeMaxLength =>
      'Location code must not exceed 20 characters';

  @override
  String get locationValidationCodeAlphanumeric =>
      'Location code can only contain letters, numbers, and dashes';

  @override
  String get locationValidationNameRequired => 'Location name is required';

  @override
  String get locationValidationNameMinLength =>
      'Location name must be at least 3 characters';

  @override
  String get locationValidationNameMaxLength =>
      'Location name must not exceed 100 characters';

  @override
  String get locationValidationBuildingMaxLength =>
      'Building must not exceed 50 characters';

  @override
  String get locationValidationFloorMaxLength =>
      'Floor must not exceed 20 characters';

  @override
  String get locationValidationLatitudeInvalid =>
      'Latitude must be a valid number';

  @override
  String get locationValidationLatitudeRange =>
      'Latitude must be between -90 and 90';

  @override
  String get locationValidationLongitudeInvalid =>
      'Longitude must be a valid number';

  @override
  String get locationValidationLongitudeRange =>
      'Longitude must be between -180 and 180';

  @override
  String get locationNotFound => 'Location not found';

  @override
  String get locationSearchFailed => 'Search failed';

  @override
  String get locationConfirmLocation => 'Confirm Location';

  @override
  String get locationSelectedFromMap => 'Location selected from map';

  @override
  String get locationSearchLocation => 'Search location...';

  @override
  String get locationPickFromMap => 'Pick from map';

  @override
  String get maintenanceScheduleDeleteSchedule => 'Delete Maintenance Schedule';

  @override
  String maintenanceScheduleDeleteConfirmation(String title) {
    return 'Are you sure you want to delete \"$title\"?';
  }

  @override
  String get maintenanceScheduleDeleted => 'Maintenance schedule deleted';

  @override
  String get maintenanceScheduleDeleteFailed => 'Delete failed';

  @override
  String get maintenanceScheduleDetail => 'Maintenance Schedule Detail';

  @override
  String get maintenanceScheduleInformation =>
      'Maintenance Schedule Information';

  @override
  String get maintenanceScheduleTitle => 'Title';

  @override
  String get maintenanceScheduleDescription => 'Description';

  @override
  String get maintenanceScheduleAsset => 'Asset';

  @override
  String get maintenanceScheduleMaintenanceType => 'Maintenance Type';

  @override
  String get maintenanceScheduleIsRecurring => 'Is Recurring';

  @override
  String get maintenanceScheduleInterval => 'Interval';

  @override
  String get maintenanceScheduleScheduledTime => 'Scheduled Time';

  @override
  String get maintenanceScheduleNextScheduledDate => 'Next Scheduled Date';

  @override
  String get maintenanceScheduleLastExecutedDate => 'Last Executed Date';

  @override
  String get maintenanceScheduleState => 'State';

  @override
  String get maintenanceScheduleAutoComplete => 'Auto Complete';

  @override
  String get maintenanceScheduleEstimatedCost => 'Estimated Cost';

  @override
  String get maintenanceScheduleCreatedBy => 'Created By';

  @override
  String get maintenanceScheduleYes => 'Yes';

  @override
  String get maintenanceScheduleNo => 'No';

  @override
  String get maintenanceScheduleUnknownAsset => 'Unknown Asset';

  @override
  String get maintenanceScheduleUnknownUser => 'Unknown User';

  @override
  String get maintenanceScheduleOnlyAdminCanEdit =>
      'Only admin can edit maintenance schedules';

  @override
  String get maintenanceScheduleOnlyAdminCanDelete =>
      'Only admin can delete maintenance schedules';

  @override
  String get maintenanceScheduleOnlyAdminCanCopy =>
      'Only admin can copy maintenance schedules';

  @override
  String get maintenanceScheduleCopyFromThis => 'Copy from this schedule';

  @override
  String get maintenanceScheduleCreateNewBasedOnThis =>
      'Create new schedule based on this one';

  @override
  String get maintenanceScheduleFailedToLoad =>
      'Failed to load maintenance schedule';

  @override
  String get maintenanceScheduleEditSchedule => 'Edit Maintenance Schedule';

  @override
  String get maintenanceScheduleCreateSchedule => 'Create Maintenance Schedule';

  @override
  String get maintenanceScheduleFillRequiredFields =>
      'Please fill all required fields';

  @override
  String get maintenanceScheduleSavedSuccessfully =>
      'Maintenance schedule saved successfully';

  @override
  String get maintenanceScheduleOperationFailed => 'Operation failed';

  @override
  String get maintenanceScheduleFailedToLoadTranslations =>
      'Failed to load translations';

  @override
  String get maintenanceScheduleSearchAsset => 'Search and select asset';

  @override
  String get maintenanceScheduleSelectMaintenanceType =>
      'Select maintenance type';

  @override
  String get maintenanceScheduleEnterIntervalValue =>
      'Enter interval value (e.g., 3)';

  @override
  String get maintenanceScheduleSelectIntervalUnit => 'Select interval unit';

  @override
  String get maintenanceScheduleEnterScheduledTime => 'e.g., 09:30';

  @override
  String get maintenanceScheduleSelectState => 'Select state';

  @override
  String get maintenanceScheduleEnterEstimatedCost =>
      'Enter estimated cost (optional)';

  @override
  String get maintenanceScheduleSearchUser =>
      'Search and select user who created the schedule';

  @override
  String get maintenanceScheduleTranslations => 'Translations';

  @override
  String get maintenanceScheduleEnglish => 'English';

  @override
  String get maintenanceScheduleJapanese => 'Japanese';

  @override
  String get maintenanceScheduleIndonesian => 'Indonesian';

  @override
  String maintenanceScheduleEnterTitle(String language) {
    return 'Enter title in $language';
  }

  @override
  String maintenanceScheduleEnterDescription(String language) {
    return 'Enter description in $language';
  }

  @override
  String get maintenanceScheduleCancel => 'Cancel';

  @override
  String get maintenanceScheduleUpdate => 'Update';

  @override
  String get maintenanceScheduleCreate => 'Create';

  @override
  String get maintenanceScheduleManagement => 'Maintenance Schedule Management';

  @override
  String get maintenanceScheduleCreateTitle => 'Create Maintenance Schedule';

  @override
  String get maintenanceScheduleCreateSubtitle =>
      'Add a new maintenance schedule';

  @override
  String get maintenanceScheduleSelectManyTitle => 'Select Many';

  @override
  String get maintenanceScheduleSelectManySubtitle =>
      'Select multiple schedules to delete';

  @override
  String get maintenanceScheduleFilterAndSortTitle => 'Filter & Sort';

  @override
  String get maintenanceScheduleFilterAndSortSubtitle =>
      'Customize schedule display';

  @override
  String get maintenanceScheduleSelectToDelete =>
      'Select maintenance schedules to delete';

  @override
  String get maintenanceScheduleSortBy => 'Sort By';

  @override
  String get maintenanceScheduleSortOrder => 'Sort Order';

  @override
  String get maintenanceScheduleReset => 'Reset';

  @override
  String get maintenanceScheduleApply => 'Apply';

  @override
  String get maintenanceScheduleFilterReset => 'Filter reset';

  @override
  String get maintenanceScheduleFilterApplied => 'Filter applied';

  @override
  String get maintenanceScheduleDeleteSchedules => 'Delete Schedules';

  @override
  String maintenanceScheduleDeleteMultipleConfirmation(int count) {
    return 'Are you sure you want to delete $count schedules?';
  }

  @override
  String get maintenanceScheduleNoSchedulesSelected => 'No schedules selected';

  @override
  String get maintenanceScheduleNotImplementedYet => 'Not implemented yet';

  @override
  String maintenanceScheduleSelectedCount(int count) {
    return '$count selected';
  }

  @override
  String get maintenanceScheduleDelete => 'Delete';

  @override
  String get maintenanceScheduleSearch => 'Search schedules...';

  @override
  String get maintenanceScheduleNoSchedulesFound => 'No schedules found';

  @override
  String get maintenanceScheduleCreateFirstSchedule =>
      'Create your first schedule to get started';

  @override
  String get maintenanceScheduleLongPressToSelect =>
      'Long press to select more schedules';

  @override
  String get maintenanceScheduleMetadata => 'Metadata';

  @override
  String get maintenanceScheduleCreatedAt => 'Created At';

  @override
  String get maintenanceScheduleUpdatedAt => 'Updated At';

  @override
  String get maintenanceScheduleIntervalValueLabel => 'Interval Value';

  @override
  String get maintenanceScheduleIntervalUnitLabel => 'Interval Unit';

  @override
  String get maintenanceScheduleScheduledTimeLabel => 'Scheduled Time (HH:mm)';

  @override
  String get maintenanceRecordDeleteRecord => 'Delete Maintenance Record';

  @override
  String maintenanceRecordDeleteConfirmation(String title) {
    return 'Are you sure you want to delete \"$title\"?';
  }

  @override
  String get maintenanceRecordDeleted => 'Maintenance record deleted';

  @override
  String get maintenanceRecordDeleteFailed => 'Delete failed';

  @override
  String get maintenanceRecordDetail => 'Maintenance Record Detail';

  @override
  String get maintenanceRecordInformation => 'Maintenance Record Information';

  @override
  String get maintenanceRecordTitle => 'Title';

  @override
  String get maintenanceRecordNotes => 'Notes';

  @override
  String get maintenanceRecordAsset => 'Asset';

  @override
  String get maintenanceRecordMaintenanceDate => 'Maintenance Date';

  @override
  String get maintenanceRecordCompletionDate => 'Completion Date';

  @override
  String get maintenanceRecordDuration => 'Duration';

  @override
  String maintenanceRecordDurationMinutes(int minutes) {
    return '$minutes minutes';
  }

  @override
  String get maintenanceRecordPerformedByUser => 'Performed By User';

  @override
  String get maintenanceRecordPerformedByVendor => 'Performed By Vendor';

  @override
  String get maintenanceRecordResult => 'Result';

  @override
  String get maintenanceRecordActualCost => 'Actual Cost';

  @override
  String maintenanceRecordActualCostValue(String cost) {
    return '\$$cost';
  }

  @override
  String get maintenanceRecordOnlyAdminCanCopy =>
      'Only admin can copy maintenance records';

  @override
  String get maintenanceRecordCopyFromThis => 'Copy from this record';

  @override
  String get maintenanceRecordCreateNewBasedOnThis =>
      'Create new record based on this one';

  @override
  String get maintenanceRecordUnknownAsset => 'Unknown Asset';

  @override
  String get maintenanceRecordOnlyAdminCanEdit =>
      'Only admin can edit maintenance records';

  @override
  String get maintenanceRecordOnlyAdminCanDelete =>
      'Only admin can delete maintenance records';

  @override
  String get maintenanceRecordFailedToLoad =>
      'Failed to load maintenance record';

  @override
  String get maintenanceRecordEditRecord => 'Edit Maintenance Record';

  @override
  String get maintenanceRecordCreateRecord => 'Create Maintenance Record';

  @override
  String get maintenanceRecordFillRequiredFields =>
      'Please fill all required fields';

  @override
  String get maintenanceRecordSavedSuccessfully =>
      'Maintenance record saved successfully';

  @override
  String get maintenanceRecordOperationFailed => 'Operation failed';

  @override
  String get maintenanceRecordFailedToLoadTranslations =>
      'Failed to load translations';

  @override
  String get maintenanceRecordSearchSchedule =>
      'Search and select maintenance schedule';

  @override
  String get maintenanceRecordSearchAsset => 'Search and select asset';

  @override
  String get maintenanceRecordCompletionDateOptional =>
      'Completion Date (Optional)';

  @override
  String get maintenanceRecordDurationMinutesLabel => 'Duration (Minutes)';

  @override
  String get maintenanceRecordEnterDuration =>
      'Enter duration in minutes (optional)';

  @override
  String get maintenanceRecordSearchPerformedByUser =>
      'Search and select user who performed the maintenance';

  @override
  String get maintenanceRecordPerformedByVendorLabel => 'Performed By Vendor';

  @override
  String get maintenanceRecordEnterVendor => 'Enter vendor name (optional)';

  @override
  String get maintenanceRecordSelectResult => 'Select maintenance result';

  @override
  String get maintenanceRecordActualCostLabel => 'Actual Cost';

  @override
  String get maintenanceRecordEnterActualCost => 'Enter actual cost (optional)';

  @override
  String get maintenanceRecordTranslations => 'Translations';

  @override
  String get maintenanceRecordEnglish => 'English';

  @override
  String get maintenanceRecordJapanese => 'Japanese';

  @override
  String get maintenanceRecordIndonesian => 'Indonesian';

  @override
  String maintenanceRecordEnterTitle(String language) {
    return 'Enter title in $language';
  }

  @override
  String maintenanceRecordEnterNotes(String language) {
    return 'Enter notes in $language';
  }

  @override
  String get maintenanceRecordCancel => 'Cancel';

  @override
  String get maintenanceRecordUpdate => 'Update';

  @override
  String get maintenanceRecordCreate => 'Create';

  @override
  String get maintenanceRecordManagement => 'Maintenance Record Management';

  @override
  String get maintenanceRecordCreateTitle => 'Create Maintenance Record';

  @override
  String get maintenanceRecordCreateSubtitle => 'Add a new maintenance record';

  @override
  String get maintenanceRecordSelectManyTitle => 'Select Many';

  @override
  String get maintenanceRecordSelectManySubtitle =>
      'Select multiple records to delete';

  @override
  String get maintenanceRecordFilterAndSortTitle => 'Filter & Sort';

  @override
  String get maintenanceRecordFilterAndSortSubtitle =>
      'Customize record display';

  @override
  String get maintenanceRecordSelectToDelete =>
      'Select maintenance records to delete';

  @override
  String get maintenanceRecordSortBy => 'Sort By';

  @override
  String get maintenanceRecordSortOrder => 'Sort Order';

  @override
  String get maintenanceRecordReset => 'Reset';

  @override
  String get maintenanceRecordApply => 'Apply';

  @override
  String get maintenanceRecordFilterReset => 'Filter reset';

  @override
  String get maintenanceRecordFilterApplied => 'Filter applied';

  @override
  String get maintenanceRecordDeleteRecords => 'Delete Records';

  @override
  String maintenanceRecordDeleteMultipleConfirmation(int count) {
    return 'Are you sure you want to delete $count records?';
  }

  @override
  String get maintenanceRecordNoRecordsSelected => 'No records selected';

  @override
  String get maintenanceRecordNotImplementedYet => 'Not implemented yet';

  @override
  String maintenanceRecordSelectedCount(int count) {
    return '$count selected';
  }

  @override
  String get maintenanceRecordDelete => 'Delete';

  @override
  String get maintenanceRecordSearch => 'Search records...';

  @override
  String get maintenanceRecordNoRecordsFound => 'No records found';

  @override
  String get maintenanceRecordCreateFirstRecord =>
      'Create your first record to get started';

  @override
  String get maintenanceRecordLongPressToSelect =>
      'Long press to select more records';

  @override
  String get maintenanceRecordMetadata => 'Metadata';

  @override
  String get maintenanceRecordCreatedAt => 'Created At';

  @override
  String get maintenanceRecordUpdatedAt => 'Updated At';

  @override
  String get maintenanceRecordSchedule => 'Maintenance Schedule';

  @override
  String get notificationManagement => 'Notification Management';

  @override
  String get notificationDetail => 'Notification Detail';

  @override
  String get notificationMyNotifications => 'My Notifications';

  @override
  String get notificationDeleteNotification => 'Delete Notification';

  @override
  String get notificationDeleteConfirmation =>
      'Are you sure you want to delete this notification?';

  @override
  String notificationDeleteMultipleConfirmation(int count) {
    return 'Are you sure you want to delete $count notifications?';
  }

  @override
  String get notificationCancel => 'Cancel';

  @override
  String get notificationDelete => 'Delete';

  @override
  String get notificationOnlyAdminCanDelete =>
      'Only admin can delete notifications';

  @override
  String get notificationDeleted => 'Notification deleted';

  @override
  String get notificationDeleteFailed => 'Delete failed';

  @override
  String get notificationFailedToLoad => 'Failed to load notification';

  @override
  String get notificationInformation => 'Notification Information';

  @override
  String get notificationTitle => 'Title';

  @override
  String get notificationMessage => 'Message';

  @override
  String get notificationType => 'Type';

  @override
  String get notificationPriority => 'Priority';

  @override
  String get notificationIsRead => 'Is Read';

  @override
  String get notificationReadStatus => 'Read Status';

  @override
  String get notificationRead => 'Read';

  @override
  String get notificationUnread => 'Unread';

  @override
  String get notificationYes => 'Yes';

  @override
  String get notificationNo => 'No';

  @override
  String get notificationCreatedAt => 'Created At';

  @override
  String get notificationExpiresAt => 'Expires At';

  @override
  String get notificationSearchNotifications => 'Search notifications...';

  @override
  String get notificationSearchMyNotifications => 'Search my notifications...';

  @override
  String get notificationNoNotificationsFound => 'No notifications found';

  @override
  String get notificationNoNotificationsYet => 'You have no notifications';

  @override
  String get notificationCreateFirstNotification =>
      'Create your first notification to get started';

  @override
  String get notificationCreateNotification => 'Create Notification';

  @override
  String get notificationCreateNotificationSubtitle => 'Add a new notification';

  @override
  String get notificationSelectMany => 'Select Many';

  @override
  String get notificationSelectManySubtitle =>
      'Select multiple notifications to delete';

  @override
  String get notificationFilterAndSort => 'Filter & Sort';

  @override
  String get notificationFilterAndSortSubtitle =>
      'Customize notification display';

  @override
  String get notificationFiltersAndSorting => 'Filters & Sorting';

  @override
  String get notificationSelectNotificationsToDelete =>
      'Select notifications to delete';

  @override
  String get notificationLongPressToSelect =>
      'Long press to select more notifications';

  @override
  String notificationSelectedCount(int count) {
    return '$count selected';
  }

  @override
  String get notificationNoNotificationsSelected => 'No notifications selected';

  @override
  String get notificationFilterByUser => 'Filter by User';

  @override
  String get notificationFilterByRelatedAsset => 'Filter by Related Asset';

  @override
  String get notificationSearchUser => 'Search user...';

  @override
  String get notificationSearchAsset => 'Search asset...';

  @override
  String get notificationSortBy => 'Sort By';

  @override
  String get notificationSortOrder => 'Sort Order';

  @override
  String get notificationReset => 'Reset';

  @override
  String get notificationApply => 'Apply';

  @override
  String get notificationApplyFilters => 'Apply Filters';

  @override
  String get notificationFilterReset => 'Filter reset';

  @override
  String get notificationFilterApplied => 'Filter applied';

  @override
  String get notificationFiltersApplied => 'Filters Applied';

  @override
  String get notificationNotImplementedYet => 'Not implemented yet';

  @override
  String get notificationJustNow => 'Just now';

  @override
  String notificationMinutesAgo(int minutes) {
    return '${minutes}m ago';
  }

  @override
  String notificationHoursAgo(int hours) {
    return '${hours}h ago';
  }

  @override
  String notificationDaysAgo(int days) {
    return '${days}d ago';
  }

  @override
  String get notificationMarkAsRead => 'Mark as Read';

  @override
  String get notificationMarkAsUnread => 'Mark as Unread';

  @override
  String notificationMarkedAsRead(int count) {
    return '$count marked as read';
  }

  @override
  String notificationMarkedAsUnread(int count) {
    return '$count marked as unread';
  }

  @override
  String get scanLogManagement => 'Scan Log Management';

  @override
  String get scanLogDetail => 'Scan Log Detail';

  @override
  String get scanLogDeleteScanLog => 'Delete Scan Log';

  @override
  String get scanLogDeleteConfirmation =>
      'Are you sure you want to delete this scan log?';

  @override
  String scanLogDeleteMultipleConfirmation(int count) {
    return 'Are you sure you want to delete $count scan logs?';
  }

  @override
  String get scanLogCancel => 'Cancel';

  @override
  String get scanLogDelete => 'Delete';

  @override
  String get scanLogOnlyAdminCanDelete => 'Only admin can delete scan logs';

  @override
  String get scanLogDeleted => 'Scan log deleted';

  @override
  String get scanLogDeleteFailed => 'Delete failed';

  @override
  String get scanLogFailedToLoad => 'Failed to load scan log';

  @override
  String get scanLogInformation => 'Scan Information';

  @override
  String get scanLogScannedValue => 'Scanned Value';

  @override
  String get scanLogScanMethod => 'Scan Method';

  @override
  String get scanLogScanResult => 'Scan Result';

  @override
  String get scanLogScanTimestamp => 'Scan Timestamp';

  @override
  String get scanLogLocation => 'Location';

  @override
  String get scanLogSearchScanLogs => 'Search scan logs...';

  @override
  String get scanLogNoScanLogsFound => 'No scan logs found';

  @override
  String get scanLogCreateFirstScanLog =>
      'Create your first scan log to get started';

  @override
  String get scanLogCreateScanLog => 'Create Scan Log';

  @override
  String get scanLogCreateScanLogSubtitle => 'Add a new scan log';

  @override
  String get scanLogSelectMany => 'Select Many';

  @override
  String get scanLogSelectManySubtitle => 'Select multiple scan logs to delete';

  @override
  String get scanLogFilterAndSort => 'Filter & Sort';

  @override
  String get scanLogFilterAndSortSubtitle => 'Customize scan log display';

  @override
  String get scanLogFiltersAndSorting => 'Filters & Sorting';

  @override
  String get scanLogSelectScanLogsToDelete => 'Select scan logs to delete';

  @override
  String get scanLogLongPressToSelect => 'Long press to select more scan logs';

  @override
  String scanLogSelectedCount(int count) {
    return '$count selected';
  }

  @override
  String get scanLogNoScanLogsSelected => 'No scan logs selected';

  @override
  String get scanLogFilterByAsset => 'Filter by Asset';

  @override
  String get scanLogFilterByScannedBy => 'Filter by Scanned By';

  @override
  String get scanLogSearchAsset => 'Search asset...';

  @override
  String get scanLogSearchUser => 'Search user...';

  @override
  String get scanLogSortBy => 'Sort By';

  @override
  String get scanLogSortOrder => 'Sort Order';

  @override
  String get scanLogHasCoordinates => 'Has Coordinates';

  @override
  String get scanLogDateFrom => 'Date From';

  @override
  String get scanLogDateTo => 'Date To';

  @override
  String get scanLogReset => 'Reset';

  @override
  String get scanLogApply => 'Apply';

  @override
  String get scanLogFilterReset => 'Filter reset';

  @override
  String get scanLogFilterApplied => 'Filter applied';

  @override
  String get scanLogNotImplementedYet => 'Not implemented yet';

  @override
  String get userManagement => 'User Management';

  @override
  String get userCreateUser => 'Create User';

  @override
  String get userAddNewUser => 'Add a new user';

  @override
  String get userSelectMany => 'Select Many';

  @override
  String get userSelectMultipleToDelete => 'Select multiple users to delete';

  @override
  String get userFilterAndSort => 'Filter & Sort';

  @override
  String get userCustomizeDisplay => 'Customize user display';

  @override
  String get userFilters => 'Filters';

  @override
  String get userRole => 'Role';

  @override
  String get userEmployeeId => 'Employee ID';

  @override
  String get userEnterEmployeeId => 'Enter employee ID...';

  @override
  String get userOnlyAdminCanCopy => 'Only admin can copy users';

  @override
  String get userCopyFromThisUser => 'Copy from this user';

  @override
  String get userCreateNewBasedOnThis => 'Create new user based on this one';

  @override
  String get userActiveStatus => 'Active Status';

  @override
  String get userActive => 'Active';

  @override
  String get userInactive => 'Inactive';

  @override
  String get userSort => 'Sort';

  @override
  String get userSortBy => 'Sort By';

  @override
  String get userSortOrder => 'Sort Order';

  @override
  String get userAscending => 'Ascending';

  @override
  String get userDescending => 'Descending';

  @override
  String get userReset => 'Reset';

  @override
  String get userApply => 'Apply';

  @override
  String get userFilterReset => 'Filter reset';

  @override
  String get userFilterApplied => 'Filter applied';

  @override
  String get userSelectUsersToDelete => 'Select users to delete';

  @override
  String get userDeleteUsers => 'Delete Users';

  @override
  String userDeleteConfirmation(int count) {
    return 'Are you sure you want to delete $count users?';
  }

  @override
  String get userCancel => 'Cancel';

  @override
  String get userDelete => 'Delete';

  @override
  String get userNoUsersSelected => 'No users selected';

  @override
  String get userNotImplementedYet => 'Not implemented yet';

  @override
  String userSelectedCount(int count) {
    return '$count selected';
  }

  @override
  String get userSearchUsers => 'Search users...';

  @override
  String get userNoUsersFound => 'No users found';

  @override
  String get userCreateFirstUser => 'Create your first user to get started';

  @override
  String get userLongPressToSelect => 'Long press to select more users';

  @override
  String get userEditUser => 'Edit User';

  @override
  String get userPleaseFixErrors => 'Please fix all errors';

  @override
  String get userPleaseSelectRole => 'Please select a role';

  @override
  String get userPleaseValidateFields => 'Please fill all required fields';

  @override
  String get userSavedSuccessfully => 'User saved successfully';

  @override
  String get userOperationFailed => 'Operation failed';

  @override
  String get userInformation => 'User Information';

  @override
  String get userUsername => 'Username';

  @override
  String get userEnterUsername => 'Enter username';

  @override
  String get userEmail => 'Email';

  @override
  String get userEnterEmail => 'Enter email';

  @override
  String get userPassword => 'Password';

  @override
  String get userEnterPassword => 'Enter password';

  @override
  String get userFullName => 'Full Name';

  @override
  String get userEnterFullName => 'Enter full name';

  @override
  String get userSelectRole => 'Select role';

  @override
  String get userEmployeeIdOptional => 'Employee ID (Optional)';

  @override
  String get userEnterEmployeeIdOptional => 'Enter employee ID';

  @override
  String get userPreferredLanguage => 'Preferred Language (Optional)';

  @override
  String get userSelectLanguage => 'Select language';

  @override
  String get userUpdate => 'Update';

  @override
  String get userCreate => 'Create';

  @override
  String get userDetail => 'User Detail';

  @override
  String get userOnlyAdminCanEdit => 'Only admin can edit users';

  @override
  String get userDeleteUser => 'Delete User';

  @override
  String userDeleteSingleConfirmation(String fullName) {
    return 'Are you sure you want to delete \"$fullName\"?';
  }

  @override
  String get userOnlyAdminCanDelete => 'Only admin can delete users';

  @override
  String get userDeleted => 'User deleted';

  @override
  String get userDeleteFailed => 'Delete failed';

  @override
  String get userName => 'Name';

  @override
  String get userPreferredLang => 'Preferred Language';

  @override
  String get userYes => 'Yes';

  @override
  String get userNo => 'No';

  @override
  String get userMetadata => 'Metadata';

  @override
  String get userCreatedAt => 'Created At';

  @override
  String get userUpdatedAt => 'Updated At';

  @override
  String get userFailedToLoad => 'Failed to load user';

  @override
  String get userFailedToLoadProfile => 'Failed to load profile';

  @override
  String get userPersonalInformation => 'Personal Information';

  @override
  String get userAccountDetails => 'Account Details';

  @override
  String get userStatus => 'Status';

  @override
  String get userUpdateProfile => 'Update Profile';

  @override
  String get userNoUserData => 'No user data available';

  @override
  String get userProfileInformation => 'Profile Information';

  @override
  String get userProfilePicture => 'Profile Picture';

  @override
  String get userChooseImage => 'Choose image';

  @override
  String get userProfileUpdatedSuccessfully => 'Profile updated successfully';

  @override
  String get userChangePassword => 'Change Password';

  @override
  String get userChangePasswordTitle => 'Update Your Password';

  @override
  String get userChangePasswordDescription =>
      'Enter your current password and choose a new secure password.';

  @override
  String get userCurrentPassword => 'Current Password';

  @override
  String get userEnterCurrentPassword => 'Enter current password';

  @override
  String get userNewPassword => 'New Password';

  @override
  String get userEnterNewPassword => 'Enter new password';

  @override
  String get userConfirmNewPassword => 'Confirm New Password';

  @override
  String get userEnterConfirmNewPassword => 'Re-enter new password';

  @override
  String get userPasswordRequirements => 'Password Requirements';

  @override
  String get userPasswordRequirementsList =>
      '• At least 8 characters\n• At least one uppercase letter\n• At least one lowercase letter\n• At least one number';

  @override
  String get userChangePasswordButton => 'Change Password';

  @override
  String get userPasswordChangedSuccessfully => 'Password changed successfully';

  @override
  String get adminShellBottomNavDashboard => 'Dashboard';

  @override
  String get adminShellBottomNavScanAsset => 'Scan Asset';

  @override
  String get adminShellBottomNavProfile => 'Profile';

  @override
  String get userShellBottomNavHome => 'Home';

  @override
  String get userShellBottomNavScanAsset => 'Scan Asset';

  @override
  String get userShellBottomNavProfile => 'Profile';

  @override
  String get appEndDrawerTitle => 'Sigma Asset';

  @override
  String get appEndDrawerPleaseLoginFirst => 'Please login first';

  @override
  String get appEndDrawerTheme => 'Theme';

  @override
  String get appEndDrawerLanguage => 'Language';

  @override
  String get appEndDrawerLogout => 'Logout';

  @override
  String get appEndDrawerManagementSection => 'Management';

  @override
  String get appEndDrawerMaintenanceSection => 'Maintenance';

  @override
  String get appEndDrawerEnglish => 'English';

  @override
  String get appEndDrawerIndonesian => 'Indonesia';

  @override
  String get appEndDrawerJapanese => '日本語';

  @override
  String get appEndDrawerMyAssets => 'My Assets';

  @override
  String get appEndDrawerNotifications => 'Notifications';

  @override
  String get appEndDrawerMyIssueReports => 'My Issue Reports';

  @override
  String get appEndDrawerAssets => 'Assets';

  @override
  String get appEndDrawerAssetMovements => 'Asset Movements';

  @override
  String get appEndDrawerCategories => 'Categories';

  @override
  String get appEndDrawerLocations => 'Locations';

  @override
  String get appEndDrawerUsers => 'Users';

  @override
  String get appEndDrawerMaintenanceSchedules => 'Maintenance Schedules';

  @override
  String get appEndDrawerMaintenanceRecords => 'Maintenance Records';

  @override
  String get appEndDrawerReports => 'Reports';

  @override
  String get appEndDrawerIssueReports => 'Issue Reports';

  @override
  String get appEndDrawerScanLogs => 'Scan Logs';

  @override
  String get appEndDrawerScanAsset => 'Scan Asset';

  @override
  String get appEndDrawerDashboard => 'Dashboard';

  @override
  String get appEndDrawerHome => 'Home';

  @override
  String get appEndDrawerProfile => 'Profile';

  @override
  String get customAppBarTitle => 'Sigma Asset';

  @override
  String get customAppBarOpenMenu => 'Open Menu';

  @override
  String get appDropdownSelectOption => 'Select option';

  @override
  String get appSearchFieldHint => 'Search...';

  @override
  String get appSearchFieldClear => 'Clear';

  @override
  String get appSearchFieldNoResultsFound => 'No results found';

  @override
  String get staffShellBottomNavDashboard => 'Dashboard';

  @override
  String get staffShellBottomNavScanAsset => 'Scan Asset';

  @override
  String get staffShellBottomNavProfile => 'Profile';

  @override
  String get shellDoubleBackToExitApp => 'Press back again to exit';
}
