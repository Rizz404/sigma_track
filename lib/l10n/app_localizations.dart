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
