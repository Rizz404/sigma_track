class RouteConstant {
  RouteConstant._();

  // ==================== AUTH ROUTES (Public) ====================
  static const String auth = '/auth';
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';

  // ==================== USER ROUTES ====================
  static const String home = '/';
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String scanAsset = '/scan-asset';
  static const String myAssets = '/my-assets';
  static const String myNotifications = '/my-notifications';

  // ==================== USER DETAIL ROUTES ====================
  static const String assetDetail = '/asset/:assetId';
  static const String assetMovementDetail = '/asset-movement/:movementId';
  static const String assetMovementUpsert = '/asset-movement/upsert';
  static const String categoryDetail = '/category/:categoryId';
  static const String categoryUpsert = '/category/upsert';
  static const String locationDetail = '/location/:locationId';
  static const String locationUpsert = '/location/upsert';
  static const String maintenanceDetail = '/maintenance/:maintenanceId';
  static const String maintenanceUpsert = '/maintenance/upsert';
  static const String issueReportDetail = '/issue-report/:issueReportId';
  static const String issueReportUpsert = '/issue-report/upsert';
  static const String notificationDetail = '/notification/:notificationId';
  static const String scanLogDetail = '/scan-log/:scanLogId';
  static const String userDetail = '/user/:userId';

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
  static const String adminMaintenances = '/admin/maintenances';
  static const String adminIssueReports = '/admin/issue-reports';
  static const String adminScanLogs = '/admin/scan-logs';
  static const String adminNotifications = '/admin/notifications';

  // Admin Detail Routes (Admin with prefix)
  static const String adminAssetDetail = '/admin/asset/:assetId';
  static const String adminAssetMovementDetail =
      '/admin/asset-movement/:movementId';
  static const String adminAssetMovementUpsert = '/admin/asset-movement/upsert';
  static const String adminCategoryDetail = '/admin/category/:categoryId';
  static const String adminCategoryUpsert = '/admin/category/upsert';
  static const String adminLocationDetail = '/admin/location/:locationId';
  static const String adminLocationUpsert = '/admin/location/upsert';
  static const String adminMaintenanceDetail =
      '/admin/maintenance/:maintenanceId';
  static const String adminMaintenanceUpsert = '/admin/maintenance/upsert';
  static const String adminIssueReportDetail =
      '/admin/issue-report/:issueReportId';
  static const String adminIssueReportUpsert = '/admin/issue-report/upsert';
  static const String adminNotificationDetail =
      '/admin/notification/:notificationId';
  static const String adminScanLogDetail = '/admin/scan-log/:scanLogId';
  static const String adminUserDetail = '/admin/user/:userId';

  // ==================== HELPER METHODS ====================

  // User Routes Helpers
  static String getAssetDetailPath(String assetId) => '/asset/$assetId';
  static String getAssetMovementDetailPath(String movementId) =>
      '/asset-movement/$movementId';
  static String getCategoryDetailPath(String categoryId) =>
      '/category/$categoryId';
  static String getLocationDetailPath(String locationId) =>
      '/location/$locationId';
  static String getMaintenanceDetailPath(String maintenanceId) =>
      '/maintenance/$maintenanceId';
  static String getIssueReportDetailPath(String issueReportId) =>
      '/issue-report/$issueReportId';
  static String getNotificationDetailPath(String notificationId) =>
      '/notification/$notificationId';
  static String getScanLogDetailPath(String scanLogId) =>
      '/scan-log/$scanLogId';
  static String getUserDetailPath(String userId) => '/user/$userId';

  // Admin Routes Helpers
  static String getAdminAssetDetailPath(String assetId) =>
      '/admin/asset/$assetId';
  static String getAdminAssetMovementDetailPath(String movementId) =>
      '/admin/asset-movement/$movementId';
  static String getAdminCategoryDetailPath(String categoryId) =>
      '/admin/category/$categoryId';
  static String getAdminLocationDetailPath(String locationId) =>
      '/admin/location/$locationId';
  static String getAdminMaintenanceDetailPath(String maintenanceId) =>
      '/admin/maintenance/$maintenanceId';
  static String getAdminIssueReportDetailPath(String issueReportId) =>
      '/admin/issue-report/$issueReportId';
  static String getAdminNotificationDetailPath(String notificationId) =>
      '/admin/notification/$notificationId';
  static String getAdminScanLogDetailPath(String scanLogId) =>
      '/admin/scan-log/$scanLogId';
  static String getAdminUserDetailPath(String userId) => '/admin/user/$userId';
}
