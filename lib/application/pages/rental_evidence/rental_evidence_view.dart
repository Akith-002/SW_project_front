import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:land_asset_valuation/app/base_view.dart';
import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/core/configurations/app_config.dart';
import 'package:land_asset_valuation/application/core/router/pages.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/light_color_list.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';
import 'package:land_asset_valuation/application/core/validators/rental_evidence_validator.dart';
import 'package:land_asset_valuation/application/core/widgets/breadcrumb.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_app_bar.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_button.dart';
import 'package:land_asset_valuation/application/core/widgets/image_upload.dart';
import 'package:land_asset_valuation/application/core/widgets/labeled_text_field.dart';
import 'package:land_asset_valuation/application/pages/rental_evidence/cubit/rental_evidence_cubit.dart';
import 'package:land_asset_valuation/application/pages/rental_evidence/cubit/rental_evidence_state.dart';
import 'package:land_asset_valuation/injection.dart';
import 'package:http/http.dart' as http;
import 'package:land_asset_valuation/application/core/configurations/app_config.dart';

/// RentalEvidenceView is the main view for displaying the rental evidence form.
class RentalEvidenceView extends BasePage {
  const RentalEvidenceView({super.key});

  @override
  State<RentalEvidenceView> createState() => _RentalEvidenceViewState();
}

/// State for RentalEvidenceView that handles user input and image uploads.
class _RentalEvidenceViewState extends BasePageState<RentalEvidenceView> {
  // Instantiate the cubit using dependency injection.
  final _cubit = injection<RentalEvidenceCubit>();

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

  void _validateAndSubmit() {
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
          return;
        }

        // Send data to the backend
        _cubit.sendRentalEvidence(
          masterFileId: "56249", // You can get this dynamically
          masterFileRefNo: _masterFileRefNoController.text,
          assessmentNo: _assessmentNoController.text,
          owner: _ownerController.text,
          occupier: _occupierController.text,
          description: _descriptionController.text,
          floorRateSQFT: _floorRateController.text,
          ratePerSqft: _ratePerSqftController.text,
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
      }
    } else {
      _showErrorMessage('Please fix the errors in the form');
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
    return BlocListener<RentalEvidenceCubit, BaseState<RentalEvidenceState>>(
      bloc: _cubit,
      listener: (context, state) {
        if (state is RentalEvidenceSubmitSuccess) {
          _handleSuccess(state.reportId);
        } else if (state is RentalEvidenceSubmitFailure) {
          setState(() {
            _isSubmitting = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.errorMessage}'),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is RentalEvidenceLoading) {
          setState(() {
            _isSubmitting = true;
          });
        }
      },
      child: Scaffold(
        // Custom app bar with a localized title.
        appBar: CustomAppBar(
          title: AppString.rentalEvidence.localize(context) ?? '',
        ),
        // Allows the entire view to be scrollable.
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumb navigation.
              Breadcrumb(items: [
                BreadcrumbItem(
                    label: AppString.landAcquisition.localize(context) ?? ''),
                BreadcrumbItem(label: AppString.masterFile.localize(context)!),
                BreadcrumbItem(
                    label:
                        AppString.rentalEvidenceForm.localize(context) ?? ''),
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
                                    RentalEvidenceValidator.requiredAlphaNum(
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
                                    RentalEvidenceValidator.requiredAlphaNum(
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
                                    RentalEvidenceValidator.requiredAlphaNum(
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
                                    RentalEvidenceValidator.requiredAlphaNum(
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
                                    RentalEvidenceValidator.requiredAlphaNum(
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
                                    RentalEvidenceValidator.requiredInteger(
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
                                    RentalEvidenceValidator.requiredNumeric(
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
                                    RentalEvidenceValidator.requiredNumeric(
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
                                validator: (value) =>
                                    RentalEvidenceValidator.requiredCoordinate(
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
                                validator: (value) =>
                                    RentalEvidenceValidator.requiredCoordinate(
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
                                    RentalEvidenceValidator.requiredAlphaNum(
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
                                    RentalEvidenceValidator.requiredAlphaNum(
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
                                    RentalEvidenceValidator.requiredAlphaNum(
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
                              // Text(
                              //   '(Optional)',
                              //   style: AppStyling.regularTextSize12.copyWith(
                              //     color: Colors.grey,
                              //     fontStyle: FontStyle.italic,
                              //   ),
                              // ),
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
                                onPressed: _isSubmitting ? null : () {},
                                backgroundColor: colors(context).colorGrey1 ??
                                    LightColorList.lightGrey50,
                              ),
                              _isSubmitting
                                  ? const CircularProgressIndicator()
                                  : Row(
                                      children: [
                                        // Save button.
                                        CustomButton(
                                          text: AppString.save
                                                  .localize(context) ??
                                              '',
                                          onPressed: _validateAndSubmit,
                                          backgroundColor: colors(context)
                                                  .colorPrimary5 ??
                                              LightColorList.lightPrimary700,
                                        ),
                                        const SizedBox(width: 40),
                                        // Send data button.
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

  /// Handles post-success logic: show message, upload images, then navigate
  Future<void> _handleSuccess(String reportId) async {
    setState(() {
      _isSubmitting = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Rental evidence submitted successfully!'),
        backgroundColor: Colors.green,
      ),
    );
    await uploadImages(reportId);
    if (!mounted) return;
    context.go(Pages.routeMapScreen.toPath());
  }

  // Returns the cubit instance for managing state.
  @override
  BaseCubit<BaseState> getCubit() {
    return _cubit;
  }
}
