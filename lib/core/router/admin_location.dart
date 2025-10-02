import 'package:beamer/beamer.dart';
import 'package:flutter/widgets.dart';
import 'package:sigma_track/core/constants/route_constant.dart';
import 'package:sigma_track/feature/asset/presentation/screens/admin/asset_upsert_screen.dart';
import 'package:sigma_track/feature/asset/presentation/screens/admin/list_assets_screen.dart';
import 'package:sigma_track/feature/asset/presentation/screens/scan_asset_screen.dart';
import 'package:sigma_track/feature/asset_movement/presentation/screens/admin/list_asset_movements_screen.dart';
import 'package:sigma_track/feature/category/presentation/screens/admin/list_categories_screen.dart';
import 'package:sigma_track/feature/dashboard/presentation/screens/admin/dashboard_screen.dart';
import 'package:sigma_track/feature/issue_report/presentation/screens/admin/list_issue_reports_screen.dart';
import 'package:sigma_track/feature/location/presentation/screens/admin/list_locations_screen.dart';
import 'package:sigma_track/feature/maintenance/presentation/screens/admin/list_maintenances_screen.dart';
import 'package:sigma_track/feature/notification/presentation/screens/admin/list_notifications_screen.dart';
import 'package:sigma_track/feature/scan_log/presentation/screens/admin/list_scan_logs_screen.dart';
import 'package:sigma_track/feature/user/presentation/screens/admin/list_users_screen.dart';
import 'package:sigma_track/feature/user/presentation/screens/admin/user_upsert_screen.dart';
import 'package:sigma_track/feature/user/presentation/screens/user_detail_profile_screen.dart';
import 'package:sigma_track/shared/presentation/widgets/admin_shell.dart';

// TODO: Import detail/upsert screens when implementing data fetching
// import 'package:sigma_track/feature/asset/presentation/screens/asset_detail_screen.dart';
// import 'package:sigma_track/feature/asset_movement/presentation/screens/asset_movement_detail_screen.dart';
// ... dst

