class RentalEvidenceValidator {
  /// Validates maximum length for text fields
  static String? maxLength(String? value, int max, String fieldName) {
    if (value != null && value.length > max) {
      return '$fieldName must be less than $max characters';
    }
    return null;
  }

  /// Validates that input is alphanumeric (letters, numbers, spaces, and basic punctuation)
  static String? alphanumeric(String? value, String fieldName) {
    final regex = RegExp(r'^[a-zA-Z0-9\s,.:-]*$');
    if (value != null && value.trim().isNotEmpty && !regex.hasMatch(value)) {
      return '$fieldName must contain only letters, numbers, spaces, and basic punctuation';
    }
    return null;
  }

  /// Validates that input is numeric
  static String? numeric(String? value, String fieldName) {
    final regex = RegExp(r'^\d+(\.\d+)?$');
    if (value != null && value.trim().isNotEmpty && !regex.hasMatch(value)) {
      return '$fieldName must be a valid number';
    }
    return null;
  }

  /// Validates integer values
  static String? integer(String? value, String fieldName) {
    final regex = RegExp(r'^\d+$');
    if (value != null && value.trim().isNotEmpty && !regex.hasMatch(value)) {
      return '$fieldName must be a valid integer';
    }
    return null;
  }

  /// Validates required fields
  static String? required(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validates coordinates (latitude/longitude)
  static String? coordinate(String? value, String fieldName) {
    final regex = RegExp(r'^-?\d+(\.\d+)?$');
    if (value != null && value.trim().isNotEmpty && !regex.hasMatch(value)) {
      return '$fieldName must be a valid coordinate';
    }
    return null;
  }

  /// Validates optional alphanumeric fields with max length
  static String? optionalAlphaNum(String? value, int max, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field can be empty
    }
    return alphanumeric(value, fieldName) ?? maxLength(value, max, fieldName);
  }

  /// Validates optional numeric fields with max length
  static String? optionalNumeric(String? value, int max, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field can be empty
    }
    return numeric(value, fieldName) ?? maxLength(value, max, fieldName);
  }

  /// Validates optional integer fields with max length
  static String? optionalInteger(String? value, int max, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field can be empty
    }
    return integer(value, fieldName) ?? maxLength(value, max, fieldName);
  }

  /// Validates a required alphanumeric field with max length
  static String? requiredAlphaNum(String? value, int max, String fieldName) {
    return required(value, fieldName) ??
        alphanumeric(value, fieldName) ??
        maxLength(value, max, fieldName);
  }

  /// Validates a required numeric field with max length
  static String? requiredNumeric(String? value, int max, String fieldName) {
    return required(value, fieldName) ??
        numeric(value, fieldName) ??
        maxLength(value, max, fieldName);
  }

  /// Validates a required integer field with max length
  static String? requiredInteger(String? value, int max, String fieldName) {
    return required(value, fieldName) ??
        integer(value, fieldName) ??
        maxLength(value, max, fieldName);
  }

  /// Validates a coordinate field (latitude/longitude)
  static String? requiredCoordinate(String? value, String fieldName) {
    return required(value, fieldName) ?? coordinate(value, fieldName);
  }

  /// Validates an optional coordinate field
  static String? optionalCoordinate(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field can be empty
    }
    return coordinate(value, fieldName);
  }
}
