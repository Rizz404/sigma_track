import 'package:flutter/material.dart';
import 'package:sigma_track/core/extensions/localization_extension.dart';

class LocationUpsertValidator {
  static String? validateLocationCode(BuildContext context, String? value, {bool isUpdate = false}) {
    if (!isUpdate && (value == null || value.isEmpty)) {
      return context.l10n.locationValidationCodeRequired;
    }
    if (value != null && value.isNotEmpty) {
      if (value.length < 2) {
        return context.l10n.locationValidationCodeMinLength;
      }
      if (value.length > 20) {
        return context.l10n.locationValidationCodeMaxLength;
      }
      // ! Location code hanya boleh alfanumerik dan dash
      if (!RegExp(r'^[a-zA-Z0-9-]+$').hasMatch(value)) {
        return context.l10n.locationValidationCodeAlphanumeric;
      }
    }
    return null;
  }

  static String? validateLocationName(BuildContext context, String? value, {bool isUpdate = false}) {
    if (!isUpdate && (value == null || value.isEmpty)) {
      return context.l10n.locationValidationNameRequired;
    }
    if (value != null && value.isNotEmpty) {
      if (value.length < 3) {
        return context.l10n.locationValidationNameMinLength;
      }
      if (value.length > 100) {
        return context.l10n.locationValidationNameMaxLength;
      }
    }
    return null;
  }

  static String? validateBuilding(BuildContext context, String? value, {bool isUpdate = false}) {
    if (value != null && value.isNotEmpty) {
      if (value.length > 50) {
        return context.l10n.locationValidationBuildingMaxLength;
      }
    }
    return null;
  }

  static String? validateFloor(BuildContext context, String? value, {bool isUpdate = false}) {
    if (value != null && value.isNotEmpty) {
      if (value.length > 20) {
        return context.l10n.locationValidationFloorMaxLength;
      }
    }
    return null;
  }

  static String? validateLatitude(BuildContext context, String? value, {bool isUpdate = false}) {
    if (value != null && value.isNotEmpty) {
      final lat = double.tryParse(value);
      if (lat == null) {
        return context.l10n.locationValidationLatitudeInvalid;
      }
      if (lat < -90 || lat > 90) {
        return context.l10n.locationValidationLatitudeRange;
      }
    }
    return null;
  }

  static String? validateLongitude(BuildContext context, String? value, {bool isUpdate = false}) {
    if (value != null && value.isNotEmpty) {
      final lng = double.tryParse(value);
      if (lng == null) {
        return context.l10n.locationValidationLongitudeInvalid;
      }
      if (lng < -180 || lng > 180) {
        return context.l10n.locationValidationLongitudeRange;
      }
    }
    return null;
  }
}
