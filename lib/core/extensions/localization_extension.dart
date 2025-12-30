import 'package:flutter/material.dart';
import 'package:sigma_track/l10n/app_localizations.dart';

extension LocalizationExtension on BuildContext {
  L10n get l10n => L10n.of(this)!;

  String get locale => Localizations.localeOf(this).languageCode;

  bool get isEnglish => locale == 'en';
  bool get isIndonesian => locale == 'id';
  bool get isJapanese => locale == 'ja';
}
