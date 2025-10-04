import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sigma_track/core/constants/page_key_constant.dart';
import 'package:sigma_track/core/constants/route_constant.dart';
import 'package:sigma_track/feature/asset/presentation/screens/admin/asset_upsert_screen.dart';
import 'package:sigma_track/feature/asset/presentation/screens/admin/list_assets_screen.dart';
import 'package:sigma_track/feature/asset/presentation/screens/asset_detail_screen.dart';
import 'package:sigma_track/feature/asset/presentation/screens/scan_asset_screen.dart';
import 'package:sigma_track/feature/asset/presentation/screens/user/my_list_assets_screen.dart';
import 'package:sigma_track/feature/asset_movement/presentation/screens/admin/list_asset_movements_screen.dart';
import 'package:sigma_track/feature/asset_movement/presentation/screens/asset_movement_detail_screen.dart';
import 'package:sigma_track/feature/asset_movement/presentation/screens/asset_movement_upsert_screen.dart';
import 'package:sigma_track/feature/auth/presentation/screens/forgot_password_screen.dart';
import 'package:sigma_track/feature/auth/presentation/screens/login_screen.dart';
import 'package:sigma_track/feature/auth/presentation/screens/register_screen.dart';
import 'package:sigma_track/feature/category/presentation/screens/admin/list_categories_screen.dart';
import 'package:sigma_track/feature/category/presentation/screens/category_detail_screen.dart';
import 'package:sigma_track/feature/category/presentation/screens/category_upsert_screen.dart';
import 'package:sigma_track/feature/dashboard/presentation/screens/admin/dashboard_screen.dart';
import 'package:sigma_track/feature/home/presentation/screens/user/home_screen.dart';
import 'package:sigma_track/feature/issue_report/presentation/screens/admin/issue_report_upsert_screen.dart';
import 'package:sigma_track/feature/issue_report/presentation/screens/admin/list_issue_reports_screen.dart';
import 'package:sigma_track/feature/issue_report/presentation/screens/issue_report_detail_screen.dart';
import 'package:sigma_track/feature/location/presentation/screens/admin/list_locations_screen.dart';
import 'package:sigma_track/feature/location/presentation/screens/location_detail_screen.dart';
import 'package:sigma_track/feature/location/presentation/screens/location_upsert_screen.dart';
import 'package:sigma_track/feature/maintenance/presentation/screens/admin/list_maintenance_records_screen.dart';
import 'package:sigma_track/feature/maintenance/presentation/screens/admin/list_maintenance_schedules_screen.dart';
import 'package:sigma_track/feature/maintenance/presentation/screens/admin/maintenance_record_upsert_screen.dart';
import 'package:sigma_track/feature/maintenance/presentation/screens/admin/maintenance_schedule_upsert_screen.dart';
import 'package:sigma_track/feature/maintenance/presentation/screens/maintenance_record_detail_screen.dart';
import 'package:sigma_track/feature/maintenance/presentation/screens/maintenance_schedule_detail_screen.dart';
import 'package:sigma_track/feature/notification/presentation/screens/admin/list_notifications_screen.dart';
import 'package:sigma_track/feature/notification/presentation/screens/notification_detail_screen.dart';
import 'package:sigma_track/feature/notification/presentation/screens/user/my_list_notifications_screen.dart';
import 'package:sigma_track/feature/scan_log/presentation/screens/admin/list_scan_logs_screen.dart';
import 'package:sigma_track/feature/scan_log/presentation/screens/scan_log_detail_screen.dart';
import 'package:sigma_track/feature/user/domain/entities/user.dart';
import 'package:sigma_track/feature/asset/domain/entities/asset.dart';
import 'package:sigma_track/feature/asset_movement/domain/entities/asset_movement.dart';
import 'package:sigma_track/feature/category/domain/entities/category.dart';
import 'package:sigma_track/feature/location/domain/entities/location.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_record.dart';
import 'package:sigma_track/feature/issue_report/domain/entities/issue_report.dart';
import 'package:sigma_track/feature/notification/domain/entities/notification.dart'
    as notification_entity;
