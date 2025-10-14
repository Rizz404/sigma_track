# FCM Token Management Implementation

## 🎯 Overview

Implementasi efisien untuk FCM (Firebase Cloud Messaging) token management yang mengikuti best practices:

1. **Token disimpan di local storage** untuk cek perubahan
2. **Auto-sync ke backend** hanya saat token berubah
3. **Cooldown mechanism** untuk prevent spam sync (1 jam)
4. **Lifecycle management** yang tepat (login/logout)

## 🔄 Token Sync Flow

```
User Login
    ↓
Request Permission
    ↓
Get FCM Token
    ↓
Check Token (local vs current)
    ↓
Sync to Backend (if changed/first time)
    ↓
Save Token + Timestamp
    ↓
Listen for Token Refresh
```

## 📋 When Token is Synced

Token akan di-sync ke backend pada kondisi:

### ✅ Kondisi Sync Otomatis
1. **First Login** - Token belum pernah disimpan
2. **Token Changed** - Token berbeda dengan yang tersimpan
3. **Token Refresh** - Firebase trigger `onTokenRefresh`
4. **Cooldown Expired** - > 1 jam sejak sync terakhir

### ❌ Kondisi Skip Sync
1. Token sama dengan yang tersimpan
2. Baru sync dalam 1 jam terakhir (cooldown)
3. Permission tidak diberikan

## 🔧 Token Change Triggers

Berdasarkan dokumentasi Firebase, token berubah saat:

### 1. User Actions
- **Reinstall app** - User uninstall kemudian install ulang
- **Clear app data** - User clear data di settings
- **Restore device** - App restored ke device baru

### 2. System Actions
- **Inactivity** - App tidak aktif > 270 hari
- **Token Rotation** - FCM periodic refresh (jarang)
- **Security Refresh** - Firebase force refresh untuk keamanan

## 📝 Usage Examples

### Initialize FCM (Automatic)

```dart
// Otomatis dipanggil saat user login berhasil di main.dart
ref.listen(authNotifierProvider, (previous, next) {
  next.whenData((authState) {
    if (authState.user != null) {
      final fcmTokenManager = ref.read(fcmTokenManagerProvider);
      fcmTokenManager.initialize(); // ← Auto sync
    }
  });
});
```

### Manual Sync (if needed)

```dart
// Panggil manual sync setelah login
final fcmTokenManager = ref.read(fcmTokenManagerProvider);
await fcmTokenManager.syncAfterLogin();
```

### Clear Token on Logout

```dart
// Otomatis dipanggil saat user logout di main.dart
ref.listen(authNotifierProvider, (previous, next) {
  next.whenData((authState) {
    if (authState.user == null) {
      final fcmTokenManager = ref.read(fcmTokenManagerProvider);
      fcmTokenManager.clearToken(); // ← Auto clear
    }
  });
});
```

### Get Saved Token

```dart
final fcmTokenManager = ref.read(fcmTokenManagerProvider);
final token = fcmTokenManager.getSavedToken();
print('Saved FCM Token: $token');
```

## 🔐 Backend Integration

### API Endpoint
```
PATCH /api/users/me
```

### Request Payload
```json
{
  "fcmToken": "eXbRN_kRQYe..."
}
```

### Update User Profile
```dart
// Token akan di-append otomatis ke update profile
final result = await _updateCurrentUserUsecase.call(
  UpdateCurrentUserUsecaseParams(
    name: 'John Doe',
    fcmToken: 'eXbRN_kRQYe...', // ← FCM token
  ),
);
```

## 🎨 Architecture

```
FcmTokenManager
    ↓
FirebaseMessagingService
    ↓
FirebaseMessaging (FCM SDK)
    ↓
UpdateCurrentUserUsecase
    ↓
UserRepository
    ↓
Backend API
```

## 🛠️ Configuration

### Local Storage Keys
```dart
static const String _tokenKey = 'fcm_token';
static const String _lastSyncKey = 'fcm_token_last_sync';
```

### Cooldown Duration
```dart
static const _syncCooldown = Duration(hours: 1);
```

### Adjust jika diperlukan:
- **More Aggressive**: `Duration(minutes: 30)`
- **Less Aggressive**: `Duration(hours: 2)`

## 📊 Monitoring & Logs

Semua operasi FCM token di-log dengan format:

```
[FcmTokenManager] Initializing FCM token manager
[FcmTokenManager] FCM Token: eXbRN_kRQYe...
[FcmTokenManager] Token unchanged and recently synced, skipping
[FcmTokenManager] FCM token refreshed: fYaUO_mSPZf...
[FcmTokenManager] Syncing FCM token to backend...
[FcmTokenManager] FCM token synced successfully
```

## ⚠️ Important Notes

1. **Permission Required** - iOS requires explicit permission
2. **Background Handler** - Must be top-level function
3. **Token Expiry** - Token tidak expire, tapi bisa berubah
4. **Network Required** - Sync membutuhkan koneksi internet
5. **User Must Login** - Token hanya sync untuk authenticated user

## 🧪 Testing Scenarios

### Test 1: First Login
1. Login dengan user baru
2. Check log: "Syncing FCM token to backend"
3. Verify token tersimpan di backend

### Test 2: Token Unchanged
1. Logout kemudian login lagi
2. Check log: "Token unchanged and recently synced, skipping"
3. Verify tidak ada API call

### Test 3: Token Changed
1. Clear app data
2. Login lagi
3. Check log: "FCM token refreshed"
4. Verify token baru tersimpan

### Test 4: Logout
1. Logout
2. Check log: "Clearing FCM token"
3. Verify token terhapus dari local storage

## 🚀 Future Enhancements

- [ ] Retry mechanism untuk failed sync
- [ ] Batch sync untuk multiple devices
- [ ] Analytics tracking untuk token changes
- [ ] Support multiple FCM tokens per user
- [ ] Topic subscription management
