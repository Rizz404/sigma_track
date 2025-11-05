// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class L10nId extends L10n {
  L10nId([String locale = 'id']) : super(locale);

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
  String get assetShareAndSave => 'Share & Save';

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
  String get appEndDrawerTitle => 'Sigma Track';

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
  String get customAppBarTitle => 'Sigma Track';

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
}
