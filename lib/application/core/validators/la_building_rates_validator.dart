/// Validator class for LA Building Rates form.
/// Provides static methods for validating various form fields.
class LaBuildingRatesValidator {
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

  /// Validates year fields
  static String? year(String? value, String fieldName) {
    if (value != null && value.trim().isNotEmpty) {
      final yearRegex = RegExp(r'^\d{4}$');
      if (!yearRegex.hasMatch(value)) {
        return '$fieldName must be a valid 4-digit year';
      }

      int? year = int.tryParse(value);
      if (year != null) {
        int currentYear = DateTime.now().year;
        if (year < 1800 || year > currentYear + 10) {
          return '$fieldName must be between 1800 and ${currentYear + 10}';
        }
      }
    }
    return null;
  }

  /// Validates assessment number (alphanumeric with some special characters)
  static String? assessmentNumber(String? value, String fieldName) {
    if (value != null && value.trim().isNotEmpty) {
      final regex = RegExp(r'^[a-zA-Z0-9\s\-_/]*$');
      if (!regex.hasMatch(value)) {
        return '$fieldName must contain only letters, numbers, spaces, hyphens, underscores, and forward slashes';
      }
    }
    return null;
  }

  /// Validates optional alphanumeric fields with max length
  static String? optionalAlphaNum(String? value, int max, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field can be empty
    }
    String? alphanumericError = alphanumeric(value, fieldName);
    if (alphanumericError != null) return alphanumericError;

    return maxLength(value, max, fieldName);
  }

  /// Validates optional numeric fields with max length
  static String? optionalNumeric(String? value, int max, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field can be empty
    }
    String? numericError = numeric(value, fieldName);
    if (numericError != null) return numericError;

    return maxLength(value, max, fieldName);
  }

  /// Validates optional integer fields with max length
  static String? optionalInteger(String? value, int max, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field can be empty
    }
    String? integerError = integer(value, fieldName);
    if (integerError != null) return integerError;

    return maxLength(value, max, fieldName);
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

  /// Validates a required assessment number field
  static String? requiredAssessmentNumber(
      String? value, int max, String fieldName) {
    String? requiredError = required(value, fieldName);
    if (requiredError != null) return requiredError;

    String? assessmentError = assessmentNumber(value, fieldName);
    if (assessmentError != null) return assessmentError;

    return maxLength(value, max, fieldName);
  }

  /// Validates an optional assessment number field
  static String? optionalAssessmentNumber(
      String? value, int max, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field can be empty
    }
    String? assessmentError = assessmentNumber(value, fieldName);
    if (assessmentError != null) return assessmentError;

    return maxLength(value, max, fieldName);
  }

  /// Validates a required year field
  static String? requiredYear(String? value, String fieldName) {
    String? requiredError = required(value, fieldName);
    if (requiredError != null) return requiredError;

    return year(value, fieldName);
  }

  /// Validates an optional year field
  static String? optionalYear(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field can be empty
    }
    return year(value, fieldName);
  }

  /// Validates area in square feet (positive number)
  static String? areaSquareFeet(String? value, String fieldName) {
    if (value != null && value.trim().isNotEmpty) {
      double? area = double.tryParse(value);
      if (area == null) {
        return '$fieldName must be a valid number';
      }
      if (area <= 0) {
        return '$fieldName must be greater than 0';
      }
      if (area > 1000000) {
        // Reasonable upper limit
        return '$fieldName seems too large, please verify';
      }
    }
    return null;
  }

  /// Validates a required area field
  static String? requiredArea(String? value, String fieldName) {
    String? requiredError = required(value, fieldName);
    if (requiredError != null) return requiredError;

    return areaSquareFeet(value, fieldName);
  }

  /// Validates an optional area field
  static String? optionalArea(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field can be empty
    }
    return areaSquareFeet(value, fieldName);
  }

  /// Validates rate per square foot (positive number)
  static String? ratePerSquareFoot(String? value, String fieldName) {
    if (value != null && value.trim().isNotEmpty) {
      double? rate = double.tryParse(value);
      if (rate == null) {
        return '$fieldName must be a valid number';
      }
      if (rate <= 0) {
        return '$fieldName must be greater than 0';
      }
      if (rate > 100000) {
        // Reasonable upper limit
        return '$fieldName seems too high, please verify';
      }
    }
    return null;
  }

  /// Validates a required rate field
  static String? requiredRate(String? value, String fieldName) {
    String? requiredError = required(value, fieldName);
    if (requiredError != null) return requiredError;

    return ratePerSquareFoot(value, fieldName);
  }

  /// Validates an optional rate field
  static String? optionalRate(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field can be empty
    }
    return ratePerSquareFoot(value, fieldName);
  }

  /// Validates cost (positive number)
  static String? cost(String? value, String fieldName) {
    if (value != null && value.trim().isNotEmpty) {
      double? cost = double.tryParse(value);
      if (cost == null) {
        return '$fieldName must be a valid number';
      }
      if (cost < 0) {
        return '$fieldName cannot be negative';
      }
      if (cost > 1000000000) {
        // Reasonable upper limit
        return '$fieldName seems too high, please verify';
      }
    }
    return null;
  }

  /// Validates a required cost field
  static String? requiredCost(String? value, String fieldName) {
    String? requiredError = required(value, fieldName);
    if (requiredError != null) return requiredError;

    return cost(value, fieldName);
  }

  /// Validates an optional cost field
  static String? optionalCost(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field can be empty
    }
    return cost(value, fieldName);
  }
}
