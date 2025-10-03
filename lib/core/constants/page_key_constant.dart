class PageKeyConstant {
  PageKeyConstant._();

  // ==================== AUTH PAGES ====================
  static const String auth = 'auth';
  static const String login = 'login';
  static const String register = 'register';
  static const String forgotPassword = 'forgot-password';

  // ==================== USER MAIN PAGES ====================
  static const String userMain = 'user-main';
  static const String myAssets = 'my-assets';
  static const String myNotifications = 'my-notifications';
  static const String userUpdateProfile = 'user-update-profile';

  // ==================== ADMIN MAIN PAGES ====================
  static const String adminDashboard = 'admin-dashboard';
  static const String adminUserUpdateProfile = 'admin-user-update-profile';

  // ==================== ADMIN LIST PAGES ====================
  static const String adminAssets = 'admin-assets';
  static const String adminAssetMovements = 'admin-asset-movements';
  static const String adminCategories = 'admin-categories';
  static const String adminLocations = 'admin-locations';
  static const String adminUsers = 'admin-users';
  static const String adminMaintenanceSchedules = 'admin-maintenance-schedules';
  static const String adminMaintenanceRecords = 'admin-maintenance-records';
  static const String adminIssueReports = 'admin-issue-reports';
  static const String adminScanLogs = 'admin-scan-logs';
  static const String adminNotifications = 'admin-notifications';

  // ==================== SHARED DETAIL PAGES ====================
  static const String assetDetail = 'asset-detail';
  static const String assetMovementDetail = 'asset-movement-detail';
  static const String categoryDetail = 'category-detail';
  static const String locationDetail = 'location-detail';
  static const String maintenanceScheduleDetail = 'maintenance-schedule-detail';
  static const String maintenanceRecordDetail = 'maintenance-record-detail';
  static const String issueReportDetail = 'issue-report-detail';
  static const String notificationDetail = 'notification-detail';
  static const String scanLogDetail = 'scan-log-detail';
  static const String userDetail = 'user-detail';

  // ==================== HELPER METHODS ====================

  // User Detail Pages Helpers
  static String getAssetDetailKey(String assetId) => '$assetDetail-$assetId';
  static String getAssetMovementDetailKey(String movementId) =>
      '$assetMovementDetail-$movementId';
  static String getCategoryDetailKey(String categoryId) =>
      '$categoryDetail-$categoryId';
  static String getLocationDetailKey(String locationId) =>
      '$locationDetail-$locationId';
  static String getMaintenanceScheduleDetailKey(String maintenanceId) =>
      '$maintenanceScheduleDetail-$maintenanceId';
  static String getMaintenanceRecordDetailKey(String maintenanceId) =>
      '$maintenanceRecordDetail-$maintenanceId';
  static String getIssueReportDetailKey(String issueReportId) =>
      '$issueReportDetail-$issueReportId';
  static String getNotificationDetailKey(String notificationId) =>
      '$notificationDetail-$notificationId';
  static String getScanLogDetailKey(String scanLogId) =>
      '$scanLogDetail-$scanLogId';
  static String getUserDetailKey(String userId) => '$userDetail-$userId';

  // Admin Detail Pages Helpers
  static String getAdminAssetDetailKey(String assetId) =>
      'admin-$assetDetail-$assetId';
  static String getAdminAssetMovementDetailKey(String movementId) =>
      'admin-$assetMovementDetail-$movementId';
  static String getAdminCategoryDetailKey(String categoryId) =>
      'admin-$categoryDetail-$categoryId';
  static String getAdminLocationDetailKey(String locationId) =>
      'admin-$locationDetail-$locationId';
  static String getAdminMaintenanceScheduleDetailKey(String maintenanceId) =>
      'admin-$maintenanceScheduleDetail-$maintenanceId';
  static String getAdminMaintenanceRecordDetailKey(String maintenanceId) =>
      'admin-$maintenanceRecordDetail-$maintenanceId';
  static String getAdminIssueReportDetailKey(String issueReportId) =>
      'admin-$issueReportDetail-$issueReportId';
  static String getAdminNotificationDetailKey(String notificationId) =>
      'admin-$notificationDetail-$notificationId';
  static String getAdminScanLogDetailKey(String scanLogId) =>
      'admin-$scanLogDetail-$scanLogId';
  static String getAdminUserDetailKey(String userId) =>
      'admin-$userDetail-$userId';

  // Admin Upsert Pages Helpers
  static String getAdminAssetUpsertKey(String? assetId) =>
      assetId != null ? 'admin-asset-upsert-$assetId' : 'admin-asset-upsert';
  static String getAdminAssetMovementUpsertKey(String? movementId) =>
      movementId != null
      ? 'admin-asset-movement-upsert-$movementId'
      : 'admin-asset-movement-upsert';
  static String getAdminCategoryUpsertKey(String? categoryId) =>
      categoryId != null
      ? 'admin-category-upsert-$categoryId'
      : 'admin-category-upsert';
  static String getAdminLocationUpsertKey(String? locationId) =>
      locationId != null
      ? 'admin-location-upsert-$locationId'
      : 'admin-location-upsert';

  static String getAdminMaintenanceScheduleUpsertKey(String? maintenanceId) =>
      maintenanceId != null
      ? 'admin-maintenance-schedule-upsert-$maintenanceId'
      : 'admin-maintenance-schedule-upsert';

  static String getAdminMaintenanceRecordUpsertKey(String? maintenanceId) =>
      maintenanceId != null
      ? 'admin-maintenance-record-upsert-$maintenanceId'
      : 'admin-maintenance-record-upsert';

  static String getAdminIssueReportUpsertKey(String? issueReportId) =>
      issueReportId != null
      ? 'admin-issue-report-upsert-$issueReportId'
      : 'admin-issue-report-upsert';
  static String getAdminUserUpsertKey(String? userId) =>
      userId != null ? 'admin-user-upsert-$userId' : 'admin-user-upsert';
}
