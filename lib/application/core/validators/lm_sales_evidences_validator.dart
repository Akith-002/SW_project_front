/// Validator class for LM Sales Evidences form.
/// Provides static methods for validating various form fields.
class LmSalesEvidencesValidator {
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

    // Additional coordinate range validation
    if (value != null && value.trim().isNotEmpty) {
      double? coordinate = double.tryParse(value);
      if (coordinate != null) {
        if (fieldName.toLowerCase().contains('latitude')) {
          if (coordinate < -90 || coordinate > 90) {
            return '$fieldName must be between -90 and 90 degrees';
          }
        } else if (fieldName.toLowerCase().contains('longitude')) {
          if (coordinate < -180 || coordinate > 180) {
            return '$fieldName must be between -180 and 180 degrees';
          }
        }
      }
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
    String? requiredError = required(value, fieldName);
    if (requiredError != null) return requiredError;

    String? alphanumericError = alphanumeric(value, fieldName);
    if (alphanumericError != null) return alphanumericError;

    return maxLength(value, max, fieldName);
  }

  /// Validates a required numeric field with max length
  static String? requiredNumeric(String? value, int max, String fieldName) {
    String? requiredError = required(value, fieldName);
    if (requiredError != null) return requiredError;

    String? numericError = numeric(value, fieldName);
    if (numericError != null) return numericError;

    return maxLength(value, max, fieldName);
  }

  /// Validates a required integer field with max length
  static String? requiredInteger(String? value, int max, String fieldName) {
    String? requiredError = required(value, fieldName);
    if (requiredError != null) return requiredError;

    String? integerError = integer(value, fieldName);
    if (integerError != null) return integerError;

    return maxLength(value, max, fieldName);
  }

  /// Validates a coordinate field (latitude/longitude)
  static String? requiredCoordinate(String? value, String fieldName) {
    String? requiredError = required(value, fieldName);
    if (requiredError != null) return requiredError;

    return coordinate(value, fieldName);
  }

  /// Validates an optional coordinate field
  static String? optionalCoordinate(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field can be empty
    }
    return coordinate(value, fieldName);
  }

  /// Validates date fields (basic format validation)
  static String? date(String? value, String fieldName) {
    if (value != null && value.trim().isNotEmpty) {
      // Basic date format validation (supports various formats)
      final dateRegex = RegExp(
          r'^\d{1,2}[/-]\d{1,2}[/-]\d{4}$|^\d{4}[/-]\d{1,2}[/-]\d{1,2}$');
      if (!dateRegex.hasMatch(value)) {
        return '$fieldName must be a valid date format';
      }
    }
    return null;
  }

  /// Validates a required date field
  static String? requiredDate(String? value, String fieldName) {
    String? requiredError = required(value, fieldName);
    if (requiredError != null) return requiredError;

    return date(value, fieldName);
  }

  /// Validates an optional date field
  static String? optionalDate(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field can be empty
    }
    return date(value, fieldName);
  }

  /// Validates deed/document number (alphanumeric with some special characters)
  static String? deedNumber(String? value, String fieldName) {
    if (value != null && value.trim().isNotEmpty) {
      final regex = RegExp(r'^[a-zA-Z0-9\s\-_/]*$');
      if (!regex.hasMatch(value)) {
        return '$fieldName must contain only letters, numbers, spaces, hyphens, underscores, and forward slashes';
      }
    }
    return null; // Additional deed number specific validations can be added here
  }

  /// Validates a required deed number field
  static String? requiredDeedNumber(String? value, String fieldName) {
    String? requiredError = required(value, fieldName);
    if (requiredError != null) return requiredError;

    return deedNumber(value, fieldName);
  }

  /// Validates an optional deed number field
  static String? optionalDeedNumber(String? value, int max, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field can be empty
    }
    return deedNumber(value, fieldName) ?? maxLength(value, max, fieldName);
  }
}