import 'package:sigma_track/feature/scan_log/domain/entities/scan_log.dart';
import 'package:sigma_track/feature/user/presentation/screens/admin/list_users_screen.dart';
import 'package:sigma_track/feature/user/presentation/screens/admin/user_upsert_screen.dart';
import 'package:sigma_track/feature/user/presentation/screens/user_detail_profile_screen.dart';
import 'package:sigma_track/feature/user/presentation/screens/user_detail_screen.dart';
import 'package:sigma_track/feature/user/presentation/screens/user_update_profile_screen.dart';
import 'package:sigma_track/shared/presentation/widgets/user_shell.dart';
import 'package:sigma_track/shared/presentation/widgets/admin_shell.dart';

/// * GoRouter configuration untuk aplikasi Sigma Track
class AppRouter {
  AppRouter({required this.isAuthenticated, required this.isAdmin});

  final bool isAuthenticated;
  final bool isAdmin;

  // * Non-static keys agar bisa recreate tanpa conflict
  final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'root',
  );
  final GlobalKey<NavigatorState> _userShellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'userShell');
  final GlobalKey<NavigatorState> _adminShellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'adminShell');

  late final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteConstant.home,
    debugLogDiagnostics: true,
    redirect: _handleRedirect,
    routes: [
      // ==================== AUTH ROUTES ====================
      GoRoute(
        path: RouteConstant.login,
        name: PageKeyConstant.login,
        pageBuilder: (context, state) =>
            NoTransitionPage(key: state.pageKey, child: const LoginScreen()),
      ),
      GoRoute(
        path: RouteConstant.register,
        name: PageKeyConstant.register,
        pageBuilder: (context, state) =>
            NoTransitionPage(key: state.pageKey, child: const RegisterScreen()),
      ),
      GoRoute(
        path: RouteConstant.forgotPassword,
        name: PageKeyConstant.forgotPassword,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const ForgotPasswordScreen(),
        ),
      ),

      // ==================== USER SHELL ====================
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return UserShell(navigationShell: navigationShell);
        },
        branches: [
          // * Branch 1: Home
          StatefulShellBranch(
            navigatorKey: _userShellNavigatorKey,
            routes: [
              GoRoute(
                path: RouteConstant.home,
                name: PageKeyConstant.userMain,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: HomeScreen()),
              ),
            ],
          ),

          // * Branch 2: Scan Asset (User)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteConstant.scanAsset,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: ScanAssetScreen()),
              ),
            ],
          ),

          // * Branch 3: User Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteConstant.userDetailProfile,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: UserDetailProfileScreen()),
              ),
            ],
          ),
        ],
      ),

      // ==================== USER ROUTES (Outside shell) ====================
      GoRoute(
        path: RouteConstant.myAssets,
        name: PageKeyConstant.myAssets,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const MyListAssetsScreen()),
      ),
      GoRoute(
        path: RouteConstant.myNotifications,
        name: PageKeyConstant.myNotifications,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const MyListNotificationsScreen(),
        ),
      ),
      GoRoute(
        path: RouteConstant.userUpdateProfile,
        name: PageKeyConstant.userUpdateProfile,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final user = state.extra as User;

          return MaterialPage(
            key: state.pageKey,
            child: UserUpdateProfileScreen(user: user),
          );
        },
      ),

      // ==================== USER DETAIL ROUTES (Outside shell) ====================
      GoRoute(
        path: RouteConstant.assetDetail,
        name: PageKeyConstant.assetDetail,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final asset = state.extra as Asset;
          return MaterialPage(
            key: state.pageKey,
            child: AssetDetailScreen(asset: asset),
          );
        },
      ),
      GoRoute(
        path: RouteConstant.assetMovementDetail,
        name: PageKeyConstant.assetMovementDetail,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final assetMovement = state.extra as AssetMovement;
          return MaterialPage(
            key: state.pageKey,
            child: AssetMovementDetailScreen(assetMovement: assetMovement),
          );
        },
      ),
      GoRoute(
        path: RouteConstant.categoryDetail,
        name: PageKeyConstant.categoryDetail,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final category = state.extra as Category;
          return MaterialPage(
            key: state.pageKey,
            child: CategoryDetailScreen(category: category),
          );
        },
      ),
      GoRoute(
        path: RouteConstant.locationDetail,
        name: PageKeyConstant.locationDetail,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final location = state.extra as Location;
          return MaterialPage(
            key: state.pageKey,
            child: LocationDetailScreen(location: location),
          );
        },
      ),
      GoRoute(
        path: RouteConstant.maintenanceScheduleDetail,
        name: PageKeyConstant.maintenanceScheduleDetail,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final maintenanceSchedule = state.extra as MaintenanceSchedule;
          return MaterialPage(
            key: state.pageKey,
            child: MaintenanceScheduleDetailScreen(
              maintenanceSchedule: maintenanceSchedule,
            ),
          );
        },
      ),
      GoRoute(
        path: RouteConstant.maintenanceRecordDetail,
        name: PageKeyConstant.maintenanceRecordDetail,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final maintenanceRecord = state.extra as MaintenanceRecord;
          return MaterialPage(
            key: state.pageKey,
            child: MaintenanceRecordDetailScreen(
              maintenanceRecord: maintenanceRecord,
            ),
          );
        },
      ),
      GoRoute(
        path: RouteConstant.issueReportDetail,
        name: PageKeyConstant.issueReportDetail,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final issueReport = state.extra as IssueReport;
          return MaterialPage(
            key: state.pageKey,
            child: IssueReportDetailScreen(issueReport: issueReport),
          );
        },
      ),
      GoRoute(
        path: RouteConstant.notificationDetail,
        name: PageKeyConstant.notificationDetail,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final notification = state.extra as notification_entity.Notification;
          return MaterialPage(
            key: state.pageKey,
            child: NotificationDetailScreen(notification: notification),
          );
        },
      ),
      GoRoute(
        path: RouteConstant.scanLogDetail,
        name: PageKeyConstant.scanLogDetail,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final scanLog = state.extra as ScanLog;
          return MaterialPage(
            key: state.pageKey,
            child: ScanLogDetailScreen(scanLog: scanLog),
          );
        },
      ),
      GoRoute(
        path: RouteConstant.userDetail,
        name: PageKeyConstant.userDetail,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final user = state.extra as User;
          return MaterialPage(
            key: state.pageKey,
            child: UserDetailScreen(user: user),
          );
        },
      ),

      // ==================== ADMIN SHELL ====================
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AdminShell(navigationShell: navigationShell);
        },
        branches: [
          // * Branch 1: Admin Dashboard
          StatefulShellBranch(
            navigatorKey: _adminShellNavigatorKey,
            routes: [
              GoRoute(
                path: RouteConstant.adminDashboard,
                name: PageKeyConstant.adminDashboard,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: DashboardScreen()),
              ),
            ],
          ),

          // * Branch 2: Scan Asset (Admin)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteConstant.adminScanAsset,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: ScanAssetScreen()),
              ),
            ],
          ),

          // * Branch 3: Admin Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteConstant.adminUserDetailProfile,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: UserDetailProfileScreen()),
              ),
            ],
          ),
        ],
      ),

      // ==================== ADMIN LIST ROUTES (Outside shell) ====================
      GoRoute(
        path: RouteConstant.adminAssets,
        name: PageKeyConstant.adminAssets,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const ListAssetsScreen()),
      ),
      GoRoute(
        path: RouteConstant.adminAssetMovements,
        name: PageKeyConstant.adminAssetMovements,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const ListAssetMovementsScreen(),
        ),
      ),
      GoRoute(
        path: RouteConstant.adminCategories,
        name: PageKeyConstant.adminCategories,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const ListCategoriesScreen(),
        ),
      ),
      GoRoute(
        path: RouteConstant.adminLocations,
        name: PageKeyConstant.adminLocations,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const ListLocationsScreen(),
        ),
      ),
      GoRoute(
        path: RouteConstant.adminUsers,
        name: PageKeyConstant.adminUsers,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const ListUsersScreen()),
      ),
      GoRoute(
        path: RouteConstant.adminMaintenanceSchedules,
        name: PageKeyConstant.adminMaintenanceSchedules,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const ListMaintenanceSchedulesScreen(),
        ),
      ),
      GoRoute(
        path: RouteConstant.adminMaintenanceRecords,
        name: PageKeyConstant.adminMaintenanceRecords,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const ListMaintenanceRecordsScreen(),
        ),
      ),
      GoRoute(
        path: RouteConstant.adminIssueReports,
        name: PageKeyConstant.adminIssueReports,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const ListIssueReportsScreen(),
        ),
      ),
      GoRoute(
        path: RouteConstant.adminScanLogs,
        name: PageKeyConstant.adminScanLogs,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const ListScanLogsScreen()),
      ),
      GoRoute(
        path: RouteConstant.adminNotifications,
        name: PageKeyConstant.adminNotifications,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const ListNotificationsScreen(),
        ),
      ),

      // ==================== ADMIN UPSERT ROUTES (Outside shell) ====================
      GoRoute(
        path: RouteConstant.adminAssetUpsert,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final assetId = state.uri.queryParameters['assetId'];
          final asset = state.extra as Asset?;
          return MaterialPage(
            key: state.pageKey,
            child: AssetUpsertScreen(asset: asset, assetId: assetId),
          );
        },
      ),
      GoRoute(
        path: RouteConstant.adminAssetMovementUpsert,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final assetMovementId = state.uri.queryParameters['movementId'];
          final assetMovement = state.extra as AssetMovement?;
          return MaterialPage(
            key: state.pageKey,
            child: AssetMovementUpsertScreen(
              assetMovement: assetMovement,
              assetMovementId: assetMovementId,
            ),
          );
        },
      ),
      GoRoute(
        path: RouteConstant.adminCategoryUpsert,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final categoryId = state.uri.queryParameters['categoryId'];
          final category = state.extra as Category?;
          return MaterialPage(
            key: state.pageKey,
            child: CategoryUpsertScreen(
              category: category,
              categoryId: categoryId,
            ),
          );
        },
      ),
      GoRoute(
        path: RouteConstant.adminLocationUpsert,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final locationId = state.uri.queryParameters['locationId'];
          final location = state.extra as Location?;
          return MaterialPage(
            key: state.pageKey,
            child: LocationUpsertScreen(
              location: location,
              locationId: locationId,
            ),
          );
        },
      ),
      GoRoute(
        path: RouteConstant.adminUserUpsert,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final userId = state.uri.queryParameters['userId'];
          final user = state.extra as User?;
          return MaterialPage(
            key: state.pageKey,
            child: UserUpsertScreen(user: user, userId: userId),
          );
        },
      ),
      GoRoute(
        path: RouteConstant.adminMaintenanceScheduleUpsert,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final maintenanceId = state.uri.queryParameters['maintenanceId'];
          final maintenanceSchedule = state.extra as MaintenanceSchedule?;
          return MaterialPage(
            key: state.pageKey,
            child: MaintenanceScheduleUpsertScreen(
              maintenanceSchedule: maintenanceSchedule,
              maintenanceId: maintenanceId,
            ),
          );
        },
      ),
      GoRoute(
        path: RouteConstant.adminMaintenanceRecordUpsert,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final maintenanceId = state.uri.queryParameters['maintenanceId'];
          final maintenanceRecord = state.extra as MaintenanceRecord?;
          return MaterialPage(
            key: state.pageKey,
            child: MaintenanceRecordUpsertScreen(
              maintenanceRecord: maintenanceRecord,
              maintenanceId: maintenanceId,
            ),
          );
        },
      ),
      GoRoute(
        path: RouteConstant.adminIssueReportUpsert,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final issueReportId = state.uri.queryParameters['issueReportId'];
          final issueReport = state.extra as IssueReport?;
          return MaterialPage(
            key: state.pageKey,
            child: IssueReportUpsertScreen(
              issueReport: issueReport,
              issueReportId: issueReportId,
            ),
          );
        },
      ),

      // ==================== ADMIN DETAIL ROUTES (Outside shell) ====================
      GoRoute(
        path: RouteConstant.adminAssetDetail,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final asset = state.extra as Asset;
          return MaterialPage(
            key: state.pageKey,
            child: AssetDetailScreen(asset: asset),
          );
        },
      ),
      GoRoute(
        path: RouteConstant.adminAssetMovementDetail,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final assetMovement = state.extra as AssetMovement;
          return MaterialPage(
            key: state.pageKey,
            child: AssetMovementDetailScreen(assetMovement: assetMovement),
          );
        },
      ),
      GoRoute(
        path: RouteConstant.adminCategoryDetail,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final category = state.extra as Category;
          return MaterialPage(
            key: state.pageKey,
            child: CategoryDetailScreen(category: category),
          );
        },
      ),
      GoRoute(
        path: RouteConstant.adminLocationDetail,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final location = state.extra as Location;
          return MaterialPage(
            key: state.pageKey,
            child: LocationDetailScreen(location: location),
          );
        },
      ),
      GoRoute(
        path: RouteConstant.adminMaintenanceScheduleDetail,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final maintenanceSchedule = state.extra as MaintenanceSchedule;
          return MaterialPage(
            key: state.pageKey,
            child: MaintenanceScheduleDetailScreen(
              maintenanceSchedule: maintenanceSchedule,
            ),
          );
        },
      ),
      GoRoute(
        path: RouteConstant.adminMaintenanceRecordDetail,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final maintenanceRecord = state.extra as MaintenanceRecord;
          return MaterialPage(
            key: state.pageKey,
            child: MaintenanceRecordDetailScreen(
              maintenanceRecord: maintenanceRecord,
            ),
          );
        },
      ),
      GoRoute(
        path: RouteConstant.adminIssueReportDetail,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final issueReport = state.extra as IssueReport;
          return MaterialPage(
            key: state.pageKey,
            child: IssueReportDetailScreen(issueReport: issueReport),
          );
        },
      ),
      GoRoute(
        path: RouteConstant.adminNotificationDetail,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final notification = state.extra as notification_entity.Notification;
          return MaterialPage(
            key: state.pageKey,
            child: NotificationDetailScreen(notification: notification),
          );
        },
      ),
      GoRoute(
        path: RouteConstant.adminScanLogDetail,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final scanLog = state.extra as ScanLog;
          return MaterialPage(
            key: state.pageKey,
            child: ScanLogDetailScreen(scanLog: scanLog),
          );
        },
      ),
      GoRoute(
        path: RouteConstant.adminUserDetail,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final user = state.extra as User;
          return MaterialPage(
            key: state.pageKey,
            child: UserDetailScreen(user: user),
          );
        },
      ),
      GoRoute(
        path: RouteConstant.adminUserUpdateProfile,
        name: PageKeyConstant.adminUserUpdateProfile,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final user = state.extra as User;
          return MaterialPage(
            key: state.pageKey,
            child: UserUpdateProfileScreen(user: user),
          );
        },
      ),
    ],
  );

  String? _handleRedirect(BuildContext context, GoRouterState state) {
    final isGoingToAuth = state.matchedLocation.startsWith('/auth');
    final isGoingToAdmin = state.matchedLocation.startsWith('/admin');

    if (!isAuthenticated && !isGoingToAuth) {
      return RouteConstant.login;
    }

    if (isAuthenticated && isGoingToAuth) {
      return isAdmin ? RouteConstant.adminDashboard : RouteConstant.home;
    }

    if (!isAdmin && isGoingToAdmin) {
      return RouteConstant.home;
    }

    return null;
  }
}
