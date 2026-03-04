import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:land_asset_valuation/app/base_view.dart';
import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/core/configurations/app_config.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/light_color_list.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';
import 'package:land_asset_valuation/application/core/validators/lm_rental_evidences_validator.dart';
import 'package:land_asset_valuation/application/core/widgets/breadcrumb.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_app_bar.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_button.dart';
import 'package:land_asset_valuation/application/core/widgets/image_upload.dart';
import 'package:land_asset_valuation/application/core/widgets/labeled_text_field.dart';
import 'package:land_asset_valuation/application/pages/LMRentalEvidences/cubit/lm_rental_evidences_cubit.dart';
import 'package:land_asset_valuation/application/pages/LMRentalEvidences/cubit/lm_rental_evidences_state.dart';
import 'package:land_asset_valuation/injection.dart';
import 'package:http/http.dart' as http;

/// LMRentalEvidencesView is the main view for displaying the LM rental evidence form.
class LmRentalEvidencesView extends BasePage {
  const LmRentalEvidencesView({super.key});

  @override
  State<LmRentalEvidencesView> createState() => _LmRentalEvidencesViewState();
}

/// State for LMRentalEvidencesView that handles user input and image uploads.
class _LmRentalEvidencesViewState extends BasePageState<LmRentalEvidencesView> {
  // Instantiate the cubit using dependency injection.
  final _cubit = injection<LmRentalEvidencesCubit>();

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Text controllers for form fields
  final _assessmentNoController = TextEditingController();
  final _masterFileRefNoController = TextEditingController();
  final _ownerController = TextEditingController();
  final _occupierController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _floorRateController = TextEditingController();
  final _ratePerSqftController = TextEditingController();
  final _ratePerMonthController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _headOfTermsController = TextEditingController();
  final _situationController = TextEditingController();
  final _remarksController = TextEditingController();

  // List to store uploaded images.
  List<dynamic> uploadedImages = []; // Track submission state
  bool _isSubmitting = false;

  // Master file data for breadcrumb
  String? _masterFileNo;
  String? _masterFileId;

