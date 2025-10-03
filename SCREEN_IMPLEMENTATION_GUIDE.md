# Screen Implementation Guide

## Screen Types & Implementation

### 1. Screen dengan UserShell (Bottom Navigation)
**3 screen utama yang selalu memiliki bottom nav:**
- Home (`/`)
- Scan Asset (`/scan-asset`)
- User Detail Profile (`/profile`)

#### Struktur Screen di Dalam Shell:
```dart
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.home),
        // AppBar properties lainnya
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Content screen Anda
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(...), // Optional
    );
  }
}
```

**⚠️ PENTING:**
- Screen di dalam shell **TETAP MENGGUNAKAN SCAFFOLD**
- UserShell sudah menyediakan bottom navigation via `bottomNavigationBar`
- Screen hanya perlu fokus ke `appBar` dan `body` nya saja
- UserShell akan wrap Scaffold Anda, jadi struktur lengkapnya:
  ```
  UserShell
  └── Scaffold (dari UserShell)
      ├── body: HomeScreen widget
      │   └── Scaffold (dari HomeScreen)
      │       ├── appBar: AppBar Anda
      │       └── body: Content Anda
      └── bottomNavigationBar: NavigationBar (dari UserShell)
  ```

### 2. Screen Fullscreen (Tanpa Bottom Nav)
**Screen secondary/detail yang tidak butuh persistent navigation:**
- My Assets (`/my-assets`)
- My Notifications (`/my-notifications`)
- Asset Detail (`/asset/:id`)
- Category Detail, Location Detail, dll

#### Struktur Screen Fullscreen:
```dart
class MyListAssetsScreen extends StatelessWidget {
  const MyListAssetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.myAssets),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.beamBack(),
        ),
      ),
      body: SafeArea(
        child: // Your content
      ),
    );
  }
}
```

**Karakteristik:**
- Punya tombol back di AppBar
- Tidak ada bottom navigation
- Full screen untuk maximize space
- Biasanya untuk detail, list management, atau form

## Architecture Flow

### User Navigation Flow:
```
┌─────────────────────────────────────────────┐
│  UserShell (Persistent Bottom Navigation)   │
├─────────────────────────────────────────────┤
│  [Home]  [Scan Asset]  [Profile]            │
└─────────────────────────────────────────────┘
          │                │            │
          ▼                ▼            ▼
    HomeScreen    ScanAssetScreen  ProfileScreen
    (Scaffold)       (Scaffold)      (Scaffold)
          │
          └──> Navigate to /my-assets
                    │
                    ▼
            MyListAssetsScreen
            (Fullscreen Scaffold)
            (Has back button)
```

## Best Practices

### ✅ DO:
1. **Screen di dalam shell tetap pakai Scaffold lengkap**
   ```dart
   class HomeScreen extends StatelessWidget {
     @override
     Widget build(BuildContext context) {
       return Scaffold(
         appBar: AppBar(...),
         body: ...,
         floatingActionButton: ..., // OK!
       );
     }
   }
   ```

2. **Gunakan theme extensions untuk styling**
   ```dart
   AppBar(
     backgroundColor: context.colorScheme.surface,
     title: Text(
       context.l10n.home,
       style: context.textTheme.titleLarge,
     ),
   )
   ```

3. **Screen fullscreen harus punya back navigation**
   ```dart
   AppBar(
     leading: IconButton(
       icon: const Icon(Icons.arrow_back),
       onPressed: () => context.beamBack(),
     ),
   )
   ```

### ❌ DON'T:
1. **Jangan set bottomNavigationBar di screen yang ada di shell**
   ```dart
   // ❌ SALAH - UserShell sudah handle ini
   Scaffold(
     bottomNavigationBar: NavigationBar(...),
   )
   ```

2. **Jangan pakai warna statis**
   ```dart
   // ❌ SALAH
   Container(color: Colors.blue)

   // ✅ BENAR
   Container(color: context.colorScheme.primary)
   ```

3. **Jangan hardcode string**
   ```dart
   // ❌ SALAH
   Text('Home')

   // ✅ BENAR
   Text(context.l10n.home)
   ```

## Example: Complete Screen Implementation

### Home Screen (Dengan Bottom Nav)
```dart
import 'package:flutter/material.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/core/extensions/localization_extension.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.home),
        backgroundColor: context.colorScheme.surface,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.welcome,
                style: context.textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),
              // Your widgets here
              ElevatedButton(
                onPressed: () {
                  // Navigate to fullscreen page
                  context.toMyAssets();
                },
                child: Text(context.l10n.viewMyAssets),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### My Assets Screen (Fullscreen)
```dart
import 'package:flutter/material.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/core/extensions/localization_extension.dart';


class MyListAssetsScreen extends StatelessWidget {
  const MyListAssetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.myAssets),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.beamBack(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Show filter
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text('Asset ${index + 1}'),
              subtitle: Text('Details...'),
              onTap: () {
                // Navigate to asset detail
                context.toAssetDetail('asset-id-$index');
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new asset
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

## Summary

| Aspect | With UserShell | Fullscreen |
|--------|----------------|------------|
| Bottom Nav | ✅ Yes | ❌ No |
| Scaffold | ✅ Yes | ✅ Yes |
| AppBar | ✅ Yes | ✅ Yes (with back) |
| Use Case | Main 3 screens | Secondary/Detail screens |
| Navigation | Via bottom nav | Via back button |

**Key Takeaway**: Screen di dalam shell tetap implementasinya normal (ada Scaffold, AppBar, body, dll). UserShell hanya menambahkan persistent bottom navigation, tidak mengubah cara Anda membuat screen.
