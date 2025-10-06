class AssetUpsertValidator {
  static String? validateAssetTag(String? value) {
    if (value == null || value.isEmpty) {
      return 'Asset tag is required';
    }
    if (value.length < 3) {
      return 'Asset tag must be at least 3 characters';
    }
    if (value.length > 50) {
      return 'Asset tag must not exceed 50 characters';
    }
    // ! Asset tag hanya boleh alfanumerik dan dash
    if (!RegExp(r'^[a-zA-Z0-9-]+$').hasMatch(value)) {
      return 'Asset tag can only contain letters, numbers, and dashes';
    }
    return null;
  }

  static String? validateAssetName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Asset name is required';
    }
    if (value.length < 3) {
      return 'Asset name must be at least 3 characters';
    }
    if (value.length > 100) {
      return 'Asset name must not exceed 100 characters';
    }
    return null;
  }

  static String? validateCategoryId(String? value) {
    if (value == null || value.isEmpty) {
      return 'Category is required';
    }
    return null;
  }

  static String? validateBrand(String? value) {
    if (value != null && value.isNotEmpty) {
      if (value.length > 50) {
        return 'Brand must not exceed 50 characters';
      }
    }
    return null;
  }

  static String? validateModel(String? value) {
    if (value != null && value.isNotEmpty) {
      if (value.length > 50) {
        return 'Model must not exceed 50 characters';
      }
    }
    return null;
  }

  static String? validateSerialNumber(String? value) {
    if (value != null && value.isNotEmpty) {
      if (value.length > 50) {
        return 'Serial number must not exceed 50 characters';
      }
    }
    return null;
  }

  static String? validatePurchasePrice(String? value) {
    if (value != null && value.isNotEmpty) {
      final price = double.tryParse(value);
      if (price == null) {
        return 'Purchase price must be a valid number';
      }
      if (price < 0) {
        return 'Purchase price cannot be negative';
      }
    }
    return null;
  }

  static String? validateVendorName(String? value) {
    if (value != null && value.isNotEmpty) {
      if (value.length > 100) {
        return 'Vendor name must not exceed 100 characters';
      }
    }
    return null;
  }
}
