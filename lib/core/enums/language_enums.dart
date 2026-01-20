import 'package:flutter/material.dart';

enum Language {
  english('en'),
  japanese('ja'),
  indonesian('id');

  const Language(this.value);
  final String value;

  String get mobileCode => value;

  String get backendCode {
    switch (this) {
      case Language.english:
        return 'en-US';
      case Language.japanese:
        return 'ja-JP';
      case Language.indonesian:
        return 'id-ID';
    }
  }

  // * Convert dari backend code ke enum
  static Language fromBackendCode(String code) {
    switch (code) {
      case 'en-US':
        return Language.english;
      case 'ja-JP':
        return Language.japanese;
      case 'id-ID':
        return Language.indonesian;
      default:
        return Language.english; // * Fallback ke english
    }
  }

  // * Dropdown helper
  String get label => mobileCode;

  IconData get icon {
    switch (this) {
      case Language.english:
      case Language.japanese:
      case Language.indonesian:
        return Icons.language;
    }
  }
}
