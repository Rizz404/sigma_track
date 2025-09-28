// Route constants for the app
// Add new route constants here when adding new screens
//
// NAVIGATION STRUCTURE:
//
// USER BOTTOM NAVIGATION (3 tabs):
// - Home Screen (homeRoute)
// - Scan Asset Screen (scanAssetRoute)
// - Profile Screen (profileRoute)
//
// ADMIN BOTTOM NAVIGATION (3 tabs):
// - Dashboard Screen (dashboardRoute)
// - Scan Log List Screen (adminScanLogListRoute)
// - Profile Screen (profileRoute)
//
// LOGIN REDIRECT:
// - User -> Home Screen after successful login
// - Admin -> Dashboard Screen after successful login
//
// ROUTE CATEGORIES:
// - /admin/* = Admin-only routes
// - /user/* = User-specific routes
// - Other routes = Shared between admin and user

// Auth Routes
const String loginRoute = '/login';
const String registerRoute = '/register';
const String forgotPasswordRoute = '/forgot-password';

// Main Routes
const String homeRoute = '/home';
const String dashboardRoute = '/dashboard';

// Profile Routes
const String profileRoute = '/profile';
const String editProfileRoute = '/edit-profile';

// Asset Routes
const String scanAssetRoute = '/scan-asset';
const String assetDetailRoute = '/asset-detail';
// Admin Asset Routes
const String adminAssetListRoute = '/admin/assets';
// User Asset Routes
const String userAssetListRoute = '/user/assets';

// Asset Movement Routes
const String assetMovementDetailRoute = '/asset-movement-detail';
const String assetMovementUpsertRoute = '/asset-movement-upsert';
// Admin Asset Movement Routes
const String adminAssetMovementListRoute = '/admin/asset-movements';

// Category Routes
const String categoryDetailRoute = '/category-detail';
const String categoryUpsertRoute = '/category-upsert';
// Admin Category Routes
const String adminCategoryListRoute = '/admin/categories';

// Issue Report Routes
const String issueReportDetailRoute = '/issue-report-detail';
const String issueReportUpsertRoute = '/issue-report-upsert';
// Admin Issue Report Routes
const String adminIssueReportListRoute = '/admin/issue-reports';

// Location Routes
const String locationDetailRoute = '/location-detail';
const String locationUpsertRoute = '/location-upsert';
// Admin Location Routes
const String adminLocationListRoute = '/admin/locations';

// Maintenance Routes
const String maintenanceDetailRoute = '/maintenance-detail';
const String maintenanceUpsertRoute = '/maintenance-upsert';
// Admin Maintenance Routes
const String adminMaintenanceListRoute = '/admin/maintenance';

// Notification Routes
const String notificationDetailRoute = '/notification-detail';
// Admin Notification Routes
const String adminNotificationListRoute = '/admin/notifications';
// User Notification Routes
const String userNotificationListRoute = '/user/notifications';

// Scan Log Routes
const String scanLogDetailRoute = '/scan-log-detail';
// Admin Scan Log Routes
const String adminScanLogListRoute = '/admin/scan-logs';

// User Routes
const String userDetailRoute = '/user-detail';
const String userUpsertRoute = '/user-upsert';
// Admin User Routes
const String adminUserListRoute = '/admin/users';