/// Handles admin-related routes (Admin-only list/management screens)
class AdminLocation extends BeamLocation<BeamState> {
  @override
  List<Pattern> get pathPatterns => [
    RouteConstant.admin,
    RouteConstant.adminDashboard,
    RouteConstant.adminScanAsset,
    RouteConstant.adminUserDetailProfile,
    RouteConstant.adminUserUpdateProfile,
    RouteConstant.adminAssets,
    RouteConstant.adminAssetUpsert,
    RouteConstant.adminAssetMovements,
    RouteConstant.adminCategories,
    RouteConstant.adminLocations,
    RouteConstant.adminUsers,
    RouteConstant.adminUserUpsert,
    RouteConstant.adminMaintenances,
    RouteConstant.adminIssueReports,
    RouteConstant.adminScanLogs,
    RouteConstant.adminNotifications,
    RouteConstant.adminAssetDetail,
    RouteConstant.adminAssetMovementDetail,
    RouteConstant.adminAssetMovementUpsert,
    RouteConstant.adminCategoryDetail,
    RouteConstant.adminCategoryUpsert,
    RouteConstant.adminLocationDetail,
    RouteConstant.adminLocationUpsert,
    RouteConstant.adminMaintenanceDetail,
    RouteConstant.adminMaintenanceUpsert,
    RouteConstant.adminIssueReportDetail,
    RouteConstant.adminIssueReportUpsert,
    RouteConstant.adminNotificationDetail,
    RouteConstant.adminScanLogDetail,
    RouteConstant.adminUserDetail,
  ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final pages = <BeamPage>[
      // Always add dashboard as base with AdminShell wrapper
      BeamPage(
        key: const ValueKey('admin-dashboard'),
        title: 'Admin Dashboard - Sigma Track',
        child: AdminShell(
          child: Builder(
            builder: (context) {
              // Return different screens based on route
              if (state.uri.path == RouteConstant.adminScanAsset) {
                return const ScanAssetScreen();
              } else if (state.uri.path ==
                  RouteConstant.adminUserDetailProfile) {
                return const UserDetailProfileScreen();
              }
              // Default: Dashboard
              return const DashboardScreen();
            },
          ),
        ),
      ),
    ];

    // ========== ADMIN MANAGEMENT ROUTES (FULLSCREEN) ==========
    // * Route management lainnya tetap sebagai pages terpisah (fullscreen)
    // * Tidak menggunakan AdminShell karena butuh lebih banyak ruang

    // Admin Assets
    if (state.uri.path == RouteConstant.adminAssets) {
      pages.add(
        const BeamPage(
          key: ValueKey('admin-assets'),
          title: 'Assets Management - Sigma Track',
          child: ListAssetsScreen(),
        ),
      );
    } else if (state.uri.path == RouteConstant.adminAssetUpsert) {
      pages.add(
        const BeamPage(
          key: ValueKey('admin-asset-upsert'),
          title: 'Upsert Asset - Sigma Track',
          child: AssetUpsertScreen(),
        ),
      );
    }
    // Admin Asset Movements
    else if (state.uri.path == RouteConstant.adminAssetMovements) {
      pages.add(
        const BeamPage(
          key: ValueKey('admin-asset-movements'),
          title: 'Asset Movements Management - Sigma Track',
          child: ListAssetMovementsScreen(),
        ),
      );
    }
    // Admin Categories
    else if (state.uri.path == RouteConstant.adminCategories) {
      pages.add(
        const BeamPage(
          key: ValueKey('admin-categories'),
          title: 'Categories Management - Sigma Track',
          child: ListCategoriesScreen(),
        ),
      );
    }
    // Admin Locations
    else if (state.uri.path == RouteConstant.adminLocations) {
      pages.add(
        const BeamPage(
          key: ValueKey('admin-locations'),
          title: 'Locations Management - Sigma Track',
          child: ListLocationsScreen(),
        ),
      );
    }
    // Admin Users
    else if (state.uri.path == RouteConstant.adminUsers) {
      pages.add(
        const BeamPage(
          key: ValueKey('admin-users'),
          title: 'Users Management - Sigma Track',
          child: ListUsersScreen(),
        ),
      );
    } else if (state.uri.path == RouteConstant.adminUserUpsert) {
      pages.add(
        const BeamPage(
          key: ValueKey('admin-user-upsert'),
          title: 'Upsert User - Sigma Track',
          child: UserUpsertScreen(),
        ),
      );
    }
    // Admin Maintenances
    else if (state.uri.path == RouteConstant.adminMaintenances) {
      pages.add(
        const BeamPage(
          key: ValueKey('admin-maintenances'),
          title: 'Maintenances Management - Sigma Track',
          child: ListMaintenancesScreen(),
        ),
      );
    }
    // Admin Issue Reports
    else if (state.uri.path == RouteConstant.adminIssueReports) {
      pages.add(
        const BeamPage(
          key: ValueKey('admin-issue-reports'),
          title: 'Issue Reports Management - Sigma Track',
          child: ListIssueReportsScreen(),
        ),
      );
    }
    // Admin Scan Logs
    else if (state.uri.path == RouteConstant.adminScanLogs) {
      pages.add(
        const BeamPage(
          key: ValueKey('admin-scan-logs'),
          title: 'Scan Logs - Sigma Track',
          child: ListScanLogsScreen(),
        ),
      );
    }
    // Admin Notifications
    else if (state.uri.path == RouteConstant.adminNotifications) {
      pages.add(
        const BeamPage(
          key: ValueKey('admin-notifications'),
          title: 'Notifications Management - Sigma Track',
          child: ListNotificationsScreen(),
        ),
      );
    }

    // ========== ADMIN PROFILE ROUTES (FULLSCREEN) ==========

    // Admin User Update Profile
    if (state.uri.path == RouteConstant.adminUserUpdateProfile) {
      // TODO: Fetch current user data and pass to UserUpdateProfileScreen
      pages.add(
        BeamPage(
          key: const ValueKey('admin-user-update-profile'),
          title: 'Update Profile - Sigma Track',
          child: Container(), // ! Placeholder - implement user fetching
        ),
      );
    }

    // ========== ADMIN DETAIL/UPSERT ROUTES (FULLSCREEN) ==========
    // * Screen detail/upsert dengan prefix /admin
    // TODO: Implementasi detail screens membutuhkan data fetching dari parameter

    // Admin Asset Detail
    if (state.uri.path.startsWith('/admin/asset/') &&
        state.pathParameters.containsKey('assetId')) {
      // TODO: Fetch asset data by assetId
      pages.add(
        BeamPage(
          key: ValueKey(
            'admin-asset-detail-${state.pathParameters['assetId']}',
          ),
          title: 'Asset Detail - Sigma Track',
          child: Container(), // ! Placeholder
        ),
      );
    }

    // Admin Asset Movement Detail
    if (state.uri.path.startsWith('/admin/asset-movement/') &&
        state.pathParameters.containsKey('movementId')) {
      // TODO: Fetch asset movement by movementId
      pages.add(
        BeamPage(
          key: ValueKey(
            'admin-asset-movement-detail-${state.pathParameters['movementId']}',
          ),
          title: 'Asset Movement Detail - Sigma Track',
          child: Container(), // ! Placeholder
        ),
      );
    }

    // Admin Asset Movement Upsert
    if (state.uri.path == RouteConstant.adminAssetMovementUpsert) {
      // TODO: Implement asset movement upsert
      pages.add(
        BeamPage(
          key: const ValueKey('admin-asset-movement-upsert'),
          title: 'Asset Movement - Sigma Track',
          child: Container(), // ! Placeholder
        ),
      );
    }

    // Admin Category Detail
    if (state.uri.path.startsWith('/admin/category/') &&
        state.pathParameters.containsKey('categoryId')) {
      // TODO: Fetch category by categoryId
      pages.add(
        BeamPage(
          key: ValueKey(
            'admin-category-detail-${state.pathParameters['categoryId']}',
          ),
          title: 'Category Detail - Sigma Track',
          child: Container(), // ! Placeholder
        ),
      );
    }

    // Admin Category Upsert
    if (state.uri.path == RouteConstant.adminCategoryUpsert) {
      // TODO: Implement category upsert
      pages.add(
        BeamPage(
          key: const ValueKey('admin-category-upsert'),
          title: 'Category - Sigma Track',
          child: Container(), // ! Placeholder
        ),
      );
    }

    // Admin Location Detail
    if (state.uri.path.startsWith('/admin/location/') &&
        state.pathParameters.containsKey('locationId')) {
      // TODO: Fetch location by locationId
      pages.add(
        BeamPage(
          key: ValueKey(
            'admin-location-detail-${state.pathParameters['locationId']}',
          ),
          title: 'Location Detail - Sigma Track',
          child: Container(), // ! Placeholder
        ),
      );
    }

    // Admin Location Upsert
    if (state.uri.path == RouteConstant.adminLocationUpsert) {
      // TODO: Implement location upsert
      pages.add(
        BeamPage(
          key: const ValueKey('admin-location-upsert'),
          title: 'Location - Sigma Track',
          child: Container(), // ! Placeholder
        ),
      );
    }

    // Admin Maintenance Detail
    if (state.uri.path.startsWith('/admin/maintenance/') &&
        state.pathParameters.containsKey('maintenanceId')) {
      // TODO: Fetch maintenance by maintenanceId
      pages.add(
        BeamPage(
          key: ValueKey(
            'admin-maintenance-detail-${state.pathParameters['maintenanceId']}',
          ),
          title: 'Maintenance Detail - Sigma Track',
          child: Container(), // ! Placeholder
        ),
      );
    }

    // Admin Maintenance Upsert
    if (state.uri.path == RouteConstant.adminMaintenanceUpsert) {
      // TODO: Implement maintenance upsert
      pages.add(
        BeamPage(
          key: const ValueKey('admin-maintenance-upsert'),
          title: 'Maintenance - Sigma Track',
          child: Container(), // ! Placeholder
        ),
      );
    }

    // Admin Issue Report Detail
    if (state.uri.path.startsWith('/admin/issue-report/') &&
        state.pathParameters.containsKey('issueReportId')) {
      // TODO: Fetch issue report by issueReportId
      pages.add(
        BeamPage(
          key: ValueKey(
            'admin-issue-report-detail-${state.pathParameters['issueReportId']}',
          ),
          title: 'Issue Report Detail - Sigma Track',
          child: Container(), // ! Placeholder
        ),
      );
    }

    // Admin Issue Report Upsert
    if (state.uri.path == RouteConstant.adminIssueReportUpsert) {
      // TODO: Implement issue report upsert
      pages.add(
        BeamPage(
          key: const ValueKey('admin-issue-report-upsert'),
          title: 'Issue Report - Sigma Track',
          child: Container(), // ! Placeholder
        ),
      );
    }

    // Admin Notification Detail
    if (state.uri.path.startsWith('/admin/notification/') &&
        state.pathParameters.containsKey('notificationId')) {
      // TODO: Fetch notification by notificationId
      pages.add(
        BeamPage(
          key: ValueKey(
            'admin-notification-detail-${state.pathParameters['notificationId']}',
          ),
          title: 'Notification Detail - Sigma Track',
          child: Container(), // ! Placeholder
        ),
      );
    }

    // Admin Scan Log Detail
    if (state.uri.path.startsWith('/admin/scan-log/') &&
        state.pathParameters.containsKey('scanLogId')) {
      // TODO: Fetch scan log by scanLogId
      pages.add(
        BeamPage(
          key: ValueKey(
            'admin-scan-log-detail-${state.pathParameters['scanLogId']}',
          ),
          title: 'Scan Log Detail - Sigma Track',
          child: Container(), // ! Placeholder
        ),
      );
    }

    // Admin User Detail
    if (state.uri.path.startsWith('/admin/user/') &&
        state.pathParameters.containsKey('userId') &&
        !state.uri.path.contains('profile')) {
      // TODO: Fetch user by userId
      pages.add(
        BeamPage(
          key: ValueKey('admin-user-detail-${state.pathParameters['userId']}'),
          title: 'User Detail - Sigma Track',
          child: Container(), // ! Placeholder
        ),
      );
    }

    return pages;
  }
}
