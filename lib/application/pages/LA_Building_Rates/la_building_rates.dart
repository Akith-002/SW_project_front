import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:land_asset_valuation/app/base_view.dart';
import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/widgets/breadcrumb.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_app_bar.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_button.dart';
import 'package:land_asset_valuation/application/core/widgets/image_upload.dart';
import 'package:land_asset_valuation/application/core/widgets/labeled_text_field.dart';
import 'package:land_asset_valuation/application/pages/LA_Building_Rates/cubit/la_building_rates_cubit.dart';
import 'package:land_asset_valuation/application/pages/LA_Building_Rates/cubit/la_building_rates_state.dart';
import 'package:land_asset_valuation/application/core/validators/la_building_rates_validator.dart';
import 'package:land_asset_valuation/application/core/widgets/data_send_successfully_dialogbox.dart';
import 'package:land_asset_valuation/data/models/la_building_rates_model.dart';
import 'package:land_asset_valuation/injection.dart';

/// LA Building Rates form page for collecting building valuation data
class LaBuildingRates extends BasePage {
  const LaBuildingRates({super.key});

  @override
  State<LaBuildingRates> createState() => _LaBuildingRatesState();
}

class _LaBuildingRatesState extends BasePageState<LaBuildingRates> {
  final _cubit = injection<LaBuildingRatesCubit>();

  // Form validation key
  final _formKey = GlobalKey<FormState>();

  // Auto-validation mode
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  // Text controllers for all form fields
  final _assessmentNumberController = TextEditingController();
  final _ownerController = TextEditingController();
  final _constructedByController = TextEditingController();
  final _yearOfConstructionController = TextEditingController();
  final _descriptionOfPropertyController = TextEditingController();
  final _floorAreaSQFTController = TextEditingController();
  final _ratePerSQFTController = TextEditingController();
  final _costController = TextEditingController();
  final _remarksController = TextEditingController();
  final _locationLatitudeController = TextEditingController();
  final _locationLongitudeController = TextEditingController();

  // Stores uploaded image files and paths
  List<dynamic> uploadedImages = [];

  @override
  void dispose() {
    // Clean up all controllers to prevent memory leaks
    _assessmentNumberController.dispose();
    _ownerController.dispose();
    _constructedByController.dispose();
    _yearOfConstructionController.dispose();
    _descriptionOfPropertyController.dispose();
    _floorAreaSQFTController.dispose();
    _ratePerSQFTController.dispose();
    _costController.dispose();
    _remarksController.dispose();
    _locationLatitudeController.dispose();
    _locationLongitudeController.dispose();
    super.dispose();
  }

  /// Handles image selection and adds to uploaded images list
  void _onImagePicked(File file) {
    setState(() {
      uploadedImages.add(file);
    });
  }

  /// Removes image from uploaded images list
  void _deleteImage(int index) {
    setState(() {
      uploadedImages.removeAt(index);
    });
  }

