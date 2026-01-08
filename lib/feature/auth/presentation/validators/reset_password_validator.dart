import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sigma_track/core/extensions/localization_extension.dart';

class ResetPasswordValidator {
  static String? validateNewPassword(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return context.l10n.authValidationNewPasswordRequired;
    }
    return null;
  }

  static String? validateConfirmPassword(
    BuildContext context,
    String? value,
    GlobalKey<FormBuilderState> formKey,
  ) {
    if (value == null || value.isEmpty) {
      return context.l10n.authValidationConfirmPasswordRequired;
    }
    final newPassword = formKey.currentState?.fields['newPassword']?.value;
    if (value != newPassword) {
      return context.l10n.authValidationPasswordsDoNotMatch;
    }
    return null;
  }
}
