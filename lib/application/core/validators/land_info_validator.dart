class LandInfoValidator {
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validateNumeric(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return '$fieldName must contain only numbers';
    }
    return null;
  }

  static String? validateAlphaNumeric(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    if (!RegExp(r'^[a-zA-Z0-9\s]+$').hasMatch(value)) {
      return '$fieldName must contain only letters and numbers';
    }
    return null;
  }

  static String? validateDate(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    try {
      // Try to parse the date string
      DateTime.parse(value);
      return null;
    } catch (e) {
      return 'Invalid date format';
    }
  }
}
