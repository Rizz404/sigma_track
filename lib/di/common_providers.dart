import 'package:beamer/beamer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/network/dio_client.dart';
import 'package:sigma_track/core/router/app_router.dart';
import 'package:sigma_track/core/services/language_storage_service.dart';
import 'package:sigma_track/core/services/theme_storage_service.dart';
import 'package:sigma_track/di/datasource_providers.dart';
import 'package:sigma_track/di/service_providers.dart';
import 'package:sigma_track/feature/user/data/models/user_model.dart';
import 'package:sigma_track/l10n/app_localizations.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  throw UnimplementedError('secureStorageProvider not initialized');
});

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider not initialized');
});

final sharedPreferencesWithCacheProvider = Provider<SharedPreferencesWithCache>(
  (ref) {
    throw UnimplementedError(
      'sharedPreferencesWithCacheProvider not initialized',
    );
  },
);

final dioProvider = Provider<Dio>((ref) {
  return Dio();
});

final dioClientProvider = Provider<DioClient>((ref) {
  final _dio = ref.watch(dioProvider);
  final _authService = ref.watch(authServiceProvider);
  final dioClient = DioClient(_dio, _authService);

  final currentLocale = ref.watch(localeProvider);
  dioClient.updateLocale(currentLocale);

  return dioClient;
});

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);

final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(
  ThemeNotifier.new,
);

final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final authLocalDatasource = ref.watch(authLocalDatasourceProvider);
  return authLocalDatasource.getUser();
});

final isAuthenticatedProvider = FutureProvider<bool>((ref) async {
  final authService = ref.watch(authServiceProvider);
  final token = await authService.getAccessToken();
  return token != null;
});

final isAdminProvider = FutureProvider<bool>((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  return user?.role == UserRole.admin;
});

class LocaleNotifier extends Notifier<Locale> {
  late LanguageStorageService _languageStorageService;

  @override
  Locale build() {
    _languageStorageService = ref.watch(languageStorageServiceProvider);
    Future.microtask(() => _loadLocale());
    return L10n.supportedLocales.first;
  }

  Future<void> _loadLocale() async {
    try {
      final locale = await _languageStorageService.getLocale();
      state = locale;
    } catch (e) {
      state = L10n.supportedLocales.first;
    }
  }

  Future<void> changeLocale(Locale newLocale) async {
    try {
      if (L10n.supportedLocales.contains(newLocale)) {
        await _languageStorageService.setLocale(newLocale);
        state = newLocale;
      } else {
        throw ArgumentError('Unsupported locale: $newLocale');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetLocale() async {
    try {
      await _languageStorageService.removeLocale();
      state = L10n.supportedLocales.first;
    } catch (e) {
      rethrow;
    }
  }
}

class ThemeNotifier extends Notifier<ThemeMode> {
  late ThemeStorageService _themeStorageService;

  @override
  ThemeMode build() {
    _themeStorageService = ref.watch(themeStorageServiceProvider);
    Future.microtask(() => _loadThemeMode());
    return ThemeMode.system;
  }

  Future<void> _loadThemeMode() async {
    try {
      final themeMode = await _themeStorageService.getThemeMode();
      state = themeMode;
    } catch (e) {
      state = ThemeMode.system;
    }
  }

  Future<void> changeTheme(ThemeMode newThemeMode) async {
    try {
      await _themeStorageService.setThemeMode(newThemeMode);
      state = newThemeMode;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetTheme() async {
    try {
      await _themeStorageService.removeThemeMode();
      state = ThemeMode.system;
    } catch (e) {
      rethrow;
    }
  }
}
