import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of L10n
/// returned by `L10n.of(context)`.
///
/// Applications need to include `L10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: L10n.localizationsDelegates,
///   supportedLocales: L10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the L10n.supportedLocales
/// property.
abstract class L10n {
  L10n(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static L10n? of(BuildContext context) {
    return Localizations.of<L10n>(context, L10n);
  }

  static const LocalizationsDelegate<L10n> delegate = _L10nDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
    Locale('ja'),
  ];

  /// Dialog title for deleting an asset
  ///
  /// In en, this message translates to:
  /// **'Delete Asset'**
  String get assetDeleteAsset;

  /// Confirmation message for deleting an asset
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{assetName}\"?'**
  String assetDeleteConfirmation(String assetName);

  /// Cancel button label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get assetCancel;

  /// Delete button label
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get assetDelete;

  /// Asset detail screen title
  ///
  /// In en, this message translates to:
  /// **'Asset Detail'**
  String get assetDetail;

  /// Asset information section title
  ///
  /// In en, this message translates to:
  /// **'Asset Information'**
  String get assetInformation;

  /// Asset tag label
  ///
  /// In en, this message translates to:
  /// **'Asset Tag'**
  String get assetTag;

  /// Asset name label
  ///
  /// In en, this message translates to:
  /// **'Asset Name'**
  String get assetName;

  /// Category label
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get assetCategory;

  /// Brand label
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get assetBrand;

  /// Brand label for filters
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get assetBrandLabel;

  /// Model label
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get assetModel;

  /// Model label for filters
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get assetModelLabel;

  /// Serial number label
  ///
  /// In en, this message translates to:
  /// **'Serial Number'**
  String get assetSerialNumber;

  /// Status label
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get assetStatus;

  /// Condition label
  ///
  /// In en, this message translates to:
  /// **'Condition'**
  String get assetCondition;

  /// Location label
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get assetLocation;

  /// Assigned to label
  ///
  /// In en, this message translates to:
  /// **'Assigned To'**
  String get assetAssignedTo;

  /// Purchase information section title
  ///
  /// In en, this message translates to:
  /// **'Purchase Information'**
  String get assetPurchaseInformation;

  /// Purchase date label
  ///
  /// In en, this message translates to:
  /// **'Purchase Date'**
  String get assetPurchaseDate;

  /// Purchase price label
  ///
  /// In en, this message translates to:
  /// **'Purchase Price'**
  String get assetPurchasePrice;

  /// Vendor name label
  ///
  /// In en, this message translates to:
  /// **'Vendor Name'**
  String get assetVendorName;

  /// Warranty end label
  ///
  /// In en, this message translates to:
  /// **'Warranty End'**
  String get assetWarrantyEnd;

  /// Metadata section title
  ///
  /// In en, this message translates to:
  /// **'Metadata'**
  String get assetMetadata;

  /// Created at label
  ///
  /// In en, this message translates to:
  /// **'Created At'**
  String get assetCreatedAt;

  /// Updated at label
  ///
  /// In en, this message translates to:
  /// **'Updated At'**
  String get assetUpdatedAt;

  /// Data matrix image section title
  ///
  /// In en, this message translates to:
  /// **'Data Matrix Image'**
  String get assetDataMatrixImage;

  /// Error message for non-admin trying to edit
  ///
  /// In en, this message translates to:
  /// **'Only admin can edit assets'**
  String get assetOnlyAdminCanEdit;

  /// Error message for non-admin trying to delete
  ///
  /// In en, this message translates to:
  /// **'Only admin can delete assets'**
  String get assetOnlyAdminCanDelete;

  /// Error message when asset fails to load
  ///
  /// In en, this message translates to:
  /// **'Failed to load asset'**
  String get assetFailedToLoad;

  /// Location permission dialog title
  ///
  /// In en, this message translates to:
  /// **'Location Permission Required'**
  String get assetLocationPermissionRequired;

  /// Location permission dialog message
  ///
  /// In en, this message translates to:
  /// **'Location access is needed to track scan logs. Please enable it in settings.'**
  String get assetLocationPermissionMessage;

  /// Open settings button label
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get assetOpenSettings;

  /// Warning message for location permission
  ///
  /// In en, this message translates to:
  /// **'Location permission needed for scan logs'**
  String get assetLocationPermissionNeeded;

  /// Error message for invalid barcode
  ///
  /// In en, this message translates to:
  /// **'Invalid barcode data'**
  String get assetInvalidBarcode;

  /// Success message when asset is found
  ///
  /// In en, this message translates to:
  /// **'Asset found: {assetName}'**
  String assetFound(String assetName);

  /// Error message when asset is not found
  ///
  /// In en, this message translates to:
  /// **'Asset not found'**
  String get assetNotFound;

  /// Error message when barcode processing fails
  ///
  /// In en, this message translates to:
  /// **'Failed to process barcode'**
  String get assetFailedToProcessBarcode;

  /// Camera error title
  ///
  /// In en, this message translates to:
  /// **'Camera Error'**
  String get assetCameraError;

  /// Instruction for scanning data matrix
  ///
  /// In en, this message translates to:
  /// **'Align data matrix within frame'**
  String get assetAlignDataMatrix;

  /// Processing indicator text
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get assetProcessing;

  /// Flash button label
  ///
  /// In en, this message translates to:
  /// **'Flash'**
  String get assetFlash;

  /// Flip camera button label
  ///
  /// In en, this message translates to:
  /// **'Flip'**
  String get assetFlip;

  /// Edit asset screen title
  ///
  /// In en, this message translates to:
  /// **'Edit Asset'**
  String get assetEditAsset;

  /// Create asset screen title
  ///
  /// In en, this message translates to:
  /// **'Create Asset'**
  String get assetCreateAsset;

  /// Validation message for required fields
  ///
  /// In en, this message translates to:
  /// **'Please fill all required fields'**
  String get assetFillRequiredFields;

  /// Validation message for category selection
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get assetSelectCategory;

  /// Success message for asset save
  ///
  /// In en, this message translates to:
  /// **'Asset saved successfully'**
  String get assetSavedSuccessfully;

  /// Generic operation failure message
  ///
  /// In en, this message translates to:
  /// **'Operation failed'**
  String get assetOperationFailed;

  /// Success message for asset deletion
  ///
  /// In en, this message translates to:
  /// **'Asset deleted'**
  String get assetDeletedSuccess;

  /// Error message for asset deletion failure
  ///
  /// In en, this message translates to:
  /// **'Delete failed'**
  String get assetDeletedFailed;

  /// Error message for data matrix generation failure
  ///
  /// In en, this message translates to:
  /// **'Failed to generate data matrix'**
  String get assetFailedToGenerateDataMatrix;

  /// Warning message for category selection before tag generation
  ///
  /// In en, this message translates to:
  /// **'Please select a category first'**
  String get assetSelectCategoryFirst;

  /// Success message for asset tag generation
  ///
  /// In en, this message translates to:
  /// **'Asset tag generated: {tag}'**
  String assetTagGenerated(String tag);

  /// Error message for asset tag generation failure
  ///
  /// In en, this message translates to:
  /// **'Failed to generate asset tag'**
  String get assetFailedToGenerateTag;

