# Auth Architecture Documentation v2

## Overview
Arsitektur auth di aplikasi ini memisahkan concern antara **API Response (LoginResponse)** dan **Application State (Auth)** untuk handling authentication yang lebih clean dan type-safe.

## Key Concepts

### 1. LoginResponse - API Response Entity
**Purpose:** Merepresentasikan response dari API login (one-time use)
**Location:**
- Entity: `lib/feature/auth/domain/entities/login_response.dart`
- Model: `lib/feature/auth/data/models/login_response_model.dart`

**Characteristics:**
- ✅ Semua field **required** (never null)
- ✅ Selalu lengkap karena API login pasti return data komplit
- ✅ Digunakan **HANYA** untuk:
  - Return type dari `login()` usecase
  - One-time response dari API
  - Langsung diconvert ke `Auth` setelah login

**Fields:**
```dart
class LoginResponse {
  final UserModel user;        // Required - dari API
  final String accessToken;    // Required - dari API
  final String refreshToken;   // Required - dari API
}
```

### 2. Auth - Application State Entity ⭐
**Purpose:** Merepresentasikan authentication state aplikasi (persistent state)
**Location:**
- Entity: `lib/feature/auth/domain/entities/auth.dart`
- Model: `lib/feature/auth/data/models/auth_model.dart`

**Characteristics:**
- ✅ Semua field **nullable** (natural support untuk logout!)
- ✅ Punya helper `isAuthenticated` untuk check completeness
- ✅ Digunakan untuk:
  - Return type dari `getCurrentAuth()` usecase ✨
  - State yang disimpan/diambil dari local storage
  - Repository layer untuk handle auth state
  - Bridge ke presentation layer

**Fields:**
```dart
class Auth {
  final UserModel? user;         // Nullable - bisa logout
  final String? accessToken;     // Nullable - bisa expired
  final String? refreshToken;    // Nullable - bisa expired

  // Helper getter
  bool get isAuthenticated =>
      user != null && accessToken != null && refreshToken != null;

  // Named constructor untuk empty state
  const Auth.empty() : user = null, accessToken = null, refreshToken = null;
}
```

### 3. AuthState - Presentation State
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
3. API returns LoginResponse (always complete) ✅
   ↓
4. Save to local storage (separately):
   - accessToken → FlutterSecureStorage
   - refreshToken → FlutterSecureStorage
   - user → SharedPreferences
   ↓
5. Return LoginResponse from usecase
   ↓
6. AuthNotifier converts to AuthState
   ↓
7. UI redirects based on role
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

### App Startup Flow (GetCurrentAuth) ⭐
```
1. App starts
   ↓
2. GetCurrentAuthUsecase called
   ↓
3. Repository mengambil dari local storage:
   - accessToken (nullable)
   - refreshToken (nullable)
   - user (nullable)
   ↓
4. Buat Auth object dengan nullable fields:
   Auth(user: user, accessToken: token, refreshToken: refresh)
   ↓
5a. Auth.isAuthenticated == true
    → AuthState.authenticated ✅

5b. Auth.isAuthenticated == false
    → AuthState.unauthenticated (no error!) ✅
```

## File Structure

```
lib/feature/auth/
├── data/
│   ├── datasources/
│   │   ├── auth_local_datasource.dart      # Storage: tokens & user
│   │   └── auth_remote_datasource.dart     # API: login, register
│   ├── models/
│   │   ├── auth_model.dart                 # AuthModel (nullable) ⭐
│   │   └── login_response_model.dart       # LoginResponseModel (required)
│   ├── mapper/
│   │   └── auth_mappers.dart               # Model ↔ Entity conversion
│   ├── repositories/
│   │   └── auth_repository_impl.dart       # Business logic
│   └── services/
│       └── auth_service_impl.dart          # Token management service
├── domain/
│   ├── entities/
│   │   ├── auth.dart                       # Auth entity (nullable) ⭐
│   │   └── login_response.dart             # LoginResponse entity (required)
│   ├── repositories/
│   │   └── auth_repository.dart            # Repository interface
│   └── usecases/
│       ├── login_usecase.dart              # Login flow → LoginResponse
│       ├── register_usecase.dart           # Register flow
│       ├── get_current_auth_usecase.dart   # Get stored auth → Auth ⭐
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
// Gimana cara represent "not authenticated"?
// - Return null? Type mismatch!
// - Return error? Logout bukan error!
```

### ✅ Solution v1 (Previous)
```dart
// LoginResponse: API response (always complete)
class LoginResponse {
  final UserModel user;  // Required
}

// getCurrentAuth returns LoginResponse?
Future<ItemSuccess<LoginResponse?>> getCurrentAuth();
// Problem: Masih butuh nullable wrapper
```

