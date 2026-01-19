import 'package:flutter/material.dart';
import 'package:sigma_track/core/extensions/localization_extension.dart';

class RegisterValidator {
  static String? validateName(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return context.l10n.authValidationNameRequired;
    }
    if (value.length < 3) {
      return context.l10n.authValidationNameMinLength;
    }
    if (value.length > 20) {
      return context.l10n.authValidationNameMaxLength;
    }
    // ! Name hanya boleh alfanumerik dan dash
    if (!RegExp(r'^[a-zA-Z0-9-]+$').hasMatch(value)) {
      return context.l10n.authValidationNameAlphanumeric;
    }
    return null;
  }

  static String? validateEmail(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return context.l10n.authValidationEmailRequired;
    }
    // * Email regex pattern standar
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return context.l10n.authValidationEmailInvalid;
    }
    return null;
  }

  static String? validatePassword(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return context.l10n.authValidationPasswordRequired;
    }
    // Todo: Uncomment di production
    // if (value.length < 8) {
    //   return 'Password must be at least 8 characters';
    // }
    // if (value.length > 100) {
    //   return 'Password must not exceed 100 characters';
    // }
    // // * Password harus mengandung minimal 1 huruf besar, 1 huruf kecil, dan 1 angka
    // if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
    //   return 'Password must contain at least one lowercase letter';
    // }
    // if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
    //   return 'Password must contain at least one uppercase letter';
    // }
    // if (!RegExp(r'(?=.*\d)').hasMatch(value)) {
    //   return 'Password must contain at least one number';
    // }
    return null;
  }

  static String? validateConfirmPassword(
    BuildContext context,
    String? value,
    String? password,
  ) {
    if (value == null || value.isEmpty) {
      return context.l10n.authValidationConfirmPasswordRequired;
    }
    if (value != password) {
      return context.l10n.authValidationPasswordsDoNotMatch;
    }
    return null;
  }
}
