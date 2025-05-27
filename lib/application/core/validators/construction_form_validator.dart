class ConstructionFormValidator {
  /// Validates if a building or construction description is provided
  /// and contains only alphanumeric characters and spaces.
  static String? validateDescription(String? value,
      {String fieldName = 'Description'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    final alphanumericRegex = RegExp(r'^[a-zA-Z0-9\s]+$');
    if (!alphanumericRegex.hasMatch(value.trim())) {
      return '$fieldName must contain only letters and numbers';
    }

    return null;
  }

  /// Validates if a required field has a value
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validates if a numeric field contains only numbers and is not empty
  static String? validateNumeric(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    final numericRegex = RegExp(r'^\d+(\.\d+)?$');
    if (!numericRegex.hasMatch(value.trim())) {
      return '$fieldName must contain only numbers';
    }

    final numValue = double.tryParse(value.trim());
    if (numValue == null || numValue < 0) {
      return '$fieldName must be a valid positive number';
    }

    return null;
  }

  /// Validates if a date field has a valid date format (YYYY-MM-DD)
  static String? validateDate(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    try {
      final date = DateTime.parse(value.trim());
      final now = DateTime.now();

      if (date.isAfter(now)) {
        return '$fieldName cannot be a future date';
      }

      return null;
    } catch (e) {
      return 'Invalid date format for $fieldName (use YYYY-MM-DD)';
    }
  }

  /// Validates if a text field contains only alphanumeric characters and spaces
  static String? validateAlphaNumeric(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    final alphanumericRegex = RegExp(r'^[a-zA-Z0-9\s]+$');
    if (!alphanumericRegex.hasMatch(value.trim())) {
      return '$fieldName must contain only letters, numbers, and spaces';
    }

    return null;
  }

  /// Validates if a measurement value is a positive number with optional decimals
  static String? validateMeasurement(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    final measurementRegex = RegExp(r'^\d+(\.\d{1,2})?$');
    if (!measurementRegex.hasMatch(value.trim())) {
      return '$fieldName must be a valid number with up to 2 decimal places';
    }

    final numValue = double.tryParse(value.trim());
    if (numValue == null || numValue <= 0) {
      return '$fieldName must be greater than zero';
    }

    return null;
  }
}
