import 'package:beamer/beamer.dart';
import 'package:flutter/widgets.dart';
import 'package:sigma_track/core/constants/route_constant.dart';
import 'package:sigma_track/feature/asset/presentation/screens/scan_asset_screen.dart';
import 'package:sigma_track/feature/asset/presentation/screens/user/my_list_assets_screen.dart';
import 'package:sigma_track/feature/home/presentation/screens/user/home_screen.dart';
import 'package:sigma_track/feature/notification/presentation/screens/user/my_list_notifications_screen.dart';
import 'package:sigma_track/feature/user/presentation/screens/user_detail_profile_screen.dart';

/// Handles user-related routes (User-only screens)
class UserLocation extends BeamLocation<BeamState> {
  @override
  List<Pattern> get pathPatterns => [
    RouteConstant.home,
    RouteConstant.scanAsset,
    RouteConstant.myAssets,
    RouteConstant.myNotifications,
    RouteConstant.userDetailProfile,
    RouteConstant.userUpdateProfile,
    RouteConstant.assetDetail,
    RouteConstant.assetMovementDetail,
    RouteConstant.assetMovementUpsert,
    RouteConstant.categoryDetail,
    RouteConstant.categoryUpsert,
    RouteConstant.locationDetail,
    RouteConstant.locationUpsert,
    RouteConstant.maintenanceDetail,
    RouteConstant.maintenanceUpsert,
    RouteConstant.issueReportDetail,
    RouteConstant.issueReportUpsert,
    RouteConstant.notificationDetail,
    RouteConstant.scanLogDetail,
    RouteConstant.userDetail,
  ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final pages = <BeamPage>[
      // Always include home as the base page
      const BeamPage(
        key: ValueKey('home'),
        title: 'Home - Sigma Track',
        child: HomeScreen(),
      ),
    ];

    // ========== USER ONLY ROUTES ==========

    // Scan Asset
    if (state.uri.path == RouteConstant.scanAsset) {
      pages.add(
        const BeamPage(
          key: ValueKey('scan-asset'),
          title: 'Scan Asset - Sigma Track',
          child: ScanAssetScreen(),
        ),
      );
    }

    // User Detail Profile
    if (state.uri.path == RouteConstant.userDetailProfile) {
      pages.add(
        const BeamPage(
          key: ValueKey('user-detail-profile'),
          title: 'My Profile - Sigma Track',
          child: UserDetailProfileScreen(),
        ),
      );
    }

    // My Assets
    if (state.uri.path == RouteConstant.myAssets) {
      pages.add(
        const BeamPage(
          key: ValueKey('my-assets'),
          title: 'My Assets - Sigma Track',
          child: MyListAssetsScreen(),
        ),
      );
    }

    // My Notifications
    if (state.uri.path == RouteConstant.myNotifications) {
      pages.add(
        const BeamPage(
          key: ValueKey('my-notifications'),
          title: 'My Notifications - Sigma Track',
          child: MyListNotificationsScreen(),
        ),
      );
    }

    return pages;
  }
}
