class MaintenanceRecordUpsertValidator {
  static String? validateAssetId(String? value) {
    if (value == null || value.isEmpty) {
      return 'Asset is required';
    }
    return null;
  }

  static String? validateMaintenanceDate(DateTime? value) {
    if (value == null) {
      return 'Maintenance date is required';
    }
    if (value.isAfter(DateTime.now())) {
      return 'Maintenance date cannot be in the future';
    }
    return null;
  }

  static String? validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Title is required';
    }
    if (value.length < 3) {
      return 'Title must be at least 3 characters';
    }
    if (value.length > 100) {
      return 'Title must not exceed 100 characters';
    }
    return null;
  }

  static String? validatePerformedByVendor(String? value) {
    if (value != null && value.isNotEmpty) {
      if (value.length > 100) {
        return 'Performed by vendor must not exceed 100 characters';
      }
    }
    return null;
  }

  static String? validateActualCost(String? value) {
    if (value != null && value.isNotEmpty) {
      final cost = double.tryParse(value);
      if (cost == null) {
        return 'Actual cost must be a valid number';
      }
      if (cost < 0) {
        return 'Actual cost cannot be negative';
      }
    }
    return null;
  }

  static String? validateNotes(String? value) {
    if (value != null && value.isNotEmpty) {
      if (value.length > 500) {
        return 'Notes must not exceed 500 characters';
      }
    }
    return null;
  }
}
