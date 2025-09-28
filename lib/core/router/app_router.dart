import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:sigma_track/core/constants/route_constants.dart';
import 'package:sigma_track/feature/auth/presentation/screens/login_screen.dart';
import 'package:sigma_track/feature/auth/presentation/screens/register_screen.dart';
import 'package:sigma_track/feature/auth/presentation/screens/forgot_password_screen.dart';
import 'package:sigma_track/feature/home/presentation/screens/home_screen.dart';
import 'package:sigma_track/feature/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:sigma_track/feature/profile/presentation/screens/profile_screen.dart';
import 'package:sigma_track/feature/profile/presentation/screens/edit_profile_screen.dart';
import 'package:sigma_track/feature/asset/presentation/screens/scan_asset_screen.dart';
import 'package:sigma_track/feature/asset/presentation/screens/asset_detail_screen.dart';
import 'package:sigma_track/feature/asset/presentation/screens/admin/list_assets_screen.dart';
import 'package:sigma_track/feature/asset/presentation/screens/user/my_list_assets_screen.dart';
import 'package:sigma_track/feature/asset_movement/presentation/screens/asset_movement_detail_screen.dart';
import 'package:sigma_track/feature/asset_movement/presentation/screens/asset_movement_upsert_screen.dart';
import 'package:sigma_track/feature/asset_movement/presentation/screens/admin/list_asset_movements_screen.dart';
import 'package:sigma_track/feature/category/presentation/screens/category_detail_screen.dart';
import 'package:sigma_track/feature/category/presentation/screens/category_upsert_screen.dart';
import 'package:sigma_track/feature/category/presentation/screens/admin/list_categories_screen.dart';
import 'package:sigma_track/feature/issue_report/presentation/screens/issue_report_detail_screen.dart';
import 'package:sigma_track/feature/issue_report/presentation/screens/issue_report_upsert_screen.dart';
import 'package:sigma_track/feature/issue_report/presentation/screens/admin/list_issue_reports_screen.dart';
import 'package:sigma_track/feature/location/presentation/screens/location_detail_screen.dart';
import 'package:sigma_track/feature/location/presentation/screens/location_upsert_screen.dart';
import 'package:sigma_track/feature/location/presentation/screens/admin/list_locations_screen.dart';
import 'package:sigma_track/feature/maintenance/presentation/screens/maintenance_detail_screen.dart';
import 'package:sigma_track/feature/maintenance/presentation/screens/maintenance_upsert_screen.dart';
import 'package:sigma_track/feature/maintenance/presentation/screens/admin/list_maintenances_screen.dart';
import 'package:sigma_track/feature/notification/presentation/screens/notification_detail_screen.dart';
import 'package:sigma_track/feature/notification/presentation/screens/admin/list_notifications_screen.dart';
import 'package:sigma_track/feature/notification/presentation/screens/user/my_list_notifications_screen.dart';
import 'package:sigma_track/feature/scan_log/presentation/screens/scan_log_detail_screen.dart';
import 'package:sigma_track/feature/scan_log/presentation/screens/admin/list_scan_logs_screen.dart';
import 'package:sigma_track/feature/user/presentation/screens/user_detail_screen.dart';
import 'package:sigma_track/feature/user/presentation/screens/user_upsert_screen.dart';
import 'package:sigma_track/feature/user/presentation/screens/admin/list_users_screen.dart';

