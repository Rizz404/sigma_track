import 'package:beamer/beamer.dart';
import 'package:flutter/widgets.dart';
import 'package:sigma_track/core/constants/route_constant.dart';
import 'package:sigma_track/feature/asset/presentation/screens/scan_asset_screen.dart';
import 'package:sigma_track/feature/asset/presentation/screens/user/my_list_assets_screen.dart';
import 'package:sigma_track/feature/home/presentation/screens/user/home_screen.dart';
import 'package:sigma_track/feature/notification/presentation/screens/user/my_list_notifications_screen.dart';
import 'package:sigma_track/feature/user/presentation/screens/user_detail_profile_screen.dart';
import 'package:sigma_track/shared/presentation/widgets/user_shell.dart';

// TODO: Import detail/upsert screens when implementing data fetching
// import 'package:sigma_track/feature/asset/presentation/screens/asset_detail_screen.dart';
// import 'package:sigma_track/feature/asset_movement/presentation/screens/asset_movement_detail_screen.dart';
// import 'package:sigma_track/feature/asset_movement/presentation/screens/asset_movement_upsert_screen.dart';
// ... dst

/// Handles user-related routes (User-only screens)
class UserLocation extends BeamLocation<BeamState> {
  @override
  List<Pattern> get pathPatterns => [
    RouteConstant.home,
    RouteConstant.scanAsset,
    RouteConstant.myAssets,
    RouteConstant.myNotifications,
    RouteConstant.userDetailProfile,
    RouteConstant.userUpdateProfile,
    RouteConstant.assetDetail,
    RouteConstant.assetMovementDetail,
    RouteConstant.assetMovementUpsert,
    RouteConstant.categoryDetail,
    RouteConstant.categoryUpsert,
    RouteConstant.locationDetail,
    RouteConstant.locationUpsert,
    RouteConstant.maintenanceDetail,
    RouteConstant.maintenanceUpsert,
    RouteConstant.issueReportDetail,
    RouteConstant.issueReportUpsert,
    RouteConstant.notificationDetail,
    RouteConstant.scanLogDetail,
    RouteConstant.userDetail,
  ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final pages = <BeamPage>[];

    // ========== MAIN ROUTES WITH BOTTOM NAV (UserShell) ==========
    // * Hanya 3 screen utama yang menggunakan persistent bottom navigation

    if (state.uri.path == RouteConstant.home ||
        state.uri.path == RouteConstant.scanAsset ||
        state.uri.path == RouteConstant.userDetailProfile) {
      pages.add(
        BeamPage(
          key: const ValueKey('user-main'),
          title: _getTitleForRoute(state.uri.path),
          child: UserShell(
            child: Builder(
              builder: (context) {
                if (state.uri.path == RouteConstant.scanAsset) {
                  return const ScanAssetScreen();
                } else if (state.uri.path == RouteConstant.userDetailProfile) {
                  return const UserDetailProfileScreen();
                }
                // Default: Home
                return const HomeScreen();
              },
            ),
          ),
        ),
      );
      return pages;
    }

    // ========== SECONDARY ROUTES (FULLSCREEN, NO BOTTOM NAV) ==========
    // * Screen lain ditampilkan fullscreen tanpa bottom navigation

    // My Assets
    if (state.uri.path == RouteConstant.myAssets) {
      pages.add(
        const BeamPage(
          key: ValueKey('my-assets'),
          title: 'My Assets - Sigma Track',
          child: MyListAssetsScreen(),
        ),
      );
    }

    // My Notifications
    if (state.uri.path == RouteConstant.myNotifications) {
      pages.add(
        const BeamPage(
          key: ValueKey('my-notifications'),
          title: 'My Notifications - Sigma Track',
          child: MyListNotificationsScreen(),
        ),
      );
    }

    // User Update Profile
    if (state.uri.path == RouteConstant.userUpdateProfile) {
      // TODO: Fetch current user data and pass to UserUpdateProfileScreen
      pages.add(
        BeamPage(
          key: const ValueKey('user-update-profile'),
          title: 'Update Profile - Sigma Track',
          child: Container(), // ! Placeholder - implement user fetching
        ),
      );
    }

    // ========== SHARED DETAIL/UPSERT ROUTES (FULLSCREEN) ==========
    // * Screen detail/upsert yang bisa diakses oleh user
    // TODO: Implementasi detail screens membutuhkan data fetching dari parameter

    // Asset Detail
    if (state.pathPatternSegments.contains('asset') &&
        state.pathParameters.containsKey('assetId')) {
      // TODO: Fetch asset data by assetId and pass to AssetDetailScreen
      // final assetId = state.pathParameters['assetId']!;
      pages.add(
        BeamPage(
          key: ValueKey('asset-detail-${state.pathParameters['assetId']}'),
          title: 'Asset Detail - Sigma Track',
          // child: AssetDetailScreen(asset: fetchedAsset),
          child: Container(), // ! Placeholder - implement asset fetching
        ),
      );
    }

    // Asset Movement Detail
    if (state.pathPatternSegments.contains('asset-movement') &&
        state.pathParameters.containsKey('movementId')) {
      // TODO: Fetch asset movement by movementId
      pages.add(
        BeamPage(
          key: ValueKey(
            'asset-movement-detail-${state.pathParameters['movementId']}',
          ),
          title: 'Asset Movement Detail - Sigma Track',
          child: Container(), // ! Placeholder
        ),
      );
    }

    // Asset Movement Upsert
    if (state.uri.path == RouteConstant.assetMovementUpsert) {
      // TODO: Implement asset movement upsert
      pages.add(
        BeamPage(
          key: const ValueKey('asset-movement-upsert'),
          title: 'Asset Movement - Sigma Track',
          child: Container(), // ! Placeholder
        ),
      );
    }

    // Category Detail
    if (state.pathPatternSegments.contains('category') &&
        state.pathParameters.containsKey('categoryId')) {
      // TODO: Fetch category by categoryId
      pages.add(
        BeamPage(
          key: ValueKey(
            'category-detail-${state.pathParameters['categoryId']}',
          ),
          title: 'Category Detail - Sigma Track',
          child: Container(), // ! Placeholder
        ),
      );
    }

    // Category Upsert
    if (state.uri.path == RouteConstant.categoryUpsert) {
      // TODO: Implement category upsert
      pages.add(
        BeamPage(
          key: const ValueKey('category-upsert'),
          title: 'Category - Sigma Track',
          child: Container(), // ! Placeholder
        ),
      );
    }

    // Location Detail
    if (state.pathPatternSegments.contains('location') &&
        state.pathParameters.containsKey('locationId')) {
      // TODO: Fetch location by locationId
      pages.add(
        BeamPage(
          key: ValueKey(
            'location-detail-${state.pathParameters['locationId']}',
          ),
          title: 'Location Detail - Sigma Track',
          child: Container(), // ! Placeholder
        ),
      );
    }

    // Location Upsert
    if (state.uri.path == RouteConstant.locationUpsert) {
      // TODO: Implement location upsert
      pages.add(
        BeamPage(
          key: const ValueKey('location-upsert'),
          title: 'Location - Sigma Track',
          child: Container(), // ! Placeholder
        ),
      );
    }

    // Maintenance Detail
    if (state.pathPatternSegments.contains('maintenance') &&
        state.pathParameters.containsKey('maintenanceId')) {
      // TODO: Fetch maintenance by maintenanceId
      pages.add(
        BeamPage(
          key: ValueKey(
            'maintenance-detail-${state.pathParameters['maintenanceId']}',
          ),
          title: 'Maintenance Detail - Sigma Track',
          child: Container(), // ! Placeholder
        ),
      );
    }

    // Maintenance Upsert
    if (state.uri.path == RouteConstant.maintenanceUpsert) {
      // TODO: Implement maintenance upsert
      pages.add(
        BeamPage(
          key: const ValueKey('maintenance-upsert'),
          title: 'Maintenance - Sigma Track',
          child: Container(), // ! Placeholder
        ),
      );
    }

    // Issue Report Detail
    if (state.pathPatternSegments.contains('issue-report') &&
        state.pathParameters.containsKey('issueReportId')) {
      // TODO: Fetch issue report by issueReportId
      pages.add(
        BeamPage(
          key: ValueKey(
            'issue-report-detail-${state.pathParameters['issueReportId']}',
          ),
          title: 'Issue Report Detail - Sigma Track',
          child: Container(), // ! Placeholder
        ),
      );
    }

    // Issue Report Upsert
    if (state.uri.path == RouteConstant.issueReportUpsert) {
      // TODO: Implement issue report upsert
      pages.add(
        BeamPage(
          key: const ValueKey('issue-report-upsert'),
          title: 'Issue Report - Sigma Track',
          child: Container(), // ! Placeholder
        ),
      );
    }

    // Notification Detail
    if (state.pathPatternSegments.contains('notification') &&
        state.pathParameters.containsKey('notificationId')) {
      // TODO: Fetch notification by notificationId
      pages.add(
        BeamPage(
          key: ValueKey(
            'notification-detail-${state.pathParameters['notificationId']}',
          ),
          title: 'Notification Detail - Sigma Track',
          child: Container(), // ! Placeholder
        ),
      );
    }

    // Scan Log Detail
    if (state.pathPatternSegments.contains('scan-log') &&
        state.pathParameters.containsKey('scanLogId')) {
      // TODO: Fetch scan log by scanLogId
      pages.add(
        BeamPage(
          key: ValueKey('scan-log-detail-${state.pathParameters['scanLogId']}'),
          title: 'Scan Log Detail - Sigma Track',
          child: Container(), // ! Placeholder
        ),
      );
    }

    // User Detail
    if (state.pathPatternSegments.contains('user') &&
        state.pathParameters.containsKey('userId') &&
        !state.uri.path.contains('profile')) {
      // TODO: Fetch user by userId
      pages.add(
        BeamPage(
          key: ValueKey('user-detail-${state.pathParameters['userId']}'),
          title: 'User Detail - Sigma Track',
          child: Container(), // ! Placeholder
        ),
      );
    }

    return pages;
  }

  String _getTitleForRoute(String path) {
    if (path == RouteConstant.scanAsset) return 'Scan Asset - Sigma Track';
    if (path == RouteConstant.userDetailProfile) {
      return 'My Profile - Sigma Track';
    }
    return 'Home - Sigma Track';
  }
}