  @override
  Widget buildView(BuildContext context) {
    return BlocProvider<LaBuildingRatesCubit>.value(
      value: _cubit,
      child: BlocConsumer<LaBuildingRatesCubit, dynamic>(
        listener: (context, state) {
          if (state is LaBuildingRatesSubmitSuccess) {
            _showSuccessDialog();
          } else if (state is LaBuildingRatesSubmitFailure) {
            _showErrorMessage(state.errorMessage);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: CustomAppBar(
                title: AppString.buildingRatesForm.localize(context)!),
            body: LayoutBuilder(
              builder: (context, constraints) {
                // Calculate responsive field width (47% of screen width)
                double fieldWidth = constraints.maxWidth * 0.47;

                return Form(
                  key: _formKey,
                  autovalidateMode: _autovalidateMode,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Navigation breadcrumb
                        Breadcrumb(
                          items: [
                            BreadcrumbItem(
                                label: AppString.landAcquisition
                                    .localize(context)!),
                            BreadcrumbItem(
                                label: AppString.masterFile.localize(context)!),
                            BreadcrumbItem(
                                label:
                                    AppString.buildingRates.localize(context)!),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Form fields in responsive grid layout
                              Wrap(
                                spacing: 16,
                                runSpacing: 16,
                                alignment: WrapAlignment.start,
                                children: [
                                  LabeledTextField(
                                    label: AppString.assessmentNumber
                                        .localize(context)!,
                                    placeholder: AppString.assessmentNumber
                                        .localize(context)!,
                                    width: fieldWidth,
                                    controller: _assessmentNumberController,
                                    validator: (value) =>
                                        LaBuildingRatesValidator
                                            .requiredAssessmentNumber(
                                                value, 50, "Assessment Number"),
                                  ),
                                  LabeledTextField(
                                    label: AppString.owner.localize(context)!,
                                    placeholder: AppString.nameOfTheOwner
                                        .localize(context)!,
                                    width: fieldWidth,
                                    controller: _ownerController,
                                    validator: (value) =>
                                        LaBuildingRatesValidator
                                            .requiredAlphaNum(
                                                value, 100, "Owner"),
                                  ),
                                  LabeledTextField(
                                    label: AppString.constructedBy
                                        .localize(context)!,
                                    placeholder: AppString.constructedBy
                                        .localize(context)!,
                                    width: fieldWidth,
                                    controller: _constructedByController,
                                    validator: (value) =>
                                        LaBuildingRatesValidator
                                            .optionalAlphaNum(
                                                value, 100, "Constructed By"),
                                  ),
                                  LabeledTextField(
                                    label: AppString.yearofConstruction
                                        .localize(context)!,
                                    placeholder: AppString.yearofConstruction
                                        .localize(context)!,
                                    width: fieldWidth,
                                    controller: _yearOfConstructionController,
                                    validator: (value) =>
                                        LaBuildingRatesValidator.requiredYear(
                                            value, "Year of Construction"),
                                  ),
                                  LabeledTextField(
                                    label: AppString.descriptionofProperty
                                        .localize(context)!,
                                    placeholder: AppString.propertyDescription
                                        .localize(context)!,
                                    width: fieldWidth,
                                    controller:
                                        _descriptionOfPropertyController,
                                    validator: (value) =>
                                        LaBuildingRatesValidator
                                            .optionalAlphaNum(value, 500,
                                                "Property Description"),
                                  ),
                                  LabeledTextField(
                                    label: AppString.floorAreaSQFT
                                        .localize(context)!,
                                    placeholder: AppString.floorAreaSQFT
                                        .localize(context)!,
                                    width: fieldWidth,
                                    controller: _floorAreaSQFTController,
                                    validator: (value) =>
                                        LaBuildingRatesValidator.requiredArea(
                                            value, "Floor Area (SQFT)"),
                                  ),
                                  LabeledTextField(
                                    label: AppString.ratePerSQFT
                                        .localize(context)!,
                                    placeholder: AppString.ratePerSQFT
                                        .localize(context)!,
                                    width: fieldWidth,
                                    controller: _ratePerSQFTController,
                                    validator: (value) =>
                                        LaBuildingRatesValidator.requiredRate(
                                            value, "Rate Per SQFT"),
                                  ),
                                  LabeledTextField(
                                    label: AppString.cost.localize(context)!,
                                    placeholder:
                                        AppString.cost.localize(context)!,
                                    width: fieldWidth,
                                    controller: _costController,
                                    validator: (value) =>
                                        LaBuildingRatesValidator.requiredCost(
                                            value, "Cost"),
                                  ),
                                  LabeledTextField(
                                    label: AppString.remarks.localize(context)!,
                                    placeholder:
                                        AppString.remarks.localize(context)!,
                                    width: fieldWidth,
                                    controller: _remarksController,
                                    validator: (value) =>
                                        LaBuildingRatesValidator
                                            .optionalAlphaNum(
                                                value, 500, "Remarks"),
                                  ),
                                  LabeledTextField(
                                    label: AppString.locationLatitude
                                        .localize(context)!,
                                    placeholder: AppString.locationLatitude
                                        .localize(context)!,
                                    width: fieldWidth,
                                    controller: _locationLatitudeController,
                                    validator: (value) =>
                                        LaBuildingRatesValidator
                                            .optionalCoordinate(
                                                value, "Location Latitude"),
                                  ),
                                  LabeledTextField(
                                    label: AppString.locationLongitude
                                        .localize(context)!,
                                    placeholder: AppString.locationLongitude
                                        .localize(context)!,
                                    width: fieldWidth,
                                    controller: _locationLongitudeController,
                                    validator: (value) =>
                                        LaBuildingRatesValidator
                                            .optionalCoordinate(
                                                value, "Location Longitude"),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              // Image upload section
                              Text(
                                AppString.imageCapturing.localize(context)!,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 16),
                              // Image gallery with upload functionality
                              Wrap(
                                spacing: 16,
                                runSpacing: 16,
                                children: [
                                  // Display uploaded images with delete option
                                  ...List.generate(
                                    uploadedImages.length,
                                    (index) {
                                      final image = uploadedImages[index];
                                      return ImageUpload(
                                        imageFile: image is File ? image : null,
                                        imagePath:
                                            image is String ? image : null,
                                        onDelete: () => _deleteImage(index),
                                        size: 128,
                                      );
                                    },
                                  ),
                                  // Upload new image button
                                  ImageUpload(
                                    isUploadButton: true,
                                    onImagePicked: _onImagePicked,
                                    onDelete: () {},
                                    size: 128,
                                  ),
                                ],
                              ),
                              // Divider line
                              Container(
                                height: 1,
                                margin: EdgeInsets.all(16),
                                width: double.infinity,
                                color: Colors.grey,
                              ),
                              // Action buttons
                              Row(
                                children: [
                                  CustomButton(
                                    text: AppString.cancel.localize(context)!,
                                    onPressed: () {},
                                    backgroundColor:
                                        colors(context).colorGrey1!,
                                  ),
                                  Spacer(),
                                  CustomButton(
                                    text: AppString.save.localize(context)!,
                                    onPressed: _validateAndSave,
                                    backgroundColor:
                                        colors(context).colorPrimary1!,
                                  ),
                                  SizedBox(width: 40),
                                  CustomButton(
                                    text: AppString.sendData.localize(context)!,
                                    onPressed: state is LaBuildingRatesLoading
                                        ? null
                                        : _validateAndSubmit,
                                    backgroundColor:
                                        colors(context).colorPrimary5!,
                                  ),
                                ],
                              ),
                              // Show loading indicator when submitting
                              if (state is LaBuildingRatesLoading)
                                Container(
                                  margin: EdgeInsets.only(top: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(),
                                      SizedBox(width: 16),
                                      Text('Sending data...'),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  /// Validates form and saves data locally
  void _validateAndSave() {
    // Enable auto-validation mode to show validation errors
    setState(() {
      _autovalidateMode = AutovalidateMode.onUserInteraction;
    });

    // Validate the form
    bool isFormValid = _formKey.currentState?.validate() ?? false;

    if (isFormValid) {
      // Form is valid, save the data
      _showSuccessMessage('Building rates data saved successfully');
      // TODO: Implement actual save logic
    } else {
      _showErrorMessage('Please fix the validation errors in the form');
    }
  }

  /// Validates form and submits data to server
  void _validateAndSubmit() async {
    // Enable auto-validation mode to show validation errors
    setState(() {
      _autovalidateMode = AutovalidateMode.onUserInteraction;
    });

    // Validate the form using the validators you've defined
    bool isFormValid = _formKey.currentState?.validate() ?? false;

    if (!isFormValid) {
      _showErrorMessage('Please fix the validation errors in the form');
      return;
    }

    // Additional manual validation (similar to rental evidence form)
    try {
      // Create a map to track all validation issues
      Map<String, String> validationErrors = {};

      // Validate required fields are not empty
      _validateRequiredField(_assessmentNumberController.text,
          'Assessment Number', validationErrors);
      _validateRequiredField(_ownerController.text, 'Owner', validationErrors);
      _validateRequiredField(_yearOfConstructionController.text,
          'Year of Construction', validationErrors);
      _validateRequiredField(
          _floorAreaSQFTController.text, 'Floor Area (SQFT)', validationErrors);
      _validateRequiredField(
          _ratePerSQFTController.text, 'Rate Per SQFT', validationErrors);
      _validateRequiredField(_costController.text, 'Cost', validationErrors);

      // Validate numeric fields
      _validateYearField(_yearOfConstructionController.text,
          'Year of Construction', validationErrors);
      _validateAreaField(
          _floorAreaSQFTController.text, 'Floor Area (SQFT)', validationErrors);
      _validateRateField(
          _ratePerSQFTController.text, 'Rate Per SQFT', validationErrors);
      _validateCostField(_costController.text, 'Cost', validationErrors);

      // Validate coordinate fields (optional)
      if (_locationLatitudeController.text.trim().isNotEmpty) {
        _validateCoordinateField(
            _locationLatitudeController.text, 'Latitude', validationErrors);
      }
      if (_locationLongitudeController.text.trim().isNotEmpty) {
        _validateCoordinateField(
            _locationLongitudeController.text, 'Longitude', validationErrors);
      }

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
      try {
        // Ensure these are valid numbers before sending
        int.parse(_yearOfConstructionController.text);
        double.parse(_floorAreaSQFTController.text);
        double.parse(_ratePerSQFTController.text);
        double.parse(_costController.text);

        // Parse optional coordinates if provided
        if (_locationLatitudeController.text.trim().isNotEmpty) {
          double.parse(_locationLatitudeController.text);
        }
        if (_locationLongitudeController.text.trim().isNotEmpty) {
          double.parse(_locationLongitudeController.text);
        }
      } catch (e) {
        _showErrorMessage('Error converting numeric values: ${e.toString()}');
        return;
      }

      // Create the model from form data
      final buildingRatesModel = LaBuildingRatesModel(
        assessmentNumber: _assessmentNumberController.text.trim(),
        owner: _ownerController.text.trim(),
        constructedBy: _constructedByController.text.trim(),
        yearOfConstruction: _yearOfConstructionController.text.trim(),
        descriptionOfProperty: _descriptionOfPropertyController.text.trim(),
        floorAreaSQFT: _floorAreaSQFTController.text.trim(),
        ratePerSQFT: _ratePerSQFTController.text.trim(),
        cost: _costController.text.trim(),
        remarks: _remarksController.text.trim(),
        locationLatitude: _locationLatitudeController.text.trim(),
        locationLongitude: _locationLongitudeController.text.trim(),
      );

      // Send data using cubit
      await _cubit.sendLaBuildingRates(buildingRatesModel);

      // TODO: Handle image upload separately after successful form submission
      // if (success && uploadedImages.isNotEmpty) {
      //   await _uploadImages(reportId);
      // }
    } catch (e) {
      _showErrorMessage('Error preparing form data: ${e.toString()}');
    }
  }

  /// Displays success message using SnackBar
  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Shows success dialog when data is sent successfully
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SuccessMessageCard(
          onClose: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  /// Displays error message using SnackBar
  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Validates that required fields are not empty
  void _validateRequiredField(
      String value, String fieldName, Map<String, String> errors) {
    if (value.trim().isEmpty) {
      errors[fieldName] = 'Cannot be empty';
    }
  }

  /// Validates year field
  void _validateYearField(
      String value, String fieldName, Map<String, String> errors) {
    if (value.trim().isEmpty) {
      errors[fieldName] = 'Cannot be empty';
      return;
    }

    // Check if it's a valid 4-digit year
    if (!RegExp(r'^\d{4}$').hasMatch(value)) {
      errors[fieldName] = 'Must be a valid 4-digit year';
      return;
    }

    int? year = int.tryParse(value);
    if (year == null) {
      errors[fieldName] = 'Must be a valid year';
      return;
    }

    int currentYear = DateTime.now().year;
    if (year < 1800 || year > currentYear + 10) {
      errors[fieldName] = 'Must be between 1800 and ${currentYear + 10}';
    }
  }

  /// Validates area field
  void _validateAreaField(
      String value, String fieldName, Map<String, String> errors) {
    if (value.trim().isEmpty) {
      errors[fieldName] = 'Cannot be empty';
      return;
    }

    double? area = double.tryParse(value);
    if (area == null) {
      errors[fieldName] = 'Must be a valid number';
      return;
    }

    if (area <= 0) {
      errors[fieldName] = 'Must be greater than 0';
      return;
    }

    if (area > 1000000) {
      errors[fieldName] = 'Value seems too large, please verify';
    }
  }

  /// Validates rate field
  void _validateRateField(
      String value, String fieldName, Map<String, String> errors) {
    if (value.trim().isEmpty) {
      errors[fieldName] = 'Cannot be empty';
      return;
    }

    double? rate = double.tryParse(value);
    if (rate == null) {
      errors[fieldName] = 'Must be a valid number';
      return;
    }

    if (rate <= 0) {
      errors[fieldName] = 'Must be greater than 0';
      return;
    }

    if (rate > 100000) {
      errors[fieldName] = 'Value seems too high, please verify';
    }
  }

  /// Validates cost field
  void _validateCostField(
      String value, String fieldName, Map<String, String> errors) {
    if (value.trim().isEmpty) {
      errors[fieldName] = 'Cannot be empty';
      return;
    }

    double? cost = double.tryParse(value);
    if (cost == null) {
      errors[fieldName] = 'Must be a valid number';
      return;
    }

    if (cost < 0) {
      errors[fieldName] = 'Cannot be negative';
      return;
    }

    if (cost > 1000000000) {
      errors[fieldName] = 'Value seems too high, please verify';
    }
  }

  /// Validates coordinate field (latitude/longitude)
  void _validateCoordinateField(
      String value, String fieldName, Map<String, String> errors) {
    if (value.trim().isEmpty) {
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

  @override
  BaseCubit<BaseState> getCubit() {
    return _cubit;
  }
}
