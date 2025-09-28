import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/services/language_storage_service.dart';
import 'package:sigma_track/core/services/session_storage_services.dart';
import 'package:sigma_track/core/services/theme_storage_service.dart';
import 'package:sigma_track/di/common_providers.dart';

final sessionStorageServiceProvider = Provider<SessionStorageService>((ref) {
  final _sharedPreferencesWithCache = ref.watch(
    sharedPreferencesWithCacheProvider,
  );
  final _flutterSecureStorage = ref.watch(secureStorageProvider);

  return SessionStorageServiceImpl(
    _flutterSecureStorage,
    _sharedPreferencesWithCache,
  );
});

final languageStorageServiceProvider = Provider<LanguageStorageService>((ref) {
  final _sharedPreferences = ref.watch(sharedPreferencesProvider);
  return LanguageStorageServiceImpl(_sharedPreferences);
});

final themeStorageServiceProvider = Provider<ThemeStorageService>((ref) {
  final _sharedPreferences = ref.watch(sharedPreferencesProvider);
  return ThemeStorageServiceImpl(_sharedPreferences);
});
