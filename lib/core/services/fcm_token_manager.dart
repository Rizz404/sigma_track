import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/extensions/logger_extension.dart';
import 'package:sigma_track/di/common_providers.dart';
import 'package:sigma_track/di/service_providers.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/user/domain/usecases/update_current_user_usecase.dart';

/// Service untuk manage FCM token lifecycle
/// Token akan di-sync ke backend hanya saat:
/// 1. User login pertama kali
/// 2. Token berubah (onTokenRefresh)
/// 3. Token berbeda dengan yang tersimpan di local storage
class FcmTokenManager {
  final Ref _ref;
  static const String _tokenKey = 'fcm_token';
  static const String _lastSyncKey = 'fcm_token_last_sync';
  static const _syncCooldown = Duration(hours: 1); // * Prevent spam sync

  FcmTokenManager(this._ref);

  // * Initialize FCM token management
  Future<void> initialize() async {
    this.logService('Initializing FCM token manager');

    // * Request permission first
    final messagingService = _ref.read(firebaseMessagingServiceProvider);
    final isGranted = await messagingService.requestPermission();

    if (!isGranted) {
      this.logService(
        'Notification permission not granted, skipping FCM setup',
      );
      return;
    }

    // * Get current token
    final currentToken = await messagingService.getToken();
    if (currentToken == null) {
      this.logError('Failed to get FCM token');
      return;
    }

    // * Check if token needs sync
    await _syncTokenIfNeeded(currentToken);

    // * Listen for token refresh
    _setupTokenRefreshListener();
  }

  // * Setup listener untuk token refresh
  void _setupTokenRefreshListener() {
    FirebaseMessaging.instance.onTokenRefresh.listen(
      (newToken) async {
        this.logService('FCM token refreshed: $newToken');
        await _syncTokenToBackend(newToken, forceSync: true);
      },
      onError: (error, stackTrace) {
        this.logError('FCM token refresh error', error, stackTrace);
      },
    );
  }

  // * Sync token hanya jika diperlukan
  Future<void> _syncTokenIfNeeded(String currentToken) async {
    try {
      final prefs = _ref.read(sharedPreferencesProvider);
      final savedToken = prefs.getString(_tokenKey);
      final lastSync = prefs.getString(_lastSyncKey);

      // * Token sama dan baru sync, skip
      if (savedToken == currentToken && lastSync != null) {
        final lastSyncTime = DateTime.parse(lastSync);
        final now = DateTime.now();

        if (now.difference(lastSyncTime) < _syncCooldown) {
          this.logService('Token unchanged and recently synced, skipping');
          return;
        }
      }

      // * Token berbeda atau belum pernah sync, sync sekarang
      await _syncTokenToBackend(currentToken);
    } catch (e, s) {
      this.logError('Failed to check token sync status', e, s);
    }
  }

  // * Sync token ke backend
  Future<void> _syncTokenToBackend(
    String token, {
    bool forceSync = false,
  }) async {
    try {
      if (!forceSync) {
        // * Check cooldown untuk prevent spam
        final prefs = _ref.read(sharedPreferencesProvider);
        final lastSync = prefs.getString(_lastSyncKey);

        if (lastSync != null) {
          final lastSyncTime = DateTime.parse(lastSync);
          final now = DateTime.now();

          if (now.difference(lastSyncTime) < _syncCooldown) {
            this.logService('Token sync on cooldown, skipping');
            return;
          }
        }
      }

      this.logService('Syncing FCM token to backend...');

      final updateUsecase = _ref.read(updateCurrentUserUsecaseProvider);
      final result = await updateUsecase.call(
        UpdateCurrentUserUsecaseParams(fcmToken: token),
      );

      result.fold(
        (failure) {
          this.logError('Failed to sync FCM token', failure);
        },
        (success) async {
          this.logService('FCM token synced successfully');

          // * Save token & timestamp to local storage
          final prefs = _ref.read(sharedPreferencesProvider);
          await prefs.setString(_tokenKey, token);
          await prefs.setString(_lastSyncKey, DateTime.now().toIso8601String());
        },
      );
    } catch (e, s) {
      this.logError('Exception while syncing FCM token', e, s);
    }
  }

  // * Manual sync (dipanggil saat login berhasil)
  Future<void> syncAfterLogin() async {
    this.logService('Manual token sync after login');

    final messagingService = _ref.read(firebaseMessagingServiceProvider);
    final token = await messagingService.getToken();

    if (token != null) {
      await _syncTokenToBackend(token, forceSync: true);
    }
  }

  // * Clear token saat logout
  Future<void> clearToken() async {
    try {
      this.logService('Clearing FCM token');

      final prefs = _ref.read(sharedPreferencesProvider);
      await prefs.remove(_tokenKey);
      await prefs.remove(_lastSyncKey);

      // * Optional: Delete token dari Firebase
      final messagingService = _ref.read(firebaseMessagingServiceProvider);
      await messagingService.deleteToken();
    } catch (e, s) {
      this.logError('Failed to clear FCM token', e, s);
    }
  }

  // * Get saved token dari local storage
  String? getSavedToken() {
    try {
      final prefs = _ref.read(sharedPreferencesProvider);
      return prefs.getString(_tokenKey);
    } catch (e, s) {
      this.logError('Failed to get saved token', e, s);
      return null;
    }
  }
}
