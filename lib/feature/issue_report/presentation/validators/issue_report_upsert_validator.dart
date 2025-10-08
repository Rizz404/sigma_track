class IssueReportUpsertValidator {
  static String? validateAssetId(String? value) {
    if (value == null || value.isEmpty) {
      return 'Asset is required';
    }
    return null;
  }

  static String? validateReportedById(String? value) {
    if (value == null || value.isEmpty) {
      return 'Reported by is required';
    }
    return null;
  }

  static String? validateIssueType(String? value) {
    if (value == null || value.isEmpty) {
      return 'Issue type is required';
    }
    if (value.length > 100) {
      return 'Issue type must not exceed 100 characters';
    }
    return null;
  }

  static String? validatePriority(String? value) {
    if (value == null || value.isEmpty) {
      return 'Priority is required';
    }
    return null;
  }

  static String? validateStatus(String? value) {
    if (value == null || value.isEmpty) {
      return 'Status is required';
    }
    return null;
  }

  static String? validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Title is required';
    }
    if (value.length > 200) {
      return 'Title must not exceed 200 characters';
    }
    return null;
  }

  static String? validateDescription(String? value) {
    if (value != null && value.isNotEmpty) {
      if (value.length > 1000) {
        return 'Description must not exceed 1000 characters';
      }
    }
    return null;
  }

  static String? validateResolutionNotes(String? value) {
    if (value != null && value.isNotEmpty) {
      if (value.length > 1000) {
        return 'Resolution notes must not exceed 1000 characters';
      }
    }
    return null;
  }
}
