class UserChangePasswordValidator {
  static String? validateCurrentPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Current password is required';
    }
    return null;
  }

  static String? validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'New password is required';
    }
    // if (value.length < 8) {
    //   return 'Password must be at least 8 characters';
    // }
    // if (value.length > 100) {
    //   return 'Password must not exceed 100 characters';
    // }
    // // * Password harus punya minimal 1 huruf besar, 1 huruf kecil, 1 angka
    // if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$').hasMatch(value)) {
    //   return 'Password must contain uppercase, lowercase, and number';
    // }
    return null;
  }

  static String? validateConfirmPassword(String? value, String? newPassword) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required';
    }
    if (value != newPassword) {
      return 'Passwords do not match';
    }
    return null;
  }
}
