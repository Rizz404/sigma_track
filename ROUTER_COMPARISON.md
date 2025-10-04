# Router Implementation Comparison

Dokumentasi perbandingan antara 2 pendekatan routing di Sigma Track.

## 📋 Overview

Ada 2 versi implementasi routing authentication:

1. **Current (Router Recreate)** - `auth_providers.dart` + `app_router.dart`
2. **Alternative (RefreshListenable)** - `auth_providers_refresh_listenable.dart`

---

## 🔄 Version 1: Router Recreate (Current)

### File Structure
```
lib/
├── di/
│   └── auth_providers.dart          # authNotifierProvider
│   └── common_providers.dart        # routerProvider
└── core/
    └── router/
        └── app_router.dart          # AppRouter class
```

### How It Works

```dart
// common_providers.dart
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider).valueOrNull;

  final isAuthenticated = authState?.status == AuthStatus.authenticated;
  final isAdmin = authState?.user?.role == UserRole.admin;

  // ⚠️ Router RECREATED setiap auth berubah
  return AppRouter(isAuthenticated: isAuthenticated, isAdmin: isAdmin).router;
});

// app_router.dart
class AppRouter {
  // ✅ NON-STATIC keys (setiap instance punya key sendiri)
  final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  late final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    redirect: _handleRedirect,
    routes: [...],
  );
}
```

### Karakteristik

**✅ Kelebihan:**
- Simple & straightforward
- Mudah dipahami pemula
- Code lebih sedikit
- Tidak perlu ChangeNotifier

**❌ Kekurangan:**
- Router recreate setiap auth state berubah
- Semua widget di-rebuild
- Perlu non-static GlobalKeys untuk avoid conflict
- Kurang optimal untuk performa

### Flow Diagram

```
Auth State Change
    ↓
routerProvider rebuild
    ↓
new AppRouter() instance created
    ↓
new router with NEW GlobalKeys
    ↓
Old router disposed
    ↓
Widget tree rebuild
```

---

## 🚀 Version 2: RefreshListenable (Alternative)

### File Structure
```
lib/
└── di/
    └── auth_providers_refresh_listenable.dart
        ├── authNotifierRefreshListenableProvider
        ├── AuthRouterNotifier (ChangeNotifier)
        └── routerRefreshListenableProvider
```

### How It Works

```dart
// AuthRouterNotifier - Listen auth changes
class AuthRouterNotifier extends ChangeNotifier {
  final Ref _ref;

  AuthRouterNotifier(this._ref) {
    _ref.listen<AsyncValue<AuthState>>(
      authNotifierRefreshListenableProvider,
      (_, __) {
        notifyListeners(); // ✅ Trigger refresh WITHOUT recreate
      },
    );
  }
}

// Router Provider
final routerRefreshListenableProvider = Provider<GoRouter>((ref) {
  final authRouterNotifier = AuthRouterNotifier(ref);

  return GoRouter(
    navigatorKey: appRouter.router.configuration.navigatorKey,
    refreshListenable: authRouterNotifier, // 🔑 KEY DIFFERENCE!
    redirect: (context, state) {
      // Read FRESH auth state setiap redirect triggered
      final currentAuthState =
          ref.read(authNotifierRefreshListenableProvider).valueOrNull;
      // ... redirect logic
    },
    routes: [...],
  );
});
```

### Karakteristik

**✅ Kelebihan:**
- Router hanya dibuat SEKALI (saat app start)
- Tidak ada GlobalKey conflict (keys tidak berubah)
- Hanya redirect logic yang di-refresh
- Lebih performant (minimal rebuild)
- Best practice sesuai GoRouter docs
- Cocok untuk production apps

**❌ Kekurangan:**
- Lebih complex (butuh ChangeNotifier)
- Butuh understanding tentang Listenable pattern
- Code lebih panjang
- Learning curve lebih tinggi

### Flow Diagram

```
Auth State Change
    ↓
AuthRouterNotifier.notifyListeners()
    ↓
GoRouter refresh triggered
    ↓
redirect() callback dipanggil
    ↓
Read FRESH auth state
    ↓
Update route if needed
    ↓
✅ SAME router instance, SAME GlobalKeys
```

---

## 📊 Comparison Table

| Aspect | Router Recreate | RefreshListenable |
|--------|----------------|-------------------|
| **Performa** | ⚠️ Medium (rebuild widget tree) | ✅ High (minimal rebuild) |
| **Complexity** | ✅ Simple | ⚠️ Complex |
| **GlobalKey** | ⚠️ Must be non-static | ✅ Can be static |
| **Router Instance** | ❌ New each auth change | ✅ Single instance |
| **Widget Rebuild** | ❌ Full tree | ✅ Minimal |
| **Code Amount** | ✅ Less | ⚠️ More |
| **Learning Curve** | ✅ Easy | ⚠️ Medium |
| **Production Ready** | ✅ Yes | ✅ Yes (preferred) |
| **GoRouter Best Practice** | ⚠️ Acceptable | ✅ Recommended |

---

## 🔧 How to Switch Between Versions

### Current Setup (Router Recreate)

```dart
// main.dart
final router = ref.watch(routerProvider); // from common_providers.dart

MaterialApp.router(
  routerConfig: router,
  // ...
);

// app_end_drawer.dart
ref.read(authNotifierProvider.notifier).logout();
```

### Switch to RefreshListenable

**Step 1:** Update main.dart
```dart
// main.dart
final router = ref.watch(routerRefreshListenableProvider); // NEW

MaterialApp.router(
  routerConfig: router,
  // ...
);
```

**Step 2:** Update widgets yang pakai auth
```dart
// app_end_drawer.dart - CHANGE PROVIDER
ref.read(authNotifierRefreshListenableProvider.notifier).logout();

// register_screen.dart, login_screen.dart, etc.
ref.listen<AsyncValue<AuthState>>(
  authNotifierRefreshListenableProvider, // CHANGE THIS
  (previous, next) {
    // ... same logic
  },
);
```

**Step 3:** (Optional) Update app_router.dart
```dart
// Bisa ubah ke static keys lagi karena tidak ada recreate
class AppRouter {
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  // ...
}
```

---

## 🎯 Recommendation

### Use Router Recreate When:
- ✅ Prototyping / MVP
- ✅ Small to medium apps
- ✅ Team kurang familiar dengan advanced patterns
- ✅ Simplicity > Performance

### Use RefreshListenable When:
- ✅ Production apps
- ✅ Large apps with complex navigation
- ✅ Performance critical
- ✅ Following best practices
- ✅ Team experienced dengan Flutter

---

## 📝 Notes

1. **Both approaches are valid** - Pilih sesuai kebutuhan project
2. **Current implementation works fine** - Tidak perlu switch jika tidak ada masalah
3. **RefreshListenable is future-proof** - Lebih aligned dengan GoRouter evolution
4. **Easy to migrate** - Bisa switch kapan saja dengan minimal changes

---

## 🔗 References

- [GoRouter Official Docs - Refreshing](https://pub.dev/documentation/go_router/latest/topics/Refreshing-topic.html)
- [Flutter Navigation Best Practices](https://docs.flutter.dev/ui/navigation)
- [Riverpod State Management](https://riverpod.dev/)

---

**Last Updated:** October 4, 2025
**Author:** Sigma Track Team
