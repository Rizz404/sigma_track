import 'package:flutter/material.dart';

enum Language {
  english('en'),
  japanese('ja');

  const Language(this.mobileCode);
  final String mobileCode;

  String get backendCode {
    switch (this) {
      case Language.english:
        return 'en-US';
      case Language.japanese:
        return 'ja-JP';
    }
  }

  Map<String, dynamic> toMap() => {
    'mobileCode': mobileCode,
    'backendCode': backendCode,
  };

  static Language fromMap(Map<String, dynamic> map) =>
      fromString(map['mobileCode'] as String);

  static Language fromString(String value) => Language.values.firstWhere(
    (lang) => lang.mobileCode == value,
    orElse: () => throw ArgumentError('Invalid Language value: $value'),
  );

  String toJson() => mobileCode;
  static Language fromJson(String json) => fromString(json);

  @override
  String toString() => mobileCode;

  // * Dropdown helper
  String get label {
    switch (this) {
      case Language.english:
        return 'English';
      case Language.japanese:
        return 'Japanese';
    }
  }

  IconData get icon {
    switch (this) {
      case Language.english:
        return Icons.language;
      case Language.japanese:
        return Icons.language;
    }
  }
}
