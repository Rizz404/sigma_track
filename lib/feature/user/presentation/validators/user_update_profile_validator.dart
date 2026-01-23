import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sigma_track/core/extensions/localization_extension.dart';

class UserUpdateProfileValidator {
  static String? validateName(BuildContext context, String? value) {
    if (value != null && value.isNotEmpty) {
      if (value.length < 3) {
        return context.l10n.userValidationNameMinLength;
      }
      if (value.length > 20) {
        return context.l10n.userValidationNameMaxLength;
      }
      // ! Name hanya boleh alfanumerik dan dash
      if (!RegExp(r'^[a-zA-Z0-9-]+$').hasMatch(value)) {
        return context.l10n.userValidationNameAlphanumeric;
      }
    }
    return null;
  }

  static String? validateEmail(BuildContext context, String? value) {
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

  static String? validateFullName(BuildContext context, String? value) {
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

  static String? validateEmployeeId(BuildContext context, String? value) {
    if (value != null && value.isNotEmpty) {
      if (value.length > 20) {
        return context.l10n.userValidationEmployeeIdMaxLength;
      }
    }
    return null;
  }

  static String? validateAvatar(
    BuildContext context,
    List<PlatformFile>? files,
  ) {
    if (files != null && files.isNotEmpty) {
      final file = files.first;
      final extension = file.extension?.toLowerCase();
      final allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];

      if (!allowedExtensions.contains(extension)) {
        return context.l10n.userValidationImageOnly;
      }

      // * Max 5MB
      if (file.size > 5 * 1024 * 1024) {
        return context.l10n.userValidationImageSize(5);
      }
    }
    return null;
  }
}
