class LocationUpsertValidator {
  static String? validateLocationCode(String? value, {bool isUpdate = false}) {
    if (!isUpdate && (value == null || value.isEmpty)) {
      return 'Location code is required';
    }
    if (value != null && value.isNotEmpty) {
      if (value.length < 2) {
        return 'Location code must be at least 2 characters';
      }
      if (value.length > 20) {
        return 'Location code must not exceed 20 characters';
      }
      // ! Location code hanya boleh alfanumerik dan dash
      if (!RegExp(r'^[a-zA-Z0-9-]+$').hasMatch(value)) {
        return 'Location code can only contain letters, numbers, and dashes';
      }
    }
    return null;
  }

  static String? validateLocationName(String? value, {bool isUpdate = false}) {
    if (!isUpdate && (value == null || value.isEmpty)) {
      return 'Location name is required';
    }
    if (value != null && value.isNotEmpty) {
      if (value.length < 3) {
        return 'Location name must be at least 3 characters';
      }
      if (value.length > 100) {
        return 'Location name must not exceed 100 characters';
      }
    }
    return null;
  }

  static String? validateBuilding(String? value, {bool isUpdate = false}) {
    if (value != null && value.isNotEmpty) {
      if (value.length > 50) {
        return 'Building must not exceed 50 characters';
      }
    }
    return null;
  }

  static String? validateFloor(String? value, {bool isUpdate = false}) {
    if (value != null && value.isNotEmpty) {
      if (value.length > 20) {
        return 'Floor must not exceed 20 characters';
      }
    }
    return null;
  }

  static String? validateLatitude(String? value, {bool isUpdate = false}) {
    if (value != null && value.isNotEmpty) {
      final lat = double.tryParse(value);
      if (lat == null) {
        return 'Latitude must be a valid number';
      }
      if (lat < -90 || lat > 90) {
        return 'Latitude must be between -90 and 90';
      }
    }
    return null;
  }

  static String? validateLongitude(String? value, {bool isUpdate = false}) {
    if (value != null && value.isNotEmpty) {
      final lng = double.tryParse(value);
      if (lng == null) {
        return 'Longitude must be a valid number';
      }
      if (lng < -180 || lng > 180) {
        return 'Longitude must be between -180 and 180';
      }
    }
    return null;
  }
}