  // Unique identifier for this specific rental evidence marker
  String? _markerId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _extractNavigationData();
    // Use a post-frame callback to ensure data loading happens after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSavedDataIfExists();
    });
  }

  void _extractNavigationData() {
    final GoRouterState state = GoRouterState.of(context);
    final queryParams = state.uri.queryParameters;

    // Extract master file data
    _masterFileNo = queryParams['masterFileNo'];
    _masterFileId = queryParams['masterFileId']; // Store master file ID
    final masterFileRefNo = queryParams['masterFileRefNo'];

    // Extract coordinates from query parameters
    final lat = queryParams['latitude'];
    final lng = queryParams['longitude'];

    if (lat != null && lat.isNotEmpty) {
      _latitudeController.text = lat;
    }

    if (lng != null && lng.isNotEmpty) {
      _longitudeController.text = lng;
    }

    // Generate unique marker ID based on coordinates
    if (lat != null && lng != null && lat.isNotEmpty && lng.isNotEmpty) {
      // Create a unique identifier using coordinates (rounded to avoid floating point precision issues)
      final roundedLat = double.parse(lat).toStringAsFixed(6);
      final roundedLng = double.parse(lng).toStringAsFixed(6);
      _markerId = '${roundedLat}_$roundedLng';
      debugPrint('Generated marker ID: $_markerId');
    } else {
      // Fallback to timestamp if coordinates are not available
      _markerId = DateTime.now().millisecondsSinceEpoch.toString();
      debugPrint('Generated fallback marker ID: $_markerId');
    }

    // Pre-fill master file reference number if available
    if (masterFileRefNo != null && masterFileRefNo.isNotEmpty) {
      _masterFileRefNoController.text = masterFileRefNo;
      debugPrint('Pre-filled masterFileRefNo from URL: $masterFileRefNo');
    }

    debugPrint(
        "LmRentalEvidences: Extracted data - MasterFileNo: $_masterFileNo, MasterFileRefNo: $masterFileRefNo, Coordinates: ($lat, $lng), MarkerID: $_markerId");
  }

  /// Attempts to load previously saved data for this specific marker
  Future<void> _loadSavedDataIfExists() async {
    if (_masterFileNo == null || _markerId == null) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      // Use both master file number and marker ID to create unique storage key
      final String key = 'lm_rental_evidence_${_masterFileNo}_$_markerId';
      final String? savedDataJson = prefs.getString(key);

      if (savedDataJson != null) {
        final Map<String, dynamic> savedData = jsonDecode(savedDataJson);

        debugPrint(
            'LM Rental Evidence: Found saved data for masterFileNo: $_masterFileNo, markerID: $_markerId');
        debugPrint('Saved masterFileRefNo: ${savedData['masterFileRefNo']}');
        debugPrint(
            'Current masterFileRefNoController: ${_masterFileRefNoController.text}');

        // Load all saved data (we can overwrite since this is the same marker)
        _assessmentNoController.text = savedData['assessmentNo'] ?? '';
        _ownerController.text = savedData['owner'] ?? '';
        _occupierController.text = savedData['occupier'] ?? '';
        _descriptionController.text = savedData['description'] ?? '';
        _floorRateController.text = savedData['floorRate'] ?? '';
        _ratePerSqftController.text = savedData['ratePerSqft'] ?? '';
        _ratePerMonthController.text = savedData['ratePerMonth'] ?? '';
        _headOfTermsController.text = savedData['headOfTerms'] ?? '';
        _situationController.text = savedData['situation'] ?? '';
        _remarksController.text = savedData['remarks'] ?? '';

        // Load coordinates (these should match the current coordinates from URL)
        final savedLng = savedData['longitude'] ?? '';
        final savedLat = savedData['latitude'] ?? '';
        if (savedLng.isNotEmpty) {
          _longitudeController.text = savedLng;
        }
        if (savedLat.isNotEmpty) {
          _latitudeController.text = savedLat;
        }

        // Load master file ref no if available
        final savedMasterFileRefNo = savedData['masterFileRefNo'] ?? '';
        if (savedMasterFileRefNo.isNotEmpty) {
          _masterFileRefNoController.text = savedMasterFileRefNo;
          debugPrint(
              'Loaded masterFileRefNo from saved data: ${_masterFileRefNoController.text}');
        }

        debugPrint(
            'LM Rental Evidence: Loaded previously saved data for this specific marker');

        // Force a rebuild to update the UI with loaded data
        if (mounted) {
          setState(() {});
        }
      } else {
        debugPrint(
            'LM Rental Evidence: No saved data found for masterFileNo: $_masterFileNo, markerID: $_markerId');
      }
    } catch (e) {
      debugPrint('Error loading saved data: $e');
    }
  }

  @override
  void dispose() {
    // Dispose all controllers
    _assessmentNoController.dispose();
    _masterFileRefNoController.dispose();
    _ownerController.dispose();
    _occupierController.dispose();
    _descriptionController.dispose();
    _floorRateController.dispose();
    _ratePerSqftController.dispose();
    _ratePerMonthController.dispose();
    _longitudeController.dispose();
    _latitudeController.dispose();
    _headOfTermsController.dispose();
    _situationController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  // Helper method to show error messages
  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  // Helper method to show success messages
  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  // Local save method - validates and saves locally without backend submission
  void _saveLocally() {
    debugPrint('=== Save button pressed ===');
    debugPrint('Master File No: $_masterFileNo');
    debugPrint('Marker ID: $_markerId');
    debugPrint(
        'Master File Ref No Controller text: "${_masterFileRefNoController.text}"');
    debugPrint(
        'Master File Ref No Controller text length: ${_masterFileRefNoController.text.length}');
    debugPrint(
        'Is Master File Ref No empty: ${_masterFileRefNoController.text.isEmpty}');

    if (_formKey.currentState!.validate()) {
      debugPrint('Form validation PASSED');
      // All form validation passed, now perform additional data type validation
      try {
        // Create a map to track all validation issues
        Map<String, String> validationErrors = {};

        // Validate numeric fields
        _validateNumericField(
            _floorRateController.text, 'Floor Rate', validationErrors);
        _validateNumericField(
            _ratePerSqftController.text, 'Rate Per Sqft', validationErrors);
        _validateNumericField(
            _ratePerMonthController.text, 'Rate Per Month', validationErrors);

        // Validate coordinate fields
        _validateCoordinateField(
            _longitudeController.text, 'Longitude', validationErrors);
        _validateCoordinateField(
            _latitudeController.text, 'Latitude', validationErrors);

        // If there are validation errors, show them and stop
        if (validationErrors.isNotEmpty) {
          String errorMessage = 'Validation errors:\n';
          validationErrors.forEach((field, error) {
            errorMessage += '• $field: $error\n';
          });
          _showErrorMessage(errorMessage);
          return;
        }

        // Double-check numeric conversions
        try {
          // Ensure these are valid numbers
          double.parse(_floorRateController.text);
          double.parse(_ratePerSqftController.text);
          double.parse(_ratePerMonthController.text);
          double.parse(_longitudeController.text);
          double.parse(_latitudeController.text);
        } catch (e) {
          _showErrorMessage('Error converting numeric values: $e');
          return;
        }

        // Create form data map for local storage
        final formData = {
          'assessmentNo': _assessmentNoController.text.trim(),
          'masterFileRefNo': _masterFileRefNoController.text.trim(),
          'owner': _ownerController.text.trim(),
          'occupier': _occupierController.text.trim(),
          'description': _descriptionController.text.trim(),
          'floorRate': _floorRateController.text.trim(),
          'ratePerSqft': _ratePerSqftController.text.trim(),
          'ratePerMonth': _ratePerMonthController.text.trim(),
          'longitude': _longitudeController.text.trim(),
          'latitude': _latitudeController.text.trim(),
          'headOfTerms': _headOfTermsController.text.trim(),
          'situation': _situationController.text.trim(),
          'remarks': _remarksController.text.trim(),
        };

        // Save data locally for this specific marker
        _saveDataLocally(formData);
      } catch (e) {
        _showErrorMessage('Error saving form data locally: $e');
      }
    } else {
      debugPrint('Form validation FAILED');
      _showErrorMessage('Please fix the errors in the form');
    }
  }

  /// Saves the form data to local storage for this specific marker
  Future<void> _saveDataLocally(Map<String, String> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Create a map with form data and metadata
      final localData = {
        'masterFileNo': _masterFileNo,
        'markerId': _markerId,
        ...data, // Spread the form data
        'savedAt': DateTime.now().toIso8601String(),
        'imageCount': uploadedImages.length,
      };

      // Convert to JSON string
      final jsonString = jsonEncode(localData);

      // Generate a unique key for this specific marker
      final String key = 'lm_rental_evidence_${_masterFileNo}_$_markerId';

      // Save to SharedPreferences
      await prefs.setString(key, jsonString);

      debugPrint('LM Rental Evidence data saved locally with key: $key');

      // Show success message for local save
      _showSuccessMessage('Rental evidence saved locally for this location!');
    } catch (e) {
      debugPrint('Error saving data locally: $e');
      _showErrorMessage('Failed to save data locally. Please try again.');
    }
  }

  // Submit method - validates and submits to backend
  void _validateAndSubmit() {
    setState(() {
      _isSubmitting = true;
    });

    if (_formKey.currentState!.validate()) {
      // All form validation passed, now perform additional data type validation
      try {
        // Create a map to track all validation issues
        Map<String, String> validationErrors = {};

        // Validate numeric fields
        _validateNumericField(
            _floorRateController.text, 'Floor Rate', validationErrors);
        _validateNumericField(
            _ratePerSqftController.text, 'Rate Per Sqft', validationErrors);
        _validateNumericField(
            _ratePerMonthController.text, 'Rate Per Month', validationErrors);

        // Validate coordinate fields
        _validateCoordinateField(
            _longitudeController.text, 'Longitude', validationErrors);
        _validateCoordinateField(
            _latitudeController.text, 'Latitude', validationErrors);

        // If there are validation errors, show them and stop
        if (validationErrors.isNotEmpty) {
          String errorMessage = 'Validation errors:\n';
          validationErrors.forEach((field, error) {
            errorMessage += '• $field: $error\n';
          });
          _showErrorMessage(errorMessage);
          setState(() {
            _isSubmitting = false;
          });
          return;
        }

        // Double-check numeric conversions before sending to the backend
        // This ensures that even if validation passes, we're sending the correct data types
        try {
          // Ensure these are valid numbers before sending
          double.parse(_floorRateController.text);
          double.parse(_ratePerSqftController.text);
          double.parse(_ratePerMonthController.text);
          double.parse(_longitudeController.text);
          double.parse(_latitudeController.text);
        } catch (e) {
          _showErrorMessage('Error converting numeric values: $e');
          setState(() {
            _isSubmitting = false;
          });
          return;
        }

        // Send data to the backend
        _cubit.sendLmRentalEvidence(
          landMiscellaneousMasterFileId: _masterFileId != null
              ? int.tryParse(_masterFileId!) ?? 72
              : 72, // Use provided master file ID or fallback to 72
          masterFileRefNo: _masterFileRefNoController.text,
          assessmentNo: _assessmentNoController.text,
          owner: _ownerController.text,
          occupier: _occupierController.text,
          description: _descriptionController.text,
          floorRate: _floorRateController.text,
          ratePer:
              _ratePerSqftController.text, // This maps to ratePer in the API
          ratePerMonth: _ratePerMonthController.text,
          locationLongitude: _longitudeController.text,
          locationLatitude: _latitudeController.text,
          headOfTerms: _headOfTermsController.text,
          situation: _situationController.text,
          remarks: _remarksController.text,
        );

        // Display a temporary success message for form validation
        _showSuccessMessage('Form validated successfully. Submitting data...');
      } catch (e) {
        _showErrorMessage('Error validating form data: $e');
        setState(() {
          _isSubmitting = false;
        });
      }
    } else {
      _showErrorMessage('Please fix the errors in the form');
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  // Improved validation method for numeric fields
  void _validateNumericField(
      String value, String fieldName, Map<String, String> errors) {
    if (value.isEmpty) {
      errors[fieldName] = 'Cannot be empty';
      return;
    }

    // Try to parse as double first
    double? numericValue = double.tryParse(value);
    if (numericValue == null) {
      errors[fieldName] = 'Must be a valid number';
      return;
    }

    // Check for negative values where it doesn't make sense
    if (fieldName.toLowerCase().contains('rate') && numericValue < 0) {
      errors[fieldName] = 'Cannot be negative';
      return;
    }

    // Check for reasonableness (add custom validation rules as needed)
    if (fieldName.contains('Rate Per') && numericValue > 1000000) {
      errors[fieldName] = 'Value seems too high, please verify';
    }
  }

  // Improved validation method for coordinate fields
  void _validateCoordinateField(
      String value, String fieldName, Map<String, String> errors) {
    if (value.isEmpty) {
      errors[fieldName] = 'Cannot be empty';
      return;
    }

    double? coordinate = double.tryParse(value);
    if (coordinate == null) {
      errors[fieldName] = 'Must be a valid coordinate value';
      return;
    }

    // Detailed coordinate validation
    if (fieldName == 'Latitude') {
      if (coordinate < -90 || coordinate > 90) {
        errors[fieldName] = 'Must be between -90 and 90 degrees';
      }
    } else if (fieldName == 'Longitude') {
      if (coordinate < -180 || coordinate > 180) {
        errors[fieldName] = 'Must be between -180 and 180 degrees';
      }
    }
  }

  /// Callback when an image is picked.
  void _onImagePicked(File file) {
    setState(() {
      uploadedImages.add(file);
    });
  }

  /// Delete an image from the uploadedImages list by index.
  void _deleteImage(int index) {
    setState(() {
      uploadedImages.removeAt(index);
    });
  }

  /// Upload images to the backend after form submission
  Future<void> uploadImages(String reportId) async {
    print('DEBUG: uploadImages called with reportId: $reportId');
    print('DEBUG: Number of images to upload: ${uploadedImages.length}');
    if (uploadedImages.isEmpty) return;
    var uri = Uri.parse(
        '${AppConfig.apiBaseUrl}ImageData/upload'); // Make sure this matches your backend
    var request = http.MultipartRequest('POST', uri)
      ..fields['reportId'] = reportId;
    for (var image in uploadedImages) {
      if (image is File) {
        print('DEBUG: Adding image file: ${image.path}');
        request.files
            .add(await http.MultipartFile.fromPath('files', image.path));
      } else {
        print('DEBUG: Skipping non-File image: $image');
      }
    }
    try {
      var response = await request.send();
      print('DEBUG: Image upload response status: ${response.statusCode}');
      final respStr = await response.stream.bytesToString();
      print('DEBUG: Image upload response body: $respStr');
      if (response.statusCode == 200) {
        _showSuccessMessage('Images uploaded successfully.');
      } else {
        _showErrorMessage('Failed to upload images.');
      }
    } catch (e) {
      print('DEBUG: Exception during image upload: $e');
      _showErrorMessage('Error uploading images: $e');
    }
  }

  @override
  Widget buildView(BuildContext context) {
    return BlocListener<LmRentalEvidencesCubit,
        BaseState<LmRentalEvidencesState>>(
      bloc: _cubit,
      listener: (context, state) {
        if (state is LmRentalEvidencesSubmitSuccess) {
          _handleSuccess(state.reportId);
        } else if (state is LmRentalEvidencesSubmitFailure) {
          setState(() {
            _isSubmitting = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.errorMessage}'),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is LmRentalEvidencesLoading) {
          setState(() {
            _isSubmitting = true;
          });
        }
      },
      child: Scaffold(
        // Custom app bar with a localized title.
        appBar: CustomAppBar(
          title: "Rental Evidence",
        ),
        // Allows the entire view to be scrollable.
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumb navigation.
              Breadcrumb(items: [
                BreadcrumbItem(label: "Land Miscellaneous"),
                BreadcrumbItem(
                  label: _masterFileNo != null
                      ? "Master File - #$_masterFileNo"
                      : AppString.masterFile.localize(context)!,
                ),
                BreadcrumbItem(label: "LM Rental Evidence Form"),
              ]),
              // LayoutBuilder used to determine the width constraints for form fields.
              LayoutBuilder(
                builder: (context, constraints) {
                  double fieldWidth = constraints.maxWidth * 0.47;
                  double fullWidth = constraints.maxWidth * 0.96;

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Wrap widget to arrange text fields responsively.
                          Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            alignment: WrapAlignment.start,
                            children: [
                              // Each LabeledTextField represents a form field with a label and placeholder.
                              LabeledTextField(
                                placeholder: AppString.assesmentNoPlaceholder
                                    .localize(context)!,
                                label:
                                    AppString.assesmentNo.localize(context) ??
                                        '',
                                width: fieldWidth,
                                controller: _assessmentNoController,
                                validator: (value) =>
                                    LmRentalEvidencesValidator.requiredAlphaNum(
                                        value,
                                        50,
                                        AppString.assesmentNo
                                                .localize(context) ??
                                            'Assessment No'),
                              ),
                              LabeledTextField(
                                placeholder: AppString
                                    .masterFileRefNoPlaceholder
                                    .localize(context)!,
                                label: AppString.masterFileRefNo
                                        .localize(context) ??
                                    '',
                                width: fieldWidth,
                                controller: _masterFileRefNoController,
                                validator: (value) =>
                                    LmRentalEvidencesValidator.requiredAlphaNum(
                                        value,
                                        50,
                                        AppString.masterFileRefNo
                                                .localize(context) ??
                                            'Master File Ref No'),
                              ),
                              LabeledTextField(
                                placeholder:
                                    AppString.owner.localize(context) ?? '',
                                label: AppString.owner.localize(context)!,
                                width: fieldWidth,
                                controller: _ownerController,
                                validator: (value) =>
                                    LmRentalEvidencesValidator.requiredAlphaNum(
                                        value,
                                        100,
                                        AppString.owner.localize(context) ??
                                            'Owner'),
                              ),
                              LabeledTextField(
                                placeholder:
                                    AppString.occupier.localize(context) ?? '',
                                label: AppString.occupier.localize(context)!,
                                width: fieldWidth,
                                controller: _occupierController,
                                validator: (value) =>
                                    LmRentalEvidencesValidator.requiredAlphaNum(
                                        value,
                                        100,
                                        AppString.occupier.localize(context) ??
                                            'Occupier'),
                              ),
                              LabeledTextField(
                                placeholder:
                                    AppString.description.localize(context) ??
                                        '',
                                label:
                                    AppString.description.localize(context) ??
                                        '',
                                width: fieldWidth,
                                controller: _descriptionController,
                                validator: (value) =>
                                    LmRentalEvidencesValidator.requiredAlphaNum(
                                        value,
                                        255,
                                        AppString.description
                                                .localize(context) ??
                                            'Description'),
                              ),
                              LabeledTextField(
                                placeholder: AppString.floorRatePlaceholder
                                    .localize(context)!,
                                label:
                                    AppString.floorRate.localize(context) ?? '',
                                width: fieldWidth,
                                controller: _floorRateController,
                                validator: (value) =>
                                    LmRentalEvidencesValidator.requiredInteger(
                                        value,
                                        20,
                                        AppString.floorRate.localize(context) ??
                                            'Floor Rate'),
                              ),
                              LabeledTextField(
                                placeholder:
                                    AppString.ratePerSqft.localize(context) ??
                                        '',
                                label:
                                    AppString.ratePerSqft.localize(context) ??
                                        '',
                                width: fieldWidth,
                                controller: _ratePerSqftController,
                                validator: (value) =>
                                    LmRentalEvidencesValidator.requiredNumeric(
                                        value,
                                        20,
                                        AppString.ratePerSqft
                                                .localize(context) ??
                                            'Rate Per Sqft'),
                              ),
                              LabeledTextField(
                                placeholder:
                                    AppString.ratePerMonth.localize(context) ??
                                        '',
                                label:
                                    AppString.ratePerMonth.localize(context) ??
                                        '',
                                width: fieldWidth,
                                controller: _ratePerMonthController,
                                validator: (value) =>
                                    LmRentalEvidencesValidator.requiredNumeric(
                                        value,
                                        20,
                                        AppString.ratePerMonth
                                                .localize(context) ??
                                            'Rate Per Month'),
                              ),
                              LabeledTextField(
                                placeholder: AppString
                                    .locationLongitudePlaceholder
                                    .localize(context)!,
                                label: AppString.locationLongitude
                                        .localize(context) ??
                                    '',
                                width: fieldWidth,
                                controller: _longitudeController,
                                validator: (value) => LmRentalEvidencesValidator
                                    .requiredCoordinate(
                                        value,
                                        AppString.locationLongitude
                                                .localize(context) ??
                                            'Longitude'),
                              ),
                              LabeledTextField(
                                placeholder: AppString
                                    .locationLatitudePlaceholder
                                    .localize(context)!,
                                label: AppString.locationLatitude
                                        .localize(context) ??
                                    '',
                                width: fieldWidth,
                                controller: _latitudeController,
                                validator: (value) => LmRentalEvidencesValidator
                                    .requiredCoordinate(
                                        value,
                                        AppString.locationLatitude
                                                .localize(context) ??
                                            'Latitude'),
                              ),
                              LabeledTextField(
                                placeholder:
                                    AppString.headOfTerms.localize(context) ??
                                        '',
                                label:
                                    AppString.headOfTerms.localize(context) ??
                                        '',
                                width: fieldWidth,
                                controller: _headOfTermsController,
                                validator: (value) =>
                                    LmRentalEvidencesValidator.requiredAlphaNum(
                                        value,
                                        255,
                                        AppString.headOfTerms
                                                .localize(context) ??
                                            'Head of Terms'),
                              ),
                              LabeledTextField(
                                placeholder:
                                    AppString.situation.localize(context) ?? '',
                                label:
                                    AppString.situation.localize(context) ?? '',
                                width: fieldWidth,
                                controller: _situationController,
                                validator: (value) =>
                                    LmRentalEvidencesValidator.requiredAlphaNum(
                                        value,
                                        255,
                                        AppString.situation.localize(context) ??
                                            'Situation'),
                              ),
                              // Full width text field for remarks.
                              LabeledTextField(
                                placeholder:
                                    AppString.remarks.localize(context) ?? '',
                                label:
                                    AppString.remarks.localize(context) ?? '',
                                width: fullWidth,
                                controller: _remarksController,
                                validator: (value) =>
                                    LmRentalEvidencesValidator.requiredAlphaNum(
                                        value,
                                        500,
                                        AppString.remarks.localize(context) ??
                                            'Remarks'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Section title for image uploads.
                          Row(
                            children: [
                              Text(
                                AppString.uploadImgs.localize(context) ?? '',
                                style: AppStyling.mediumTextSize14,
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Image upload section using Wrap for responsive image display.
                          Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            alignment: WrapAlignment.start,
                            children: [
                              // Display each uploaded image with a delete button.
                              ...List.generate(
                                uploadedImages.length,
                                (index) {
                                  final image = uploadedImages[index];
                                  return ImageUpload(
                                    imageFile: image is File ? image : null,
                                    imagePath: image is String ? image : null,
                                    onDelete: () => _deleteImage(index),
                                    size: 128,
                                  );
                                },
                              ),
                              // Button to upload a new image.
                              ImageUpload(
                                isUploadButton: true,
                                onImagePicked: _onImagePicked,
                                onDelete: () {},
                                size: 128,
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Row for Cancel, Save, and Send Data buttons.
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Cancel button.
                              CustomButton(
                                text: AppString.cancel.localize(context) ?? '',
                                onPressed: _isSubmitting
                                    ? null
                                    : () {
                                        Navigator.of(context)
                                            .pop(); // Close the form
                                      },
                                backgroundColor: colors(context).colorGrey1 ??
                                    LightColorList.lightGrey50,
                              ),
                              _isSubmitting
                                  ? const CircularProgressIndicator()
                                  : Row(
                                      children: [
                                        // Save button - saves locally without redirection.
                                        CustomButton(
                                          text: AppString.save
                                                  .localize(context) ??
                                              '',
                                          onPressed: _saveLocally,
                                          backgroundColor: colors(context)
                                                  .colorPrimary5 ??
                                              LightColorList.lightPrimary700,
                                        ),
                                        const SizedBox(width: 40),
                                        // Send data button - submits to backend.
                                        CustomButton(
                                          text: AppString.sendData
                                                  .localize(context) ??
                                              '',
                                          onPressed: _validateAndSubmit,
                                          backgroundColor: colors(context)
                                                  .colorPrimary1 ??
                                              LightColorList.lightPrimary500,
                                        ),
                                      ],
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ), // Closing Scaffold
    ); // Closing BlocListener
  }

  /// Handles post-success logic: show message, upload images, then show success dialog
  Future<void> _handleSuccess(String reportId) async {
    setState(() {
      _isSubmitting = false;
    });

    // Upload images first
    await uploadImages(reportId);

    if (!mounted) return;

    // Show success dialog
    _showSuccessDialog();
  }

  /// Shows a success dialog and goes back to previous screen when dismissed
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 24,
              ),
              SizedBox(width: 8),
              Text('Success'),
            ],
          ),
          content: const Text('LM rental evidence data sent successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog first
                Navigator.of(dialogContext).pop();
                context.pop(); // Use GoRouter's pop to safely go back
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Returns the cubit instance for managing state.
  @override
  BaseCubit<BaseState> getCubit() {
    return _cubit;
  }
}