  /// Warning message for entering asset tag before regeneration
  ///
  /// In en, this message translates to:
  /// **'Please enter asset tag first'**
  String get assetEnterAssetTagFirst;

  /// Basic information section title
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get assetBasicInformation;

  /// Asset tag input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter asset tag (e.g., AST-001)'**
  String get assetEnterAssetTag;

  /// Auto-generate tag button tooltip
  ///
  /// In en, this message translates to:
  /// **'Auto-generate asset tag'**
  String get assetAutoGenerateTag;

  /// Asset name input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter asset name'**
  String get assetEnterAssetName;

  /// Brand input label
  ///
  /// In en, this message translates to:
  /// **'Brand (Optional)'**
  String get assetBrandOptional;

  /// Brand input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter brand name'**
  String get assetEnterBrand;

  /// Model input label
  ///
  /// In en, this message translates to:
  /// **'Model (Optional)'**
  String get assetModelOptional;

  /// Model input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter model'**
  String get assetEnterModel;

  /// Serial number input label
  ///
  /// In en, this message translates to:
  /// **'Serial Number (Optional)'**
  String get assetSerialNumberOptional;

  /// Serial number input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter serial number'**
  String get assetEnterSerialNumber;

  /// Data matrix preview section title
  ///
  /// In en, this message translates to:
  /// **'Data Matrix Preview'**
  String get assetDataMatrixPreview;

  /// Regenerate data matrix button label
  ///
  /// In en, this message translates to:
  /// **'Regenerate Data Matrix'**
  String get assetRegenerateDataMatrix;

  /// Category and location section title
  ///
  /// In en, this message translates to:
  /// **'Category & Location'**
  String get assetCategoryAndLocation;

  /// Category search placeholder
  ///
  /// In en, this message translates to:
  /// **'Search category...'**
  String get assetSearchCategory;

  /// Not set value text
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get assetNotSet;

  /// Instruction for changing location
  ///
  /// In en, this message translates to:
  /// **'To change location, use Asset Movement screen'**
  String get assetChangeLocationInstruction;

  /// Location input label
  ///
  /// In en, this message translates to:
  /// **'Location (Optional)'**
  String get assetLocationOptional;

  /// Location search placeholder
  ///
  /// In en, this message translates to:
  /// **'Search location...'**
  String get assetSearchLocation;

  /// Not assigned value text
  ///
  /// In en, this message translates to:
  /// **'Not assigned'**
  String get assetNotAssigned;

  /// Instruction for changing assignment
  ///
  /// In en, this message translates to:
  /// **'To change assignment, use Asset Movement screen'**
  String get assetChangeAssignmentInstruction;

  /// Assigned to input label
  ///
  /// In en, this message translates to:
  /// **'Assigned To (Optional)'**
  String get assetAssignedToOptional;

  /// User search placeholder
  ///
  /// In en, this message translates to:
  /// **'Search user...'**
  String get assetSearchUser;

  /// Purchase date input label
  ///
  /// In en, this message translates to:
  /// **'Purchase Date (Optional)'**
  String get assetPurchaseDateOptional;

  /// Purchase price input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter purchase price'**
  String get assetEnterPurchasePrice;

  /// Vendor name input label
  ///
  /// In en, this message translates to:
  /// **'Vendor Name (Optional)'**
  String get assetVendorNameOptional;

  /// Vendor name input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter vendor name'**
  String get assetEnterVendorName;

  /// Warranty end date input label
  ///
  /// In en, this message translates to:
  /// **'Warranty End Date (Optional)'**
  String get assetWarrantyEndDateOptional;

  /// Status and condition section title
  ///
  /// In en, this message translates to:
  /// **'Status & Condition'**
  String get assetStatusAndCondition;

  /// Status dropdown placeholder
  ///
  /// In en, this message translates to:
  /// **'Select status'**
  String get assetSelectStatus;

  /// Condition dropdown placeholder
  ///
  /// In en, this message translates to:
  /// **'Select condition'**
  String get assetSelectCondition;

  /// Update button label
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get assetUpdate;

  /// Create button label
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get assetCreate;

  /// Create asset option title
  ///
  /// In en, this message translates to:
  /// **'Create Asset'**
  String get assetCreateAssetTitle;

  /// Create asset option subtitle
  ///
  /// In en, this message translates to:
  /// **'Add a new asset'**
  String get assetCreateAssetSubtitle;

  /// Select many option title
  ///
  /// In en, this message translates to:
  /// **'Select Many'**
  String get assetSelectManyTitle;

  /// Select many option subtitle
  ///
  /// In en, this message translates to:
  /// **'Select multiple assets to delete'**
  String get assetSelectManySubtitle;

  /// Filter and sort option title
  ///
  /// In en, this message translates to:
  /// **'Filter & Sort'**
  String get assetFilterAndSortTitle;

  /// Filter and sort option subtitle
  ///
  /// In en, this message translates to:
  /// **'Customize asset display'**
  String get assetFilterAndSortSubtitle;

  /// Filter by category label
  ///
  /// In en, this message translates to:
  /// **'Filter by Category'**
  String get assetFilterByCategory;

  /// Filter by location label
  ///
  /// In en, this message translates to:
  /// **'Filter by Location'**
  String get assetFilterByLocation;

  /// Filter by assigned to label
  ///
  /// In en, this message translates to:
  /// **'Filter by Assigned To'**
  String get assetFilterByAssignedTo;

  /// Brand filter input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter brand...'**
  String get assetEnterBrandFilter;

  /// Model filter input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter model...'**
  String get assetEnterModelFilter;

  /// Sort by label
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get assetSortBy;

  /// Sort order label
  ///
  /// In en, this message translates to:
  /// **'Sort Order'**
  String get assetSortOrder;

  /// Reset button label
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get assetReset;

  /// Apply button label
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get assetApply;

  /// Filter reset success message
  ///
  /// In en, this message translates to:
  /// **'Filter reset'**
  String get assetFilterReset;

  /// Filter applied success message
  ///
  /// In en, this message translates to:
  /// **'Filter applied'**
  String get assetFilterApplied;

  /// Asset management screen title
  ///
  /// In en, this message translates to:
  /// **'Asset Management'**
  String get assetManagement;

  /// Instruction for selecting assets to delete
  ///
  /// In en, this message translates to:
  /// **'Select assets to delete'**
  String get assetSelectAssetsToDelete;

  /// Delete assets dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Assets'**
  String get assetDeleteAssets;

  /// Confirmation message for deleting multiple assets
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {count} assets?'**
  String assetDeleteMultipleConfirmation(int count);

  /// Warning message when no assets are selected
  ///
  /// In en, this message translates to:
  /// **'No assets selected'**
  String get assetNoAssetsSelected;

  /// Placeholder message for unimplemented features
  ///
  /// In en, this message translates to:
  /// **'Not implemented yet'**
  String get assetNotImplementedYet;

  /// Selected count display
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String assetSelectedCount(int count);

  /// Assets search placeholder
  ///
  /// In en, this message translates to:
  /// **'Search assets...'**
  String get assetSearchAssets;

