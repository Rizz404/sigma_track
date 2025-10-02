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
      // Always add dashboard as base
      const BeamPage(
        key: ValueKey('admin-dashboard'),
        title: 'Admin Dashboard - Sigma Track',
        child: DashboardScreen(),
      ),
    ];

    // Dashboard only
    if (state.uri.path == RouteConstant.admin ||
        state.uri.path == RouteConstant.adminDashboard) {
      return pages;
    }

    // Admin Scan Asset
    if (state.uri.path == RouteConstant.adminScanAsset) {
      pages.add(
        const BeamPage(
          key: ValueKey('admin-scan-asset'),
          title: 'Scan Asset - Sigma Track',
          child: ScanAssetScreen(),
        ),
      );
    }

    // Admin User Detail Profile
    if (state.uri.path == RouteConstant.adminUserDetailProfile) {
      pages.add(
        const BeamPage(
          key: ValueKey('admin-user-detail-profile'),
          title: 'My Profile - Sigma Track',
          child: UserDetailProfileScreen(),
        ),
      );
    }

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

    return pages;
  }
}