class AppRouter {
  static final BeamerDelegate routerDelegate = BeamerDelegate(
    initialPath: loginRoute, // Start with login
    locationBuilder: RoutesLocationBuilder(
      routes: {
        // Root route
        '/': (context, state, data) => const LoginScreen(),

        // Auth Routes
        loginRoute: (context, state, data) => const LoginScreen(),
        registerRoute: (context, state, data) => const RegisterScreen(),
        forgotPasswordRoute: (context, state, data) =>
            const ForgotPasswordScreen(),

        // Main Routes
        homeRoute: (context, state, data) =>
            const HomeScreen(), // User main screen
        dashboardRoute: (context, state, data) =>
            const DashboardScreen(), // Admin main screen
        // Profile Routes (Shared)
        profileRoute: (context, state, data) => const ProfileScreen(),
        editProfileRoute: (context, state, data) => const EditProfileScreen(),

        // Asset Routes
        scanAssetRoute: (context, state, data) =>
            const ScanAssetScreen(), // User bottom nav
        assetDetailRoute: (context, state, data) =>
            AssetDetailScreen(asset: data as dynamic),
        // Admin Asset Routes
        adminAssetListRoute: (context, state, data) => const ListAssetsScreen(),
        // User Asset Routes
        userAssetListRoute: (context, state, data) =>
            const MyListAssetsScreen(),

        // Asset Movement Routes
        assetMovementDetailRoute: (context, state, data) =>
            AssetMovementDetailScreen(assetMovement: data as dynamic),
        assetMovementUpsertRoute: (context, state, data) =>
            const AssetMovementUpsertScreen(),
        // Admin Asset Movement Routes
        adminAssetMovementListRoute: (context, state, data) =>
            const ListAssetMovementsScreen(),

        // Category Routes
        categoryDetailRoute: (context, state, data) =>
            CategoryDetailScreen(category: data as dynamic),
        categoryUpsertRoute: (context, state, data) =>
            const CategoryUpsertScreen(),
        // Admin Category Routes
        adminCategoryListRoute: (context, state, data) =>
            const ListCategoriesScreen(),

        // Issue Report Routes
        issueReportDetailRoute: (context, state, data) =>
            IssueReportDetailScreen(issueReport: data as dynamic),
        issueReportUpsertRoute: (context, state, data) =>
            const IssueReportUpsertScreen(),
        // Admin Issue Report Routes
        adminIssueReportListRoute: (context, state, data) =>
            const ListIssueReportsScreen(),

        // Location Routes
        locationDetailRoute: (context, state, data) =>
            LocationDetailScreen(location: data as dynamic),
        locationUpsertRoute: (context, state, data) =>
            const LocationUpsertScreen(),
        // Admin Location Routes
        adminLocationListRoute: (context, state, data) =>
            const ListLocationsScreen(),

        // Maintenance Routes
        maintenanceDetailRoute: (context, state, data) =>
            MaintenanceDetailScreen(maintenanceRecord: data as dynamic),
        maintenanceUpsertRoute: (context, state, data) =>
            const MaintenanceUpsertScreen(),
        // Admin Maintenance Routes
        adminMaintenanceListRoute: (context, state, data) =>
            const ListMaintenancesScreen(),

        // Notification Routes
        notificationDetailRoute: (context, state, data) =>
            NotificationDetailScreen(notification: data as dynamic),
        // Admin Notification Routes
        adminNotificationListRoute: (context, state, data) =>
            const ListNotificationsScreen(),
        // User Notification Routes
        userNotificationListRoute: (context, state, data) =>
            const MyListNotificationsScreen(),

        // Scan Log Routes
        scanLogDetailRoute: (context, state, data) =>
            ScanLogDetailScreen(scanLog: data as dynamic),
        // Admin Scan Log Routes
        adminScanLogListRoute: (context, state, data) =>
            const ListScanLogsScreen(), // Admin bottom nav
        // User Routes
        userDetailRoute: (context, state, data) =>
            UserDetailScreen(user: data as dynamic),
        userUpsertRoute: (context, state, data) => const UserUpsertScreen(),
        // Admin User Routes
        adminUserListRoute: (context, state, data) => const ListUsersScreen(),
      },
    ),
  );

  static MaterialApp get app => MaterialApp.router(
    routerDelegate: routerDelegate,
    routeInformationParser: BeamerParser(),
    backButtonDispatcher: BeamerBackButtonDispatcher(delegate: routerDelegate),
  );

  // Helper methods for navigation
  static void navigateToHome() {
    routerDelegate.beamToNamed(homeRoute);
  }

  static void navigateToDashboard() {
    routerDelegate.beamToNamed(dashboardRoute);
  }

  static void navigateToLogin() {
    routerDelegate.beamToNamed(loginRoute);
  }

  // Navigation for User (Bottom Navigation)
  // - Home Screen (homeRoute)
  // - Scan Asset Screen (scanAssetRoute)
  // - Profile Screen (profileRoute)

  // Navigation for Admin (Bottom Navigation)
  // - Dashboard Screen (dashboardRoute)
  // - Scan Log List Screen (adminScanLogListRoute)
  // - Profile Screen (profileRoute)

  // Redirect after successful login
  static void redirectAfterLogin({required bool isAdmin}) {
    if (isAdmin) {
      navigateToDashboard(); // Admin -> Dashboard
    } else {
      navigateToHome(); // User -> Home
    }
  }
}