  /// No assets found message
  ///
  /// In en, this message translates to:
  /// **'No assets found'**
  String get assetNoAssetsFound;

  /// Empty state message for assets
  ///
  /// In en, this message translates to:
  /// **'Create your first asset to get started'**
  String get assetCreateFirstAsset;

  /// Instruction for selecting multiple assets
  ///
  /// In en, this message translates to:
  /// **'Long press to select more assets'**
  String get assetLongPressToSelect;

  /// Filters and sorting bottom sheet title
  ///
  /// In en, this message translates to:
  /// **'Filters & Sorting'**
  String get assetFiltersAndSorting;

  /// Apply filters button label
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get assetApplyFilters;

  /// My assets screen title
  ///
  /// In en, this message translates to:
  /// **'My Assets'**
  String get assetMyAssets;

  /// My assets search placeholder
  ///
  /// In en, this message translates to:
  /// **'Search my assets...'**
  String get assetSearchMyAssets;

  /// Filters applied state text
  ///
  /// In en, this message translates to:
  /// **'Filters Applied'**
  String get assetFiltersApplied;

  /// Empty state message for my assets
  ///
  /// In en, this message translates to:
  /// **'You have no assigned assets'**
  String get assetNoAssignedAssets;

  /// Export assets bottom sheet title
  ///
  /// In en, this message translates to:
  /// **'Export Assets'**
  String get assetExportAssets;

  /// Export format dropdown label
  ///
  /// In en, this message translates to:
  /// **'Export Format'**
  String get assetExportFormat;

  /// Include data matrix images checkbox label
  ///
  /// In en, this message translates to:
  /// **'Include Data Matrix Images'**
  String get assetIncludeDataMatrixImages;

  /// Export ready status text
  ///
  /// In en, this message translates to:
  /// **'Export Ready'**
  String get assetExportReady;

  /// Export file size display
  ///
  /// In en, this message translates to:
  /// **'Size: {size} KB'**
  String assetExportSize(String size);

  /// Export format display
  ///
  /// In en, this message translates to:
  /// **'Format: {format}'**
  String assetExportFormatDisplay(String format);

  /// Instruction for export share process
  ///
  /// In en, this message translates to:
  /// **'File will open share menu. Choose app to open or save directly.'**
  String get assetExportShareInstruction;

  /// Share and save button label
  ///
  /// In en, this message translates to:
  /// **'Share & Save'**
  String get assetShareAndSave;

  /// Export share subject
  ///
  /// In en, this message translates to:
  /// **'Assets Export'**
  String get assetExportSubject;

  /// Save to downloads dialog title
  ///
  /// In en, this message translates to:
  /// **'Save to Downloads?'**
  String get assetSaveToDownloads;

  /// Save to downloads dialog message
  ///
  /// In en, this message translates to:
  /// **'File has been shared. Would you like to save a copy to Downloads folder?'**
  String get assetSaveToDownloadsMessage;

  /// No button label
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get assetNo;

  /// Save button label
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get assetSave;

  /// File shared success message
  ///
  /// In en, this message translates to:
  /// **'File shared successfully'**
  String get assetFileSharedSuccessfully;

  /// Share cancelled message
  ///
  /// In en, this message translates to:
  /// **'Share cancelled'**
  String get assetShareCancelled;

  /// Failed to share file error message
  ///
  /// In en, this message translates to:
  /// **'Failed to share file: {error}'**
  String assetFailedToShareFile(String error);

  /// File saved success message
  ///
  /// In en, this message translates to:
  /// **'File saved successfully to Downloads'**
  String get assetFileSavedSuccessfully;

  /// Failed to save file error message
  ///
  /// In en, this message translates to:
  /// **'Failed to save file: {error}'**
  String assetFailedToSaveFile(String error);

  /// Validation error for required asset tag
  ///
  /// In en, this message translates to:
  /// **'Asset tag is required'**
  String get assetValidationTagRequired;

  /// Validation error for asset tag minimum length
  ///
  /// In en, this message translates to:
  /// **'Asset tag must be at least 3 characters'**
  String get assetValidationTagMinLength;

  /// Validation error for asset tag maximum length
  ///
  /// In en, this message translates to:
  /// **'Asset tag must not exceed 50 characters'**
  String get assetValidationTagMaxLength;

  /// Validation error for asset tag format
  ///
  /// In en, this message translates to:
  /// **'Asset tag can only contain letters, numbers, and dashes'**
  String get assetValidationTagAlphanumeric;

  /// Validation error for required asset name
  ///
  /// In en, this message translates to:
  /// **'Asset name is required'**
  String get assetValidationNameRequired;

  /// Validation error for asset name minimum length
  ///
  /// In en, this message translates to:
  /// **'Asset name must be at least 3 characters'**
  String get assetValidationNameMinLength;

  /// Validation error for asset name maximum length
  ///
  /// In en, this message translates to:
  /// **'Asset name must not exceed 100 characters'**
  String get assetValidationNameMaxLength;

  /// Validation error for required category
  ///
  /// In en, this message translates to:
  /// **'Category is required'**
  String get assetValidationCategoryRequired;

  /// Validation error for brand maximum length
  ///
  /// In en, this message translates to:
  /// **'Brand must not exceed 50 characters'**
  String get assetValidationBrandMaxLength;

  /// Validation error for model maximum length
  ///
  /// In en, this message translates to:
  /// **'Model must not exceed 50 characters'**
  String get assetValidationModelMaxLength;

  /// Validation error for serial number maximum length
  ///
  /// In en, this message translates to:
  /// **'Serial number must not exceed 50 characters'**
  String get assetValidationSerialMaxLength;

  /// Validation error for invalid purchase price
  ///
  /// In en, this message translates to:
  /// **'Purchase price must be a valid number'**
  String get assetValidationPriceInvalid;

  /// Validation error for negative purchase price
  ///
  /// In en, this message translates to:
  /// **'Purchase price cannot be negative'**
  String get assetValidationPriceNegative;

  /// Validation error for vendor name maximum length
  ///
  /// In en, this message translates to:
  /// **'Vendor name must not exceed 100 characters'**
  String get assetValidationVendorMaxLength;

  /// Export button label
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get assetExport;

  /// Dialog title for deleting an asset movement
  ///
  /// In en, this message translates to:
  /// **'Delete Asset Movement'**
  String get assetMovementDeleteAssetMovement;

  /// Confirmation message for deleting an asset movement
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this asset movement record?'**
  String get assetMovementDeleteConfirmation;

  /// Cancel button label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get assetMovementCancel;

  /// Delete button label
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get assetMovementDelete;

  /// Asset movement detail screen title
  ///
  /// In en, this message translates to:
  /// **'Asset Movement Detail'**
  String get assetMovementDetail;

  /// Asset movement information section title
  ///
  /// In en, this message translates to:
  /// **'Movement Information'**
  String get assetMovementInformation;

  /// Movement ID label
  ///
  /// In en, this message translates to:
  /// **'Movement ID'**
  String get assetMovementId;

  /// Asset label
  ///
  /// In en, this message translates to:
  /// **'Asset'**
  String get assetMovementAsset;

