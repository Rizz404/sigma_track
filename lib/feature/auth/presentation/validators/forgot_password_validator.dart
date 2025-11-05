import 'package:flutter/material.dart';
import 'package:sigma_track/core/extensions/localization_extension.dart';

class ForgotPasswordValidator {
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
}
