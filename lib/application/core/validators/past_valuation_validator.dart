class PastValuationValidator {
  static String? maxLength(String? value, int max, String fieldName) {
    if (value != null && value.length > max) {
      return '$fieldName must be less than $max characters';
    }
    return null;
  }

  static String? alphanumeric(String? value, String fieldName) {
    final regex = RegExp(r'^[a-zA-Z0-9\s]*$');
    if (value != null && value.trim().isNotEmpty && !regex.hasMatch(value)) {
      return '$fieldName must be alphanumeric';
    }
    return null;
  }

  static String? numeric(String? value, String fieldName) {
    final regex = RegExp(r'^\d+(\.\d+)?$');
    if (value != null && value.trim().isNotEmpty && !regex.hasMatch(value)) {
      return '$fieldName must be numeric';
    }
    return null;
  }

  static String? optionalAlphaNum(String? value, int max, String fieldName) {
    return alphanumeric(value, fieldName) ?? maxLength(value, max, fieldName);
  }

  static String? optionalNumeric(String? value, int max, String fieldName) {
    return numeric(value, fieldName) ?? maxLength(value, max, fieldName);
  }
}