  /// Movement type label
  ///
  /// In en, this message translates to:
  /// **'Movement Type'**
  String get assetMovementMovementType;

  /// From location label
  ///
  /// In en, this message translates to:
  /// **'From Location'**
  String get assetMovementFromLocation;

  /// To location label
  ///
  /// In en, this message translates to:
  /// **'To Location'**
  String get assetMovementToLocation;

  /// From user label
  ///
  /// In en, this message translates to:
  /// **'From User'**
  String get assetMovementFromUser;

  /// To user label
  ///
  /// In en, this message translates to:
  /// **'To User'**
  String get assetMovementToUser;

  /// Moved by label
  ///
  /// In en, this message translates to:
  /// **'Moved By'**
  String get assetMovementMovedBy;

  /// Movement date label
  ///
  /// In en, this message translates to:
  /// **'Movement Date'**
  String get assetMovementMovementDate;

  /// Notes label
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get assetMovementNotes;

  /// Status label
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get assetMovementStatus;

  /// Metadata section title
  ///
  /// In en, this message translates to:
  /// **'Metadata'**
  String get assetMovementMetadata;

  /// Created at label
  ///
  /// In en, this message translates to:
  /// **'Created At'**
  String get assetMovementCreatedAt;

  /// Updated at label
  ///
  /// In en, this message translates to:
  /// **'Updated At'**
  String get assetMovementUpdatedAt;

  /// Error message for non-admin trying to edit
  ///
  /// In en, this message translates to:
  /// **'Only admin can edit asset movements'**
  String get assetMovementOnlyAdminCanEdit;

  /// Error message for non-admin trying to delete
  ///
  /// In en, this message translates to:
  /// **'Only admin can delete asset movements'**
  String get assetMovementOnlyAdminCanDelete;

  /// Error message when asset movement fails to load
  ///
  /// In en, this message translates to:
  /// **'Failed to load asset movement'**
  String get assetMovementFailedToLoad;

  /// Edit asset movement screen title
  ///
  /// In en, this message translates to:
  /// **'Edit Asset Movement'**
  String get assetMovementEditAssetMovement;

  /// Create asset movement screen title
  ///
  /// In en, this message translates to:
  /// **'Create Asset Movement'**
  String get assetMovementCreateAssetMovement;

  /// Validation message for required fields
  ///
  /// In en, this message translates to:
  /// **'Please fill all required fields'**
  String get assetMovementFillRequiredFields;

  /// Validation message for asset selection
  ///
  /// In en, this message translates to:
  /// **'Please select an asset'**
  String get assetMovementSelectAsset;

  /// Success message for asset movement save
  ///
  /// In en, this message translates to:
  /// **'Asset movement saved successfully'**
  String get assetMovementSavedSuccessfully;

  /// Generic operation failure message
  ///
  /// In en, this message translates to:
  /// **'Operation failed'**
  String get assetMovementOperationFailed;

  /// Basic information section title
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get assetMovementBasicInformation;

  /// Select asset placeholder
  ///
  /// In en, this message translates to:
  /// **'Select asset'**
  String get assetMovementSelectAssetPlaceholder;

  /// Search asset placeholder
  ///
  /// In en, this message translates to:
  /// **'Search asset...'**
  String get assetMovementSearchAsset;

  /// Select movement type placeholder
  ///
  /// In en, this message translates to:
  /// **'Select movement type'**
  String get assetMovementSelectMovementType;

  /// Location details section title
  ///
  /// In en, this message translates to:
  /// **'Location Details'**
  String get assetMovementLocationDetails;

  /// From location input label
  ///
  /// In en, this message translates to:
  /// **'From Location'**
  String get assetMovementFromLocationLabel;

  /// Search from location placeholder
  ///
  /// In en, this message translates to:
  /// **'Search from location...'**
  String get assetMovementSearchFromLocation;

  /// To location input label
  ///
  /// In en, this message translates to:
  /// **'To Location'**
  String get assetMovementToLocationLabel;

  /// Search to location placeholder
  ///
  /// In en, this message translates to:
  /// **'Search to location...'**
  String get assetMovementSearchToLocation;

  /// User details section title
  ///
  /// In en, this message translates to:
  /// **'User Details'**
  String get assetMovementUserDetails;

  /// From user input label
  ///
  /// In en, this message translates to:
  /// **'From User'**
  String get assetMovementFromUserLabel;

  /// Search from user placeholder
  ///
  /// In en, this message translates to:
  /// **'Search from user...'**
  String get assetMovementSearchFromUser;

  /// To user input label
  ///
  /// In en, this message translates to:
  /// **'To User'**
  String get assetMovementToUserLabel;

  /// Search to user placeholder
  ///
  /// In en, this message translates to:
  /// **'Search to user...'**
  String get assetMovementSearchToUser;

  /// Movement date input label
  ///
  /// In en, this message translates to:
  /// **'Movement Date'**
  String get assetMovementMovementDateLabel;

  /// Notes input label
  ///
  /// In en, this message translates to:
  /// **'Notes (Optional)'**
  String get assetMovementNotesLabel;

  /// Notes input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter notes...'**
  String get assetMovementEnterNotes;

  /// Update button label
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get assetMovementUpdate;

  /// Create button label
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get assetMovementCreate;

  /// Asset movement management screen title
  ///
  /// In en, this message translates to:
  /// **'Asset Movement Management'**
  String get assetMovementManagement;

  /// Asset movements search placeholder
  ///
  /// In en, this message translates to:
  /// **'Search asset movements...'**
  String get assetMovementSearchAssetMovements;

  /// No asset movements found message
  ///
  /// In en, this message translates to:
  /// **'No asset movements found'**
  String get assetMovementNoMovementsFound;

  /// Empty state message for asset movements
  ///
  /// In en, this message translates to:
  /// **'Create your first asset movement to get started'**
  String get assetMovementCreateFirstMovement;

  /// Filter and sort option title
  ///
  /// In en, this message translates to:
  /// **'Filter & Sort'**
  String get assetMovementFilterAndSortTitle;

  /// Filter and sort option subtitle
  ///
  /// In en, this message translates to:
  /// **'Customize asset movement display'**
  String get assetMovementFilterAndSortSubtitle;

  /// Filter by asset label
  ///
  /// In en, this message translates to:
  /// **'Filter by Asset'**
  String get assetMovementFilterByAsset;

  /// Filter by movement type label
  ///
  /// In en, this message translates to:
  /// **'Filter by Movement Type'**
  String get assetMovementFilterByMovementType;

  /// Filter by location label
  ///
  /// In en, this message translates to:
  /// **'Filter by Location'**
  String get assetMovementFilterByLocation;

  /// Filter by user label
  ///
  /// In en, this message translates to:
  /// **'Filter by User'**
  String get assetMovementFilterByUser;

  /// Sort by label
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get assetMovementSortBy;

  /// Sort order label
  ///
  /// In en, this message translates to:
  /// **'Sort Order'**
  String get assetMovementSortOrder;

  /// Reset button label
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get assetMovementReset;

  /// Apply button label
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get assetMovementApply;

