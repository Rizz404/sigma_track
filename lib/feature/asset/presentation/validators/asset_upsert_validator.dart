import 'package:flutter/material.dart';
import 'package:sigma_track/core/extensions/localization_extension.dart';

class AssetUpsertValidator {
  static String? validateAssetTag(
    BuildContext context,
    String? value, {
    bool isUpdate = false,
  }) {
    if (!isUpdate && (value == null || value.isEmpty)) {
      return context.l10n.assetValidationTagRequired;
    }
    if (value != null && value.isNotEmpty) {
      if (value.length < 3) {
        return context.l10n.assetValidationTagMinLength;
      }
      if (value.length > 50) {
        return context.l10n.assetValidationTagMaxLength;
      }
      // ! Asset tag hanya boleh alfanumerik dan dash
      if (!RegExp(r'^[a-zA-Z0-9-_]+$').hasMatch(value)) {
        return context.l10n.assetValidationTagAlphanumeric;
      }
    }
    return null;
  }

  static String? validateAssetName(
    BuildContext context,
    String? value, {
    bool isUpdate = false,
  }) {
    if (!isUpdate && (value == null || value.isEmpty)) {
      return context.l10n.assetValidationNameRequired;
    }
    if (value != null && value.isNotEmpty) {
      if (value.length < 3) {
        return context.l10n.assetValidationNameMinLength;
      }
      if (value.length > 100) {
        return context.l10n.assetValidationNameMaxLength;
      }
    }
    return null;
  }

  static String? validateCategoryId(
    BuildContext context,
    String? value, {
    bool isUpdate = false,
  }) {
    if (!isUpdate && (value == null || value.isEmpty)) {
      return context.l10n.assetValidationCategoryRequired;
    }
    return null;
  }

  static String? validateBrand(
    BuildContext context,
    String? value, {
    bool isUpdate = false,
  }) {
    if (value != null && value.isNotEmpty) {
      if (value.length > 50) {
        return context.l10n.assetValidationBrandMaxLength;
      }
    }
    return null;
  }

  static String? validateModel(
    BuildContext context,
    String? value, {
    bool isUpdate = false,
  }) {
    if (value != null && value.isNotEmpty) {
      if (value.length > 50) {
        return context.l10n.assetValidationModelMaxLength;
      }
    }
    return null;
  }

  static String? validateSerialNumber(
    BuildContext context,
    String? value, {
    bool isUpdate = false,
  }) {
    if (value != null && value.isNotEmpty) {
      if (value.length > 50) {
        return context.l10n.assetValidationSerialMaxLength;
      }
    }
    return null;
  }

  static String? validatePurchasePrice(
    BuildContext context,
    String? value, {
    bool isUpdate = false,
  }) {
    if (value != null && value.isNotEmpty) {
      final price = double.tryParse(value);
      if (price == null) {
        return context.l10n.assetValidationPriceInvalid;
      }
      if (price < 0) {
        return context.l10n.assetValidationPriceNegative;
      }
    }
    return null;
  }

  static String? validateVendorName(
    BuildContext context,
    String? value, {
    bool isUpdate = false,
  }) {
    if (value != null && value.isNotEmpty) {
      if (value.length > 100) {
        return context.l10n.assetValidationVendorMaxLength;
      }
    }
    return null;
  }
}
