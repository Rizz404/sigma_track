class MaintenanceScheduleUpsertValidator {
  static String? validateAssetId(String? value, {bool isUpdate = false}) {
    if (!isUpdate && (value == null || value.isEmpty)) {
      return 'Asset is required';
    }
    return null;
  }

  static String? validateMaintenanceType(
    String? value, {
    bool isUpdate = false,
  }) {
    if (!isUpdate && (value == null || value.isEmpty)) {
      return 'Maintenance type is required';
    }
    return null;
  }

  static String? validateNextScheduledDate(
    DateTime? value, {
    bool isUpdate = false,
  }) {
    if (!isUpdate && value == null) {
      return 'Next scheduled date is required';
    }
    return null;
  }

  static String? validateState(String? value, {bool isUpdate = false}) {
    if (!isUpdate && (value == null || value.isEmpty)) {
      return 'State is required';
    }
    return null;
  }

  static String? validateCreatedById(String? value, {bool isUpdate = false}) {
    if (!isUpdate && (value == null || value.isEmpty)) {
      return 'Created by is required';
    }
    return null;
  }

  static String? validateTitle(String? value, {bool isUpdate = false}) {
    if (!isUpdate && (value == null || value.isEmpty)) {
      return 'Title is required';
    }
    if (value != null && value.isNotEmpty) {
      if (value.length < 3) {
        return 'Title must be at least 3 characters';
      }
      if (value.length > 100) {
        return 'Title must not exceed 100 characters';
      }
    }
    return null;
  }

  static String? validateDescription(String? value, {bool isUpdate = false}) {
    if (value != null && value.isNotEmpty) {
      if (value.length > 500) {
        return 'Description must not exceed 500 characters';
      }
    }
    return null;
  }

  static String? validateIntervalValue(String? value, {bool isUpdate = false}) {
    if (value != null && value.isNotEmpty) {
      final interval = int.tryParse(value);
      if (interval == null) {
        return 'Interval value must be a valid number';
      }
      if (interval <= 0) {
        return 'Interval value must be greater than 0';
      }
    }
    return null;
  }

  static String? validateScheduledTime(String? value, {bool isUpdate = false}) {
    if (value != null && value.isNotEmpty) {
      // * Validate time format (HH:mm:ss)
      final timeRegex = RegExp(r'^([0-1]?[0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]$');
      if (!timeRegex.hasMatch(value)) {
        return 'Scheduled time must be in HH:mm:ss format (e.g., 09:30:00)';
      }
    }
    return null;
  }

  static String? validateEstimatedCost(String? value, {bool isUpdate = false}) {
    if (value != null && value.isNotEmpty) {
      // ! Remove thousand separators (dots) before parsing
      final cleanValue = value.replaceAll('.', '');
      final cost = double.tryParse(cleanValue);
      if (cost == null) {
        return 'Estimated cost must be a valid number';
      }
      if (cost < 0) {
        return 'Estimated cost cannot be negative';
      }
    }
    return null;
  }
}
