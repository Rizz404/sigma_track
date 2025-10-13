import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/services/auth_service.dart';
import 'package:sigma_track/core/services/firebase_messaging_service.dart';
import 'package:sigma_track/core/services/language_storage_service.dart';
import 'package:sigma_track/core/services/theme_storage_service.dart';
import 'package:sigma_track/di/common_providers.dart';
import 'package:sigma_track/di/datasource_providers.dart';
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