  /// Filter reset success message
  ///
  /// In en, this message translates to:
  /// **'Filter reset'**
  String get assetMovementFilterReset;

  /// Filter applied success message
  ///
  /// In en, this message translates to:
  /// **'Filter applied'**
  String get assetMovementFilterApplied;

  /// Movement statistics section title
  ///
  /// In en, this message translates to:
  /// **'Movement Statistics'**
  String get assetMovementStatistics;

  /// Total movements label
  ///
  /// In en, this message translates to:
  /// **'Total Movements'**
  String get assetMovementTotalMovements;

  /// Movements by type label
  ///
  /// In en, this message translates to:
  /// **'Movements by Type'**
  String get assetMovementByType;

  /// Movements by status label
  ///
  /// In en, this message translates to:
  /// **'Movements by Status'**
  String get assetMovementByStatus;

  /// Recent activity label
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get assetMovementRecentActivity;

  /// Validation error for required asset
  ///
  /// In en, this message translates to:
  /// **'Asset is required'**
  String get assetMovementValidationAssetRequired;

  /// Validation error for required movement type
  ///
  /// In en, this message translates to:
  /// **'Movement type is required'**
  String get assetMovementValidationMovementTypeRequired;

  /// Validation error for required location
  ///
  /// In en, this message translates to:
  /// **'Location is required for this movement type'**
  String get assetMovementValidationLocationRequired;

  /// Validation error for required user
  ///
  /// In en, this message translates to:
  /// **'User is required for this movement type'**
  String get assetMovementValidationUserRequired;

  /// Validation error for required movement date
  ///
  /// In en, this message translates to:
  /// **'Movement date is required'**
  String get assetMovementValidationMovementDateRequired;

  /// Validation error for notes maximum length
  ///
  /// In en, this message translates to:
  /// **'Notes must not exceed 500 characters'**
  String get assetMovementValidationNotesMaxLength;

  /// Validation error for required to location
  ///
  /// In en, this message translates to:
  /// **'To location is required'**
  String get assetMovementValidationToLocationRequired;

  /// Validation error for required to user
  ///
  /// In en, this message translates to:
  /// **'To user is required'**
  String get assetMovementValidationToUserRequired;

  /// Validation error for required moved by
  ///
  /// In en, this message translates to:
  /// **'Moved by is required'**
  String get assetMovementValidationMovedByRequired;

  /// Validation error for movement date in future
  ///
  /// In en, this message translates to:
  /// **'Movement date cannot be in the future'**
  String get assetMovementValidationMovementDateFuture;

  /// Translations section title
  ///
  /// In en, this message translates to:
  /// **'Translations'**
  String get assetMovementTranslations;

  /// Unknown asset placeholder
  ///
  /// In en, this message translates to:
  /// **'Unknown Asset'**
  String get assetMovementUnknownAsset;

  /// Unknown tag placeholder
  ///
  /// In en, this message translates to:
  /// **'Unknown Tag'**
  String get assetMovementUnknownTag;

  /// Unknown placeholder
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get assetMovementUnknown;

  /// Unassigned placeholder
  ///
  /// In en, this message translates to:
  /// **'Unassigned'**
  String get assetMovementUnassigned;

  /// Not set value text
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get assetMovementNotSet;

  /// Location movement type label
  ///
  /// In en, this message translates to:
  /// **'Location Movement'**
  String get assetMovementLocationMovement;

  /// User movement type label
  ///
  /// In en, this message translates to:
  /// **'User Movement'**
  String get assetMovementUserMovement;

  /// Create asset movement option title
  ///
  /// In en, this message translates to:
  /// **'Create Asset Movement'**
  String get assetMovementCreateAssetMovementTitle;

  /// Create asset movement option subtitle
  ///
  /// In en, this message translates to:
  /// **'Record a new asset movement'**
  String get assetMovementCreateAssetMovementSubtitle;

  /// Asset movement for location screen title
  ///
  /// In en, this message translates to:
  /// **'Asset Movement for Location'**
  String get assetMovementForLocation;

  /// Asset movement for user screen title
  ///
  /// In en, this message translates to:
  /// **'Asset Movement for User'**
  String get assetMovementForUser;

  /// Current location label
  ///
  /// In en, this message translates to:
  /// **'Current Location'**
  String get assetMovementCurrentLocation;

  /// New location label
  ///
  /// In en, this message translates to:
  /// **'New Location'**
  String get assetMovementNewLocation;

  /// Current user label
  ///
  /// In en, this message translates to:
  /// **'Current User'**
  String get assetMovementCurrentUser;

  /// New user label
  ///
  /// In en, this message translates to:
  /// **'New User'**
  String get assetMovementNewUser;

  /// Movement history section title
  ///
  /// In en, this message translates to:
  /// **'Movement History'**
  String get assetMovementMovementHistory;

  /// No movement history message
  ///
  /// In en, this message translates to:
  /// **'No movement history available'**
  String get assetMovementNoHistory;

  /// View all button label
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get assetMovementViewAll;

  /// Moved to prefix text
  ///
  /// In en, this message translates to:
  /// **'Moved to'**
  String get assetMovementMovedTo;

  /// Assigned to prefix text
  ///
  /// In en, this message translates to:
  /// **'Assigned to'**
  String get assetMovementAssignedTo;

  /// Select many option title
  ///
  /// In en, this message translates to:
  /// **'Select Many'**
  String get assetMovementSelectMany;

  /// Select many option subtitle
  ///
  /// In en, this message translates to:
  /// **'Select multiple asset movements to delete'**
  String get assetMovementSelectManySubtitle;

  /// Toast message for select mode
  ///
  /// In en, this message translates to:
  /// **'Select asset movements to delete'**
  String get assetMovementSelectAssetMovementsToDelete;

  /// Dialog content for choosing movement type
  ///
  /// In en, this message translates to:
  /// **'Choose movement type:'**
  String get assetMovementChooseMovementType;

  /// Filter by from location label
  ///
  /// In en, this message translates to:
  /// **'Filter by From Location'**
  String get assetMovementFilterByFromLocation;

  /// Filter by to location label
  ///
  /// In en, this message translates to:
  /// **'Filter by To Location'**
  String get assetMovementFilterByToLocation;

  /// Filter by from user label
  ///
  /// In en, this message translates to:
  /// **'Filter by From User'**
  String get assetMovementFilterByFromUser;

  /// Filter by to user label
  ///
  /// In en, this message translates to:
  /// **'Filter by To User'**
  String get assetMovementFilterByToUser;

  /// Filter by moved by label
  ///
  /// In en, this message translates to:
  /// **'Filter by Moved By'**
  String get assetMovementFilterByMovedBy;

  /// Date from label
  ///
  /// In en, this message translates to:
  /// **'Date From'**
  String get assetMovementDateFrom;

  /// Date to label
  ///
  /// In en, this message translates to:
  /// **'Date To'**
  String get assetMovementDateTo;

  /// Search asset placeholder in filter
  ///
  /// In en, this message translates to:
  /// **'Search asset...'**
  String get assetMovementSearchAssetPlaceholder;

  /// Search from location placeholder
  ///
  /// In en, this message translates to:
  /// **'Search from location...'**
  String get assetMovementSearchFromLocationPlaceholder;

