# Router Implementation Status

## Overview
Semua route dari `RouteConstant` sudah ditambahkan ke `UserLocation` dan `AdminLocation`.

## Implementation Status

### ✅ FULLY IMPLEMENTED (Ready to Use)

#### User Routes (with UserShell - Bottom Nav):
- `/` - HomeScreen
- `/scan-asset` - ScanAssetScreen
- `/user/profile/detail` - UserDetailProfileScreen

#### User Routes (Fullscreen - No Nav):
- `/my-assets` - MyListAssetsScreen
- `/my-notifications` - MyListNotificationsScreen

#### Admin Routes (with AdminShell - Navigation Rail):
- `/admin` or `/admin/dashboard` - DashboardScreen
- `/admin/scan-asset` - ScanAssetScreen
- `/admin/user/profile/detail` - UserDetailProfileScreen

#### Admin Routes (Fullscreen - List Management):
- `/admin/assets` - ListAssetsScreen
- `/admin/asset/upsert` - AssetUpsertScreen
- `/admin/asset-movements` - ListAssetMovementsScreen
- `/admin/categories` - ListCategoriesScreen
- `/admin/locations` - ListLocationsScreen
- `/admin/users` - ListUsersScreen
- `/admin/user/upsert` - UserUpsertScreen
- `/admin/maintenances` - ListMaintenancesScreen
- `/admin/issue-reports` - ListIssueReportsScreen
- `/admin/scan-logs` - ListScanLogsScreen
- `/admin/notifications` - ListNotificationsScreen

---

### ⚠️ TODO: NEEDS DATA FETCHING IMPLEMENTATION

Route-route berikut sudah terdaftar di router dengan **placeholder** (`Container()`), tapi membutuhkan implementasi data fetching untuk bisa berfungsi.

#### User Detail/Upsert Routes:
1. **User Profile Update**
   - Route: `/user/profile/update`
   - Status: ⚠️ Placeholder
   - TODO: Fetch current user data & pass to `UserUpdateProfileScreen`

2. **Asset Detail**
   - Route: `/asset/:assetId`
   - Status: ⚠️ Placeholder
   - TODO: Fetch asset by `assetId` from API → pass to `AssetDetailScreen`

3. **Asset Movement Detail**
   - Route: `/asset-movement/:movementId`
   - Status: ⚠️ Placeholder
   - TODO: Fetch asset movement by `movementId` → `AssetMovementDetailScreen`

4. **Asset Movement Upsert**
   - Route: `/asset-movement/upsert`
   - Status: ⚠️ Placeholder
   - TODO: Implement create/edit flow → `AssetMovementUpsertScreen`

5. **Category Detail**
   - Route: `/category/:categoryId`
   - Status: ⚠️ Placeholder
   - TODO: Fetch category by `categoryId` → `CategoryDetailScreen`

6. **Category Upsert**
   - Route: `/category/upsert`
   - Status: ⚠️ Placeholder
   - TODO: Implement create/edit flow → `CategoryUpsertScreen`

7. **Location Detail**
   - Route: `/location/:locationId`
   - Status: ⚠️ Placeholder
   - TODO: Fetch location by `locationId` → `LocationDetailScreen`

8. **Location Upsert**
   - Route: `/location/upsert`
   - Status: ⚠️ Placeholder
   - TODO: Implement create/edit flow → `LocationUpsertScreen`

9. **Maintenance Detail**
   - Route: `/maintenance/:maintenanceId`
   - Status: ⚠️ Placeholder
   - TODO: Fetch maintenance by `maintenanceId` → `MaintenanceDetailScreen`

10. **Maintenance Upsert**
    - Route: `/maintenance/upsert`
    - Status: ⚠️ Placeholder
    - TODO: Implement create/edit flow → `MaintenanceUpsertScreen`

11. **Issue Report Detail**
    - Route: `/issue-report/:issueReportId`
    - Status: ⚠️ Placeholder
    - TODO: Fetch issue report by `issueReportId` → `IssueReportDetailScreen`

12. **Issue Report Upsert**
    - Route: `/issue-report/upsert`
    - Status: ⚠️ Placeholder
    - TODO: Implement create/edit flow → `IssueReportUpsertScreen`

13. **Notification Detail**
    - Route: `/notification/:notificationId`
    - Status: ⚠️ Placeholder
    - TODO: Fetch notification by `notificationId` → `NotificationDetailScreen`

14. **Scan Log Detail**
    - Route: `/scan-log/:scanLogId`
    - Status: ⚠️ Placeholder
    - TODO: Fetch scan log by `scanLogId` → `ScanLogDetailScreen`

15. **User Detail**
    - Route: `/user/:userId`
    - Status: ⚠️ Placeholder
    - TODO: Fetch user by `userId` → `UserDetailScreen`

#### Admin Detail/Upsert Routes:
Sama seperti user routes di atas, tapi dengan prefix `/admin`:

