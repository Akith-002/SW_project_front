class OfficesRatingCardValidator {
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
    // Check for special characters first
    if (RegExp(r'[!@#$%^&*()_+={}[\]|\\:;"<>?/~`]').hasMatch(value)) {
      return '$fieldName cannot contain special characters';
    }
    final regex = RegExp(r'^[a-zA-Z0-9\s\-.,]+$');
    if (!regex.hasMatch(value)) {
      return '$fieldName must contain only letters, numbers, spaces, hyphens, commas, and periods';
    }
    return null;
  }

  /// Validates numeric fields (positive integers only)
  static String? validatePositiveInteger(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    // Check if contains any non-digit characters
    if (RegExp(r'[^0-9]').hasMatch(value)) {
      return '$fieldName must contain only numbers (no letters or special characters)';
    }
    final number = int.tryParse(value);
    if (number == null) {
      return '$fieldName must be a valid number';
    }
    if (number <= 0) {
      return '$fieldName must be greater than zero';
    }
    return null;
  }

  /// Validates age field (must be between 0 and 150)
  static String? validateAge(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    // Check if contains any non-digit characters
    if (RegExp(r'[^0-9]').hasMatch(value)) {
      return '$fieldName must contain only numbers (no letters or special characters)';
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
    // Check for invalid characters (allow digits, decimal point, and optional negative sign)
    if (RegExp(r'[^0-9.]').hasMatch(value)) {
      return '$fieldName must contain only numbers and decimal point';
    }
    // Check for multiple decimal points
    if (value.split('.').length > 2) {
      return '$fieldName can only have one decimal point';
    }
    final number = double.tryParse(value);
    if (number == null) {
      return '$fieldName must be a valid number';
    }
    if (number < 0) {
      return '$fieldName must be a positive number (greater than or equal to 0)';
    }
    // Check decimal places (max 2)
    if (value.contains('.')) {
      final parts = value.split('.');
      if (parts.length > 1 && parts[1].length > 2) {
        return '$fieldName can have maximum 2 decimal places';
      }
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

  /// Validates floor number (can be negative for basements, 0 for ground)
  static String? validateFloorNumber(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    // Check if contains any non-digit characters (except minus sign at start)
    if (RegExp(r'[^0-9\-]').hasMatch(value) || (value.contains('-') && !value.startsWith('-'))) {
      return '$fieldName must be a whole number (use negative for basement floors, e.g., -1 for B1)';
    }
    final number = int.tryParse(value);
    if (number == null) {
      return '$fieldName must be a valid number';
    }
    if (number < -10) {
      return '$fieldName cannot be less than -10 (basement 10)';
    }
    if (number > 200) {
      return '$fieldName cannot be more than 200';
    }
    return null;
  }

  /// Validates ceiling height (in feet or meters)
  static String? validateCeilingHeight(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    // Check for invalid characters
    if (RegExp(r'[^0-9.]').hasMatch(value)) {
      return '$fieldName must contain only numbers and decimal point';
    }
    // Check for multiple decimal points
    if (value.split('.').length > 2) {
      return '$fieldName can only have one decimal point';
    }
    final number = double.tryParse(value);
    if (number == null) {
      return '$fieldName must be a valid number';
    }
    if (number <= 0) {
      return '$fieldName must be greater than 0';
    }
    if (number > 50) {
      return '$fieldName seems too high (max 50), please verify';
    }
    return null;
  }
}