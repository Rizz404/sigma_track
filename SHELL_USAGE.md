# Shell Widgets Usage Guide

## Overview
`UserShell` dan `AdminShell` adalah wrapper widgets yang menyediakan persistent navigation untuk user dan admin roles.

## Features
- **Auto route detection**: Otomatis highlight menu aktif berdasarkan route Beamer
- **Stateless**: Tidak perlu manage state manual untuk selectedIndex
- **i18n ready**: Menggunakan localization untuk label navigation
- **Theme-aware**: Menggunakan Material 3 NavigationBar/NavigationRail

## Implementation

### 1. UserShell (Bottom Navigation)
Digunakan untuk user biasa dengan 3 menu utama:
- Home
- Scan Asset
- Profile

**Lokasi**: `lib/shared/presentation/widgets/user_shell.dart`
**Sudah diterapkan di**: `lib/core/router/user_location.dart`

### 2. AdminShell (Navigation Rail)
Digunakan untuk admin dengan sidebar navigation:
- Dashboard
- Scan Asset
- Profile

**Lokasi**: `lib/shared/presentation/widgets/admin_shell.dart`
**Sudah diterapkan di**: `lib/core/router/admin_location.dart`

## How It Works

### UserLocation (user_location.dart)
```dart
BeamPage(
  key: const ValueKey('home'),
  title: 'Home - Sigma Track',
  child: UserShell(
    child: Builder(
      builder: (context) {
        // Route switching logic
        if (state.uri.path == RouteConstant.scanAsset) {
          return const ScanAssetScreen();
        } else if (state.uri.path == RouteConstant.userDetailProfile) {
          return const UserDetailProfileScreen();
        }
        // Default: Home
        return const HomeScreen();
      },
    ),
  ),
)
```

### AdminLocation (admin_location.dart)
```dart
BeamPage(
  key: const ValueKey('admin-dashboard'),
  title: 'Admin Dashboard - Sigma Track',
  child: AdminShell(
    child: Builder(
      builder: (context) {
        // Route switching logic
        if (state.uri.path == RouteConstant.adminScanAsset) {
          return const ScanAssetScreen();
        } else if (state.uri.path == RouteConstant.adminUserDetailProfile) {
          return const UserDetailProfileScreen();
        }
        // Default: Dashboard
        return const DashboardScreen();
      },
    ),
  ),
)
```

## Key Points

### ✅ Routes with Shell (Persistent Navigation)
- `/` - Home (UserShell)
- `/scan-asset` - Scan Asset (UserShell)
- `/profile` - User Profile (UserShell)
- `/admin` - Dashboard (AdminShell)
- `/admin/scan-asset` - Admin Scan Asset (AdminShell)
- `/admin/profile` - Admin Profile (AdminShell)

### ⚠️ Routes without Shell (Fullscreen)
Secondary/detail screens yang butuh lebih banyak ruang tidak menggunakan shell:

**User Routes:**
- `/my-assets` - My Assets List (Fullscreen)
- `/my-notifications` - My Notifications (Fullscreen)
- `/asset/:id` - Asset Detail (Fullscreen)
- Detail screens lainnya (category, location, maintenance, dll)

**Admin Routes:**
- `/admin/assets` - Assets Management (Fullscreen)
- `/admin/users` - Users Management (Fullscreen)
- `/admin/categories` - Categories Management (Fullscreen)
- Management screens lainnya

## Benefits
1. **Konsistensi UI**: Navigation selalu visible untuk main routes
2. **Better UX**: User tidak perlu mencari cara untuk navigate
3. **Auto-detection**: Selected menu otomatis ter-highlight
4. **Easy maintenance**: Cukup update di 1 tempat (shell widget)

## Screen Implementation
**PENTING**: Screen di dalam shell tetap menggunakan Scaffold lengkap (AppBar, body, dll).

```dart
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.home)),
      body: YourContent(),
      // floatingActionButton, drawer, dll tetap bisa dipakai
    );
  }
}
```

UserShell/AdminShell hanya menambahkan persistent navigation, tidak mengubah cara Anda membuat screen.

📖 **Lihat**: `SCREEN_IMPLEMENTATION_GUIDE.md` untuk detail lengkap dan contoh.

## Localization Keys Used
```json
{
  "home": "Home",
  "dashboard": "Dashboard",
  "scanAsset": "Scan Asset",
  "profile": "Profile"
}
```

Sudah ditambahkan di:
- `lib/l10n/app_en.arb` (English)
- `lib/l10n/app_id.arb` (Indonesian)
- `lib/l10n/app_ja.arb` (Japanese)
