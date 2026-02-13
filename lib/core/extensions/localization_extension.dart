import 'package:flutter/material.dart';
import 'package:sigma_track/l10n/app_localizations.dart';
import 'package:sigma_track/core/router/app_router.dart';
import 'package:sigma_track/core/enums/language_enums.dart';

extension LocalizationExtension on BuildContext {
  L10n get l10n => L10n.of(this)!;

  String get locale => Localizations.localeOf(this).languageCode;

  bool get isEnglish => locale == 'en';
  bool get isIndonesian => locale == 'id';
  bool get isJapanese => locale == 'ja';

  // * Get backend code format (en-US, ja-JP, id-ID) from current locale
  String get backendLocaleCode {
    final langCode = Localizations.localeOf(this).languageCode;
    switch (langCode) {
      case 'en':
        return Language.english.backendCode;
      case 'ja':
        return Language.japanese.backendCode;
      case 'id':
        return Language.indonesian.backendCode;
      default:
        return Language.english.backendCode;
    }
  }

  // * Static helper for usage without context (e.g. Enums)
  // * Requires AppRouter.navigatorKey to be exposed
  static L10n get current {
    final context = AppRouter.navigatorKey.currentContext;
    if (context == null) {
      throw Exception(
        'Navigator context is null. Ensure AppRouter is initialized.',
      );
    }
    return L10n.of(context)!;
  }
}
