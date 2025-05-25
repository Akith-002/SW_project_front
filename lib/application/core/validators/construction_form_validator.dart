class ConstructionFormValidator {
  /// Validates if a building or construction description is provided
  /// and contains only alphanumeric characters and spaces.
  static String? validateDescription(String? value, {String fieldName = 'Description'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    final alphanumericRegex = RegExp(r'^[a-zA-Z0-9\s]+$');
    if (!alphanumericRegex.hasMatch(value)) {
      return '$fieldName must contain only letters and numbers';
    }

    return null;
  }
}
