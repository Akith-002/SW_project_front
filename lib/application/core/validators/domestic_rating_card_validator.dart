class DomesticRatingCardValidator {
  /// Validates required text fields
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validates alphanumeric fields (allows letters, numbers, and spaces)
  static String? validateAlphaNumeric(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    final regex = RegExp(r'^[a-zA-Z0-9\s\-.,]+$');
    if (!regex.hasMatch(value)) {
      return '$fieldName must contain only letters, numbers, spaces, and basic punctuation';
    }
    return null;
  }

  /// Validates numeric fields (positive integers only)
  static String? validatePositiveInteger(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    final number = int.tryParse(value);
    if (number == null || number <= 0) {
      return '$fieldName must be a positive number';
    }
    return null;
  }

  /// Validates age field (must be between 0 and 150)
  static String? validateAge(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    final number = int.tryParse(value);
    if (number == null) {
      return '$fieldName must be a valid number';
    }
    if (number < 0) {
      return '$fieldName cannot be negative';
    }
    if (number > 150) {
      return '$fieldName cannot be more than 150 years';
    }
    return null;
  }

  /// Validates decimal fields (positive numbers with decimals)
  static String? validatePositiveDecimal(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    final number = double.tryParse(value);
    if (number == null || number < 0) {
      return '$fieldName must be a valid positive number';
    }
    return null;
  }

  /// Validates dropdown selections
  static String? validateDropdown(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty || value.startsWith('Select')) {
      return 'Please select a $fieldName';
    }
    return null;
  }

  /// Validates date fields
  static String? validateDate(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    try {
      DateTime.parse(value);
      return null;
    } catch (e) {
      return 'Please enter a valid date for $fieldName';
    }
  }

  /// Optional text validation (allows empty but validates format if provided)
  static String? validateOptionalText(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field
    }
    final regex = RegExp(r'^[a-zA-Z0-9\s\-.,/()]+$');
    if (!regex.hasMatch(value)) {
      return '$fieldName must contain only letters, numbers, spaces, and basic punctuation';
    }
    return null;
  }

  /// Validates maximum length
  static String? validateMaxLength(
      String? value, int maxLength, String fieldName) {
    if (value != null && value.length > maxLength) {
      return '$fieldName cannot exceed $maxLength characters';
    }
    return null;
  }

  /// Combined validation for optional text with max length
  static String? validateOptionalTextWithLength(
      String? value, int maxLength, String fieldName) {
    return validateOptionalText(value, fieldName) ??
        validateMaxLength(value, maxLength, fieldName);
  }

  /// Combined validation for required text with max length
  static String? validateRequiredTextWithLength(
      String? value, int maxLength, String fieldName) {
    return validateAlphaNumeric(value, fieldName) ??
        validateMaxLength(value, maxLength, fieldName);
  }
}
