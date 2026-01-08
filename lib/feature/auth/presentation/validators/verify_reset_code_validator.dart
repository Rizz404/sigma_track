import 'package:flutter/material.dart';
import 'package:sigma_track/core/extensions/localization_extension.dart';

class VerifyResetCodeValidator {
  static String? validateResetCode(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return context.l10n.authValidationResetCodeRequired;
    }
    if (value.length != 6) {
      return context.l10n.authValidationResetCodeLength;
    }
    return null;
  }
}
