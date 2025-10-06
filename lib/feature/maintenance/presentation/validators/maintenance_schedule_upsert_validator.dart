class MaintenanceScheduleUpsertValidator {
  static String? validateAssetId(String? value) {
    if (value == null || value.isEmpty) {
      return 'Asset is required';
    }
    return null;
  }

  static String? validateMaintenanceType(String? value) {
    if (value == null || value.isEmpty) {
      return 'Maintenance type is required';
    }
    return null;
  }

  static String? validateScheduledDate(DateTime? value) {
    if (value == null) {
      return 'Scheduled date is required';
    }
    return null;
  }

  static String? validateStatus(String? value) {
    if (value == null || value.isEmpty) {
      return 'Status is required';
    }
    return null;
  }

  static String? validateCreatedById(String? value) {
    if (value == null || value.isEmpty) {
      return 'Created by is required';
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

  static String? validateDescription(String? value) {
    if (value != null && value.isNotEmpty) {
      if (value.length > 500) {
        return 'Description must not exceed 500 characters';
      }
    }
    return null;
  }

  static String? validateFrequencyMonths(String? value) {
    if (value != null && value.isNotEmpty) {
      final freq = int.tryParse(value);
      if (freq == null) {
        return 'Frequency months must be a valid number';
      }
      if (freq <= 0) {
        return 'Frequency months must be greater than 0';
      }
    }
    return null;
  }
}
