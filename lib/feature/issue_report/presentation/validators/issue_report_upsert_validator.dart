class IssueReportUpsertValidator {
  static String? validateAssetId(String? value, {bool isUpdate = false}) {
    if (!isUpdate && (value == null || value.isEmpty)) {
      return 'Asset is required';
    }
    return null;
  }

  static String? validateReportedById(String? value, {bool isUpdate = false}) {
    if (!isUpdate && (value == null || value.isEmpty)) {
      return 'Reported by is required';
    }
    return null;
  }

  static String? validateIssueType(String? value, {bool isUpdate = false}) {
    if (!isUpdate && (value == null || value.isEmpty)) {
      return 'Issue type is required';
    }
    if (value != null && value.isNotEmpty) {
      if (value.length > 100) {
        return 'Issue type must not exceed 100 characters';
      }
    }
    return null;
  }

  static String? validatePriority(String? value, {bool isUpdate = false}) {
    if (!isUpdate && (value == null || value.isEmpty)) {
      return 'Priority is required';
    }
    return null;
  }

  static String? validateStatus(String? value, {bool isUpdate = false}) {
    if (!isUpdate && (value == null || value.isEmpty)) {
      return 'Status is required';
    }
    return null;
  }

  static String? validateTitle(String? value, {bool isUpdate = false}) {
    if (!isUpdate && (value == null || value.isEmpty)) {
      return 'Title is required';
    }
    if (value != null && value.isNotEmpty) {
      if (value.length > 200) {
        return 'Title must not exceed 200 characters';
      }
    }
    return null;
  }

  static String? validateDescription(String? value, {bool isUpdate = false}) {
    if (value != null && value.isNotEmpty) {
      if (value.length > 1000) {
        return 'Description must not exceed 1000 characters';
      }
    }
    return null;
  }

  static String? validateResolvedBy(String? value, {bool isUpdate = false}) {
    // Resolved by is optional for updates
    return null;
  }

  static String? validateResolutionNotes(
    String? value, {
    bool isUpdate = false,
  }) {
    if (value != null && value.isNotEmpty) {
      if (value.length > 1000) {
        return 'Resolution notes must not exceed 1000 characters';
      }
    }
    return null;
  }
}