  /// Search to location placeholder
  ///
  /// In en, this message translates to:
  /// **'Search to location...'**
  String get assetMovementSearchToLocationPlaceholder;

  /// Search from user placeholder
  ///
  /// In en, this message translates to:
  /// **'Search from user...'**
  String get assetMovementSearchFromUserPlaceholder;

  /// Search to user placeholder
  ///
  /// In en, this message translates to:
  /// **'Search to user...'**
  String get assetMovementSearchToUserPlaceholder;

  /// Search moved by user placeholder
  ///
  /// In en, this message translates to:
  /// **'Search moved by user...'**
  String get assetMovementSearchMovedByPlaceholder;

  /// Dialog title for deleting multiple asset movements
  ///
  /// In en, this message translates to:
  /// **'Delete Asset Movements'**
  String get assetMovementDeleteAssetMovements;

  /// Confirmation message for deleting multiple asset movements
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {count} asset movements?'**
  String assetMovementDeleteManyConfirmation(int count);

  /// Warning message when no asset movements selected
  ///
  /// In en, this message translates to:
  /// **'No asset movements selected'**
  String get assetMovementNoAssetMovementsSelected;

  /// Info message for not implemented feature
  ///
  /// In en, this message translates to:
  /// **'Not implemented yet'**
  String get assetMovementNotImplementedYet;

  /// Selected count text
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String assetMovementSelectedCount(int count);

  /// Toast message for long press to select
  ///
  /// In en, this message translates to:
  /// **'Long press to select more asset movements'**
  String get assetMovementLongPressToSelectMore;

  /// Short label for location movement
  ///
  /// In en, this message translates to:
  /// **'For Location'**
  String get assetMovementForLocationShort;

  /// Short label for user movement
  ///
  /// In en, this message translates to:
  /// **'For User'**
  String get assetMovementForUserShort;

  /// Login screen header title
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get authWelcomeBack;

  /// Login screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get authSignInToContinue;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmail;

  /// Email field placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get authEnterYourEmail;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// Password field placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get authEnterYourPassword;

  /// Forgot password link text
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get authForgotPassword;

  /// Login button label
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get authLogin;

  /// Register link prefix text
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get authDontHaveAccount;

  /// Register link/button label
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get authRegister;

  /// Success message after login
  ///
  /// In en, this message translates to:
  /// **'Login successful'**
  String get authLoginSuccessful;

  /// Register screen header title
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get authCreateAccount;

  /// Register screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Sign up to get started'**
  String get authSignUpToGetStarted;

  /// Name field label
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get authName;

  /// Name field placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get authEnterYourName;

  /// Confirm password field label
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get authConfirmPassword;

  /// Confirm password field placeholder
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get authReEnterYourPassword;

  /// Password requirements section title
  ///
  /// In en, this message translates to:
  /// **'Password must contain:'**
  String get authPasswordMustContain;

  /// Placeholder password requirement text
  ///
  /// In en, this message translates to:
  /// **'Just make the password man!'**
  String get authPasswordRequirementPlaceholder;

  /// Success message after registration
  ///
  /// In en, this message translates to:
  /// **'Registration successful'**
  String get authRegistrationSuccessful;

  /// Login link prefix text
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get authAlreadyHaveAccount;

  /// Forgot password screen header title
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get authForgotPasswordTitle;

  /// Forgot password screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Enter your email to reset your password'**
  String get authEnterEmailToResetPassword;

  /// Send reset link button label
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get authSendResetLink;

  /// Success message after sending reset email
  ///
  /// In en, this message translates to:
  /// **'Email sent successfully'**
  String get authEmailSentSuccessfully;

  /// Back to login link prefix text
  ///
  /// In en, this message translates to:
  /// **'Remember your password? '**
  String get authRememberPassword;

  /// Validation error for required email
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get authValidationEmailRequired;

  /// Validation error for invalid email format
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get authValidationEmailInvalid;

  /// Validation error for required password
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get authValidationPasswordRequired;

  /// Validation error for required name
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get authValidationNameRequired;

  /// Validation error for name minimum length
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 3 characters'**
  String get authValidationNameMinLength;

  /// Validation error for name maximum length
  ///
  /// In en, this message translates to:
  /// **'Name must not exceed 20 characters'**
  String get authValidationNameMaxLength;

  /// Validation error for name format
  ///
  /// In en, this message translates to:
  /// **'Name can only contain letters, numbers, and underscores'**
  String get authValidationNameAlphanumeric;

  /// Validation error for required confirm password
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get authValidationConfirmPasswordRequired;

  /// Validation error when passwords don't match
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get authValidationPasswordsDoNotMatch;

  /// Category detail screen title
  ///
  /// In en, this message translates to:
  /// **'Category Detail'**
  String get categoryDetail;

  /// Category information section title
  ///
  /// In en, this message translates to:
  /// **'Category Information'**
  String get categoryInformation;

  /// Category code label
  ///
  /// In en, this message translates to:
  /// **'Category Code'**
  String get categoryCategoryCode;

  /// Category name label
  ///
  /// In en, this message translates to:
  /// **'Category Name'**
  String get categoryCategoryName;

  /// Description label
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get categoryDescription;

  /// Parent category label
  ///
  /// In en, this message translates to:
  /// **'Parent Category'**
  String get categoryParentCategory;

  /// Metadata section title
  ///
  /// In en, this message translates to:
  /// **'Metadata'**
  String get categoryMetadata;

  /// Created at label
  ///
  /// In en, this message translates to:
  /// **'Created At'**
  String get categoryCreatedAt;

  /// Updated at label
  ///
  /// In en, this message translates to:
  /// **'Updated At'**
  String get categoryUpdatedAt;

  /// Error message for non-admin trying to edit
  ///
  /// In en, this message translates to:
  /// **'Only admin can edit categories'**
  String get categoryOnlyAdminCanEdit;

  /// Error message for non-admin trying to delete
  ///
  /// In en, this message translates to:
  /// **'Only admin can delete categories'**
  String get categoryOnlyAdminCanDelete;

  /// Delete category dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Category'**
  String get categoryDeleteCategory;

  /// Confirmation message for deleting a category
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{categoryName}\"?'**
  String categoryDeleteConfirmation(String categoryName);

  /// Cancel button label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get categoryCancel;

  /// Delete button label
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get categoryDelete;

  /// Success message for category deletion
  ///
  /// In en, this message translates to:
  /// **'Category deleted'**
  String get categoryCategoryDeleted;

  /// Error message for category deletion failure
  ///
  /// In en, this message translates to:
  /// **'Delete failed'**
  String get categoryDeleteFailed;

  /// Edit category screen title
  ///
  /// In en, this message translates to:
  /// **'Edit Category'**
  String get categoryEditCategory;

  /// Create category screen title
  ///
  /// In en, this message translates to:
  /// **'Create Category'**
  String get categoryCreateCategory;

  /// Search category placeholder
  ///
  /// In en, this message translates to:
  /// **'Search category...'**
  String get categorySearchCategory;

  /// Category code input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter category code (e.g., CAT-001)'**
  String get categoryEnterCategoryCode;

