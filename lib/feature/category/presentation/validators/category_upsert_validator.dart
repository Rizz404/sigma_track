class CategoryUpsertValidator {
  static String? validateParentId(String? value) {
    if (value == null || value.isEmpty) {
      return 'Parent category is required';
    }
    return null;
  }

  static String? validateCategoryCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Category code is required';
    }
    if (value.length < 2) {
      return 'Category code must be at least 2 characters';
    }
    if (value.length > 20) {
      return 'Category code must not exceed 20 characters';
    }
    // ! Category code hanya boleh alfanumerik dan underscore
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
      return 'Category code can only contain letters, numbers, and underscores';
    }
    return null;
  }

  static String? validateCategoryName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Category name is required';
    }
    if (value.length < 3) {
      return 'Category name must be at least 3 characters';
    }
    if (value.length > 100) {
      return 'Category name must not exceed 100 characters';
    }
    return null;
  }

  static String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Description is required';
    }
    if (value.length < 10) {
      return 'Description must be at least 10 characters';
    }
    if (value.length > 500) {
      return 'Description must not exceed 500 characters';
    }
    return null;
  }
}
