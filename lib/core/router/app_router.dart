import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sigma_track/core/constants/page_key_constant.dart';
import 'package:sigma_track/core/constants/route_constant.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/router/router_refresh_listenable.dart';
import 'package:sigma_track/di/auth_providers.dart';
import 'package:sigma_track/feature/auth/presentation/providers/auth_state.dart';
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
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_schedule.dart';
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
/// * Menggunakan static GlobalKeys untuk refreshListenable pattern
class AppRouter {
  AppRouter._();

  static final AppRouter _instance = AppRouter._();
  factory AppRouter() => _instance;

  // * Static keys untuk mendukung refreshListenable tanpa GlobalKey conflict
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  static final GlobalKey<NavigatorState> _userShellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'userShell');
  static final GlobalKey<NavigatorState> _adminShellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'adminShell');

  // ==================== TRANSITION HELPERS ====================

  /// * Slide from right - untuk detail screens (iOS-style)
  /// * Memberikan context navigasi yang jelas: "going deeper"
  static CustomTransitionPage _slideFromRight({
    required LocalKey key,
    required Widget child,
  }) {
    return CustomTransitionPage(
      key: key,
      child: child,
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  /// * Slide from bottom - untuk form/upsert screens (modal-style)
  /// * Memberikan kesan "action modal" untuk create/edit
  static CustomTransitionPage _slideFromBottom({
    required LocalKey key,
    required Widget child,
  }) {
    return CustomTransitionPage(
      key: key,
      child: child,
      transitionDuration: const Duration(milliseconds: 350),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  /// * Fade + Scale - untuk profile updates (smooth & elegant)
  /// * Memberikan kesan premium untuk personal actions
  static CustomTransitionPage _fadeScale({
    required LocalKey key,
    required Widget child,
  }) {
    return CustomTransitionPage(
      key: key,
      child: child,
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeOut;

        var fadeTween = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: curve));

        var scaleTween = Tween<double>(
          begin: 0.95,
          end: 1.0,
        ).chain(CurveTween(curve: curve));

        return FadeTransition(
          opacity: animation.drive(fadeTween),
          child: ScaleTransition(
            scale: animation.drive(scaleTween),
            child: child,
          ),
        );
      },
    );
  }

  /// * Create GoRouter instance dengan refreshListenable
  GoRouter createRouter(Ref ref) {
    final authRouterNotifier = RouterRefreshListenable(ref);

    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: _getInitialLocation(ref),
      debugLogDiagnostics: true,
      refreshListenable: authRouterNotifier,
      redirect: (context, state) => _handleRedirect(ref, state),
      routes: routes,
    );
  }

  /// * Tentukan initial location berdasarkan auth state
  String _getInitialLocation(Ref ref) {
    final authState = ref.read(authNotifierProvider);

    // * Kalau masih loading, default ke login (native splash masih tampil)
    if (authState.isLoading) {
      return RouteConstant.login;
    }

    final currentAuthState = authState.valueOrNull;
    final isAuthenticated =
        currentAuthState?.status == AuthStatus.authenticated;
    final isAdmin = currentAuthState?.user?.role == UserRole.admin;

    if (!isAuthenticated) {
      return RouteConstant.login;
    }

    return isAdmin ? RouteConstant.adminDashboard : RouteConstant.home;
  }

  /// * Handle redirect logic berdasarkan auth state
  String? _handleRedirect(Ref ref, GoRouterState state) {
    final authState = ref.read(authNotifierProvider);

    // * Jangan redirect apapun kalau masih loading (native splash masih tampil)
    if (authState.isLoading) {
      return null;
    }

    final currentAuthState = authState.valueOrNull;
    final currentIsAuthenticated =
        currentAuthState?.status == AuthStatus.authenticated;
    final currentIsAdmin = currentAuthState?.user?.role == UserRole.admin;

    final isGoingToAuth = state.matchedLocation.startsWith('/auth');
    final isGoingToAdmin = state.matchedLocation.startsWith('/admin');

    if (!currentIsAuthenticated && !isGoingToAuth) {
      return RouteConstant.login;
    }

    if (currentIsAuthenticated && isGoingToAuth) {
      return currentIsAdmin ? RouteConstant.adminDashboard : RouteConstant.home;
    }

    if (!currentIsAdmin && isGoingToAdmin) {
      return RouteConstant.home;
    }

    return null;
  }

  List<RouteBase> get routes => [
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
              name: PageKeyConstant.home,
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
              name: PageKeyConstant.scanAsset,
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
              name: PageKeyConstant.userDetailProfile,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: UserDetailProfileScreen()),
            ),
          ],
        ),
      ],
    ),

    // ==================== USER SPECIFIC ROUTES (Outside shell) ====================
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
        return _fadeScale(
          key: state.pageKey,
          child: const UserUpdateProfileScreen(),
        );
      },
    ),

    // ==================== SHARED DETAIL ROUTES (Accessible by both User & Admin) ====================
    GoRoute(
      path: RouteConstant.assetDetail,
      name: PageKeyConstant.assetDetail,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final asset = state.extra as Asset?;
        final id = state.uri.queryParameters['id'];
        final assetTag = state.uri.queryParameters['assetTag'];
        return _slideFromRight(
          key: state.pageKey,
          child: AssetDetailScreen(asset: asset, id: id, assetTag: assetTag),
        );
      },
    ),
    GoRoute(
      path: RouteConstant.assetMovementDetail,
      name: PageKeyConstant.assetMovementDetail,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final assetMovement = state.extra as AssetMovement?;
        final id = state.uri.queryParameters['id'];
        return _slideFromRight(
          key: state.pageKey,
          child: AssetMovementDetailScreen(
            assetMovement: assetMovement,
            id: id,
          ),
        );
      },
    ),
    GoRoute(
      path: RouteConstant.categoryDetail,
      name: PageKeyConstant.categoryDetail,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final category = state.extra as Category?;
        final id = state.uri.queryParameters['id'];
        final categoryCode = state.uri.queryParameters['categoryCode'];
        return _slideFromRight(
          key: state.pageKey,
          child: CategoryDetailScreen(
            category: category,
            id: id,
            categoryCode: categoryCode,
          ),
        );
      },
    ),
    GoRoute(
      path: RouteConstant.locationDetail,
      name: PageKeyConstant.locationDetail,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final location = state.extra as Location?;
        final id = state.uri.queryParameters['id'];
        final locationCode = state.uri.queryParameters['locationCode'];
        return _slideFromRight(
          key: state.pageKey,
          child: LocationDetailScreen(
            location: location,
            id: id,
            locationCode: locationCode,
          ),
        );
      },
    ),
    GoRoute(
      path: RouteConstant.maintenanceScheduleDetail,
      name: PageKeyConstant.maintenanceScheduleDetail,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final maintenanceSchedule = state.extra as MaintenanceSchedule?;
        final id = state.uri.queryParameters['id'];
        return _slideFromRight(
          key: state.pageKey,
          child: MaintenanceScheduleDetailScreen(
            maintenanceSchedule: maintenanceSchedule,
            id: id,
          ),
        );
      },
    ),
    GoRoute(
      path: RouteConstant.maintenanceRecordDetail,
      name: PageKeyConstant.maintenanceRecordDetail,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final maintenanceRecord = state.extra as MaintenanceRecord?;
        final id = state.uri.queryParameters['id'];
        return _slideFromRight(
          key: state.pageKey,
          child: MaintenanceRecordDetailScreen(
            maintenanceRecord: maintenanceRecord,
            id: id,
          ),
        );
      },
    ),
    GoRoute(
      path: RouteConstant.issueReportDetail,
      name: PageKeyConstant.issueReportDetail,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final issueReport = state.extra as IssueReport?;
        final id = state.uri.queryParameters['id'];
        return _slideFromRight(
          key: state.pageKey,
          child: IssueReportDetailScreen(issueReport: issueReport, id: id),
        );
      },
    ),
    GoRoute(
      path: RouteConstant.notificationDetail,
      name: PageKeyConstant.notificationDetail,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final notification = state.extra as notification_entity.Notification?;
        final id = state.uri.queryParameters['id'];
        return _slideFromRight(
          key: state.pageKey,
          child: NotificationDetailScreen(notification: notification, id: id),
        );
      },
    ),
    GoRoute(
      path: RouteConstant.scanLogDetail,
      name: PageKeyConstant.scanLogDetail,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final scanLog = state.extra as ScanLog?;
        final id = state.uri.queryParameters['id'];
        return _slideFromRight(
          key: state.pageKey,
          child: ScanLogDetailScreen(scanLog: scanLog, id: id),
        );
      },
    ),
    GoRoute(
      path: RouteConstant.userDetail,
      name: PageKeyConstant.userDetail,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final user = state.extra as User?;
        final id = state.uri.queryParameters['id'];
        return _slideFromRight(
          key: state.pageKey,
          child: UserDetailScreen(user: user, id: id),
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
              name: PageKeyConstant.adminScanAsset,
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
              name: PageKeyConstant.adminUserDetailProfile,
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
      pageBuilder: (context, state) =>
          MaterialPage(key: state.pageKey, child: const ListCategoriesScreen()),
    ),
    GoRoute(
      path: RouteConstant.adminLocations,
      name: PageKeyConstant.adminLocations,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) =>
          MaterialPage(key: state.pageKey, child: const ListLocationsScreen()),
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
    // * Untuk saat ini query params tidak dipakai dulu
    GoRoute(
      path: RouteConstant.adminAssetUpsert,
      name: PageKeyConstant.adminAssetUpsert,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final assetId = state.uri.queryParameters['assetId'];
        final asset = state.extra as Asset?;
        return _slideFromBottom(
          key: state.pageKey,
          child: AssetUpsertScreen(asset: asset, assetId: assetId),
        );
      },
    ),
    GoRoute(
      path: RouteConstant.adminAssetMovementUpsert,
      name: PageKeyConstant.adminAssetMovementUpsert,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final assetMovementId = state.uri.queryParameters['movementId'];
        final assetMovement = state.extra as AssetMovement?;
        return _slideFromBottom(
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
      name: PageKeyConstant.adminCategoryUpsert,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final categoryId = state.uri.queryParameters['categoryId'];
        final category = state.extra as Category?;
        return _slideFromBottom(
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
      name: PageKeyConstant.adminLocationUpsert,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final locationId = state.uri.queryParameters['locationId'];
        final location = state.extra as Location?;
        return _slideFromBottom(
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
      name: PageKeyConstant.adminUserUpsert,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final userId = state.uri.queryParameters['userId'];
        final user = state.extra as User?;
        return _slideFromBottom(
          key: state.pageKey,
          child: UserUpsertScreen(user: user, userId: userId),
        );
      },
    ),
    GoRoute(
      path: RouteConstant.adminMaintenanceScheduleUpsert,
      name: PageKeyConstant.adminMaintenanceScheduleUpsert,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final maintenanceId = state.uri.queryParameters['maintenanceId'];
        final maintenanceSchedule = state.extra as MaintenanceSchedule?;
        return _slideFromBottom(
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
      name: PageKeyConstant.adminMaintenanceRecordUpsert,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final maintenanceRecordId =
            state.uri.queryParameters['maintenanceRecordId'];
        final maintenanceRecord = state.extra as MaintenanceRecord?;
        return _slideFromBottom(
          key: state.pageKey,
          child: MaintenanceRecordUpsertScreen(
            maintenanceRecord: maintenanceRecord,
            maintenanceRecordId: maintenanceRecordId,
          ),
        );
      },
    ),
    GoRoute(
      path: RouteConstant.adminIssueReportUpsert,
      name: PageKeyConstant.adminIssueReportUpsert,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final issueReportId = state.uri.queryParameters['issueReportId'];
        final issueReport = state.extra as IssueReport?;
        return _slideFromBottom(
          key: state.pageKey,
          child: IssueReportUpsertScreen(
            issueReport: issueReport,
            issueReportId: issueReportId,
          ),
        );
      },
    ),

    // ==================== ADMIN SPECIFIC ROUTES (Outside shell) ====================
    GoRoute(
      path: RouteConstant.adminUserUpdateProfile,
      name: PageKeyConstant.adminUserUpdateProfile,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        return _fadeScale(
          key: state.pageKey,
          child: const UserUpdateProfileScreen(),
        );
      },
    ),
  ];

  GlobalKey<NavigatorState> get rootNavigatorKey => _rootNavigatorKey;
  GlobalKey<NavigatorState> get userShellNavigatorKey => _userShellNavigatorKey;
  GlobalKey<NavigatorState> get adminShellNavigatorKey =>
      _adminShellNavigatorKey;
}