  /// Translations section title
  ///
  /// In en, this message translates to:
  /// **'Translations'**
  String get categoryTranslations;

  /// Translations section subtitle
  ///
  /// In en, this message translates to:
  /// **'Add translations for different languages'**
  String get categoryAddTranslations;

  /// English language label
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get categoryEnglish;

  /// Japanese language label
  ///
  /// In en, this message translates to:
  /// **'Japanese'**
  String get categoryJapanese;

  /// Category name input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter category name'**
  String get categoryEnterCategoryName;

  /// Description input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter description'**
  String get categoryEnterDescription;

  /// Update button label
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get categoryUpdate;

  /// Create button label
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get categoryCreate;

  /// Validation message for required fields
  ///
  /// In en, this message translates to:
  /// **'Please fill all required fields'**
  String get categoryFillRequiredFields;

  /// Success message for category save
  ///
  /// In en, this message translates to:
  /// **'Category saved successfully'**
  String get categorySavedSuccessfully;

  /// Generic operation failure message
  ///
  /// In en, this message translates to:
  /// **'Operation failed'**
  String get categoryOperationFailed;

  /// Error message when translations fail to load
  ///
  /// In en, this message translates to:
  /// **'Failed to load translations'**
  String get categoryFailedToLoadTranslations;

  /// Category management screen title
  ///
  /// In en, this message translates to:
  /// **'Category Management'**
  String get categoryManagement;

  /// Categories search placeholder
  ///
  /// In en, this message translates to:
  /// **'Search categories...'**
  String get categorySearchCategories;

  /// Create category option title
  ///
  /// In en, this message translates to:
  /// **'Create Category'**
  String get categoryCreateCategoryTitle;

  /// Create category option subtitle
  ///
  /// In en, this message translates to:
  /// **'Add a new category'**
  String get categoryCreateCategorySubtitle;

  /// Select many option title
  ///
  /// In en, this message translates to:
  /// **'Select Many'**
  String get categorySelectManyTitle;

  /// Select many option subtitle
  ///
  /// In en, this message translates to:
  /// **'Select multiple categories to delete'**
  String get categorySelectManySubtitle;

  /// Filter and sort option title
  ///
  /// In en, this message translates to:
  /// **'Filter & Sort'**
  String get categoryFilterAndSortTitle;

  /// Filter and sort option subtitle
  ///
  /// In en, this message translates to:
  /// **'Customize category display'**
  String get categoryFilterAndSortSubtitle;

  /// Instruction for selecting categories to delete
  ///
  /// In en, this message translates to:
  /// **'Select categories to delete'**
  String get categorySelectCategoriesToDelete;

  /// Sort by label
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get categorySortBy;

  /// Sort order label
  ///
  /// In en, this message translates to:
  /// **'Sort Order'**
  String get categorySortOrder;

  /// Has parent checkbox label
  ///
  /// In en, this message translates to:
  /// **'Has Parent'**
  String get categoryHasParent;

  /// Filter by parent category label
  ///
  /// In en, this message translates to:
  /// **'Filter by Parent Category'**
  String get categoryFilterByParent;

  /// Search parent category placeholder
  ///
  /// In en, this message translates to:
  /// **'Search parent category...'**
  String get categorySearchParentCategory;

  /// Reset button label
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get categoryReset;

  /// Apply button label
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get categoryApply;

  /// Filter reset success message
  ///
  /// In en, this message translates to:
  /// **'Filter reset'**
  String get categoryFilterReset;

  /// Filter applied success message
  ///
  /// In en, this message translates to:
  /// **'Filter applied'**
  String get categoryFilterApplied;

  /// Delete categories dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Categories'**
  String get categoryDeleteCategories;

  /// Confirmation message for deleting multiple categories
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {count} categories?'**
  String categoryDeleteMultipleConfirmation(int count);

  /// Warning message when no categories are selected
  ///
  /// In en, this message translates to:
  /// **'No categories selected'**
  String get categoryNoCategoriesSelected;

  /// Placeholder message for unimplemented features
  ///
  /// In en, this message translates to:
  /// **'Not implemented yet'**
  String get categoryNotImplementedYet;

  /// Selected count display
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String categorySelectedCount(int count);

  /// No categories found message
  ///
  /// In en, this message translates to:
  /// **'No categories found'**
  String get categoryNoCategoriesFound;

  /// Empty state message for categories
  ///
  /// In en, this message translates to:
  /// **'Create your first category to get started'**
  String get categoryCreateFirstCategory;

  /// Instruction for selecting multiple categories
  ///
  /// In en, this message translates to:
  /// **'Long press to select more categories'**
  String get categoryLongPressToSelect;

  /// Validation error for required category code
  ///
  /// In en, this message translates to:
  /// **'Category code is required'**
  String get categoryValidationCodeRequired;

  /// Validation error for category code minimum length
  ///
  /// In en, this message translates to:
  /// **'Category code must be at least 2 characters'**
  String get categoryValidationCodeMinLength;

  /// Validation error for category code maximum length
  ///
  /// In en, this message translates to:
  /// **'Category code must not exceed 20 characters'**
  String get categoryValidationCodeMaxLength;

  /// Validation error for category code format
  ///
  /// In en, this message translates to:
  /// **'Category code can only contain letters, numbers, and underscores'**
  String get categoryValidationCodeAlphanumeric;

  /// Validation error for required category name
  ///
  /// In en, this message translates to:
  /// **'Category name is required'**
  String get categoryValidationNameRequired;

  /// Validation error for category name minimum length
  ///
  /// In en, this message translates to:
  /// **'Category name must be at least 3 characters'**
  String get categoryValidationNameMinLength;

  /// Validation error for category name maximum length
  ///
  /// In en, this message translates to:
  /// **'Category name must not exceed 100 characters'**
  String get categoryValidationNameMaxLength;

  /// Validation error for required description
  ///
  /// In en, this message translates to:
  /// **'Description is required'**
  String get categoryValidationDescriptionRequired;

  /// Validation error for description minimum length
  ///
  /// In en, this message translates to:
  /// **'Description must be at least 10 characters'**
  String get categoryValidationDescriptionMinLength;

  /// Validation error for description maximum length
  ///
  /// In en, this message translates to:
  /// **'Description must not exceed 500 characters'**
  String get categoryValidationDescriptionMaxLength;

  /// Total users stat card title
  ///
  /// In en, this message translates to:
  /// **'Total Users'**
  String get dashboardTotalUsers;

  /// Total assets stat card title
  ///
  /// In en, this message translates to:
  /// **'Total Assets'**
  String get dashboardTotalAssets;

  /// Asset status overview chart title
  ///
  /// In en, this message translates to:
  /// **'Asset Status Overview'**
  String get dashboardAssetStatusOverview;

  /// Active status label
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get dashboardActive;

  /// Maintenance status label
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get dashboardMaintenance;

  /// Disposed status label
  ///
  /// In en, this message translates to:
  /// **'Disposed'**
  String get dashboardDisposed;

  /// Lost status label
  ///
  /// In en, this message translates to:
  /// **'Lost'**
  String get dashboardLost;

