import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sigma_track/core/network/dio_client.dart';
import 'package:sigma_track/core/services/language_storage_service.dart';
import 'package:sigma_track/di/service_providers.dart';
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
  final _sessionStorageService = ref.watch(sessionStorageServiceProvider);
  final dioClient = DioClient(_dio, _sessionStorageService);

  // * Watch locale provider.
  // This will re-create the DioClient whenever the locale changes.
  final currentLocale = ref.watch(localeProvider);
  dioClient.updateLocale(currentLocale);

  return dioClient;
});

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);

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
