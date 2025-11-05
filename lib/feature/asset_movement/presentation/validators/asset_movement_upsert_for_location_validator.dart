import 'package:flutter/material.dart';
import 'package:sigma_track/core/extensions/localization_extension.dart';

class AssetMovementUpsertForLocationValidator {
  static String? validateAssetId(
    BuildContext context,
    String? value, {
    bool isUpdate = false,
  }) {
    if (!isUpdate && (value == null || value.isEmpty)) {
      return context.l10n.assetMovementValidationAssetRequired;
    }
    return null;
  }

  static String? validateToLocationId(
    BuildContext context,
    String? value, {
    bool isUpdate = false,
  }) {
    if (!isUpdate && (value == null || value.isEmpty)) {
      return context.l10n.assetMovementValidationToLocationRequired;
    }
    return null;
  }

  static String? validateMovedById(
    BuildContext context,
    String? value, {
    bool isUpdate = false,
  }) {
    if (!isUpdate && (value == null || value.isEmpty)) {
      return context.l10n.assetMovementValidationMovedByRequired;
    }
    return null;
  }

  static String? validateMovementDate(
    BuildContext context,
    DateTime? value, {
    bool isUpdate = false,
  }) {
    if (!isUpdate && value == null) {
      return context.l10n.assetMovementValidationMovementDateRequired;
    }
    if (value != null && value.isAfter(DateTime.now())) {
      return context.l10n.assetMovementValidationMovementDateFuture;
    }
    return null;
  }

  static String? validateNotes(
    BuildContext context,
    String? value, {
    bool isUpdate = false,
  }) {
    if (value != null && value.isNotEmpty) {
      if (value.length > 500) {
        return context.l10n.assetMovementValidationNotesMaxLength;
      }
    }
    return null;
  }
}
