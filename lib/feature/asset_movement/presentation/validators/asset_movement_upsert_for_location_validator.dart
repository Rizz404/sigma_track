class AssetMovementUpsertForLocationValidator {
  static String? validateAssetId(String? value, {bool isUpdate = false}) {
    if (!isUpdate && (value == null || value.isEmpty)) {
      return 'Asset is required';
    }
    return null;
  }

  static String? validateToLocationId(String? value, {bool isUpdate = false}) {
    if (!isUpdate && (value == null || value.isEmpty)) {
      return 'To location is required';
    }
    return null;
  }

  static String? validateMovedById(String? value, {bool isUpdate = false}) {
    if (!isUpdate && (value == null || value.isEmpty)) {
      return 'Moved by is required';
    }
    return null;
  }

  static String? validateMovementDate(
    DateTime? value, {
    bool isUpdate = false,
  }) {
    if (!isUpdate && value == null) {
      return 'Movement date is required';
    }
    if (value != null && value.isAfter(DateTime.now())) {
      return 'Movement date cannot be in the future';
    }
    return null;
  }

  static String? validateNotes(String? value, {bool isUpdate = false}) {
    if (value != null && value.isNotEmpty) {
      if (value.length > 500) {
        return 'Notes must not exceed 500 characters';
      }
    }
    return null;
  }
}
