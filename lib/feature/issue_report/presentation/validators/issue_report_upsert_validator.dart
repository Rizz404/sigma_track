import 'package:sigma_track/core/extensions/localization_extension.dart';
import 'package:flutter/material.dart';

class IssueReportUpsertValidator {
  static String? validateAssetId(
    String? value, {
    required BuildContext context,
    bool isUpdate = false,
  }) {
    if (!isUpdate && (value == null || value.isEmpty)) {
      return context.l10n.issueReportValidationAssetRequired;
    }
    return null;
  }

  static String? validateReportedById(
    String? value, {
    required BuildContext context,
    bool isUpdate = false,
  }) {
    if (!isUpdate && (value == null || value.isEmpty)) {
      return context.l10n.issueReportValidationReportedByRequired;
    }
    return null;
  }

  static String? validateIssueType(
    String? value, {
    required BuildContext context,
    bool isUpdate = false,
  }) {
    if (!isUpdate && (value == null || value.isEmpty)) {
      return context.l10n.issueReportValidationIssueTypeRequired;
    }
    if (value != null && value.isNotEmpty) {
      if (value.length > 100) {
        return context.l10n.issueReportValidationIssueTypeMaxLength;
      }
    }
    return null;
  }

  static String? validatePriority(
    String? value, {
    required BuildContext context,
    bool isUpdate = false,
  }) {
    if (!isUpdate && (value == null || value.isEmpty)) {
      return context.l10n.issueReportValidationPriorityRequired;
    }
    return null;
  }

  static String? validateStatus(
    String? value, {
    required BuildContext context,
    bool isUpdate = false,
  }) {
    if (!isUpdate && (value == null || value.isEmpty)) {
      return context.l10n.issueReportValidationStatusRequired;
    }
    return null;
  }

  static String? validateTitle(
    String? value, {
    required BuildContext context,
    bool isUpdate = false,
  }) {
    if (!isUpdate && (value == null || value.isEmpty)) {
      return context.l10n.issueReportValidationTitleRequired;
    }
    if (value != null && value.isNotEmpty) {
      if (value.length > 200) {
        return context.l10n.issueReportValidationTitleMaxLength;
      }
    }
    return null;
  }

  static String? validateDescription(
    String? value, {
    required BuildContext context,
    bool isUpdate = false,
  }) {
    if (value != null && value.isNotEmpty) {
      if (value.length > 1000) {
        return context.l10n.issueReportValidationDescriptionMaxLength;
      }
    }
    return null;
  }

  static String? validateResolvedBy(
    String? value, {
    required BuildContext context,
    bool isUpdate = false,
  }) {
    // Resolved by is optional for updates
    return null;
  }

  static String? validateResolutionNotes(
    String? value, {
    required BuildContext context,
    bool isUpdate = false,
  }) {
    if (value != null && value.isNotEmpty) {
      if (value.length > 1000) {
        return context.l10n.issueReportValidationResolutionNotesMaxLength;
      }
    }
    return null;
  }
}
