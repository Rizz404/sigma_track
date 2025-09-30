import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/services/language_storage_service.dart';
import 'package:sigma_track/core/services/theme_storage_service.dart';
import 'package:sigma_track/di/common_providers.dart';

final languageStorageServiceProvider = Provider<LanguageStorageService>((ref) {
  final _sharedPreferences = ref.watch(sharedPreferencesProvider);
  return LanguageStorageServiceImpl(_sharedPreferences);
});

final themeStorageServiceProvider = Provider<ThemeStorageService>((ref) {
  final _sharedPreferences = ref.watch(sharedPreferencesProvider);
  return ThemeStorageServiceImpl(_sharedPreferences);
});
