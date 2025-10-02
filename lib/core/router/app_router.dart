import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:sigma_track/core/constants/route_constant.dart';
import 'package:sigma_track/core/router/admin_location.dart';
import 'package:sigma_track/core/router/auth_location.dart';
import 'package:sigma_track/core/router/user_location.dart';

class AppRouter {
  static BeamerDelegate createRouterDelegate({
    required bool Function() isAuthenticated,
    required bool Function() isAdmin,
  }) {
    return BeamerDelegate(
      initialPath: RouteConstant.home,
      locationBuilder: BeamerLocationBuilder(
        beamLocations: [AuthLocation(), UserLocation(), AdminLocation()],
      ),
      guards: [
        BeamGuard(
          pathPatterns: [
            RouteConstant.login,
            RouteConstant.register,
            RouteConstant.forgotPassword,
          ],
          guardNonMatching: true,
          check: (context, location) => isAuthenticated(),
          beamToNamed: (origin, target) => RouteConstant.login,
        ),
        BeamGuard(
          pathPatterns: [RouteConstant.admin + '/*'],
          check: (context, location) => isAdmin(),
          beamToNamed: (origin, target) => RouteConstant.home,
        ),
      ],
    );
  }
}

extension BeamerNavigationExtension on BuildContext {
  void navigateTo(String path, {Object? data}) {
    beamToNamed(path, data: data);
  }

  void navigateToReplacement(String path, {Object? data}) {
    beamToReplacementNamed(path, data: data);
  }

  void navigateBack() {
    final beamer = Beamer.of(this);
    if (beamer.canBeamBack) {
      beamer.beamBack();
    }
  }

  Future<bool> pop() {
    return Beamer.of(this).popRoute();
  }

  // Auth
  void toLogin() => navigateTo(RouteConstant.login);
  void toRegister() => navigateTo(RouteConstant.register);
  void toForgotPassword() => navigateTo(RouteConstant.forgotPassword);

  // User
  void toHome() => navigateTo(RouteConstant.home);
  void toProfile() => navigateTo(RouteConstant.profile);
  void toEditProfile() => navigateTo(RouteConstant.editProfile);
  void toScanAsset() => navigateTo(RouteConstant.scanAsset);
  void toMyAssets() => navigateTo(RouteConstant.myAssets);
  void toMyNotifications() => navigateTo(RouteConstant.myNotifications);

  // Admin
  void toAdminDashboard() => navigateTo(RouteConstant.adminDashboard);
  void toAdminAssets() => navigateTo(RouteConstant.adminAssets);
  void toAdminAssetUpsert({String? assetId}) => navigateTo(
    assetId != null
        ? RouteConstant.getAdminAssetDetailPath(assetId)
        : RouteConstant.adminAssetUpsert,
  );
  void toAdminAssetMovements() => navigateTo(RouteConstant.adminAssetMovements);
  void toAdminCategories() => navigateTo(RouteConstant.adminCategories);
  void toAdminLocations() => navigateTo(RouteConstant.adminLocations);
  void toAdminUsers() => navigateTo(RouteConstant.adminUsers);
  void toAdminUserUpsert({String? userId}) => navigateTo(
    userId != null
        ? RouteConstant.getAdminUserDetailPath(userId)
        : RouteConstant.adminUserUpsert,
  );
  void toAdminMaintenances() => navigateTo(RouteConstant.adminMaintenances);
  void toAdminIssueReports() => navigateTo(RouteConstant.adminIssueReports);
  void toAdminScanLogs() => navigateTo(RouteConstant.adminScanLogs);
  void toAdminNotifications() => navigateTo(RouteConstant.adminNotifications);

