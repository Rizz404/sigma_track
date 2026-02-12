import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sigma_track/core/extensions/localization_extension.dart';

class CategoryUpsertValidator {
  static String? validateParentId(
    BuildContext context,
    String? value, {
    bool isUpdate = false,
  }) {
    // if (!isUpdate && (value == null || value.isEmpty)) {
    //   return 'Parent category is required';
    // }
    return null;
  }

  static String? validateCategoryCode(
    BuildContext context,
    String? value, {
    bool isUpdate = false,
  }) {
    if (!isUpdate && (value == null || value.isEmpty)) {
      return context.l10n.categoryValidationCodeRequired;
    }
    if (value != null && value.isNotEmpty) {
      if (value.length < 2) {
        return context.l10n.categoryValidationCodeMinLength;
      }
      if (value.length > 20) {
        return context.l10n.categoryValidationCodeMaxLength;
      }
      // ! Category code hanya boleh alfanumerik dan dash
      if (!RegExp(r'^[a-zA-Z0-9-]+$').hasMatch(value)) {
        return context.l10n.categoryValidationCodeAlphanumeric;
      }
    }
    return null;
  }

  static String? validateCategoryName(
    BuildContext context,
    String? value, {
    bool isUpdate = false,
  }) {
    // * Translation fields are optional - backend auto-translates
    if (value != null && value.isNotEmpty) {
      if (value.length < 3) {
        return context.l10n.categoryValidationNameMinLength;
      }
      if (value.length > 100) {
        return context.l10n.categoryValidationNameMaxLength;
      }
    }
    return null;
  }

  static String? validateDescription(
    BuildContext context,
    String? value, {
    bool isUpdate = false,
  }) {
    // * Translation fields are optional - backend auto-translates
    if (value != null && value.isNotEmpty) {
      if (value.length < 10) {
        return context.l10n.categoryValidationDescriptionMinLength;
      }
      if (value.length > 500) {
        return context.l10n.categoryValidationDescriptionMaxLength;
      }
    }
    return null;
  }

  static String? validateImage(List<PlatformFile>? files) {
    if (files != null && files.isNotEmpty) {
      final file = files.first;
      final extension = file.extension?.toLowerCase();
      final allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];

      if (!allowedExtensions.contains(extension)) {
        return 'Only image files are allowed (jpg, jpeg, png, gif, webp)';
      }

      // * Max 10MB
      if (file.size > 10 * 1024 * 1024) {
        return 'Image size must not exceed 10MB';
      }
    }
    return null;
  }
}
