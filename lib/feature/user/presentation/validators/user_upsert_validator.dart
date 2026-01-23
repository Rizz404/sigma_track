import 'package:flutter/material.dart';
import 'package:sigma_track/core/extensions/localization_extension.dart';

class UserUpsertValidator {
  static String? validateName(
    BuildContext context,
    String? value, {
    bool isUpdate = false,
  }) {
    if (!isUpdate && (value == null || value.isEmpty)) {
      return context.l10n.userValidationNameRequired;
    }
    if (value != null && value.isNotEmpty) {
      if (value.length < 3) {
        return context.l10n.userValidationNameMinLength;
      }
      if (value.length > 20) {
        return context.l10n.userValidationNameMaxLength;
      }
    }
    return null;
  }

  static String? validateEmail(
    BuildContext context,
    String? value, {
    bool isUpdate = false,
  }) {
    if (!isUpdate && (value == null || value.isEmpty)) {
      return context.l10n.userValidationEmailRequired;
    }
    if (value != null && value.isNotEmpty) {
      // * Email regex pattern standar
      final emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      );
      if (!emailRegex.hasMatch(value)) {
        return context.l10n.userValidationEmailInvalid;
      }
    }
    return null;
  }

  static String? validatePassword(
    BuildContext context,
    String? value, {
    bool isUpdate = false,
  }) {
    // Password hanya required untuk create, tidak untuk update
    if (!isUpdate && (value == null || value.isEmpty)) {
      return context.l10n.userValidationPasswordRequired;
    }
    if (value != null && value.isNotEmpty) {
      if (value.length < 8) {
        return context.l10n.userValidationPasswordMinLength;
      }
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
    }
    return null;
  }

  static String? validateFullName(
    BuildContext context,
    String? value, {
    bool isUpdate = false,
  }) {
    if (!isUpdate && (value == null || value.isEmpty)) {
      return context.l10n.userValidationFullNameRequired;
    }
    if (value != null && value.isNotEmpty) {
      if (value.length < 3) {
        return context.l10n.userValidationFullNameMinLength;
      }
      if (value.length > 100) {
        return context.l10n.userValidationFullNameMaxLength;
      }
    }
    return null;
  }

  static String? validateRole(
    BuildContext context,
    String? value, {
    bool isUpdate = false,
  }) {
    if (!isUpdate && (value == null || value.isEmpty)) {
      return context.l10n.userValidationRoleRequired;
    }
    return null;
  }

  static String? validateEmployeeId(BuildContext context, String? value) {
    if (value != null && value.isNotEmpty) {
      if (value.length > 20) {
        return context.l10n.userValidationEmployeeIdMaxLength;
      }
    }
    return null;
  }
}
