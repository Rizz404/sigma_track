# Auth Architecture Documentation

## Overview
Arsitektur auth di aplikasi ini memisahkan concern antara **API Response** dan **Application State** untuk handling authentication yang lebih baik.

## Key Concepts

### 1. LoginResponse (Entity) & LoginResponseModel (Model)
**Purpose:** Merepresentasikan response dari API login
**Location:**
- Entity: `lib/feature/auth/domain/entities/auth.dart`
- Model: `lib/feature/auth/data/models/auth_model.dart`

**Characteristics:**
- ✅ Semua field **required** (never null)
- ✅ Selalu lengkap karena API login pasti return data komplit
- ✅ Digunakan untuk:
  - Return type dari `login()` usecase
  - Return type dari `getCurrentAuth()` (tapi nullable)
  - Data yang disimpan di local storage (terpisah: user, accessToken, refreshToken)

**Fields:**
```dart
class LoginResponse {
  final UserModel user;        // Required
  final String accessToken;    // Required
  final String refreshToken;   // Required
}
```

### 2. AuthState (Presentation State)
**Purpose:** Merepresentasikan state authentication di UI layer
**Location:** `lib/feature/auth/presentation/providers/auth_state.dart`

**Characteristics:**
- ✅ User field **nullable** (`User? user`)
- ✅ Support authenticated & unauthenticated state
- ✅ Digunakan untuk:
  - State management (Riverpod)
  - UI conditional rendering
  - Route guards

**Fields:**
```dart
class AuthState {
  final AuthStatus status;  // authenticated | unauthenticated
  final User? user;         // Nullable - null saat logout
  final String message;
  final bool isError;
}
```

## Flow Diagram

### Login Flow
```
1. User submit login form
   ↓
2. LoginUsecase called
   ↓
3. API returns LoginResponse (always complete)
   ↓
4. Save to local storage:
   - accessToken → FlutterSecureStorage
   - refreshToken → FlutterSecureStorage
   - user → SharedPreferences
   ↓
5. Update AuthState with user data
   ↓
6. UI redirects based on role
```

### Logout Flow
```
1. User clicks logout
   ↓
2. Clear local storage:
   - Delete accessToken
   - Delete refreshToken
   - Delete user
   ↓
3. Update AuthState to unauthenticated (user = null)
   ↓
4. UI redirects to login
```

### App Startup Flow
```
1. App starts
   ↓
2. GetCurrentAuthUsecase called
   ↓
3. Check local storage:
   - accessToken exists?
   - refreshToken exists?
   - user exists?
   ↓
4a. All exist → Return LoginResponse (complete)
    → AuthState.authenticated

4b. Any missing → Return null
    → AuthState.unauthenticated
```

## File Structure

```
lib/feature/auth/
├── data/
│   ├── datasources/
│   │   ├── auth_local_datasource.dart      # Storage: tokens & user
│   │   └── auth_remote_datasource.dart     # API: login, register
│   ├── models/
│   │   └── auth_model.dart                 # LoginResponseModel
│   ├── mapper/
│   │   └── auth_mappers.dart               # Model ↔ Entity conversion
│   ├── repositories/
│   │   └── auth_repository_impl.dart       # Business logic
│   └── services/
│       └── auth_service_impl.dart          # Token management service
├── domain/
│   ├── entities/
│   │   └── auth.dart                       # LoginResponse entity
│   ├── repositories/
│   │   └── auth_repository.dart            # Repository interface
│   └── usecases/
│       ├── login_usecase.dart              # Login flow
│       ├── register_usecase.dart           # Register flow
│       ├── get_current_auth_usecase.dart   # Get stored auth
│       └── forgot_password_usecase.dart    # Forgot password
└── presentation/
    ├── providers/
    │   ├── auth_notifier.dart              # State management
    │   ├── auth_providers.dart             # Riverpod providers
    │   └── auth_state.dart                 # UI state (nullable user)
    └── screens/
        ├── login_screen.dart
        └── register_screen.dart
```

## Why This Architecture?

### ❌ Old Problem
```dart
// Auth entity dengan required fields
class Auth {
  final UserModel user;  // Required
  // ...
}

// Tapi user bisa logout, jadi butuh nullable!
// Conflict: API response vs app state
```

### ✅ Solution
```dart
// LoginResponse: API response (always complete)
class LoginResponse {
  final UserModel user;  // Required - API always return
  final String accessToken;  // Required
  final String refreshToken;  // Required
}

// AuthState: App state (nullable)
class AuthState {
  final User? user;  // Nullable - user could logout
  // ...
}
```

### Benefits
1. **Type Safety**: API response selalu lengkap (required)
2. **Clear Separation**: Response ≠ State
3. **Nullable Support**: State bisa null saat logout
4. **Better Error Handling**: Jelas mana data dari API vs state internal
5. **Maintainability**: Mudah dipahami flow data

## Best Practices

### ✅ DO
- Gunakan `LoginResponse` untuk return type API login
- Gunakan `AuthState` untuk UI state management
- Simpan token terpisah (FlutterSecureStorage untuk keamanan)
- Handle nullable user di AuthState dengan benar
- Check authentication status dari AuthState, bukan LoginResponse

### ❌ DON'T
- Jangan simpan LoginResponse langsung ke state
- Jangan tambahkan token ke UserModel
- Jangan gunakan LoginResponse sebagai global state
- Jangan lupa handle null user di UI

## Example Usage

### Login
```dart
// In AuthNotifier
Future<void> login(LoginUsecaseParams params) async {
  final result = await _loginUsecase.call(params);

  result.fold(
    (failure) => state = AuthState.unauthenticated(...),
    (success) {
      // success.data is LoginResponse (never null)
      state = AuthState.authenticated(
        user: success.data!.user.toEntity(),
        // Token sudah disimpan di repository
      );
    },
  );
}
```

### Check Auth Status
```dart
// In UI
ref.listen<AsyncValue<AuthState>>(authNotifierProvider, (prev, next) {
  next.whenData((state) {
    if (state.status == AuthStatus.authenticated) {
      // User is logged in, state.user is not null
      final userName = state.user!.name;
    } else {
      // User is logged out, state.user is null
    }
  });
});
```

### Get Current Auth
```dart
// In AuthNotifier build (startup)
final result = await _getCurrentAuthUsecase.call(NoParams());

return result.fold(
  (failure) => AuthState.unauthenticated(...),
  (success) {
    // success.data is LoginResponse? (could be null)
    if (success.data == null) {
      return AuthState.unauthenticated(...);
    }
    return AuthState.authenticated(
      user: success.data!.user.toEntity(),
    );
  },
);
```

## Migration Notes

### Changed Files
- ✏️ `auth.dart` → `LoginResponse` (renamed)
- ✏️ `auth_model.dart` → `LoginResponseModel` (renamed)
- ✏️ `auth_mappers.dart` → Updated extension names
- ✏️ `auth_repository.dart` → Updated return types
- ✏️ `auth_repository_impl.dart` → Updated implementation
- ✏️ `login_usecase.dart` → Updated return type
- ✏️ `get_current_auth_usecase.dart` → Updated return type (nullable)
- ✏️ `auth_notifier.dart` → Handle nullable LoginResponse

### Breaking Changes
None for existing UI code! `AuthState` tetap sama, hanya internal implementation yang berubah.

---

**Last Updated:** October 3, 2025
**Author:** Development Team
