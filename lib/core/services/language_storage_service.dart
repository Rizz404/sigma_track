import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sigma_track/core/constants/locale_key_constant.dart';
import 'package:sigma_track/l10n/app_localizations.dart';

abstract class LanguageStorageService {
  Future<Locale> getLocale();
  Future<void> setLocale(Locale locale);
  Future<void> removeLocale();
}

class LanguageStorageServiceImpl implements LanguageStorageService {
  final SharedPreferences _sharedPreferences;

  LanguageStorageServiceImpl(this._sharedPreferences);

  @override
  Future<Locale> getLocale() async {
    final localeString = _sharedPreferences.getString(
      LocaleKeyConstant.localeKey,
    );

    if (localeString != null) {
      final parts = localeString.split('_');
      Locale locale;

      if (parts.length == 2) {
        locale = Locale(parts[0], parts[1]);
      } else if (parts.length == 1) {
        locale = Locale(parts[0]);
      } else {
        // * Fallback ke default locale
        return L10n.supportedLocales.first;
      }

      if (L10n.supportedLocales.contains(locale)) {
        return locale;
      }
    }

    return L10n.supportedLocales.first;
  }

  @override
  Future<void> setLocale(Locale locale) async {
    if (L10n.supportedLocales.contains(locale)) {
      await _sharedPreferences.setString(
        LocaleKeyConstant.localeKey,
        locale.toString(),
      );
    } else {
      throw ArgumentError('Unsupported locale: $locale');
    }
  }

  @override
  Future<void> removeLocale() async {
    await _sharedPreferences.remove(LocaleKeyConstant.localeKey);
  }
}
