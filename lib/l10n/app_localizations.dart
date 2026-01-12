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

  /// Button text for selecting images
  ///
  /// In en, this message translates to:
  /// **'Select Images'**
  String get assetSelectImages;

  /// Hint text for template images section
  ///
  /// In en, this message translates to:
  /// **'Upload images that will be used for this asset'**
  String get assetTemplateImagesHint;

  /// Text showing number of selected images
  ///
  /// In en, this message translates to:
  /// **'{count} images selected'**
  String assetImagesSelected(int count);

  /// Button text for clearing selected images
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get assetClearImages;

  /// Label for template images section
  ///
  /// In en, this message translates to:
  /// **'Select Template Images'**
  String get assetSelectTemplateImages;

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

  /// Warranty duration utility label
  ///
  /// In en, this message translates to:
  /// **'Warranty Duration (Auto-calculate)'**
  String get assetWarrantyDuration;

  /// Helper text for warranty duration utility
  ///
  /// In en, this message translates to:
  /// **'Auto-calculate warranty end from purchase date'**
  String get assetWarrantyDurationHelper;

  /// Warranty duration input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter duration'**
  String get assetEnterDuration;

  /// Month (singular)
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get assetMonth;

  /// Months (plural)
  ///
  /// In en, this message translates to:
  /// **'Months'**
  String get assetMonths;

  /// Year (singular)
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get assetYear;

  /// Years (plural)
  ///
  /// In en, this message translates to:
  /// **'Years'**
  String get assetYears;

  /// Period selection dropdown placeholder
  ///
  /// In en, this message translates to:
  /// **'Select period'**
  String get assetSelectPeriod;

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
  /// **'Save'**
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

  /// Instruction to select export type
  ///
  /// In en, this message translates to:
  /// **'Select export type'**
  String get assetSelectExportType;

  /// Export list option title
  ///
  /// In en, this message translates to:
  /// **'Export List'**
  String get assetExportList;

  /// Export list option subtitle
  ///
  /// In en, this message translates to:
  /// **'Export assets as a list'**
  String get assetExportListSubtitle;

  /// Export data matrix option title
  ///
  /// In en, this message translates to:
  /// **'Export Data Matrix'**
  String get assetExportDataMatrix;

  /// Export data matrix option subtitle
  ///
  /// In en, this message translates to:
  /// **'Export data matrix codes for assets'**
  String get assetExportDataMatrixSubtitle;

  /// Information about data matrix export format limitation
  ///
  /// In en, this message translates to:
  /// **'Data matrix export is only available in PDF format'**
  String get assetDataMatrixPdfOnly;

  /// Quick actions section title
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get assetQuickActions;

  /// Report issue action label
  ///
  /// In en, this message translates to:
  /// **'Report\nIssue'**
  String get assetReportIssue;

  /// Move to user action label
  ///
  /// In en, this message translates to:
  /// **'Move to\nUser'**
  String get assetMoveToUser;

  /// Move to location action label
  ///
  /// In en, this message translates to:
  /// **'Move to\nLocation'**
  String get assetMoveToLocation;

  /// Schedule maintenance action label
  ///
  /// In en, this message translates to:
  /// **'Schedule\nMaint.'**
  String get assetScheduleMaintenance;

  /// Record maintenance action label
  ///
  /// In en, this message translates to:
  /// **'Record\nMaint.'**
  String get assetRecordMaintenance;

  /// Copy asset action label
  ///
  /// In en, this message translates to:
  /// **'Copy\nAsset'**
  String get assetCopyAsset;

  /// Export option title
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get assetExportTitle;

  /// Export option subtitle
  ///
  /// In en, this message translates to:
  /// **'Export data to file'**
  String get assetExportSubtitle;

  /// Bulk copy section title
  ///
  /// In en, this message translates to:
  /// **'Bulk Copy'**
  String get assetBulkCopy;

  /// Bulk copy feature description
  ///
  /// In en, this message translates to:
  /// **'Create multiple assets with the same data. Only asset tag, data matrix, and serial number will be different.'**
  String get assetBulkCopyDescription;

  /// Enable bulk copy toggle label
  ///
  /// In en, this message translates to:
  /// **'Enable bulk copy'**
  String get assetEnableBulkCopy;

  /// Number of copies input label
  ///
  /// In en, this message translates to:
  /// **'Number of copies'**
  String get assetNumberOfCopies;

  /// Enter quantity placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter quantity'**
  String get assetEnterQuantity;

  /// Validation error for empty quantity
  ///
  /// In en, this message translates to:
  /// **'Please enter quantity'**
  String get assetPleaseEnterQuantity;

  /// Validation error for minimum copy quantity
  ///
  /// In en, this message translates to:
  /// **'Minimum 1 copy'**
  String get assetMinimumOneCopy;

  /// Validation error for maximum copy quantity
  ///
  /// In en, this message translates to:
  /// **'Maximum 100 copies'**
  String get assetMaximumCopies;

  /// Serial numbers bulk input label
  ///
  /// In en, this message translates to:
  /// **'Serial Numbers (Optional)'**
  String get assetSerialNumbersOptional;

  /// Serial numbers bulk input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter serial numbers separated by comma or newline'**
  String get assetEnterSerialNumbers;

  /// Warning message for bulk copy quantity
  ///
  /// In en, this message translates to:
  /// **'Please enter copy quantity (minimum 1)'**
  String get assetPleaseEnterCopyQuantity;

  /// Validation error for serial number count mismatch
  ///
  /// In en, this message translates to:
  /// **'Please enter exactly {quantity} serial numbers'**
  String assetEnterExactlySerialNumbers(int quantity);

  /// Validation error for duplicate serial numbers
  ///
  /// In en, this message translates to:
  /// **'Duplicate serial numbers found'**
  String get assetDuplicateSerialNumbers;

  /// Hint text for serial numbers input
  ///
  /// In en, this message translates to:
  /// **'Enter one serial number per line or separated by comma. Leave empty to skip serial numbers.'**
  String get assetSerialNumbersHint;

  /// Information about auto-generation in bulk mode
  ///
  /// In en, this message translates to:
  /// **'Asset tags and data matrix will be auto-generated for each copy.'**
  String get assetBulkAutoGenerateInfo;

  /// Bulk creation progress title
  ///
  /// In en, this message translates to:
  /// **'Creating Bulk Assets'**
  String get assetCreatingBulkAssets;

  /// Create bulk assets button label
  ///
  /// In en, this message translates to:
  /// **'Create Bulk Assets'**
  String get assetCreateBulkAssets;

  /// Progress status for generating asset tags
  ///
  /// In en, this message translates to:
  /// **'Generating asset tags...'**
  String get assetGeneratingAssetTags;

  /// Progress status for uploading template images
  ///
  /// In en, this message translates to:
  /// **'Uploading template images...'**
  String get assetUploadingTemplateImages;

  /// Error message for failed template image upload
  ///
  /// In en, this message translates to:
  /// **'Failed to upload template images: {error}'**
  String assetFailedToUploadTemplateImages(String error);

  /// Progress status for generating data matrix images
  ///
  /// In en, this message translates to:
  /// **'Generating data matrix images...'**
  String get assetGeneratingDataMatrixImages;

  /// Progress status for data matrix generation count
  ///
  /// In en, this message translates to:
  /// **'Generated {current}/{total} data matrix images'**
  String assetGeneratedDataMatrix(int current, int total);

  /// Progress status for uploading data matrix images
  ///
  /// In en, this message translates to:
  /// **'Uploading {current}/{total} data matrix images...'**
  String assetUploadingDataMatrix(int current, int total);

  /// Progress status with percentage for uploading data matrix
  ///
  /// In en, this message translates to:
  /// **'Uploading data matrix images... {progress}%'**
  String assetUploadingDataMatrixProgress(int progress);

  /// Progress status for creating assets
  ///
  /// In en, this message translates to:
  /// **'Creating assets...'**
  String get assetCreatingAssets;

  /// Error message for bulk asset creation failure
  ///
  /// In en, this message translates to:
  /// **'Failed to create bulk assets: {error}'**
  String assetFailedToCreateBulkAssets(String error);

  /// Tooltip when auto-generation is disabled
  ///
  /// In en, this message translates to:
  /// **'Auto-generation disabled in bulk copy mode'**
  String get assetAutoGenerationDisabled;

  /// Tooltip for auto-generate button
  ///
  /// In en, this message translates to:
  /// **'Auto-generate asset tag'**
  String get assetAutoGenerateAssetTag;

  /// Dialog title for canceling bulk processing
  ///
  /// In en, this message translates to:
  /// **'Cancel Bulk Processing?'**
  String get assetCancelBulkProcessingTitle;

  /// Dialog message for canceling bulk processing
  ///
  /// In en, this message translates to:
  /// **'Bulk asset creation is in progress. If you cancel now, all progress will be lost. Are you sure you want to cancel?'**
  String get assetCancelBulkProcessingMessage;

  /// Continue processing button label
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get assetContinueProcessing;

  /// Cancel processing button label
  ///
  /// In en, this message translates to:
  /// **'Cancel Processing'**
  String get assetCancelProcessing;

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

  /// Verify reset code screen title
  ///
  /// In en, this message translates to:
  /// **'Verify Reset Code'**
  String get authVerifyResetCode;

  /// Verify reset code screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Enter the reset code sent to your email'**
  String get authEnterResetCode;

  /// Reset code field label
  ///
  /// In en, this message translates to:
  /// **'Reset Code'**
  String get authResetCode;

  /// Reset code field placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter reset code'**
  String get authEnterResetCodePlaceholder;

  /// Verify code button label
  ///
  /// In en, this message translates to:
  /// **'Verify Code'**
  String get authVerifyCode;

  /// Reset password screen title
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get authResetPasswordTitle;

  /// Reset password screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Enter your new password'**
  String get authEnterNewPassword;

  /// New password field label
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get authNewPassword;

  /// New password field placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter new password'**
  String get authEnterNewPasswordPlaceholder;

  /// Confirm new password field label
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get authConfirmNewPassword;

  /// Confirm new password field placeholder
  ///
  /// In en, this message translates to:
  /// **'Re-enter new password'**
  String get authReEnterNewPassword;

  /// Reset password button label
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get authResetPasswordButton;

  /// Success message after verifying reset code
  ///
  /// In en, this message translates to:
  /// **'Code verified successfully'**
  String get authCodeVerifiedSuccessfully;

  /// Success message after resetting password
  ///
  /// In en, this message translates to:
  /// **'Password reset successfully'**
  String get authPasswordResetSuccessfully;

  /// Validation error for required reset code
  ///
  /// In en, this message translates to:
  /// **'Reset code is required'**
  String get authValidationResetCodeRequired;

  /// Validation error for reset code length
  ///
  /// In en, this message translates to:
  /// **'Reset code must be 6 characters'**
  String get authValidationResetCodeLength;

  /// Validation error for required new password
  ///
  /// In en, this message translates to:
  /// **'New password is required'**
  String get authValidationNewPasswordRequired;

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

  /// Indonesian language label
  ///
  /// In en, this message translates to:
  /// **'Indonesian'**
  String get categoryIndonesian;

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

  /// Category image label
  ///
  /// In en, this message translates to:
  /// **'Category Image'**
  String get categoryImage;

  /// Choose image button label
  ///
  /// In en, this message translates to:
  /// **'Choose Image'**
  String get categoryChooseImage;

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

  /// Dialog title for deleting an issue report
  ///
  /// In en, this message translates to:
  /// **'Delete Issue Report'**
  String get issueReportDeleteIssueReport;

  /// Confirmation message for deleting an issue report
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{title}\"?'**
  String issueReportDeleteConfirmation(String title);

  /// Cancel button label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get issueReportCancel;

  /// Delete button label
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get issueReportDelete;

  /// Issue report detail screen title
  ///
  /// In en, this message translates to:
  /// **'Issue Report Detail'**
  String get issueReportDetail;

  /// Issue report information section title
  ///
  /// In en, this message translates to:
  /// **'Issue Report Information'**
  String get issueReportInformation;

  /// Title label
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get issueReportTitle;

  /// Description label
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get issueReportDescription;

  /// Asset label
  ///
  /// In en, this message translates to:
  /// **'Asset'**
  String get issueReportAsset;

  /// Issue type label
  ///
  /// In en, this message translates to:
  /// **'Issue Type'**
  String get issueReportIssueType;

  /// Priority label
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get issueReportPriority;

  /// Status label
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get issueReportStatus;

  /// Reported by label
  ///
  /// In en, this message translates to:
  /// **'Reported By'**
  String get issueReportReportedBy;

  /// Reported date label
  ///
  /// In en, this message translates to:
  /// **'Reported Date'**
  String get issueReportReportedDate;

  /// Resolved date label
  ///
  /// In en, this message translates to:
  /// **'Resolved Date'**
  String get issueReportResolvedDate;

  /// Resolved by label
  ///
  /// In en, this message translates to:
  /// **'Resolved By'**
  String get issueReportResolvedBy;

  /// Resolution notes label
  ///
  /// In en, this message translates to:
  /// **'Resolution Notes'**
  String get issueReportResolutionNotes;

  /// Metadata section title
  ///
  /// In en, this message translates to:
  /// **'Metadata'**
  String get issueReportMetadata;

  /// Created at label
  ///
  /// In en, this message translates to:
  /// **'Created At'**
  String get issueReportCreatedAt;

  /// Updated at label
  ///
  /// In en, this message translates to:
  /// **'Updated At'**
  String get issueReportUpdatedAt;

  /// Error message for non-admin trying to edit
  ///
  /// In en, this message translates to:
  /// **'Only admin can edit issue reports'**
  String get issueReportOnlyAdminCanEdit;

  /// Error message for non-admin trying to delete
  ///
  /// In en, this message translates to:
  /// **'Only admin can delete issue reports'**
  String get issueReportOnlyAdminCanDelete;

  /// Error message when issue report fails to load
  ///
  /// In en, this message translates to:
  /// **'Failed to load issue report'**
  String get issueReportFailedToLoad;

  /// Success message for issue report deletion
  ///
  /// In en, this message translates to:
  /// **'Issue report deleted'**
  String get issueReportDeletedSuccess;

  /// Error message for issue report deletion failure
  ///
  /// In en, this message translates to:
  /// **'Delete failed'**
  String get issueReportDeletedFailed;

  /// Unknown asset placeholder
  ///
  /// In en, this message translates to:
  /// **'Unknown Asset'**
  String get issueReportUnknownAsset;

  /// Unknown user placeholder
  ///
  /// In en, this message translates to:
  /// **'Unknown User'**
  String get issueReportUnknownUser;

  /// Edit issue report screen title
  ///
  /// In en, this message translates to:
  /// **'Edit Issue Report'**
  String get issueReportEditIssueReport;

  /// Create issue report screen title
  ///
  /// In en, this message translates to:
  /// **'Create Issue Report'**
  String get issueReportCreateIssueReport;

  /// Validation message for required fields
  ///
  /// In en, this message translates to:
  /// **'Please fill all required fields'**
  String get issueReportFillRequiredFields;

  /// Success message for issue report save
  ///
  /// In en, this message translates to:
  /// **'Issue report saved successfully'**
  String get issueReportSavedSuccessfully;

  /// Generic operation failure message
  ///
  /// In en, this message translates to:
  /// **'Operation failed'**
  String get issueReportOperationFailed;

  /// Error message for translation loading failure
  ///
  /// In en, this message translates to:
  /// **'Failed to load translations'**
  String get issueReportFailedToLoadTranslations;

  /// Asset search placeholder
  ///
  /// In en, this message translates to:
  /// **'Search and select asset'**
  String get issueReportSearchAsset;

  /// Reported by search placeholder
  ///
  /// In en, this message translates to:
  /// **'Search and select user who reported the issue'**
  String get issueReportSearchReportedBy;

  /// Issue type input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter issue type (e.g., Hardware, Software)'**
  String get issueReportEnterIssueType;

  /// Priority dropdown placeholder
  ///
  /// In en, this message translates to:
  /// **'Select priority'**
  String get issueReportSelectPriority;

  /// Status dropdown placeholder
  ///
  /// In en, this message translates to:
  /// **'Select status'**
  String get issueReportSelectStatus;

  /// Resolved by search placeholder
  ///
  /// In en, this message translates to:
  /// **'Search and select user who resolved the issue'**
  String get issueReportSearchResolvedBy;

  /// Translations section title
  ///
  /// In en, this message translates to:
  /// **'Translations'**
  String get issueReportTranslations;

  /// English language label
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get issueReportEnglish;

  /// Japanese language label
  ///
  /// In en, this message translates to:
  /// **'Japanese'**
  String get issueReportJapanese;

  /// Indonesian language label
  ///
  /// In en, this message translates to:
  /// **'Indonesian'**
  String get issueReportIndonesian;

  /// Title input placeholder with language
  ///
  /// In en, this message translates to:
  /// **'Enter title in {language}'**
  String issueReportEnterTitleIn(String language);

  /// Description input placeholder with language
  ///
  /// In en, this message translates to:
  /// **'Enter description in {language}'**
  String issueReportEnterDescriptionIn(String language);

  /// Resolution notes input placeholder with language
  ///
  /// In en, this message translates to:
  /// **'Enter resolution notes in {language}'**
  String issueReportEnterResolutionNotesIn(String language);

  /// Update button label
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get issueReportUpdate;

  /// Create button label
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get issueReportCreate;

  /// Issue report management screen title
  ///
  /// In en, this message translates to:
  /// **'IssueReport Management'**
  String get issueReportManagement;

  /// Create issue report option title
  ///
  /// In en, this message translates to:
  /// **'Create IssueReport'**
  String get issueReportCreateIssueReportTitle;

  /// Create issue report option subtitle
  ///
  /// In en, this message translates to:
  /// **'Add a new issueReport'**
  String get issueReportCreateIssueReportSubtitle;

  /// Select many option title
  ///
  /// In en, this message translates to:
  /// **'Select Many'**
  String get issueReportSelectManyTitle;

  /// Select many option subtitle
  ///
  /// In en, this message translates to:
  /// **'Select multiple issueReports to delete'**
  String get issueReportSelectManySubtitle;

  /// Filter and sort option title
  ///
  /// In en, this message translates to:
  /// **'Filter & Sort'**
  String get issueReportFilterAndSortTitle;

  /// Filter and sort option subtitle
  ///
  /// In en, this message translates to:
  /// **'Customize issueReport display'**
  String get issueReportFilterAndSortSubtitle;

  /// Instruction for selecting issue reports to delete
  ///
  /// In en, this message translates to:
  /// **'Select issueReports to delete'**
  String get issueReportSelectIssueReportsToDelete;

  /// Delete issue reports dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete IssueReports'**
  String get issueReportDeleteIssueReports;

  /// Confirmation message for deleting multiple issue reports
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {count} issueReports?'**
  String issueReportDeleteMultipleConfirmation(int count);

  /// Warning message when no issue reports are selected
  ///
  /// In en, this message translates to:
  /// **'No issueReports selected'**
  String get issueReportNoIssueReportsSelected;

  /// Placeholder message for unimplemented features
  ///
  /// In en, this message translates to:
  /// **'Not implemented yet'**
  String get issueReportNotImplementedYet;

  /// Selected count display
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String issueReportSelectedCount(int count);

  /// Issue reports search placeholder
  ///
  /// In en, this message translates to:
  /// **'Search issueReports...'**
  String get issueReportSearchIssueReports;

  /// No issue reports found message
  ///
  /// In en, this message translates to:
  /// **'No issueReports found'**
  String get issueReportNoIssueReportsFound;

  /// Empty state message for issue reports
  ///
  /// In en, this message translates to:
  /// **'Create your first issueReport to get started'**
  String get issueReportCreateFirstIssueReport;

  /// Instruction for selecting multiple issue reports
  ///
  /// In en, this message translates to:
  /// **'Long press to select more issueReports'**
  String get issueReportLongPressToSelect;

  /// Filter by asset label
  ///
  /// In en, this message translates to:
  /// **'Filter by Asset'**
  String get issueReportFilterByAsset;

  /// Filter by reported by label
  ///
  /// In en, this message translates to:
  /// **'Filter by Reported By'**
  String get issueReportFilterByReportedBy;

  /// Filter by resolved by label
  ///
  /// In en, this message translates to:
  /// **'Filter by Resolved By'**
  String get issueReportFilterByResolvedBy;

  /// Asset filter search placeholder
  ///
  /// In en, this message translates to:
  /// **'Search asset...'**
  String get issueReportSearchAssetFilter;

  /// User filter search placeholder
  ///
  /// In en, this message translates to:
  /// **'Search user...'**
  String get issueReportSearchUserFilter;

  /// Issue type filter input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter issue type...'**
  String get issueReportEnterIssueTypeFilter;

  /// Sort by label
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get issueReportSortBy;

  /// Sort order label
  ///
  /// In en, this message translates to:
  /// **'Sort Order'**
  String get issueReportSortOrder;

  /// Is resolved checkbox label
  ///
  /// In en, this message translates to:
  /// **'Is Resolved'**
  String get issueReportIsResolved;

  /// Date from label
  ///
  /// In en, this message translates to:
  /// **'Date From'**
  String get issueReportDateFrom;

  /// Date to label
  ///
  /// In en, this message translates to:
  /// **'Date To'**
  String get issueReportDateTo;

  /// Reset button label
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get issueReportReset;

  /// Apply button label
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get issueReportApply;

  /// Filter reset success message
  ///
  /// In en, this message translates to:
  /// **'Filter reset'**
  String get issueReportFilterReset;

  /// Filter applied success message
  ///
  /// In en, this message translates to:
  /// **'Filter applied'**
  String get issueReportFilterApplied;

  /// My issue reports screen title
  ///
  /// In en, this message translates to:
  /// **'My Issue Reports'**
  String get issueReportMyIssueReports;

  /// My issue reports search placeholder
  ///
  /// In en, this message translates to:
  /// **'Search my issue reports...'**
  String get issueReportSearchMyIssueReports;

  /// Filters and sorting bottom sheet title
  ///
  /// In en, this message translates to:
  /// **'Filters & Sorting'**
  String get issueReportFiltersAndSorting;

  /// Apply filters button label
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get issueReportApplyFilters;

  /// Filters applied state text
  ///
  /// In en, this message translates to:
  /// **'Filters Applied'**
  String get issueReportFiltersApplied;

  /// Filter and sort button label
  ///
  /// In en, this message translates to:
  /// **'Filter & Sort'**
  String get issueReportFilterAndSort;

  /// Empty state message for my issue reports
  ///
  /// In en, this message translates to:
  /// **'No issue reports found'**
  String get issueReportNoIssueReportsFoundEmpty;

  /// Empty state subtitle for my issue reports
  ///
  /// In en, this message translates to:
  /// **'You have no reported issues'**
  String get issueReportYouHaveNoReportedIssues;

  /// Create issue report floating action button tooltip
  ///
  /// In en, this message translates to:
  /// **'Create Issue Report'**
  String get issueReportCreateIssueReportTooltip;

  /// Validation error for required asset
  ///
  /// In en, this message translates to:
  /// **'Asset is required'**
  String get issueReportValidationAssetRequired;

  /// Validation error for required reported by
  ///
  /// In en, this message translates to:
  /// **'Reported by is required'**
  String get issueReportValidationReportedByRequired;

  /// Validation error for required issue type
  ///
  /// In en, this message translates to:
  /// **'Issue type is required'**
  String get issueReportValidationIssueTypeRequired;

  /// Validation error for issue type maximum length
  ///
  /// In en, this message translates to:
  /// **'Issue type must not exceed 100 characters'**
  String get issueReportValidationIssueTypeMaxLength;

  /// Validation error for required priority
  ///
  /// In en, this message translates to:
  /// **'Priority is required'**
  String get issueReportValidationPriorityRequired;

  /// Validation error for required status
  ///
  /// In en, this message translates to:
  /// **'Status is required'**
  String get issueReportValidationStatusRequired;

  /// Validation error for required title
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get issueReportValidationTitleRequired;

  /// Validation error for title maximum length
  ///
  /// In en, this message translates to:
  /// **'Title must not exceed 200 characters'**
  String get issueReportValidationTitleMaxLength;

  /// Validation error for description maximum length
  ///
  /// In en, this message translates to:
  /// **'Description must not exceed 1000 characters'**
  String get issueReportValidationDescriptionMaxLength;

  /// Validation error for resolution notes maximum length
  ///
  /// In en, this message translates to:
  /// **'Resolution notes must not exceed 1000 characters'**
  String get issueReportValidationResolutionNotesMaxLength;

  /// Dialog title for deleting a location
  ///
  /// In en, this message translates to:
  /// **'Delete Location'**
  String get locationDeleteLocation;

  /// Confirmation message for deleting a location
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{locationName}\"?'**
  String locationDeleteConfirmation(String locationName);

  /// Cancel button label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get locationCancel;

  /// Delete button label
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get locationDelete;

  /// Location detail screen title
  ///
  /// In en, this message translates to:
  /// **'Location Detail'**
  String get locationDetail;

  /// Location information section title
  ///
  /// In en, this message translates to:
  /// **'Location Information'**
  String get locationInformation;

  /// Location code label
  ///
  /// In en, this message translates to:
  /// **'Location Code'**
  String get locationCode;

  /// Location name label
  ///
  /// In en, this message translates to:
  /// **'Location Name'**
  String get locationName;

  /// Building label
  ///
  /// In en, this message translates to:
  /// **'Building'**
  String get locationBuilding;

  /// Floor label
  ///
  /// In en, this message translates to:
  /// **'Floor'**
  String get locationFloor;

  /// Latitude label
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get locationLatitude;

  /// Longitude label
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get locationLongitude;

  /// Metadata section title
  ///
  /// In en, this message translates to:
  /// **'Metadata'**
  String get locationMetadata;

  /// Created at label
  ///
  /// In en, this message translates to:
  /// **'Created At'**
  String get locationCreatedAt;

  /// Updated at label
  ///
  /// In en, this message translates to:
  /// **'Updated At'**
  String get locationUpdatedAt;

  /// Error message for non-admin trying to edit
  ///
  /// In en, this message translates to:
  /// **'Only admin can edit locations'**
  String get locationOnlyAdminCanEdit;

  /// Error message for non-admin trying to delete
  ///
  /// In en, this message translates to:
  /// **'Only admin can delete locations'**
  String get locationOnlyAdminCanDelete;

  /// Error message when location fails to load
  ///
  /// In en, this message translates to:
  /// **'Failed to load location'**
  String get locationFailedToLoad;

  /// Success message for location deletion
  ///
  /// In en, this message translates to:
  /// **'Location deleted'**
  String get locationDeleted;

  /// Error message for location deletion failure
  ///
  /// In en, this message translates to:
  /// **'Delete failed'**
  String get locationDeleteFailed;

  /// Edit location screen title
  ///
  /// In en, this message translates to:
  /// **'Edit Location'**
  String get locationEditLocation;

  /// Create location screen title
  ///
  /// In en, this message translates to:
  /// **'Create Location'**
  String get locationCreateLocation;

  /// Validation message for required fields
  ///
  /// In en, this message translates to:
  /// **'Please fill all required fields'**
  String get locationFillRequiredFields;

  /// Success message for location save
  ///
  /// In en, this message translates to:
  /// **'Location saved successfully'**
  String get locationSavedSuccessfully;

  /// Generic operation failure message
  ///
  /// In en, this message translates to:
  /// **'Operation failed'**
  String get locationOperationFailed;

  /// Error message for translation loading failure
  ///
  /// In en, this message translates to:
  /// **'Failed to load translations'**
  String get locationFailedToLoadTranslations;

  /// Location code input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter location code (e.g., LOC-001)'**
  String get locationEnterLocationCode;

  /// Building input label
  ///
  /// In en, this message translates to:
  /// **'Building (Optional)'**
  String get locationBuildingOptional;

  /// Building input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter building name'**
  String get locationEnterBuilding;

  /// Floor input label
  ///
  /// In en, this message translates to:
  /// **'Floor (Optional)'**
  String get locationFloorOptional;

  /// Floor input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter floor number'**
  String get locationEnterFloor;

  /// Latitude input label
  ///
  /// In en, this message translates to:
  /// **'Latitude (Optional)'**
  String get locationLatitudeOptional;

  /// Latitude input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter latitude'**
  String get locationEnterLatitude;

  /// Longitude input label
  ///
  /// In en, this message translates to:
  /// **'Longitude (Optional)'**
  String get locationLongitudeOptional;

  /// Longitude input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter longitude'**
  String get locationEnterLongitude;

  /// Getting location button text when loading
  ///
  /// In en, this message translates to:
  /// **'Getting Location...'**
  String get locationGettingLocation;

  /// Use current location button label
  ///
  /// In en, this message translates to:
  /// **'Use Current Location'**
  String get locationUseCurrentLocation;

  /// Warning message for disabled location services
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled'**
  String get locationServicesDisabled;

  /// Location services dialog title
  ///
  /// In en, this message translates to:
  /// **'Location Services Disabled'**
  String get locationServicesDialogTitle;

  /// Location services dialog message
  ///
  /// In en, this message translates to:
  /// **'Location services are required to get your current location. Would you like to enable them?'**
  String get locationServicesDialogMessage;

  /// Open settings button label
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get locationOpenSettings;

  /// Error message for denied permission
  ///
  /// In en, this message translates to:
  /// **'Location permission denied'**
  String get locationPermissionDenied;

  /// Error message for permanently denied permission
  ///
  /// In en, this message translates to:
  /// **'Location permission permanently denied'**
  String get locationPermissionPermanentlyDenied;

  /// Permission required dialog title
  ///
  /// In en, this message translates to:
  /// **'Permission Required'**
  String get locationPermissionRequired;

  /// Permission dialog message
  ///
  /// In en, this message translates to:
  /// **'Location permission is permanently denied. Please enable it in app settings.'**
  String get locationPermissionDialogMessage;

  /// Success message for getting current location
  ///
  /// In en, this message translates to:
  /// **'Current location retrieved successfully'**
  String get locationRetrievedSuccessfully;

  /// Error message for failed location retrieval
  ///
  /// In en, this message translates to:
  /// **'Failed to get current location'**
  String get locationFailedToGetCurrent;

  /// Translations section title
  ///
  /// In en, this message translates to:
  /// **'Translations'**
  String get locationTranslations;

  /// Translations section subtitle
  ///
  /// In en, this message translates to:
  /// **'Add translations for different languages'**
  String get locationTranslationsSubtitle;

  /// English language label
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get locationEnglish;

  /// Japanese language label
  ///
  /// In en, this message translates to:
  /// **'Japanese'**
  String get locationJapanese;

  /// Indonesian language label
  ///
  /// In en, this message translates to:
  /// **'Indonesian'**
  String get locationIndonesian;

  /// Location name input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter location name'**
  String get locationEnterLocationName;

  /// Update button label
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get locationUpdate;

  /// Create button label
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get locationCreate;

  /// Location management screen title
  ///
  /// In en, this message translates to:
  /// **'Location Management'**
  String get locationManagement;

  /// Create location option title
  ///
  /// In en, this message translates to:
  /// **'Create Location'**
  String get locationCreateLocationTitle;

  /// Create location option subtitle
  ///
  /// In en, this message translates to:
  /// **'Add a new location'**
  String get locationCreateLocationSubtitle;

  /// Select many option title
  ///
  /// In en, this message translates to:
  /// **'Select Many'**
  String get locationSelectManyTitle;

  /// Select many option subtitle
  ///
  /// In en, this message translates to:
  /// **'Select multiple locations to delete'**
  String get locationSelectManySubtitle;

  /// Filter and sort option title
  ///
  /// In en, this message translates to:
  /// **'Filter & Sort'**
  String get locationFilterAndSortTitle;

  /// Filter and sort option subtitle
  ///
  /// In en, this message translates to:
  /// **'Customize location display'**
  String get locationFilterAndSortSubtitle;

  /// Instruction for selecting locations to delete
  ///
  /// In en, this message translates to:
  /// **'Select locations to delete'**
  String get locationSelectLocationsToDelete;

  /// Sort by label
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get locationSortBy;

  /// Sort order label
  ///
  /// In en, this message translates to:
  /// **'Sort Order'**
  String get locationSortOrder;

  /// Reset button label
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get locationReset;

  /// Apply button label
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get locationApply;

  /// Filter reset success message
  ///
  /// In en, this message translates to:
  /// **'Filter reset'**
  String get locationFilterReset;

  /// Filter applied success message
  ///
  /// In en, this message translates to:
  /// **'Filter applied'**
  String get locationFilterApplied;

  /// Delete locations dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Locations'**
  String get locationDeleteLocations;

  /// Confirmation message for deleting multiple locations
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {count} locations?'**
  String locationDeleteMultipleConfirmation(int count);

  /// Warning message when no locations are selected
  ///
  /// In en, this message translates to:
  /// **'No locations selected'**
  String get locationNoLocationsSelected;

  /// Placeholder message for unimplemented features
  ///
  /// In en, this message translates to:
  /// **'Not implemented yet'**
  String get locationNotImplementedYet;

  /// Selected count display
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String locationSelectedCount(int count);

  /// Locations search placeholder
  ///
  /// In en, this message translates to:
  /// **'Search locations...'**
  String get locationSearchLocations;

  /// No locations found message
  ///
  /// In en, this message translates to:
  /// **'No locations found'**
  String get locationNoLocationsFound;

  /// Empty state message for locations
  ///
  /// In en, this message translates to:
  /// **'Create your first location to get started'**
  String get locationCreateFirstLocation;

  /// Instruction for selecting multiple locations
  ///
  /// In en, this message translates to:
  /// **'Long press to select more locations'**
  String get locationLongPressToSelect;

  /// Floor prefix display
  ///
  /// In en, this message translates to:
  /// **'Floor {floor}'**
  String locationFloorPrefix(String floor);

  /// Validation error for required location code
  ///
  /// In en, this message translates to:
  /// **'Location code is required'**
  String get locationValidationCodeRequired;

  /// Validation error for location code minimum length
  ///
  /// In en, this message translates to:
  /// **'Location code must be at least 2 characters'**
  String get locationValidationCodeMinLength;

  /// Validation error for location code maximum length
  ///
  /// In en, this message translates to:
  /// **'Location code must not exceed 20 characters'**
  String get locationValidationCodeMaxLength;

  /// Validation error for location code format
  ///
  /// In en, this message translates to:
  /// **'Location code can only contain letters, numbers, and dashes'**
  String get locationValidationCodeAlphanumeric;

  /// Validation error for required location name
  ///
  /// In en, this message translates to:
  /// **'Location name is required'**
  String get locationValidationNameRequired;

  /// Validation error for location name minimum length
  ///
  /// In en, this message translates to:
  /// **'Location name must be at least 3 characters'**
  String get locationValidationNameMinLength;

  /// Validation error for location name maximum length
  ///
  /// In en, this message translates to:
  /// **'Location name must not exceed 100 characters'**
  String get locationValidationNameMaxLength;

  /// Validation error for building maximum length
  ///
  /// In en, this message translates to:
  /// **'Building must not exceed 50 characters'**
  String get locationValidationBuildingMaxLength;

  /// Validation error for floor maximum length
  ///
  /// In en, this message translates to:
  /// **'Floor must not exceed 20 characters'**
  String get locationValidationFloorMaxLength;

  /// Validation error for invalid latitude
  ///
  /// In en, this message translates to:
  /// **'Latitude must be a valid number'**
  String get locationValidationLatitudeInvalid;

  /// Validation error for latitude range
  ///
  /// In en, this message translates to:
  /// **'Latitude must be between -90 and 90'**
  String get locationValidationLatitudeRange;

  /// Validation error for invalid longitude
  ///
  /// In en, this message translates to:
  /// **'Longitude must be a valid number'**
  String get locationValidationLongitudeInvalid;

  /// Validation error for longitude range
  ///
  /// In en, this message translates to:
  /// **'Longitude must be between -180 and 180'**
  String get locationValidationLongitudeRange;

  /// Error message when location search returns no results
  ///
  /// In en, this message translates to:
  /// **'Location not found'**
  String get locationNotFound;

  /// Error message when location search fails
  ///
  /// In en, this message translates to:
  /// **'Search failed'**
  String get locationSearchFailed;

  /// Button text to confirm selected location on map
  ///
  /// In en, this message translates to:
  /// **'Confirm Location'**
  String get locationConfirmLocation;

  /// Success message when location is selected from map picker
  ///
  /// In en, this message translates to:
  /// **'Location selected from map'**
  String get locationSelectedFromMap;

  /// Search input placeholder for location
  ///
  /// In en, this message translates to:
  /// **'Search location...'**
  String get locationSearchLocation;

  /// Button text to pick location from map
  ///
  /// In en, this message translates to:
  /// **'Pick from map'**
  String get locationPickFromMap;

  /// Dialog title for deleting a maintenance schedule
  ///
  /// In en, this message translates to:
  /// **'Delete Maintenance Schedule'**
  String get maintenanceScheduleDeleteSchedule;

  /// Confirmation message for deleting a maintenance schedule
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{title}\"?'**
  String maintenanceScheduleDeleteConfirmation(String title);

  /// Success message for schedule deletion
  ///
  /// In en, this message translates to:
  /// **'Maintenance schedule deleted'**
  String get maintenanceScheduleDeleted;

  /// Error message for schedule deletion failure
  ///
  /// In en, this message translates to:
  /// **'Delete failed'**
  String get maintenanceScheduleDeleteFailed;

  /// Schedule detail screen title
  ///
  /// In en, this message translates to:
  /// **'Maintenance Schedule Detail'**
  String get maintenanceScheduleDetail;

  /// Schedule information section title
  ///
  /// In en, this message translates to:
  /// **'Maintenance Schedule Information'**
  String get maintenanceScheduleInformation;

  /// Title label
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get maintenanceScheduleTitle;

  /// Description label
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get maintenanceScheduleDescription;

  /// Asset label
  ///
  /// In en, this message translates to:
  /// **'Asset'**
  String get maintenanceScheduleAsset;

  /// Maintenance type label
  ///
  /// In en, this message translates to:
  /// **'Maintenance Type'**
  String get maintenanceScheduleMaintenanceType;

  /// Is recurring label
  ///
  /// In en, this message translates to:
  /// **'Is Recurring'**
  String get maintenanceScheduleIsRecurring;

  /// Interval label
  ///
  /// In en, this message translates to:
  /// **'Interval'**
  String get maintenanceScheduleInterval;

  /// Scheduled time label
  ///
  /// In en, this message translates to:
  /// **'Scheduled Time'**
  String get maintenanceScheduleScheduledTime;

  /// Next scheduled date label
  ///
  /// In en, this message translates to:
  /// **'Next Scheduled Date'**
  String get maintenanceScheduleNextScheduledDate;

  /// Last executed date label
  ///
  /// In en, this message translates to:
  /// **'Last Executed Date'**
  String get maintenanceScheduleLastExecutedDate;

  /// State label
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get maintenanceScheduleState;

  /// Auto complete label
  ///
  /// In en, this message translates to:
  /// **'Auto Complete'**
  String get maintenanceScheduleAutoComplete;

  /// Estimated cost label
  ///
  /// In en, this message translates to:
  /// **'Estimated Cost'**
  String get maintenanceScheduleEstimatedCost;

  /// Created by label
  ///
  /// In en, this message translates to:
  /// **'Created By'**
  String get maintenanceScheduleCreatedBy;

  /// Yes value
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get maintenanceScheduleYes;

  /// No value
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get maintenanceScheduleNo;

  /// Unknown asset text
  ///
  /// In en, this message translates to:
  /// **'Unknown Asset'**
  String get maintenanceScheduleUnknownAsset;

  /// Unknown user text
  ///
  /// In en, this message translates to:
  /// **'Unknown User'**
  String get maintenanceScheduleUnknownUser;

  /// Error message for non-admin trying to edit
  ///
  /// In en, this message translates to:
  /// **'Only admin can edit maintenance schedules'**
  String get maintenanceScheduleOnlyAdminCanEdit;

  /// Error message for non-admin trying to delete
  ///
  /// In en, this message translates to:
  /// **'Only admin can delete maintenance schedules'**
  String get maintenanceScheduleOnlyAdminCanDelete;

  /// Error message when schedule fails to load
  ///
  /// In en, this message translates to:
  /// **'Failed to load maintenance schedule'**
  String get maintenanceScheduleFailedToLoad;

  /// Edit schedule screen title
  ///
  /// In en, this message translates to:
  /// **'Edit Maintenance Schedule'**
  String get maintenanceScheduleEditSchedule;

  /// Create schedule screen title
  ///
  /// In en, this message translates to:
  /// **'Create Maintenance Schedule'**
  String get maintenanceScheduleCreateSchedule;

  /// Validation message for required fields
  ///
  /// In en, this message translates to:
  /// **'Please fill all required fields'**
  String get maintenanceScheduleFillRequiredFields;

  /// Success message for schedule save
  ///
  /// In en, this message translates to:
  /// **'Maintenance schedule saved successfully'**
  String get maintenanceScheduleSavedSuccessfully;

  /// Generic operation failure message
  ///
  /// In en, this message translates to:
  /// **'Operation failed'**
  String get maintenanceScheduleOperationFailed;

  /// Error message for translation loading failure
  ///
  /// In en, this message translates to:
  /// **'Failed to load translations'**
  String get maintenanceScheduleFailedToLoadTranslations;

  /// Asset search placeholder
  ///
  /// In en, this message translates to:
  /// **'Search and select asset'**
  String get maintenanceScheduleSearchAsset;

  /// Maintenance type dropdown placeholder
  ///
  /// In en, this message translates to:
  /// **'Select maintenance type'**
  String get maintenanceScheduleSelectMaintenanceType;

  /// Interval value input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter interval value (e.g., 3)'**
  String get maintenanceScheduleEnterIntervalValue;

  /// Interval unit dropdown placeholder
  ///
  /// In en, this message translates to:
  /// **'Select interval unit'**
  String get maintenanceScheduleSelectIntervalUnit;

  /// Scheduled time input placeholder
  ///
  /// In en, this message translates to:
  /// **'e.g., 09:30'**
  String get maintenanceScheduleEnterScheduledTime;

  /// State dropdown placeholder
  ///
  /// In en, this message translates to:
  /// **'Select state'**
  String get maintenanceScheduleSelectState;

  /// Estimated cost input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter estimated cost (optional)'**
  String get maintenanceScheduleEnterEstimatedCost;

  /// User search placeholder
  ///
  /// In en, this message translates to:
  /// **'Search and select user who created the schedule'**
  String get maintenanceScheduleSearchUser;

  /// Translations section title
  ///
  /// In en, this message translates to:
  /// **'Translations'**
  String get maintenanceScheduleTranslations;

  /// English language label
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get maintenanceScheduleEnglish;

  /// Japanese language label
  ///
  /// In en, this message translates to:
  /// **'Japanese'**
  String get maintenanceScheduleJapanese;

  /// Indonesian language label
  ///
  /// In en, this message translates to:
  /// **'Indonesian'**
  String get maintenanceScheduleIndonesian;

  /// Title input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter title in {language}'**
  String maintenanceScheduleEnterTitle(String language);

  /// Description input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter description in {language}'**
  String maintenanceScheduleEnterDescription(String language);

  /// Cancel button label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get maintenanceScheduleCancel;

  /// Update button label
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get maintenanceScheduleUpdate;

  /// Create button label
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get maintenanceScheduleCreate;

  /// Schedule management screen title
  ///
  /// In en, this message translates to:
  /// **'Maintenance Schedule Management'**
  String get maintenanceScheduleManagement;

  /// Create schedule option title
  ///
  /// In en, this message translates to:
  /// **'Create Maintenance Schedule'**
  String get maintenanceScheduleCreateTitle;

  /// Create schedule option subtitle
  ///
  /// In en, this message translates to:
  /// **'Add a new maintenance schedule'**
  String get maintenanceScheduleCreateSubtitle;

  /// Select many option title
  ///
  /// In en, this message translates to:
  /// **'Select Many'**
  String get maintenanceScheduleSelectManyTitle;

  /// Select many option subtitle
  ///
  /// In en, this message translates to:
  /// **'Select multiple schedules to delete'**
  String get maintenanceScheduleSelectManySubtitle;

  /// Filter and sort option title
  ///
  /// In en, this message translates to:
  /// **'Filter & Sort'**
  String get maintenanceScheduleFilterAndSortTitle;

  /// Filter and sort option subtitle
  ///
  /// In en, this message translates to:
  /// **'Customize schedule display'**
  String get maintenanceScheduleFilterAndSortSubtitle;

  /// Instruction for selecting schedules to delete
  ///
  /// In en, this message translates to:
  /// **'Select maintenance schedules to delete'**
  String get maintenanceScheduleSelectToDelete;

  /// Sort by label
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get maintenanceScheduleSortBy;

  /// Sort order label
  ///
  /// In en, this message translates to:
  /// **'Sort Order'**
  String get maintenanceScheduleSortOrder;

  /// Reset button label
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get maintenanceScheduleReset;

  /// Apply button label
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get maintenanceScheduleApply;

  /// Filter reset success message
  ///
  /// In en, this message translates to:
  /// **'Filter reset'**
  String get maintenanceScheduleFilterReset;

  /// Filter applied success message
  ///
  /// In en, this message translates to:
  /// **'Filter applied'**
  String get maintenanceScheduleFilterApplied;

  /// Delete schedules dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Schedules'**
  String get maintenanceScheduleDeleteSchedules;

  /// Confirmation message for deleting multiple schedules
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {count} schedules?'**
  String maintenanceScheduleDeleteMultipleConfirmation(int count);

  /// Warning message when no schedules are selected
  ///
  /// In en, this message translates to:
  /// **'No schedules selected'**
  String get maintenanceScheduleNoSchedulesSelected;

  /// Placeholder message for unimplemented features
  ///
  /// In en, this message translates to:
  /// **'Not implemented yet'**
  String get maintenanceScheduleNotImplementedYet;

  /// Selected count display
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String maintenanceScheduleSelectedCount(int count);

  /// Delete button label
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get maintenanceScheduleDelete;

  /// Schedules search placeholder
  ///
  /// In en, this message translates to:
  /// **'Search schedules...'**
  String get maintenanceScheduleSearch;

  /// No schedules found message
  ///
  /// In en, this message translates to:
  /// **'No schedules found'**
  String get maintenanceScheduleNoSchedulesFound;

  /// Empty state message for schedules
  ///
  /// In en, this message translates to:
  /// **'Create your first schedule to get started'**
  String get maintenanceScheduleCreateFirstSchedule;

  /// Instruction for selecting multiple schedules
  ///
  /// In en, this message translates to:
  /// **'Long press to select more schedules'**
  String get maintenanceScheduleLongPressToSelect;

  /// Metadata section title
  ///
  /// In en, this message translates to:
  /// **'Metadata'**
  String get maintenanceScheduleMetadata;

  /// Created at label
  ///
  /// In en, this message translates to:
  /// **'Created At'**
  String get maintenanceScheduleCreatedAt;

  /// Updated at label
  ///
  /// In en, this message translates to:
  /// **'Updated At'**
  String get maintenanceScheduleUpdatedAt;

  /// Interval value field label
  ///
  /// In en, this message translates to:
  /// **'Interval Value'**
  String get maintenanceScheduleIntervalValueLabel;

  /// Interval unit field label
  ///
  /// In en, this message translates to:
  /// **'Interval Unit'**
  String get maintenanceScheduleIntervalUnitLabel;

  /// Scheduled time field label
  ///
  /// In en, this message translates to:
  /// **'Scheduled Time (HH:mm)'**
  String get maintenanceScheduleScheduledTimeLabel;

  /// Dialog title for deleting a maintenance record
  ///
  /// In en, this message translates to:
  /// **'Delete Maintenance Record'**
  String get maintenanceRecordDeleteRecord;

  /// Confirmation message for deleting a maintenance record
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{title}\"?'**
  String maintenanceRecordDeleteConfirmation(String title);

  /// Success message for record deletion
  ///
  /// In en, this message translates to:
  /// **'Maintenance record deleted'**
  String get maintenanceRecordDeleted;

  /// Error message for record deletion failure
  ///
  /// In en, this message translates to:
  /// **'Delete failed'**
  String get maintenanceRecordDeleteFailed;

  /// Record detail screen title
  ///
  /// In en, this message translates to:
  /// **'Maintenance Record Detail'**
  String get maintenanceRecordDetail;

  /// Record information section title
  ///
  /// In en, this message translates to:
  /// **'Maintenance Record Information'**
  String get maintenanceRecordInformation;

  /// Title label
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get maintenanceRecordTitle;

  /// Notes label
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get maintenanceRecordNotes;

  /// Asset label
  ///
  /// In en, this message translates to:
  /// **'Asset'**
  String get maintenanceRecordAsset;

  /// Maintenance date label
  ///
  /// In en, this message translates to:
  /// **'Maintenance Date'**
  String get maintenanceRecordMaintenanceDate;

  /// Completion date label
  ///
  /// In en, this message translates to:
  /// **'Completion Date'**
  String get maintenanceRecordCompletionDate;

  /// Duration label
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get maintenanceRecordDuration;

  /// Duration in minutes format
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes'**
  String maintenanceRecordDurationMinutes(int minutes);

  /// Performed by user label
  ///
  /// In en, this message translates to:
  /// **'Performed By User'**
  String get maintenanceRecordPerformedByUser;

  /// Performed by vendor label
  ///
  /// In en, this message translates to:
  /// **'Performed By Vendor'**
  String get maintenanceRecordPerformedByVendor;

  /// Result label
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get maintenanceRecordResult;

  /// Actual cost label
  ///
  /// In en, this message translates to:
  /// **'Actual Cost'**
  String get maintenanceRecordActualCost;

  /// Actual cost value format
  ///
  /// In en, this message translates to:
  /// **'\${cost}'**
  String maintenanceRecordActualCostValue(String cost);

  /// Unknown asset text
  ///
  /// In en, this message translates to:
  /// **'Unknown Asset'**
  String get maintenanceRecordUnknownAsset;

  /// Error message for non-admin trying to edit
  ///
  /// In en, this message translates to:
  /// **'Only admin can edit maintenance records'**
  String get maintenanceRecordOnlyAdminCanEdit;

  /// Error message for non-admin trying to delete
  ///
  /// In en, this message translates to:
  /// **'Only admin can delete maintenance records'**
  String get maintenanceRecordOnlyAdminCanDelete;

  /// Error message when record fails to load
  ///
  /// In en, this message translates to:
  /// **'Failed to load maintenance record'**
  String get maintenanceRecordFailedToLoad;

  /// Edit record screen title
  ///
  /// In en, this message translates to:
  /// **'Edit Maintenance Record'**
  String get maintenanceRecordEditRecord;

  /// Create record screen title
  ///
  /// In en, this message translates to:
  /// **'Create Maintenance Record'**
  String get maintenanceRecordCreateRecord;

  /// Validation message for required fields
  ///
  /// In en, this message translates to:
  /// **'Please fill all required fields'**
  String get maintenanceRecordFillRequiredFields;

  /// Success message for record save
  ///
  /// In en, this message translates to:
  /// **'Maintenance record saved successfully'**
  String get maintenanceRecordSavedSuccessfully;

  /// Generic operation failure message
  ///
  /// In en, this message translates to:
  /// **'Operation failed'**
  String get maintenanceRecordOperationFailed;

  /// Error message for translation loading failure
  ///
  /// In en, this message translates to:
  /// **'Failed to load translations'**
  String get maintenanceRecordFailedToLoadTranslations;

  /// Schedule search placeholder
  ///
  /// In en, this message translates to:
  /// **'Search and select maintenance schedule'**
  String get maintenanceRecordSearchSchedule;

  /// Asset search placeholder
  ///
  /// In en, this message translates to:
  /// **'Search and select asset'**
  String get maintenanceRecordSearchAsset;

  /// Completion date field label
  ///
  /// In en, this message translates to:
  /// **'Completion Date (Optional)'**
  String get maintenanceRecordCompletionDateOptional;

  /// Duration field label
  ///
  /// In en, this message translates to:
  /// **'Duration (Minutes)'**
  String get maintenanceRecordDurationMinutesLabel;

  /// Duration input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter duration in minutes (optional)'**
  String get maintenanceRecordEnterDuration;

  /// User search placeholder
  ///
  /// In en, this message translates to:
  /// **'Search and select user who performed the maintenance'**
  String get maintenanceRecordSearchPerformedByUser;

  /// Vendor field label
  ///
  /// In en, this message translates to:
  /// **'Performed By Vendor'**
  String get maintenanceRecordPerformedByVendorLabel;

  /// Vendor input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter vendor name (optional)'**
  String get maintenanceRecordEnterVendor;

  /// Result dropdown placeholder
  ///
  /// In en, this message translates to:
  /// **'Select maintenance result'**
  String get maintenanceRecordSelectResult;

  /// Actual cost field label
  ///
  /// In en, this message translates to:
  /// **'Actual Cost'**
  String get maintenanceRecordActualCostLabel;

  /// Actual cost input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter actual cost (optional)'**
  String get maintenanceRecordEnterActualCost;

  /// Translations section title
  ///
  /// In en, this message translates to:
  /// **'Translations'**
  String get maintenanceRecordTranslations;

  /// English language label
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get maintenanceRecordEnglish;

  /// Japanese language label
  ///
  /// In en, this message translates to:
  /// **'Japanese'**
  String get maintenanceRecordJapanese;

  /// Indonesian language label
  ///
  /// In en, this message translates to:
  /// **'Indonesian'**
  String get maintenanceRecordIndonesian;

  /// Title input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter title in {language}'**
  String maintenanceRecordEnterTitle(String language);

  /// Notes input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter notes in {language}'**
  String maintenanceRecordEnterNotes(String language);

  /// Cancel button label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get maintenanceRecordCancel;

  /// Update button label
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get maintenanceRecordUpdate;

  /// Create button label
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get maintenanceRecordCreate;

  /// Record management screen title
  ///
  /// In en, this message translates to:
  /// **'Maintenance Record Management'**
  String get maintenanceRecordManagement;

  /// Create record option title
  ///
  /// In en, this message translates to:
  /// **'Create Maintenance Record'**
  String get maintenanceRecordCreateTitle;

  /// Create record option subtitle
  ///
  /// In en, this message translates to:
  /// **'Add a new maintenance record'**
  String get maintenanceRecordCreateSubtitle;

  /// Select many option title
  ///
  /// In en, this message translates to:
  /// **'Select Many'**
  String get maintenanceRecordSelectManyTitle;

  /// Select many option subtitle
  ///
  /// In en, this message translates to:
  /// **'Select multiple records to delete'**
  String get maintenanceRecordSelectManySubtitle;

  /// Filter and sort option title
  ///
  /// In en, this message translates to:
  /// **'Filter & Sort'**
  String get maintenanceRecordFilterAndSortTitle;

  /// Filter and sort option subtitle
  ///
  /// In en, this message translates to:
  /// **'Customize record display'**
  String get maintenanceRecordFilterAndSortSubtitle;

  /// Instruction for selecting records to delete
  ///
  /// In en, this message translates to:
  /// **'Select maintenance records to delete'**
  String get maintenanceRecordSelectToDelete;

  /// Sort by label
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get maintenanceRecordSortBy;

  /// Sort order label
  ///
  /// In en, this message translates to:
  /// **'Sort Order'**
  String get maintenanceRecordSortOrder;

  /// Reset button label
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get maintenanceRecordReset;

  /// Apply button label
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get maintenanceRecordApply;

  /// Filter reset success message
  ///
  /// In en, this message translates to:
  /// **'Filter reset'**
  String get maintenanceRecordFilterReset;

  /// Filter applied success message
  ///
  /// In en, this message translates to:
  /// **'Filter applied'**
  String get maintenanceRecordFilterApplied;

  /// Delete records dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Records'**
  String get maintenanceRecordDeleteRecords;

  /// Confirmation message for deleting multiple records
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {count} records?'**
  String maintenanceRecordDeleteMultipleConfirmation(int count);

  /// Warning message when no records are selected
  ///
  /// In en, this message translates to:
  /// **'No records selected'**
  String get maintenanceRecordNoRecordsSelected;

  /// Placeholder message for unimplemented features
  ///
  /// In en, this message translates to:
  /// **'Not implemented yet'**
  String get maintenanceRecordNotImplementedYet;

  /// Selected count display
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String maintenanceRecordSelectedCount(int count);

  /// Delete button label
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get maintenanceRecordDelete;

  /// Records search placeholder
  ///
  /// In en, this message translates to:
  /// **'Search records...'**
  String get maintenanceRecordSearch;

  /// No records found message
  ///
  /// In en, this message translates to:
  /// **'No records found'**
  String get maintenanceRecordNoRecordsFound;

  /// Empty state message for records
  ///
  /// In en, this message translates to:
  /// **'Create your first record to get started'**
  String get maintenanceRecordCreateFirstRecord;

  /// Instruction for selecting multiple records
  ///
  /// In en, this message translates to:
  /// **'Long press to select more records'**
  String get maintenanceRecordLongPressToSelect;

  /// Metadata section title
  ///
  /// In en, this message translates to:
  /// **'Metadata'**
  String get maintenanceRecordMetadata;

  /// Created at label
  ///
  /// In en, this message translates to:
  /// **'Created At'**
  String get maintenanceRecordCreatedAt;

  /// Updated at label
  ///
  /// In en, this message translates to:
  /// **'Updated At'**
  String get maintenanceRecordUpdatedAt;

  /// Schedule label
  ///
  /// In en, this message translates to:
  /// **'Maintenance Schedule'**
  String get maintenanceRecordSchedule;

  /// Notification management screen title
  ///
  /// In en, this message translates to:
  /// **'Notification Management'**
  String get notificationManagement;

  /// Notification detail screen title
  ///
  /// In en, this message translates to:
  /// **'Notification Detail'**
  String get notificationDetail;

  /// My notifications screen title
  ///
  /// In en, this message translates to:
  /// **'My Notifications'**
  String get notificationMyNotifications;

  /// Dialog title for deleting a notification
  ///
  /// In en, this message translates to:
  /// **'Delete Notification'**
  String get notificationDeleteNotification;

  /// Confirmation message for deleting a notification
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this notification?'**
  String get notificationDeleteConfirmation;

  /// Confirmation message for deleting multiple notifications
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {count} notifications?'**
  String notificationDeleteMultipleConfirmation(int count);

  /// Cancel button label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get notificationCancel;

  /// Delete button label
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get notificationDelete;

  /// Error message for non-admin trying to delete
  ///
  /// In en, this message translates to:
  /// **'Only admin can delete notifications'**
  String get notificationOnlyAdminCanDelete;

  /// Success message for notification deletion
  ///
  /// In en, this message translates to:
  /// **'Notification deleted'**
  String get notificationDeleted;

  /// Error message for notification deletion failure
  ///
  /// In en, this message translates to:
  /// **'Delete failed'**
  String get notificationDeleteFailed;

  /// Error message when notification fails to load
  ///
  /// In en, this message translates to:
  /// **'Failed to load notification'**
  String get notificationFailedToLoad;

  /// Notification information section title
  ///
  /// In en, this message translates to:
  /// **'Notification Information'**
  String get notificationInformation;

  /// Title label
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get notificationTitle;

  /// Message label
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get notificationMessage;

  /// Type label
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get notificationType;

  /// Priority label
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get notificationPriority;

  /// Is read label
  ///
  /// In en, this message translates to:
  /// **'Is Read'**
  String get notificationIsRead;

  /// Read status label
  ///
  /// In en, this message translates to:
  /// **'Read Status'**
  String get notificationReadStatus;

  /// Read status value
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get notificationRead;

  /// Unread status value
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get notificationUnread;

  /// Yes label
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get notificationYes;

  /// No label
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get notificationNo;

  /// Created at label
  ///
  /// In en, this message translates to:
  /// **'Created At'**
  String get notificationCreatedAt;

  /// Expires at label
  ///
  /// In en, this message translates to:
  /// **'Expires At'**
  String get notificationExpiresAt;

  /// Notifications search placeholder
  ///
  /// In en, this message translates to:
  /// **'Search notifications...'**
  String get notificationSearchNotifications;

  /// My notifications search placeholder
  ///
  /// In en, this message translates to:
  /// **'Search my notifications...'**
  String get notificationSearchMyNotifications;

  /// No notifications found message
  ///
  /// In en, this message translates to:
  /// **'No notifications found'**
  String get notificationNoNotificationsFound;

  /// Empty state message for user notifications
  ///
  /// In en, this message translates to:
  /// **'You have no notifications'**
  String get notificationNoNotificationsYet;

  /// Empty state message for notifications
  ///
  /// In en, this message translates to:
  /// **'Create your first notification to get started'**
  String get notificationCreateFirstNotification;

  /// Create notification option title
  ///
  /// In en, this message translates to:
  /// **'Create Notification'**
  String get notificationCreateNotification;

  /// Create notification option subtitle
  ///
  /// In en, this message translates to:
  /// **'Add a new notification'**
  String get notificationCreateNotificationSubtitle;

  /// Select many option title
  ///
  /// In en, this message translates to:
  /// **'Select Many'**
  String get notificationSelectMany;

  /// Select many option subtitle
  ///
  /// In en, this message translates to:
  /// **'Select multiple notifications to delete'**
  String get notificationSelectManySubtitle;

  /// Filter and sort option title
  ///
  /// In en, this message translates to:
  /// **'Filter & Sort'**
  String get notificationFilterAndSort;

  /// Filter and sort option subtitle
  ///
  /// In en, this message translates to:
  /// **'Customize notification display'**
  String get notificationFilterAndSortSubtitle;

  /// Filters and sorting bottom sheet title
  ///
  /// In en, this message translates to:
  /// **'Filters & Sorting'**
  String get notificationFiltersAndSorting;

  /// Instruction for selecting notifications to delete
  ///
  /// In en, this message translates to:
  /// **'Select notifications to delete'**
  String get notificationSelectNotificationsToDelete;

  /// Instruction for selecting multiple notifications
  ///
  /// In en, this message translates to:
  /// **'Long press to select more notifications'**
  String get notificationLongPressToSelect;

  /// Selected count display
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String notificationSelectedCount(int count);

  /// Warning message when no notifications are selected
  ///
  /// In en, this message translates to:
  /// **'No notifications selected'**
  String get notificationNoNotificationsSelected;

  /// Filter by user label
  ///
  /// In en, this message translates to:
  /// **'Filter by User'**
  String get notificationFilterByUser;

  /// Filter by related asset label
  ///
  /// In en, this message translates to:
  /// **'Filter by Related Asset'**
  String get notificationFilterByRelatedAsset;

  /// User search placeholder
  ///
  /// In en, this message translates to:
  /// **'Search user...'**
  String get notificationSearchUser;

  /// Asset search placeholder
  ///
  /// In en, this message translates to:
  /// **'Search asset...'**
  String get notificationSearchAsset;

  /// Sort by label
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get notificationSortBy;

  /// Sort order label
  ///
  /// In en, this message translates to:
  /// **'Sort Order'**
  String get notificationSortOrder;

  /// Reset button label
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get notificationReset;

  /// Apply button label
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get notificationApply;

  /// Apply filters button label
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get notificationApplyFilters;

  /// Filter reset success message
  ///
  /// In en, this message translates to:
  /// **'Filter reset'**
  String get notificationFilterReset;

  /// Filter applied success message
  ///
  /// In en, this message translates to:
  /// **'Filter applied'**
  String get notificationFilterApplied;

  /// Filters applied state text
  ///
  /// In en, this message translates to:
  /// **'Filters Applied'**
  String get notificationFiltersApplied;

  /// Placeholder message for unimplemented features
  ///
  /// In en, this message translates to:
  /// **'Not implemented yet'**
  String get notificationNotImplementedYet;

  /// Time ago for just now
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get notificationJustNow;

  /// Time ago in minutes
  ///
  /// In en, this message translates to:
  /// **'{minutes}m ago'**
  String notificationMinutesAgo(int minutes);

  /// Time ago in hours
  ///
  /// In en, this message translates to:
  /// **'{hours}h ago'**
  String notificationHoursAgo(int hours);

  /// Time ago in days
  ///
  /// In en, this message translates to:
  /// **'{days}d ago'**
  String notificationDaysAgo(int days);

  /// Mark as read option
  ///
  /// In en, this message translates to:
  /// **'Mark as Read'**
  String get notificationMarkAsRead;

  /// Mark as unread option
  ///
  /// In en, this message translates to:
  /// **'Mark as Unread'**
  String get notificationMarkAsUnread;

  /// Success message for marking notifications as read
  ///
  /// In en, this message translates to:
  /// **'{count} marked as read'**
  String notificationMarkedAsRead(int count);

  /// Success message for marking notifications as unread
  ///
  /// In en, this message translates to:
  /// **'{count} marked as unread'**
  String notificationMarkedAsUnread(int count);

  /// Scan log management screen title
  ///
  /// In en, this message translates to:
  /// **'Scan Log Management'**
  String get scanLogManagement;

  /// Scan log detail screen title
  ///
  /// In en, this message translates to:
  /// **'Scan Log Detail'**
  String get scanLogDetail;

  /// Dialog title for deleting a scan log
  ///
  /// In en, this message translates to:
  /// **'Delete Scan Log'**
  String get scanLogDeleteScanLog;

  /// Confirmation message for deleting a scan log
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this scan log?'**
  String get scanLogDeleteConfirmation;

  /// Confirmation message for deleting multiple scan logs
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {count} scan logs?'**
  String scanLogDeleteMultipleConfirmation(int count);

  /// Cancel button label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get scanLogCancel;

  /// Delete button label
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get scanLogDelete;

  /// Error message for non-admin trying to delete
  ///
  /// In en, this message translates to:
  /// **'Only admin can delete scan logs'**
  String get scanLogOnlyAdminCanDelete;

  /// Success message for scan log deletion
  ///
  /// In en, this message translates to:
  /// **'Scan log deleted'**
  String get scanLogDeleted;

  /// Error message for scan log deletion failure
  ///
  /// In en, this message translates to:
  /// **'Delete failed'**
  String get scanLogDeleteFailed;

  /// Error message when scan log fails to load
  ///
  /// In en, this message translates to:
  /// **'Failed to load scan log'**
  String get scanLogFailedToLoad;

  /// Scan information section title
  ///
  /// In en, this message translates to:
  /// **'Scan Information'**
  String get scanLogInformation;

  /// Scanned value label
  ///
  /// In en, this message translates to:
  /// **'Scanned Value'**
  String get scanLogScannedValue;

  /// Scan method label
  ///
  /// In en, this message translates to:
  /// **'Scan Method'**
  String get scanLogScanMethod;

  /// Scan result label
  ///
  /// In en, this message translates to:
  /// **'Scan Result'**
  String get scanLogScanResult;

  /// Scan timestamp label
  ///
  /// In en, this message translates to:
  /// **'Scan Timestamp'**
  String get scanLogScanTimestamp;

  /// Location label
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get scanLogLocation;

  /// Scan logs search placeholder
  ///
  /// In en, this message translates to:
  /// **'Search scan logs...'**
  String get scanLogSearchScanLogs;

  /// No scan logs found message
  ///
  /// In en, this message translates to:
  /// **'No scan logs found'**
  String get scanLogNoScanLogsFound;

  /// Empty state message for scan logs
  ///
  /// In en, this message translates to:
  /// **'Create your first scan log to get started'**
  String get scanLogCreateFirstScanLog;

  /// Create scan log option title
  ///
  /// In en, this message translates to:
  /// **'Create Scan Log'**
  String get scanLogCreateScanLog;

  /// Create scan log option subtitle
  ///
  /// In en, this message translates to:
  /// **'Add a new scan log'**
  String get scanLogCreateScanLogSubtitle;

  /// Select many option title
  ///
  /// In en, this message translates to:
  /// **'Select Many'**
  String get scanLogSelectMany;

  /// Select many option subtitle
  ///
  /// In en, this message translates to:
  /// **'Select multiple scan logs to delete'**
  String get scanLogSelectManySubtitle;

  /// Filter and sort option title
  ///
  /// In en, this message translates to:
  /// **'Filter & Sort'**
  String get scanLogFilterAndSort;

  /// Filter and sort option subtitle
  ///
  /// In en, this message translates to:
  /// **'Customize scan log display'**
  String get scanLogFilterAndSortSubtitle;

  /// Filters and sorting bottom sheet title
  ///
  /// In en, this message translates to:
  /// **'Filters & Sorting'**
  String get scanLogFiltersAndSorting;

  /// Instruction for selecting scan logs to delete
  ///
  /// In en, this message translates to:
  /// **'Select scan logs to delete'**
  String get scanLogSelectScanLogsToDelete;

  /// Instruction for selecting multiple scan logs
  ///
  /// In en, this message translates to:
  /// **'Long press to select more scan logs'**
  String get scanLogLongPressToSelect;

  /// Selected count display
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String scanLogSelectedCount(int count);

  /// Warning message when no scan logs are selected
  ///
  /// In en, this message translates to:
  /// **'No scan logs selected'**
  String get scanLogNoScanLogsSelected;

  /// Filter by asset label
  ///
  /// In en, this message translates to:
  /// **'Filter by Asset'**
  String get scanLogFilterByAsset;

  /// Filter by scanned by label
  ///
  /// In en, this message translates to:
  /// **'Filter by Scanned By'**
  String get scanLogFilterByScannedBy;

  /// Asset search placeholder
  ///
  /// In en, this message translates to:
  /// **'Search asset...'**
  String get scanLogSearchAsset;

  /// User search placeholder
  ///
  /// In en, this message translates to:
  /// **'Search user...'**
  String get scanLogSearchUser;

  /// Sort by label
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get scanLogSortBy;

  /// Sort order label
  ///
  /// In en, this message translates to:
  /// **'Sort Order'**
  String get scanLogSortOrder;

  /// Has coordinates checkbox label
  ///
  /// In en, this message translates to:
  /// **'Has Coordinates'**
  String get scanLogHasCoordinates;

  /// Date from label
  ///
  /// In en, this message translates to:
  /// **'Date From'**
  String get scanLogDateFrom;

  /// Date to label
  ///
  /// In en, this message translates to:
  /// **'Date To'**
  String get scanLogDateTo;

  /// Reset button label
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get scanLogReset;

  /// Apply button label
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get scanLogApply;

  /// Filter reset success message
  ///
  /// In en, this message translates to:
  /// **'Filter reset'**
  String get scanLogFilterReset;

  /// Filter applied success message
  ///
  /// In en, this message translates to:
  /// **'Filter applied'**
  String get scanLogFilterApplied;

  /// Placeholder message for unimplemented features
  ///
  /// In en, this message translates to:
  /// **'Not implemented yet'**
  String get scanLogNotImplementedYet;

  /// User management screen title
  ///
  /// In en, this message translates to:
  /// **'User Management'**
  String get userManagement;

  /// Create user option title
  ///
  /// In en, this message translates to:
  /// **'Create User'**
  String get userCreateUser;

  /// Create user option subtitle
  ///
  /// In en, this message translates to:
  /// **'Add a new user'**
  String get userAddNewUser;

  /// Select many option title
  ///
  /// In en, this message translates to:
  /// **'Select Many'**
  String get userSelectMany;

  /// Select many option subtitle
  ///
  /// In en, this message translates to:
  /// **'Select multiple users to delete'**
  String get userSelectMultipleToDelete;

  /// Filter and sort option title
  ///
  /// In en, this message translates to:
  /// **'Filter & Sort'**
  String get userFilterAndSort;

  /// Filter and sort option subtitle
  ///
  /// In en, this message translates to:
  /// **'Customize user display'**
  String get userCustomizeDisplay;

  /// Filters section title
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get userFilters;

  /// Role label
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get userRole;

  /// Employee ID label
  ///
  /// In en, this message translates to:
  /// **'Employee ID'**
  String get userEmployeeId;

  /// Employee ID input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter employee ID...'**
  String get userEnterEmployeeId;

  /// Active status label
  ///
  /// In en, this message translates to:
  /// **'Active Status'**
  String get userActiveStatus;

  /// Active status value
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get userActive;

  /// Inactive status value
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get userInactive;

  /// Sort section title
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get userSort;

  /// Sort by label
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get userSortBy;

  /// Sort order label
  ///
  /// In en, this message translates to:
  /// **'Sort Order'**
  String get userSortOrder;

  /// Ascending sort order
  ///
  /// In en, this message translates to:
  /// **'Ascending'**
  String get userAscending;

  /// Descending sort order
  ///
  /// In en, this message translates to:
  /// **'Descending'**
  String get userDescending;

  /// Reset button label
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get userReset;

  /// Apply button label
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get userApply;

  /// Filter reset success message
  ///
  /// In en, this message translates to:
  /// **'Filter reset'**
  String get userFilterReset;

  /// Filter applied success message
  ///
  /// In en, this message translates to:
  /// **'Filter applied'**
  String get userFilterApplied;

  /// Select mode instruction
  ///
  /// In en, this message translates to:
  /// **'Select users to delete'**
  String get userSelectUsersToDelete;

  /// Delete users dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Users'**
  String get userDeleteUsers;

  /// Delete confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {count} users?'**
  String userDeleteConfirmation(int count);

  /// Cancel button label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get userCancel;

  /// Delete button label
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get userDelete;

  /// No users selected warning
  ///
  /// In en, this message translates to:
  /// **'No users selected'**
  String get userNoUsersSelected;

  /// Not implemented message
  ///
  /// In en, this message translates to:
  /// **'Not implemented yet'**
  String get userNotImplementedYet;

  /// Selected count display
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String userSelectedCount(int count);

  /// Search users placeholder
  ///
  /// In en, this message translates to:
  /// **'Search users...'**
  String get userSearchUsers;

  /// No users found message
  ///
  /// In en, this message translates to:
  /// **'No users found'**
  String get userNoUsersFound;

  /// Empty state message
  ///
  /// In en, this message translates to:
  /// **'Create your first user to get started'**
  String get userCreateFirstUser;

  /// Long press instruction
  ///
  /// In en, this message translates to:
  /// **'Long press to select more users'**
  String get userLongPressToSelect;

  /// Edit user screen title
  ///
  /// In en, this message translates to:
  /// **'Edit User'**
  String get userEditUser;

  /// Form validation error message
  ///
  /// In en, this message translates to:
  /// **'Please fix all errors'**
  String get userPleaseFixErrors;

  /// Role validation message
  ///
  /// In en, this message translates to:
  /// **'Please select a role'**
  String get userPleaseSelectRole;

  /// Required fields validation message
  ///
  /// In en, this message translates to:
  /// **'Please fill all required fields'**
  String get userPleaseValidateFields;

  /// User save success message
  ///
  /// In en, this message translates to:
  /// **'User saved successfully'**
  String get userSavedSuccessfully;

  /// Operation failed message
  ///
  /// In en, this message translates to:
  /// **'Operation failed'**
  String get userOperationFailed;

  /// User information section title
  ///
  /// In en, this message translates to:
  /// **'User Information'**
  String get userInformation;

  /// Username label
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get userUsername;

  /// Username input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter username'**
  String get userEnterUsername;

  /// Email label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get userEmail;

  /// Email input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter email'**
  String get userEnterEmail;

  /// Password label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get userPassword;

  /// Password input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get userEnterPassword;

  /// Full name label
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get userFullName;

  /// Full name input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter full name'**
  String get userEnterFullName;

  /// Role dropdown placeholder
  ///
  /// In en, this message translates to:
  /// **'Select role'**
  String get userSelectRole;

  /// Employee ID optional label
  ///
  /// In en, this message translates to:
  /// **'Employee ID (Optional)'**
  String get userEmployeeIdOptional;

  /// Employee ID input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter employee ID'**
  String get userEnterEmployeeIdOptional;

  /// Preferred language label
  ///
  /// In en, this message translates to:
  /// **'Preferred Language (Optional)'**
  String get userPreferredLanguage;

  /// Language dropdown placeholder
  ///
  /// In en, this message translates to:
  /// **'Select language'**
  String get userSelectLanguage;

  /// Update button label
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get userUpdate;

  /// Create button label
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get userCreate;

  /// User detail screen title
  ///
  /// In en, this message translates to:
  /// **'User Detail'**
  String get userDetail;

  /// Admin only edit warning
  ///
  /// In en, this message translates to:
  /// **'Only admin can edit users'**
  String get userOnlyAdminCanEdit;

  /// Delete user dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete User'**
  String get userDeleteUser;

  /// Delete single user confirmation
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{fullName}\"?'**
  String userDeleteSingleConfirmation(String fullName);

  /// Admin only delete warning
  ///
  /// In en, this message translates to:
  /// **'Only admin can delete users'**
  String get userOnlyAdminCanDelete;

  /// User deleted success message
  ///
  /// In en, this message translates to:
  /// **'User deleted'**
  String get userDeleted;

  /// Delete failed error message
  ///
  /// In en, this message translates to:
  /// **'Delete failed'**
  String get userDeleteFailed;

  /// Name label
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get userName;

  /// Preferred language label
  ///
  /// In en, this message translates to:
  /// **'Preferred Language'**
  String get userPreferredLang;

  /// Yes text
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get userYes;

  /// No text
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get userNo;

  /// Metadata section title
  ///
  /// In en, this message translates to:
  /// **'Metadata'**
  String get userMetadata;

  /// Created at label
  ///
  /// In en, this message translates to:
  /// **'Created At'**
  String get userCreatedAt;

  /// Updated at label
  ///
  /// In en, this message translates to:
  /// **'Updated At'**
  String get userUpdatedAt;

  /// Failed to load error message
  ///
  /// In en, this message translates to:
  /// **'Failed to load user'**
  String get userFailedToLoad;

  /// Failed to load profile error
  ///
  /// In en, this message translates to:
  /// **'Failed to load profile'**
  String get userFailedToLoadProfile;

  /// Personal information section title
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get userPersonalInformation;

  /// Account details section title
  ///
  /// In en, this message translates to:
  /// **'Account Details'**
  String get userAccountDetails;

  /// Status label
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get userStatus;

  /// Update profile screen title
  ///
  /// In en, this message translates to:
  /// **'Update Profile'**
  String get userUpdateProfile;

  /// No user data message
  ///
  /// In en, this message translates to:
  /// **'No user data available'**
  String get userNoUserData;

  /// Profile information section title
  ///
  /// In en, this message translates to:
  /// **'Profile Information'**
  String get userProfileInformation;

  /// Profile picture label
  ///
  /// In en, this message translates to:
  /// **'Profile Picture'**
  String get userProfilePicture;

  /// Choose image button text
  ///
  /// In en, this message translates to:
  /// **'Choose image'**
  String get userChooseImage;

  /// Profile update success message
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get userProfileUpdatedSuccessfully;

  /// Change password screen title
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get userChangePassword;

  /// Change password section title
  ///
  /// In en, this message translates to:
  /// **'Update Your Password'**
  String get userChangePasswordTitle;

  /// Change password section description
  ///
  /// In en, this message translates to:
  /// **'Enter your current password and choose a new secure password.'**
  String get userChangePasswordDescription;

  /// Current password label
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get userCurrentPassword;

  /// Current password placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter current password'**
  String get userEnterCurrentPassword;

  /// New password label
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get userNewPassword;

  /// New password placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter new password'**
  String get userEnterNewPassword;

  /// Confirm new password label
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get userConfirmNewPassword;

  /// Confirm new password placeholder
  ///
  /// In en, this message translates to:
  /// **'Re-enter new password'**
  String get userEnterConfirmNewPassword;

  /// Password requirements title
  ///
  /// In en, this message translates to:
  /// **'Password Requirements'**
  String get userPasswordRequirements;

  /// Password requirements list
  ///
  /// In en, this message translates to:
  /// **'• At least 8 characters\n• At least one uppercase letter\n• At least one lowercase letter\n• At least one number'**
  String get userPasswordRequirementsList;

  /// Change password button text
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get userChangePasswordButton;

  /// Password change success message
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get userPasswordChangedSuccessfully;

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
  /// **'Sigma Asset'**
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
  /// **'Sigma Asset'**
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

  /// Staff shell bottom navigation label for dashboard
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get staffShellBottomNavDashboard;

  /// Staff shell bottom navigation label for scan asset
  ///
  /// In en, this message translates to:
  /// **'Scan Asset'**
  String get staffShellBottomNavScanAsset;

  /// Staff shell bottom navigation label for profile
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get staffShellBottomNavProfile;

  /// Message shown when user needs to press back again to exit app
  ///
  /// In en, this message translates to:
  /// **'Press back again to exit'**
  String get shellDoubleBackToExitApp;
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
