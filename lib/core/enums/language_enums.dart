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
