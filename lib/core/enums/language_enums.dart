import 'package:flutter/material.dart';

enum Language {
  english('en'),
  japanese('ja');

  const Language(this.value);
  final String value;

  String get mobileCode => value;

  String get backendCode {
    switch (this) {
      case Language.english:
        return 'en-US';
      case Language.japanese:
        return 'ja-JP';
    }
  }

  // * Dropdown helper
  String get label => mobileCode;

  IconData get icon {
    switch (this) {
      case Language.english:
        return Icons.language;
      case Language.japanese:
        return Icons.language;
    }
  }
}
