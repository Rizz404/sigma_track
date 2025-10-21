class RouteConstant {
  RouteConstant._();

  // ==================== AUTH ROUTES (Public) ====================
  static const String auth = '/auth';
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';

  // ==================== USER ROUTES ====================
  static const String home = '/';
  static const String myAssets = '/my-assets';
  static const String myNotifications = '/my-notifications';
  static const String myIssueReports = '/my-issue-reports';

  // ==================== SHARED DETAIL ROUTES (Accessible by both User & Admin) ====================
  static const String assetDetail = '/asset/:assetId';
  static const String assetMovementDetail = '/asset-movement/:movementId';
  static const String categoryDetail = '/category/:categoryId';
  static const String locationDetail = '/location/:locationId';
  static const String maintenanceScheduleDetail =
      '/maintenance-schedule/:maintenanceId';
  static const String maintenanceRecordDetail =
      '/maintenance-record/:maintenanceId';
  static const String issueReportDetail = '/issue-report/:issueReportId';
  static const String issueReportUpsert = '/issue-report/upsert';
  static const String notificationDetail = '/notification/:notificationId';
  static const String scanLogDetail = '/scan-log/:scanLogId';
  static const String userDetail = '/user/:userId';

  // ==================== UTILITY USER ROUTES (User Only) ====================
  static const String scanAsset = '/scan-asset';
  static const String userDetailProfile = '/user/profile/detail';
  static const String userUpdateProfile = '/user/profile/update';

  // ==================== UTILITY ADMIN ROUTES (Admin Only) ====================
  static const String adminScanAsset = '/admin/scan-asset';
  static const String adminUserDetailProfile = '/admin/user/profile/detail';
  static const String adminUserUpdateProfile = '/admin/user/profile/update';

  // ==================== ADMIN ROUTES ====================
  static const String admin = '/admin';
  static const String adminDashboard = '/admin/dashboard';

  // Admin List Routes (Admin Only)
  static const String adminAssets = '/admin/assets';
  static const String adminAssetUpsert = '/admin/asset/upsert';
  static const String adminAssetMovements = '/admin/asset-movements';
  static const String adminCategories = '/admin/categories';
  static const String adminLocations = '/admin/locations';
  static const String adminUsers = '/admin/users';
  static const String adminUserUpsert = '/admin/user/upsert';
  static const String adminMaintenanceSchedules =
      '/admin/maintenance-schedules';
  static const String adminMaintenanceRecords = '/admin/maintenance-records';
  static const String adminIssueReports = '/admin/issue-reports';
  static const String adminScanLogs = '/admin/scan-logs';
  static const String adminNotifications = '/admin/notifications';

  // Admin Upsert Routes (Admin Only)
  static const String adminAssetMovementUpsertForLocation =
      '/admin/asset-movement/upsert/location';
  static const String adminAssetMovementUpsertForUser =
      '/admin/asset-movement/upsert/user';
  static const String adminCategoryUpsert = '/admin/category/upsert';
  static const String adminLocationUpsert = '/admin/location/upsert';
  static const String adminMaintenanceScheduleUpsert =
      '/admin/maintenance-schedule/upsert';
  static const String adminMaintenanceRecordUpsert =
      '/admin/maintenance-record/upsert';
}
