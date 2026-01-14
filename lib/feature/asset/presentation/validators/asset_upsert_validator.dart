import 'package:flutter/material.dart';
import 'package:sigma_track/core/extensions/localization_extension.dart';

class AssetUpsertValidator {
  static String? validateAssetTag(
    BuildContext context,
    String? value, {
    bool isUpdate = false,
    bool isBulkCopy = false,
  }) {
    // * Skip validation if bulk copy is enabled (tags will be auto-generated)
    if (isBulkCopy) {
      return null;
    }

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

  static String? validateBulkCopyQuantity(
    BuildContext context,
    String? value, {
    int maxWithoutImages = 100,
    int maxWithExistingImages = 50,
    int maxWithNewImages = 25,
    bool hasExistingImages = false,
    bool hasNewImages = false,
  }) {
    if (value == null || value.isEmpty) {
      return context.l10n.assetPleaseEnterQuantity;
    }
    final quantity = int.tryParse(value);
    if (quantity == null || quantity < 1) {
      return context.l10n.assetMinimumOneCopy;
    }

    late int limit;
    late String imageStatus;

    if (hasNewImages) {
      limit = maxWithNewImages;
      imageStatus = 'dengan upload images baru';
    } else if (hasExistingImages) {
      limit = maxWithExistingImages;
      imageStatus = 'dengan existing images';
    } else {
      limit = maxWithoutImages;
      imageStatus = 'tanpa images';
    }

    if (quantity > limit) {
      return 'Bulk copy $imageStatus maksimal $limit assets (anda memilih $quantity)';
    }
    return null;
  }

  static String? validateImageCount(
    BuildContext context,
    int count, {
    int maxImages = 5,
    String context_label = 'images',
  }) {
    if (count > maxImages) {
      return 'Maksimal $maxImages $context_label diizinkan (anda memilih $count)';
    }
    return null;
  }
}