  /// User role distribution chart title
  ///
  /// In en, this message translates to:
  /// **'User Role Distribution'**
  String get dashboardUserRoleDistribution;

  /// Admin role label
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get dashboardAdmin;

  /// Staff role label
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get dashboardStaff;

  /// Employee role label
  ///
  /// In en, this message translates to:
  /// **'Employee'**
  String get dashboardEmployee;

  /// Asset status breakdown chart title
  ///
  /// In en, this message translates to:
  /// **'Asset Status Breakdown'**
  String get dashboardAssetStatusBreakdown;

  /// Asset condition overview chart title
  ///
  /// In en, this message translates to:
  /// **'Asset Condition Overview'**
  String get dashboardAssetConditionOverview;

  /// Good condition label
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get dashboardGood;

  /// Fair condition label
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get dashboardFair;

  /// Poor condition label
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get dashboardPoor;

  /// Damaged condition label
  ///
  /// In en, this message translates to:
  /// **'Damaged'**
  String get dashboardDamaged;

  /// User registration trends chart title
  ///
  /// In en, this message translates to:
  /// **'User Registration Trends'**
  String get dashboardUserRegistrationTrends;

  /// Asset creation trends chart title
  ///
  /// In en, this message translates to:
  /// **'Asset Creation Trends'**
  String get dashboardAssetCreationTrends;

  /// Categories stat card title
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get dashboardCategories;

  /// Locations stat card title
  ///
  /// In en, this message translates to:
  /// **'Locations'**
  String get dashboardLocations;

  /// Activity overview section title
  ///
  /// In en, this message translates to:
  /// **'Activity Overview'**
  String get dashboardActivityOverview;

  /// Scan logs stat card title
  ///
  /// In en, this message translates to:
  /// **'Scan Logs'**
  String get dashboardScanLogs;

  /// Notifications stat card title
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get dashboardNotifications;

  /// Asset movements stat card title
  ///
  /// In en, this message translates to:
  /// **'Asset Movements'**
  String get dashboardAssetMovements;

  /// Issue reports stat card title
  ///
  /// In en, this message translates to:
  /// **'Issue Reports'**
  String get dashboardIssueReports;

  /// Maintenance schedules stat card title
  ///
  /// In en, this message translates to:
  /// **'Maintenance Schedules'**
  String get dashboardMaintenanceSchedules;

  /// Maintenance records stat card title
  ///
  /// In en, this message translates to:
  /// **'Maintenance Records'**
  String get dashboardMaintenanceRecords;

  /// Home screen title
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeScreen;

  /// Admin shell bottom navigation label for dashboard
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get adminShellBottomNavDashboard;

  /// Admin shell bottom navigation label for scan asset
  ///
  /// In en, this message translates to:
  /// **'Scan Asset'**
  String get adminShellBottomNavScanAsset;

  /// Admin shell bottom navigation label for profile
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get adminShellBottomNavProfile;

  /// User shell bottom navigation label for home
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get userShellBottomNavHome;

  /// User shell bottom navigation label for scan asset
  ///
  /// In en, this message translates to:
  /// **'Scan Asset'**
  String get userShellBottomNavScanAsset;

  /// User shell bottom navigation label for profile
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get userShellBottomNavProfile;

  /// App end drawer title
  ///
  /// In en, this message translates to:
  /// **'Sigma Track'**
  String get appEndDrawerTitle;

  /// Message shown when user needs to login
  ///
  /// In en, this message translates to:
  /// **'Please login first'**
  String get appEndDrawerPleaseLoginFirst;

  /// Theme settings label
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get appEndDrawerTheme;

  /// Language settings label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get appEndDrawerLanguage;

  /// Logout button label
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get appEndDrawerLogout;

  /// Management section header
  ///
  /// In en, this message translates to:
  /// **'Management'**
  String get appEndDrawerManagementSection;

  /// Maintenance section header
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get appEndDrawerMaintenanceSection;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get appEndDrawerEnglish;

  /// Indonesian language option
  ///
  /// In en, this message translates to:
  /// **'Indonesia'**
  String get appEndDrawerIndonesian;

  /// Japanese language option
  ///
  /// In en, this message translates to:
  /// **'日本語'**
  String get appEndDrawerJapanese;

  /// My assets menu item
  ///
  /// In en, this message translates to:
  /// **'My Assets'**
  String get appEndDrawerMyAssets;

  /// Notifications menu item
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get appEndDrawerNotifications;

  /// My issue reports menu item
  ///
  /// In en, this message translates to:
  /// **'My Issue Reports'**
  String get appEndDrawerMyIssueReports;

  /// Assets menu item
  ///
  /// In en, this message translates to:
  /// **'Assets'**
  String get appEndDrawerAssets;

  /// Asset movements menu item
  ///
  /// In en, this message translates to:
  /// **'Asset Movements'**
  String get appEndDrawerAssetMovements;

  /// Categories menu item
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get appEndDrawerCategories;

  /// Locations menu item
  ///
  /// In en, this message translates to:
  /// **'Locations'**
  String get appEndDrawerLocations;

  /// Users menu item
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get appEndDrawerUsers;

  /// Maintenance schedules menu item
  ///
  /// In en, this message translates to:
  /// **'Maintenance Schedules'**
  String get appEndDrawerMaintenanceSchedules;

  /// Maintenance records menu item
  ///
  /// In en, this message translates to:
  /// **'Maintenance Records'**
  String get appEndDrawerMaintenanceRecords;

  /// Reports menu item
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get appEndDrawerReports;

  /// Issue reports menu item
  ///
  /// In en, this message translates to:
  /// **'Issue Reports'**
  String get appEndDrawerIssueReports;

  /// Scan logs menu item
  ///
  /// In en, this message translates to:
  /// **'Scan Logs'**
  String get appEndDrawerScanLogs;

  /// Scan asset menu item
  ///
  /// In en, this message translates to:
  /// **'Scan Asset'**
  String get appEndDrawerScanAsset;

  /// Dashboard menu item
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get appEndDrawerDashboard;

  /// Home menu item
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get appEndDrawerHome;

  /// Profile menu item
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get appEndDrawerProfile;

  /// App bar title
  ///
  /// In en, this message translates to:
  /// **'Sigma Track'**
  String get customAppBarTitle;

  /// Open menu button label
  ///
  /// In en, this message translates to:
  /// **'Open Menu'**
  String get customAppBarOpenMenu;

  /// Dropdown select option placeholder
  ///
  /// In en, this message translates to:
  /// **'Select option'**
  String get appDropdownSelectOption;

  /// Search field hint text
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get appSearchFieldHint;

  /// Clear search button label
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get appSearchFieldClear;

  /// No results found message
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get appSearchFieldNoResultsFound;
}

class _L10nDelegate extends LocalizationsDelegate<L10n> {
  const _L10nDelegate();

  @override
  Future<L10n> load(Locale locale) {
    return SynchronousFuture<L10n>(lookupL10n(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_L10nDelegate old) => false;
}

L10n lookupL10n(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return L10nEn();
    case 'id':
      return L10nId();
    case 'ja':
      return L10nJa();
  }

  throw FlutterError(
    'L10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
