import 'dart:io';
import 'package:flutter/material.dart';
import 'package:land_asset_valuation/app/base_view.dart';
import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/widgets/breadcrumb.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_app_bar.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_button.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_dropdown_field.dart';
import 'package:land_asset_valuation/application/core/widgets/labeled_text_field.dart';
import 'package:land_asset_valuation/application/core/widgets/image_upload.dart';
import 'package:land_asset_valuation/application/pages/I2_rental_evidence/cubit/i2_rental_evidence_cubit.dart';
import 'package:land_asset_valuation/application/core/validators/i2_rental_evidence_validator.dart';
import 'package:land_asset_valuation/injection.dart';

/// Main page widget for displaying rental evidence.
class I2RentalEvidence extends BasePage {
  const I2RentalEvidence({super.key});

  @override
  State<I2RentalEvidence> createState() => _I2RentalEvidenceState();
}

/// State implementation for I2RentalEvidence page.
class _I2RentalEvidenceState extends BasePageState<I2RentalEvidence> {
  // Cubit instance for managing the page state
  final _cubit = injection<I2RentalEvidenceCubit>();

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Text controllers for form fields
  final _assessmentNoController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _occupierNameController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Selected values for dropdowns
  String? _selectedBuilding;
  String? _selectedPropertyCategory;
  String? _selectedPropertySubcategory;
  String? _selectedPropertyType1;
  String? _selectedPropertyType2;

  // List to hold the uploaded images (can be File or String type)
  List<dynamic> uploadedImages = [];

