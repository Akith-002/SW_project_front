/// Validator class for LM Building Rates form.
/// Provides static methods for validating various form fields.
class LmBuildingRatesValidator {
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
      return '$fieldName must be a whole number';
    }
    return null;
  }

  /// Validates decimal values
  static String? decimal(String? value, String fieldName) {
    final regex = RegExp(r'^\d+(\.\d{1,2})?$');
    if (value != null && value.trim().isNotEmpty && !regex.hasMatch(value)) {
      return '$fieldName must be a valid decimal number with up to 2 decimal places';
    }
    return null;
  }

  /// Validates latitude values
  static String? latitude(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field
    }

    final numericValue = double.tryParse(value.trim());
    if (numericValue == null) {
      return '$fieldName must be a valid number';
    }

    if (numericValue < -90 || numericValue > 90) {
      return '$fieldName must be between -90 and 90 degrees';
    }

    return null;
  }

  /// Validates longitude values
  static String? longitude(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field
    }

    final numericValue = double.tryParse(value.trim());
    if (numericValue == null) {
      return '$fieldName must be a valid number';
    }

    if (numericValue < -180 || numericValue > 180) {
      return '$fieldName must be between -180 and 180 degrees';
    }

    return null;
  }

  /// Validates year values
  static String? year(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    final yearValue = int.tryParse(value.trim());
    if (yearValue == null) {
      return '$fieldName must be a valid year';
    }

    final currentYear = DateTime.now().year;
    if (yearValue < 1800 || yearValue > currentYear + 10) {
      return '$fieldName must be between 1800 and ${currentYear + 10}';
    }

    return null;
  }

  // Required field validators with specific constraints

  /// Validates required Assessment Number field
  static String? requiredAssessmentNumber(
      String? value, int maxLength, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    // Check maximum length
    final lengthError =
        LmBuildingRatesValidator.maxLength(value, maxLength, fieldName);
    if (lengthError != null) return lengthError;

    // Check alphanumeric format
    final formatError = LmBuildingRatesValidator.alphanumeric(value, fieldName);
    if (formatError != null) return formatError;

    return null;
  }

  /// Validates required Owner field
  static String? requiredOwner(String? value, int maxLength, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    // Check maximum length
    final lengthError =
        LmBuildingRatesValidator.maxLength(value, maxLength, fieldName);
    if (lengthError != null) return lengthError;

    // Check alphanumeric format
    final formatError = LmBuildingRatesValidator.alphanumeric(value, fieldName);
    if (formatError != null) return formatError;

    return null;
  }

  /// Validates required Constructed By field
  static String? requiredConstructedBy(
      String? value, int maxLength, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    // Check maximum length
    final lengthError =
        LmBuildingRatesValidator.maxLength(value, maxLength, fieldName);
    if (lengthError != null) return lengthError;

    // Check alphanumeric format
    final formatError = LmBuildingRatesValidator.alphanumeric(value, fieldName);
    if (formatError != null) return formatError;

    return null;
  }

  /// Validates required Year of Construction field
  static String? requiredYearOfConstruction(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    return LmBuildingRatesValidator.year(value, fieldName);
  }

  /// Validates required Floor Area field
  static String? requiredFloorArea(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    return LmBuildingRatesValidator.decimal(value, fieldName);
  }

  /// Validates required Rate Per SQFT field
  static String? requiredRatePerSQFT(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    return LmBuildingRatesValidator.decimal(value, fieldName);
  }

  /// Validates required Cost field
  static String? requiredCost(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    return LmBuildingRatesValidator.decimal(value, fieldName);
  }

  // Optional field validators

  /// Validates optional Description field
  static String? optionalDescription(
      String? value, int maxLength, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field
    }

    // Check maximum length
    final lengthError =
        LmBuildingRatesValidator.maxLength(value, maxLength, fieldName);
    if (lengthError != null) return lengthError;

    // Check alphanumeric format
    final formatError = LmBuildingRatesValidator.alphanumeric(value, fieldName);
    if (formatError != null) return formatError;

    return null;
  }

  /// Validates optional Remarks field
  static String? optionalRemarks(
      String? value, int maxLength, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field
    }

    // Check maximum length
    final lengthError =
        LmBuildingRatesValidator.maxLength(value, maxLength, fieldName);
    if (lengthError != null) return lengthError;

    // Check alphanumeric format
    final formatError = LmBuildingRatesValidator.alphanumeric(value, fieldName);
    if (formatError != null) return formatError;

    return null;
  }

  /// Validates optional Location Latitude field
  static String? optionalLocationLatitude(String? value, String fieldName) {
    return LmBuildingRatesValidator.latitude(value, fieldName);
  }

  /// Validates optional Location Longitude field
  static String? optionalLocationLongitude(String? value, String fieldName) {
    return LmBuildingRatesValidator.longitude(value, fieldName);
  }

  /// Combined validation for all required fields
  static Map<String, String?> validateAllRequiredFields({
    required String? assessmentNumber,
    required String? owner,
    required String? constructedBy,
    required String? yearOfConstruction,
    required String? floorAreaSQFT,
    required String? ratePerSQFT,
    required String? cost,
  }) {
    final errors = <String, String?>{};

    errors['assessmentNumber'] =
        requiredAssessmentNumber(assessmentNumber, 50, 'Assessment Number');
    errors['owner'] = requiredOwner(owner, 100, 'Owner');
    errors['constructedBy'] =
        requiredConstructedBy(constructedBy, 100, 'Constructed By');
    errors['yearOfConstruction'] =
        requiredYearOfConstruction(yearOfConstruction, 'Year of Construction');
    errors['floorAreaSQFT'] =
        requiredFloorArea(floorAreaSQFT, 'Floor Area (SQFT)');
    errors['ratePerSQFT'] = requiredRatePerSQFT(ratePerSQFT, 'Rate Per SQFT');
    errors['cost'] = requiredCost(cost, 'Cost');

    // Remove null entries
    errors.removeWhere((key, value) => value == null);

    return errors;
  }

  /// Check if form is valid (no validation errors)
  static bool isFormValid({
    required String? assessmentNumber,
    required String? owner,
    required String? constructedBy,
    required String? yearOfConstruction,
    required String? floorAreaSQFT,
    required String? ratePerSQFT,
    required String? cost,
  }) {
    final errors = validateAllRequiredFields(
      assessmentNumber: assessmentNumber,
      owner: owner,
      constructedBy: constructedBy,
      yearOfConstruction: yearOfConstruction,
      floorAreaSQFT: floorAreaSQFT,
      ratePerSQFT: ratePerSQFT,
      cost: cost,
    );

    return errors.isEmpty;
  }
}