### ✅ Solution v2 (Current - Best!) ⭐
```dart
// LoginResponse: API response (always complete)
class LoginResponse {
  final UserModel user;  // Required - dari API
}

// Auth: App state (naturally nullable!)
class Auth {
  final UserModel? user;  // Nullable - natural!
  bool get isAuthenticated => user != null && ...;
}

// getCurrentAuth returns Auth (not nullable, tapi fields-nya nullable!)
Future<ItemSuccess<Auth>> getCurrentAuth();
```

### Benefits v2
1. **Natural Nullability**: Auth fields nullable by design, tidak perlu wrapper
2. **No "No auth data" Error**: Return `Auth.empty()` bukan error
3. **Type Safety**: API response tetap required (LoginResponse)
4. **Clear Semantics**:
   - `LoginResponse` = "I just logged in successfully"
   - `Auth` = "Current authentication state (could be empty)"
5. **Better DX**: Mudah digunakan di presentation layer
6. **Consistent**: Satu entity `Auth` untuk semua auth state operations

## Best Practices

### ✅ DO
- Gunakan `LoginResponse` **hanya** untuk return type login API
- Gunakan `Auth` untuk semua auth state operations
- Check `auth.isAuthenticated` untuk validasi lengkap
- Return `Auth` dengan nullable fields dari `getCurrentAuth`
- Simpan token & user terpisah di storage (security best practice)

### ❌ DON'T
- Jangan gunakan `LoginResponse` untuk state management
- Jangan return null/error dari `getCurrentAuth` kalau belum login
- Jangan tambahkan token ke UserModel
- Jangan simpan `LoginResponse` atau `Auth` langsung ke storage
- Jangan lupa handle `!auth.isAuthenticated` di UI

## Example Usage

### Login Flow
```dart
// In AuthNotifier
Future<void> login(LoginUsecaseParams params) async {
  final result = await _loginUsecase.call(params);

  result.fold(
    (failure) => state = AuthState.unauthenticated(...),
    (success) {
      // success.data is LoginResponse (never null, all required)
      final loginResponse = success.data!;

      // Tokens & user sudah disimpan di repository
      state = AuthState.authenticated(
        user: loginResponse.user.toEntity(),
      );
    },
  );
}
```

### Get Current Auth (Startup)
```dart
// In AuthNotifier build
final result = await _getCurrentAuthUsecase.call(NoParams());

return result.fold(
  (failure) => AuthState.unauthenticated(...),
  (success) {
    final auth = success.data!; // Auth (never null, tapi fields nullable)

    if (!auth.isAuthenticated) {
      // Tidak ada auth data, tapi bukan error!
      return AuthState.unauthenticated(
        message: 'Not authenticated',
        isError: false, // ⭐ Important!
      );
    }

    // Auth complete, user logged in
    return AuthState.authenticated(
      user: auth.user!.toEntity(),
    );
  },
);
```

### Check Auth in Repository
```dart
// In AuthRepositoryImpl.getCurrentAuth()
Future<Either<Failure, ItemSuccess<Auth>>> getCurrentAuth() async {
  final accessToken = await _authLocalDatasource.getAccessToken();
  final refreshToken = await _authLocalDatasource.getRefreshToken();
  final userModel = await _authLocalDatasource.getUser();

  // Buat Auth dengan nullable fields (natural!)
  final auth = Auth(
    user: userModel,           // Could be null
    accessToken: accessToken,   // Could be null
    refreshToken: refreshToken, // Could be null
  );

  // Always return Right dengan Auth
  return Right(
    ItemSuccess(
      message: auth.isAuthenticated
          ? 'Authentication data retrieved'
          : 'No authentication data',
      data: auth, // Never null, tapi bisa empty
    ),
  );
}
```

### UI Check
```dart
// In UI
ref.listen<AsyncValue<AuthState>>(authNotifierProvider, (prev, next) {
  next.whenData((state) {
    if (state.status == AuthStatus.authenticated) {
      // User is logged in
      final userName = state.user!.name;
      context.go('/home');
    } else {
      // User not logged in (not an error!)
      context.go('/login');
    }
  });
});
```

## Migration from v1 to v2

### What Changed
1. ✏️ Created new `Auth` entity (nullable fields)
2. ✏️ Moved `LoginResponse` to separate file
3. ✏️ `getCurrentAuth()` now returns `Auth` instead of `LoginResponse?`
4. ✏️ No more `Left(NetworkFailure(...))` for unauthenticated state
5. ✏️ Added `Auth.isAuthenticated` helper
6. ✏️ Updated mappers for both `Auth` and `LoginResponse`

### Breaking Changes
**None!** AuthState di presentation layer tetap sama.

---

**Version:** 2.0
**Last Updated:** October 3, 2025
**Author:** Development Team
**Status:** ✅ Implemented & Tested
