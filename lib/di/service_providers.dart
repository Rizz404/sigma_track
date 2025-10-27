import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/services/auth_service.dart';
import 'package:sigma_track/core/services/fcm_token_manager.dart';
import 'package:sigma_track/core/services/firebase_messaging_service.dart';
import 'package:sigma_track/core/services/language_storage_service.dart';
import 'package:sigma_track/core/services/local_notification_service.dart';
import 'package:sigma_track/core/services/notification_navigation_service.dart';
import 'package:sigma_track/core/services/theme_storage_service.dart';
import 'package:sigma_track/di/common_providers.dart';
import 'package:sigma_track/di/datasource_providers.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/auth/data/services/auth_service_impl.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  final authLocalDatasource = ref.watch(authLocalDatasourceProvider);
  return AuthServiceImpl(authLocalDatasource);
});

final languageStorageServiceProvider = Provider<LanguageStorageService>((ref) {
  final _sharedPreferences = ref.watch(sharedPreferencesProvider);
  return LanguageStorageServiceImpl(_sharedPreferences);
});

final themeStorageServiceProvider = Provider<ThemeStorageService>((ref) {
  final _sharedPreferences = ref.watch(sharedPreferencesProvider);
  return ThemeStorageServiceImpl(_sharedPreferences);
});

final firebaseMessagingServiceProvider = Provider<FirebaseMessagingService>((
  ref,
) {
  final messaging = ref.watch(firebaseMessagingProvider);
  return FirebaseMessagingService(messaging);
});

// * Flutter Local Notifications Plugin provider
final flutterLocalNotificationsPluginProvider =
    Provider<FlutterLocalNotificationsPlugin>((ref) {
      return FlutterLocalNotificationsPlugin();
    });

// * Local Notification Service provider
final localNotificationServiceProvider = Provider<LocalNotificationService>((
  ref,
) {
  final plugin = ref.watch(flutterLocalNotificationsPluginProvider);
  return LocalNotificationService(plugin);
});

final fcmTokenManagerProvider = Provider<FcmTokenManager>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final messagingService = ref.watch(firebaseMessagingServiceProvider);
  final updateUsecase = ref.watch(updateCurrentUserUsecaseProvider);
  return FcmTokenManager(prefs, messagingService, updateUsecase);
});

// * Notification Navigation Service provider
final notificationNavigationServiceProvider =
    Provider<NotificationNavigationService>((ref) {
      return const NotificationNavigationService();
    });
