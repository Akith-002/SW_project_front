import 'dart:typed_data';

class SignatureFormValidator {
  /// Validates if a signature is provided and not empty
  static String? validateSignature(Uint8List? signature, String fieldName) {
    if (signature == null || signature.isEmpty) {
      return '$fieldName signature is required';
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

  /// Validates if a numeric field contains only numbers
  static String? validateNumeric(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return '$fieldName must contain only numbers';
    }
    return null;
  }

  /// Validates if a date field has a valid date format
  static String? validateDate(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    try {
      DateTime.parse(value);
      return null;
    } catch (e) {
      return 'Invalid date format for $fieldName';
    }
  }

  /// Validates if a text field contains only alphanumeric characters
  static String? validateAlphaNumeric(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    if (!RegExp(r'^[a-zA-Z0-9\s]+$').hasMatch(value)) {
      return '$fieldName must contain only letters and numbers';
    }
    return null;
  }
}
