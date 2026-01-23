import 'package:flutter/material.dart';
import 'package:sigma_track/core/extensions/localization_extension.dart';

class UserChangePasswordValidator {
  static String? validateCurrentPassword(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return context.l10n.userValidationCurrentPasswordRequired;
    }
    return null;
  }

  static String? validateNewPassword(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return context.l10n.userValidationNewPasswordRequired;
    }
    // if (value.length < 8) {
    //   return 'Password must be at least 8 characters';
    // }
    // if (value.length > 100) {
    //   return 'Password must not exceed 100 characters';
    // }
    // // * Password harus punya minimal 1 huruf besar, 1 huruf kecil, 1 angka
    // if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$').hasMatch(value)) {
    //   return 'Password must contain uppercase, lowercase, and number';
    // }
    return null;
  }

  static String? validateConfirmPassword(
    BuildContext context,
    String? value,
    String? newPassword,
  ) {
    if (value == null || value.isEmpty) {
      return context.l10n.userValidationConfirmPasswordRequired;
    }
    if (value != newPassword) {
      return context.l10n.userValidationPasswordsDoNotMatch;
    }
    return null;
  }
}