1. **Admin User Profile Update** - `/admin/user/profile/update`
2. **Admin Asset Detail** - `/admin/asset/:assetId`
3. **Admin Asset Movement Detail** - `/admin/asset-movement/:movementId`
4. **Admin Asset Movement Upsert** - `/admin/asset-movement/upsert`
5. **Admin Category Detail** - `/admin/category/:categoryId`
6. **Admin Category Upsert** - `/admin/category/upsert`
7. **Admin Location Detail** - `/admin/location/:locationId`
8. **Admin Location Upsert** - `/admin/location/upsert`
9. **Admin Maintenance Detail** - `/admin/maintenance/:maintenanceId`
10. **Admin Maintenance Upsert** - `/admin/maintenance/upsert`
11. **Admin Issue Report Detail** - `/admin/issue-report/:issueReportId`
12. **Admin Issue Report Upsert** - `/admin/issue-report/upsert`
13. **Admin Notification Detail** - `/admin/notification/:notificationId`
14. **Admin Scan Log Detail** - `/admin/scan-log/:scanLogId`
15. **Admin User Detail** - `/admin/user/:userId`

---

## Implementation Guide

### Cara Implementasi Detail Screens

#### Step 1: Prepare Data Provider
Buat provider untuk fetch data berdasarkan ID:

```dart
// Di file: lib/di/repository_providers.dart atau service_providers.dart

final assetByIdProvider = FutureProvider.family<Asset, String>((ref, assetId) async {
  final repository = ref.watch(assetRepositoryProvider);
  return await repository.getAssetById(assetId);
});
```

#### Step 2: Update Router dengan Data Fetching
Ubah placeholder di `user_location.dart` atau `admin_location.dart`:

```dart
// BEFORE (Placeholder):
if (state.pathPatternSegments.contains('asset') &&
    state.pathParameters.containsKey('assetId')) {
  pages.add(
    BeamPage(
      key: ValueKey('asset-detail-${state.pathParameters['assetId']}'),
      title: 'Asset Detail - Sigma Track',
      child: Container(), // ! Placeholder
    ),
  );
}

// AFTER (With Data Fetching):
if (state.pathPatternSegments.contains('asset') &&
    state.pathParameters.containsKey('assetId')) {
  final assetId = state.pathParameters['assetId']!;
  pages.add(
    BeamPage(
      key: ValueKey('asset-detail-$assetId'),
      title: 'Asset Detail - Sigma Track',
      child: Consumer(
        builder: (context, ref, child) {
          final assetAsync = ref.watch(assetByIdProvider(assetId));

          return assetAsync.when(
            data: (asset) => AssetDetailScreen(asset: asset),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => ErrorScreen(error: error),
          );
        },
      ),
    ),
  );
}
```

#### Step 3: Update Screen Constructor
Pastikan screen menerima parameter yang diperlukan:

```dart
class AssetDetailScreen extends ConsumerWidget {
  final Asset asset;

  const AssetDetailScreen({super.key, required this.asset});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(asset.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.beamBack(),
        ),
      ),
      body: // ... detail content
    );
  }
}
```

---

## Route Structure Summary

```
📁 User Routes
├── 🏠 With Bottom Nav (UserShell)
│   ├── / (Home)
│   ├── /scan-asset
│   └── /user/profile/detail
│
├── 📄 Fullscreen (No Nav) - Implemented
│   ├── /my-assets
│   └── /my-notifications
│
└── 📄 Fullscreen (No Nav) - TODO (15 routes)
    ├── /user/profile/update
    ├── /asset/:assetId
    ├── /asset-movement/:movementId
    ├── /asset-movement/upsert
    └── ... (11 more detail/upsert routes)

📁 Admin Routes
├── 🏢 With Navigation Rail (AdminShell)
│   ├── /admin or /admin/dashboard
│   ├── /admin/scan-asset
│   └── /admin/user/profile/detail
│
├── 📊 Fullscreen Management (No Nav) - Implemented
│   ├── /admin/assets
│   ├── /admin/asset/upsert
│   ├── /admin/asset-movements
│   ├── /admin/categories
│   ├── /admin/locations
│   ├── /admin/users
│   ├── /admin/user/upsert
│   ├── /admin/maintenances
│   ├── /admin/issue-reports
│   ├── /admin/scan-logs
│   └── /admin/notifications
│
└── 📄 Fullscreen Detail (No Nav) - TODO (15 routes)
    ├── /admin/user/profile/update
    ├── /admin/asset/:assetId
    ├── /admin/asset-movement/:movementId
    └── ... (12 more detail/upsert routes)
```

---

## Next Steps Priority

1. **High Priority** (Core Functionality):
   - Asset Detail Screen (user & admin)
   - User Update Profile Screen
   - Asset Movement Upsert

2. **Medium Priority**:
   - Category Detail & Upsert
   - Location Detail & Upsert
   - Maintenance Detail & Upsert
   - Issue Report Detail & Upsert

3. **Low Priority** (View Only):
   - Notification Detail
   - Scan Log Detail
   - User Detail (public profile)

---

## Files Modified

- ✅ `lib/core/router/user_location.dart` - All user routes registered
- ✅ `lib/core/router/admin_location.dart` - All admin routes registered
- ✅ `lib/shared/presentation/widgets/user_shell.dart` - Bottom navigation
- ✅ `lib/shared/presentation/widgets/admin_shell.dart` - Navigation rail
- ✅ `lib/l10n/app_*.arb` - Navigation labels (EN, ID, JA)

## Related Documentation

- `SHELL_USAGE.md` - Shell widgets overview
- `SCREEN_IMPLEMENTATION_GUIDE.md` - Screen implementation patterns
- `VISUAL_STRUCTURE.md` - Visual widget tree diagrams
