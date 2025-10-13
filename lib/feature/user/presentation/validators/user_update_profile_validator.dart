import 'package:file_picker/file_picker.dart';

class UserUpdateProfileValidator {
  static String? validateName(String? value) {
    if (value != null && value.isNotEmpty) {
      if (value.length < 3) {
        return 'Name must be at least 3 characters';
      }
      if (value.length > 20) {
        return 'Name must not exceed 20 characters';
      }
      // ! Name hanya boleh alfanumerik dan underscore
      if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
        return 'Name can only contain letters, numbers, and underscores';
      }
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value != null && value.isNotEmpty) {
      // * Email regex pattern standar
      final emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      );
      if (!emailRegex.hasMatch(value)) {
        return 'Please enter a valid email address';
      }
    }
    return null;
  }

  static String? validateFullName(String? value) {
    if (value != null && value.isNotEmpty) {
      if (value.length < 3) {
        return 'Full name must be at least 3 characters';
      }
      if (value.length > 100) {
        return 'Full name must not exceed 100 characters';
      }
    }
    return null;
  }

  static String? validateEmployeeId(String? value) {
    if (value != null && value.isNotEmpty) {
      if (value.length > 20) {
        return 'Employee ID must not exceed 20 characters';
      }
    }
    return null;
  }

  static String? validateAvatar(List<PlatformFile>? files) {
    if (files != null && files.isNotEmpty) {
      final file = files.first;
      final extension = file.extension?.toLowerCase();
      final allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];

      if (!allowedExtensions.contains(extension)) {
        return 'Only image files are allowed (jpg, jpeg, png, gif, webp)';
      }

      // * Max 5MB
      if (file.size > 5 * 1024 * 1024) {
        return 'Image size must not exceed 5MB';
      }
    }
    return null;
  }
}