  @override
  void dispose() {
    // Dispose all controllers
    _assessmentNoController.dispose();
    _ownerNameController.dispose();
    _occupierNameController.dispose();
    _descriptionController.dispose();
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

        // Validate dropdowns are selected properly
        String? buildingError =
            I2RentalEvidenceValidator.dropdown(_selectedBuilding, 'Building');
        if (buildingError != null) {
          validationErrors['Building'] = buildingError;
        }

        String? categoryError = I2RentalEvidenceValidator.dropdown(
            _selectedPropertyCategory, 'Property Category');
        if (categoryError != null) {
          validationErrors['Property Category'] = categoryError;
        }

        String? subcategoryError = I2RentalEvidenceValidator.dropdown(
            _selectedPropertySubcategory, 'Property Subcategory');
        if (subcategoryError != null) {
          validationErrors['Property Subcategory'] = subcategoryError;
        }

        String? type1Error = I2RentalEvidenceValidator.dropdown(
            _selectedPropertyType1, 'Property Type');
        if (type1Error != null) {
          validationErrors['Property Type 1'] = type1Error;
        }

        String? type2Error = I2RentalEvidenceValidator.dropdown(
            _selectedPropertyType2, 'Property Type');
        if (type2Error != null) {
          validationErrors['Property Type 2'] = type2Error;
        }

        // Validate text fields for proper content
        String? assessmentError = I2RentalEvidenceValidator.alphanumeric(
            _assessmentNoController.text, 'Assessment Number');
        if (assessmentError != null) {
          validationErrors['Assessment Number'] = assessmentError;
        }

        String? ownerError = I2RentalEvidenceValidator.alphanumeric(
            _ownerNameController.text, 'Owner Name');
        if (ownerError != null) {
          validationErrors['Owner Name'] = ownerError;
        }

        String? occupierError = I2RentalEvidenceValidator.alphanumeric(
            _occupierNameController.text, 'Occupier Name');
        if (occupierError != null) {
          validationErrors['Occupier Name'] = occupierError;
        }

        String? descriptionError = I2RentalEvidenceValidator.required(
            _descriptionController.text, 'Description');
        if (descriptionError != null) {
          validationErrors['Description'] = descriptionError;
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

        // Form is valid, proceed with submission
        _showSuccessMessage(
            'Form validated successfully. Ready to submit data!');

        // Here you would normally send the data to your backend
        // _cubit.sendRentalEvidence(...);
      } catch (e) {
        _showErrorMessage('Error validating form data: $e');
      }
    } else {
      _showErrorMessage('Please fix the errors in the form');
    }
  }

  /// Callback function when an image is picked.
  /// Adds the picked [file] to the uploadedImages list.
  void _onImagePicked(File file) {
    setState(() {
      uploadedImages.add(file);
    });
  }

  /// Deletes the image at a given [index] from the uploadedImages list.
  void _deleteImage(int index) {
    setState(() {
      uploadedImages.removeAt(index);
    });
  }

  /// Builds the view for the rental evidence page.
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      // Customized AppBar with title and customized styling.
      appBar: CustomAppBar(
        title: AppString.rentalEvidence.l10n(context)!,
      ),
      // Main body wrapped in a SingleChildScrollView to allow vertical scrolling.
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Breadcrumb navigation for a clear page hierarchy.
            Breadcrumb(items: [
              BreadcrumbItem(label: AppString.massRating.l10n(context)!),
              BreadcrumbItem(
                  label: AppString.rentalEvidence.l10n(context)!),
            ]),
            // LayoutBuilder to determine available width and adjust field sizes accordingly.
            LayoutBuilder(builder: (context, constraints) {
              double fieldWidth = constraints.maxWidth * 0.47;

              return Padding(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Wrap widget for grouping input fields with spacing.
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          // Dropdown field for selecting a building.
                          CustomDropdownField(
                            label: AppString.selectBuilding.l10n(context)!,
                            items: [
                              AppString.selectBuilding.l10n(context)!,
                              AppString.building1.l10n(context)!,
                              AppString.building2.l10n(context)!
                            ],
                            initialValue:
                                AppString.selectBuilding.l10n(context)!,
                            onChanged: (value) {
                              setState(() {
                                _selectedBuilding = value;
                              });
                            },
                            width: fieldWidth,
                            validator: (value) =>
                                I2RentalEvidenceValidator.requiredDropdown(
                                    value,
                                    AppString.selectBuilding
                                        .l10n(context)!),
                          ),
                          // Dropdown field for selecting a property category.
                          CustomDropdownField(
                            label:
                                AppString.propertyCategory.l10n(context)!,
                            items: [
                              AppString.selectPropertyCategory
                                  .l10n(context)!,
                              AppString.category1.l10n(context)!,
                              AppString.category2.l10n(context)!
                            ],
                            initialValue: AppString.selectPropertyCategory
                                .l10n(context)!,
                            onChanged: (value) {
                              setState(() {
                                _selectedPropertyCategory = value;
                              });
                            },
                            width: fieldWidth,
                            validator: (value) =>
                                I2RentalEvidenceValidator.requiredDropdown(
                                    value,
                                    AppString.propertyCategory
                                        .l10n(context)!),
                          ),
                          // Dropdown field for selecting a property subcategory.
                          CustomDropdownField(
                            label: AppString.propertySubcategory
                                .l10n(context)!,
                            items: [
                              AppString.selectPropertySubcategory
                                  .l10n(context)!,
                              AppString.subcategory1.l10n(context)!,
                              AppString.subcategory2.l10n(context)!
                            ],
                            initialValue: AppString.selectPropertySubcategory
                                .l10n(context)!,
                            onChanged: (value) {
                              setState(() {
                                _selectedPropertySubcategory = value;
                              });
                            },
                            width: fieldWidth,
                            validator: (value) =>
                                I2RentalEvidenceValidator.requiredDropdown(
                                    value,
                                    AppString.propertySubcategory
                                        .l10n(context)!),
                          ),
                          // Dropdown field for selecting a property type.
                          CustomDropdownField(
                            label: AppString.propertyType.l10n(context)!,
                            items: [
                              AppString.selectPropertyType.l10n(context)!,
                              AppString.type1.l10n(context)!,
                              AppString.type2.l10n(context)!
                            ],
                            initialValue:
                                AppString.selectPropertyType.l10n(context)!,
                            onChanged: (value) {
                              setState(() {
                                _selectedPropertyType1 = value;
                              });
                            },
                            width: fieldWidth,
                            validator: (value) =>
                                I2RentalEvidenceValidator.requiredDropdown(
                                    value,
                                    AppString.propertyType.l10n(context)!),
                          ),
                          // Text field for inputting assessment number.
                          LabeledTextField(
                            label: AppString.assesmentNo.l10n(context)!,
                            placeholder:
                                AppString.assesmentNo.l10n(context)!,
                            width: fieldWidth,
                            controller: _assessmentNoController,
                            validator: (value) =>
                                I2RentalEvidenceValidator.requiredAlphaNum(
                                    value,
                                    50,
                                    AppString.assesmentNo.l10n(context)!),
                          ),
                          // Text field for inputting owner name.
                          LabeledTextField(
                            label: AppString.ownerName.l10n(context)!,
                            placeholder: AppString.ownerName.l10n(context)!,
                            width: fieldWidth,
                            controller: _ownerNameController,
                            validator: (value) =>
                                I2RentalEvidenceValidator.requiredAlphaNum(
                                    value,
                                    100,
                                    AppString.ownerName.l10n(context)!),
                          ),
                          // Dropdown field for selecting property type.
                          CustomDropdownField(
                            label: AppString.propertyType.l10n(context)!,
                            items: [
                              AppString.propertyType.l10n(context)!,
                              AppString.typeA.l10n(context)!,
                              AppString.typeB.l10n(context)!
                            ],
                            initialValue:
                                AppString.propertyType.l10n(context)!,
                            onChanged: (value) {
                              setState(() {
                                _selectedPropertyType2 = value;
                              });
                            },
                            width: fieldWidth,
                            validator: (value) =>
                                I2RentalEvidenceValidator.requiredDropdown(
                                    value,
                                    AppString.propertyType.l10n(context)!),
                          ),
                          // Text field for inputting occupier name.
                          LabeledTextField(
                            label: AppString.occupierName.l10n(context)!,
                            placeholder:
                                AppString.occupierName.l10n(context)!,
                            width: fieldWidth,
                            controller: _occupierNameController,
                            validator: (value) =>
                                I2RentalEvidenceValidator.requiredAlphaNum(
                                    value,
                                    100,
                                    AppString.occupierName.l10n(context)!),
                          ),
                          // Text field for describing the property.
                          LabeledTextField(
                            label: AppString.descriptionOfProperty
                                .l10n(context)!,
                            placeholder: AppString.descriptionOfProperty
                                .l10n(context)!,
                            width: fieldWidth,
                            controller: _descriptionController,
                            validator: (value) =>
                                I2RentalEvidenceValidator.requiredAlphaNum(
                                    value,
                                    255,
                                    AppString.descriptionOfProperty
                                        .l10n(context)!),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Labeling section for the image capturing area.
                      Row(
                        children: [
                          Text(
                            AppString.imageCapturing.l10n(context)!,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '(Optional)',
                            style: TextStyle(
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Wrap widget for displaying uploaded images and an upload button.
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          // Generate a widget for each uploaded image.
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
                          // Upload button for picking new images.
                          ImageUpload(
                            isUploadButton: true,
                            onImagePicked: _onImagePicked,
                            onDelete: () {},
                            size: 128,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Row widget containing the action buttons.
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Save and Cancel buttons grouped together.
                          Row(
                            children: [
                              CustomButton(
                                text: AppString.save.l10n(context)!,
                                onPressed: _validateAndSubmit,
                                backgroundColor: colors(context).colorPrimary5!,
                              ),
                              const SizedBox(width: 16),
                              CustomButton(
                                text: AppString.cancel,
                                onPressed: () {},
                                backgroundColor: colors(context).colorGrey1!,
                              ),
                            ],
                          ),
                          // Button for sending data.
                          CustomButton(
                            text: AppString.sendData.l10n(context)!,
                            onPressed: _validateAndSubmit,
                            backgroundColor: colors(context).colorPrimary5!,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  /// Returns the cubit instance associated with this page.
  @override
  BaseCubit<BaseState> getCubit() {
    return _cubit;
  }
}
