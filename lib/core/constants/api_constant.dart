class ApiConstant {
  ApiConstant._();

  static const String baseUrl =
      'https://rizz-inventory-api.up.railway.app/api/v1';
  static const int defaultReceiveTimeout = 30000;
  static const int defaultConnectTimeout = 30000;

  // * Prefixes
  static const String authPrefix = '$baseUrl/auth';
  static const String userPrefix = '$baseUrl/users';
  static const String categoryPrefix = '$baseUrl/categories';
  static const String locationPrefix = '$baseUrl/locations';
  static const String assetPrefix = '$baseUrl/assets';
  static const String scanLogPrefix = '$baseUrl/scan-logs';
  static const String notificationPrefix = '$baseUrl/notifications';
  static const String issueReportPrefix = '$baseUrl/issue-reports';
  static const String assetMovementPrefix = '$baseUrl/asset-movements';
  static const String maintenanceRecordPrefix = '$baseUrl/maintenance/records';
  static const String maintenanceSchedulePrefix =
      '$baseUrl/maintenance/schedules';

  // * Authentication
  static const String authRegister = '$authPrefix/register';
  static const String authLogin = '$authPrefix/login';
  static const String authForgotPassword = '$authPrefix/forgot-password';

  // * Users
  static const String createUser = userPrefix;
  static const String getUsers = userPrefix;
  static const String getUsersStatistics = '$userPrefix/statistics';
  static const String getUsersCursor = '$userPrefix/cursor';
  static const String countUsers = '$userPrefix/count';
  static const String getUserProfile = '$userPrefix/profile';
  static const String updateUserProfile = '$userPrefix/profile';
  static String getUserByName(String name) => '$userPrefix/name/$name';
  static String getUserByEmail(String email) => '$userPrefix/email/$email';
  static String checkUserNameExists(String name) =>
      '$userPrefix/check/name/$name';
  static String checkUserEmailExists(String email) =>
      '$userPrefix/check/email/$email';
  static String checkUserExists(String id) => '$userPrefix/check/$id';
  static String getUserById(String id) => '$userPrefix/$id';
  static String updateUser(String id) => '$userPrefix/$id';
  static String deleteUser(String id) => '$userPrefix/$id';
  static String changeUserPassword(String id) => '$userPrefix/$id/password';
  static const String changeCurrentUserPassword =
      '$userPrefix/profile/password';

  // * Categories
  static const String createCategory = categoryPrefix;
  static const String getCategories = categoryPrefix;
  static const String getCategoriesStatistics = '$categoryPrefix/statistics';
  static const String getCategoriesCursor = '$categoryPrefix/cursor';
  static const String countCategories = '$categoryPrefix/count';
  static String getCategoryByCode(String code) => '$categoryPrefix/code/$code';
  static String checkCategoryCodeExists(String code) =>
      '$categoryPrefix/check/code/$code';
  static String checkCategoryExists(String id) => '$categoryPrefix/check/$id';
  static String getCategoryById(String id) => '$categoryPrefix/$id';
  static String updateCategory(String id) => '$categoryPrefix/$id';
  static String deleteCategory(String id) => '$categoryPrefix/$id';

  // * Locations
  static const String createLocation = locationPrefix;
  static const String getLocations = locationPrefix;
  static const String getLocationsStatistics = '$locationPrefix/statistics';
  static const String getLocationsCursor = '$locationPrefix/cursor';
  static const String countLocations = '$locationPrefix/count';
  static String getLocationByCode(String code) => '$locationPrefix/code/$code';
  static String checkLocationCodeExists(String code) =>
      '$locationPrefix/check/code/$code';
  static String checkLocationExists(String id) => '$locationPrefix/check/$id';
  static String getLocationById(String id) => '$locationPrefix/$id';
  static String updateLocation(String id) => '$locationPrefix/$id';
  static String deleteLocation(String id) => '$locationPrefix/$id';

  // * Assets
  static const String createAsset = assetPrefix;
  static const String getAssets = assetPrefix;
  static const String getAssetsStatistics = '$assetPrefix/statistics';
  static const String getAssetsCursor = '$assetPrefix/cursor';
  static const String countAssets = '$assetPrefix/count';
  static String getAssetByTag(String tag) => '$assetPrefix/tag/$tag';
  static String checkAssetTagExists(String tag) =>
      '$assetPrefix/check/tag/$tag';
  static String checkAssetSerialExists(String serial) =>
      '$assetPrefix/check/serial/$serial';
  static String checkAssetExists(String id) => '$assetPrefix/check/$id';
  static String getAssetById(String id) => '$assetPrefix/$id';
  static String updateAsset(String id) => '$assetPrefix/$id';
  static String deleteAsset(String id) => '$assetPrefix/$id';
  static const String generateAssetTagSuggestion = '$assetPrefix/generate-tag';
  static const String exportAssetList = '$assetPrefix/export/list';

  // * Scan Logs
  static const String createScanLog = scanLogPrefix;
  static const String getScanLogs = scanLogPrefix;
  static const String getScanLogsStatistics = '$scanLogPrefix/statistics';
  static const String getScanLogsCursor = '$scanLogPrefix/cursor';
  static const String countScanLogs = '$scanLogPrefix/count';
  static String getScanLogsByUserId(String userId) =>
      '$scanLogPrefix/user/$userId';
  static String getScanLogsByAssetId(String assetId) =>
      '$scanLogPrefix/asset/$assetId';
  static String checkScanLogExists(String id) => '$scanLogPrefix/check/$id';
  static String getScanLogById(String id) => '$scanLogPrefix/$id';
  static String deleteScanLog(String id) => '$scanLogPrefix/$id';

  // * Notifications
  static const String createNotification = notificationPrefix;
  static const String getNotifications = notificationPrefix;
  static const String getNotificationsStatistics =
      '$notificationPrefix/statistics';
  static const String getNotificationsCursor = '$notificationPrefix/cursor';
  static const String countNotifications = '$notificationPrefix/count';
  static String checkNotificationExists(String id) =>
      '$notificationPrefix/check/$id';
  static String getNotificationById(String id) => '$notificationPrefix/$id';
  static String markNotificationAsRead(String id) =>
      '$notificationPrefix/$id/read';
  static String markNotificationAsUnread(String id) =>
      '$notificationPrefix/$id/unread';
  static const String markAllNotificationsAsRead =
      '$notificationPrefix/mark-all-read';
  static String updateNotification(String id) => '$notificationPrefix/$id';
  static String deleteNotification(String id) => '$notificationPrefix/$id';

  // * Issue Reports
  static const String createIssueReport = issueReportPrefix;
  static const String getIssueReports = issueReportPrefix;
  static const String getIssueReportsStatistics =
      '$issueReportPrefix/statistics';
  static const String getIssueReportsCursor = '$issueReportPrefix/cursor';
  static const String countIssueReports = '$issueReportPrefix/count';
  static String checkIssueReportExists(String id) =>
      '$issueReportPrefix/check/$id';
  static String getIssueReportById(String id) => '$issueReportPrefix/$id';
  static String updateIssueReport(String id) => '$issueReportPrefix/$id';
  static String resolveIssueReport(String id) =>
      '$issueReportPrefix/$id/resolve';
  static String reopenIssueReport(String id) => '$issueReportPrefix/$id/reopen';
  static String deleteIssueReport(String id) => '$issueReportPrefix/$id';

  // * Asset Movements
  static const String createAssetMovement = assetMovementPrefix;
  static const String getAssetMovements = assetMovementPrefix;
  static const String getAssetMovementsStatistics =
      '$assetMovementPrefix/statistics';
  static const String getAssetMovementsCursor = '$assetMovementPrefix/cursor';
  static const String countAssetMovements = '$assetMovementPrefix/count';
  static String checkAssetMovementExists(String id) =>
      '$assetMovementPrefix/check/$id';
  static String getAssetMovementsByAssetId(String assetId) =>
      '$assetMovementPrefix/asset/$assetId';
  static String getAssetMovementById(String id) => '$assetMovementPrefix/$id';
  static String updateAssetMovement(String id) => '$assetMovementPrefix/$id';
  static String deleteAssetMovement(String id) => '$assetMovementPrefix/$id';

  // * Maintenance Records
  static const String createMaintenanceRecord = maintenanceRecordPrefix;
  static const String getMaintenanceRecords = maintenanceRecordPrefix;
  static const String getMaintenanceRecordsCursor =
      '$maintenanceRecordPrefix/cursor';
  static const String countMaintenanceRecords =
      '$maintenanceRecordPrefix/count';
  static String checkMaintenanceRecordExists(String id) =>
      '$maintenanceRecordPrefix/check/$id';
  static const String getMaintenanceRecordsStatistics =
      '$maintenanceRecordPrefix/statistics';
  static String getMaintenanceRecordById(String id) =>
      '$maintenanceRecordPrefix/$id';
  static String updateMaintenanceRecord(String id) =>
      '$maintenanceRecordPrefix/$id';
  static String deleteMaintenanceRecord(String id) =>
      '$maintenanceRecordPrefix/$id';

  // * Maintenance Schedules
  static const String createMaintenanceSchedule = maintenanceSchedulePrefix;
  static const String getMaintenanceSchedules = maintenanceSchedulePrefix;
  static const String getMaintenanceSchedulesCursor =
      '$maintenanceSchedulePrefix/cursor';
  static const String countMaintenanceSchedules =
      '$maintenanceSchedulePrefix/count';
  static String checkMaintenanceScheduleExists(String id) =>
      '$maintenanceSchedulePrefix/check/$id';
  static const String getMaintenanceSchedulesStatistics =
      '$maintenanceSchedulePrefix/statistics';
  static String getMaintenanceScheduleById(String id) =>
      '$maintenanceSchedulePrefix/$id';
  static String updateMaintenanceSchedule(String id) =>
      '$maintenanceSchedulePrefix/$id';
  static String deleteMaintenanceSchedule(String id) =>
      '$maintenanceSchedulePrefix/$id';
}