  // Admin Detail Routes
  void toAdminAssetDetail(String assetId) =>
      navigateTo(RouteConstant.getAdminAssetDetailPath(assetId));
  void toAdminAssetMovementDetail(String movementId) =>
      navigateTo(RouteConstant.getAdminAssetMovementDetailPath(movementId));
  void toAdminAssetMovementUpsert({String? movementId}) => navigateTo(
    movementId != null
        ? RouteConstant.getAdminAssetMovementDetailPath(movementId)
        : RouteConstant.adminAssetMovementUpsert,
  );
  void toAdminCategoryDetail(String categoryId) =>
      navigateTo(RouteConstant.getAdminCategoryDetailPath(categoryId));
  void toAdminCategoryUpsert({String? categoryId}) => navigateTo(
    categoryId != null
        ? RouteConstant.getAdminCategoryDetailPath(categoryId)
        : RouteConstant.adminCategoryUpsert,
  );
  void toAdminLocationDetail(String locationId) =>
      navigateTo(RouteConstant.getAdminLocationDetailPath(locationId));
  void toAdminLocationUpsert({String? locationId}) => navigateTo(
    locationId != null
        ? RouteConstant.getAdminLocationDetailPath(locationId)
        : RouteConstant.adminLocationUpsert,
  );
  void toAdminMaintenanceDetail(String maintenanceId) =>
      navigateTo(RouteConstant.getAdminMaintenanceDetailPath(maintenanceId));
  void toAdminMaintenanceUpsert({String? maintenanceId}) => navigateTo(
    maintenanceId != null
        ? RouteConstant.getAdminMaintenanceDetailPath(maintenanceId)
        : RouteConstant.adminMaintenanceUpsert,
  );
  void toAdminIssueReportDetail(String issueReportId) =>
      navigateTo(RouteConstant.getAdminIssueReportDetailPath(issueReportId));
  void toAdminIssueReportUpsert({String? issueReportId}) => navigateTo(
    issueReportId != null
        ? RouteConstant.getAdminIssueReportDetailPath(issueReportId)
        : RouteConstant.adminIssueReportUpsert,
  );
  void toAdminNotificationDetail(String notificationId) =>
      navigateTo(RouteConstant.getAdminNotificationDetailPath(notificationId));
  void toAdminScanLogDetail(String scanLogId) =>
      navigateTo(RouteConstant.getAdminScanLogDetailPath(scanLogId));
  void toAdminUserDetail(String userId) =>
      navigateTo(RouteConstant.getAdminUserDetailPath(userId));

  // User Detail Routes
  void toAssetDetail(String assetId) =>
      navigateTo(RouteConstant.getAssetDetailPath(assetId));
  void toAssetMovementDetail(String movementId) =>
      navigateTo(RouteConstant.getAssetMovementDetailPath(movementId));
  void toAssetMovementUpsert({String? movementId}) => navigateTo(
    movementId != null
        ? RouteConstant.getAssetMovementDetailPath(movementId)
        : RouteConstant.assetMovementUpsert,
  );
  void toCategoryDetail(String categoryId) =>
      navigateTo(RouteConstant.getCategoryDetailPath(categoryId));
  void toCategoryUpsert({String? categoryId}) => navigateTo(
    categoryId != null
        ? RouteConstant.getCategoryDetailPath(categoryId)
        : RouteConstant.categoryUpsert,
  );
  void toLocationDetail(String locationId) =>
      navigateTo(RouteConstant.getLocationDetailPath(locationId));
  void toLocationUpsert({String? locationId}) => navigateTo(
    locationId != null
        ? RouteConstant.getLocationDetailPath(locationId)
        : RouteConstant.locationUpsert,
  );
  void toMaintenanceDetail(String maintenanceId) =>
      navigateTo(RouteConstant.getMaintenanceDetailPath(maintenanceId));
  void toMaintenanceUpsert({String? maintenanceId}) => navigateTo(
    maintenanceId != null
        ? RouteConstant.getMaintenanceDetailPath(maintenanceId)
        : RouteConstant.maintenanceUpsert,
  );
  void toIssueReportDetail(String issueReportId) =>
      navigateTo(RouteConstant.getIssueReportDetailPath(issueReportId));
  void toIssueReportUpsert({String? issueReportId}) => navigateTo(
    issueReportId != null
        ? RouteConstant.getIssueReportDetailPath(issueReportId)
        : RouteConstant.issueReportUpsert,
  );
  void toNotificationDetail(String notificationId) =>
      navigateTo(RouteConstant.getNotificationDetailPath(notificationId));
  void toScanLogDetail(String scanLogId) =>
      navigateTo(RouteConstant.getScanLogDetailPath(scanLogId));
  void toUserDetail(String userId) =>
      navigateTo(RouteConstant.getUserDetailPath(userId));
}
