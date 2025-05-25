class InspectionValidator {
  static String? required(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? maxLength(String? value, int max, String fieldName) {
    if (value != null && value.length > max) {
      return '$fieldName cannot exceed $max characters';
    }
    return null;
  }

  static String? alphanumeric(String? value, String fieldName) {
    final regex = RegExp(r'^[a-zA-Z0-9\s]*$');
    if (value != null && value.isNotEmpty && !regex.hasMatch(value)) {
      return '$fieldName must be alphanumeric';
    }
    return null;
  }

  static String? optionalAlphaNum(String? value, int max, String fieldName) {
    return alphanumeric(value, fieldName) ?? maxLength(value, max, fieldName);
  }

  static String? requiredField(String? value, String fieldName) {
    return required(value, fieldName);
  }
}
