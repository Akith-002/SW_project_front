import 'dart:io';
import 'package:flutter/material.dart';
import 'package:land_asset_valuation/app/base_view.dart';
import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/light_color_list.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';
import 'package:land_asset_valuation/application/core/widgets/breadcrumb.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_app_bar.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_button.dart';
import 'package:land_asset_valuation/application/core/widgets/image_upload.dart';
import 'package:land_asset_valuation/application/core/widgets/labeled_text_field.dart';
import 'package:land_asset_valuation/application/pages/rental_evidence/cubit/rental_evidence_cubit.dart';
import 'package:land_asset_valuation/injection.dart';

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
  List<dynamic> uploadedImages = [];

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

  // Validation methods
  String? _validateString(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? _validateInt(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    if (int.tryParse(value) == null) {
      return 'Please enter a valid integer';
    }
    return null;
  }

  String? _validateFloat(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    return null;
  }

  void _validateAndSubmit() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, proceed with submission
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form is valid!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fix the errors in the form')),
      );
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

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
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
                  label: AppString.rentalEvidenceForm.localize(context) ?? ''),
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
                                  AppString.assesmentNo.localize(context) ?? '',
                              width: fieldWidth,
                              controller: _assessmentNoController,
                              validator: _validateString,
                            ),
                            LabeledTextField(
                              placeholder: AppString.masterFileRefNoPlaceholder
                                  .localize(context)!,
                              label:
                                  AppString.masterFileRefNo.localize(context) ??
                                      '',
                              width: fieldWidth,
                              controller: _masterFileRefNoController,
                              validator: _validateString,
                            ),
                            LabeledTextField(
                              placeholder:
                                  AppString.owner.localize(context) ?? '',
                              label: AppString.owner.localize(context)!,
                              width: fieldWidth,
                              controller: _ownerController,
                              validator: _validateString,
                            ),
                            LabeledTextField(
                              placeholder:
                                  AppString.occupier.localize(context) ?? '',
                              label: AppString.occupier.localize(context)!,
                              width: fieldWidth,
                              controller: _occupierController,
                              validator: _validateString,
                            ),
                            LabeledTextField(
                              placeholder:
                                  AppString.description.localize(context) ?? '',
                              label:
                                  AppString.description.localize(context) ?? '',
                              width: fieldWidth,
                              controller: _descriptionController,
                              validator: _validateString,
                            ),
                            LabeledTextField(
                              placeholder: AppString.floorRatePlaceholder
                                  .localize(context)!,
                              label:
                                  AppString.floorRate.localize(context) ?? '',
                              width: fieldWidth,
                              controller: _floorRateController,
                              validator: _validateInt,
                            ),
                            LabeledTextField(
                              placeholder:
                                  AppString.ratePerSqft.localize(context) ?? '',
                              label:
                                  AppString.ratePerSqft.localize(context) ?? '',
                              width: fieldWidth,
                              controller: _ratePerSqftController,
                              validator: _validateInt,
                            ),
                            LabeledTextField(
                              placeholder:
                                  AppString.ratePerMonth.localize(context) ??
                                      '',
                              label: AppString.ratePerMonth.localize(context) ??
                                  '',
                              width: fieldWidth,
                              controller: _ratePerMonthController,
                              validator: _validateInt,
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
                              validator: _validateFloat,
                            ),
                            LabeledTextField(
                              placeholder: AppString.locationLatitudePlaceholder
                                  .localize(context)!,
                              label: AppString.locationLatitude
                                      .localize(context) ??
                                  '',
                              width: fieldWidth,
                              controller: _latitudeController,
                              validator: _validateFloat,
                            ),
                            LabeledTextField(
                              placeholder:
                                  AppString.headOfTerms.localize(context) ?? '',
                              label:
                                  AppString.headOfTerms.localize(context) ?? '',
                              width: fieldWidth,
                              controller: _headOfTermsController,
                              validator: _validateString,
                            ),
                            LabeledTextField(
                              placeholder:
                                  AppString.situation.localize(context) ?? '',
                              label:
                                  AppString.situation.localize(context) ?? '',
                              width: fieldWidth,
                              controller: _situationController,
                              validator: _validateString,
                            ),
                            // Full width text field for remarks.
                            LabeledTextField(
                              placeholder:
                                  AppString.remarks.localize(context) ?? '',
                              label: AppString.remarks.localize(context) ?? '',
                              width: fullWidth,
                              controller: _remarksController,
                              validator: _validateString,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Section title for image uploads.
                        Text(
                          AppString.uploadImgs.localize(context) ?? '',
                          style: AppStyling.mediumTextSize14,
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
                              onPressed: () {},
                              backgroundColor: colors(context).colorGrey1 ??
                                  LightColorList.lightGrey50,
                            ),
                            Row(
                              children: [
                                // Save button.
                                CustomButton(
                                  text: AppString.save.localize(context) ?? '',
                                  onPressed: _validateAndSubmit,
                                  backgroundColor:
                                      colors(context).colorPrimary5 ??
                                          LightColorList.lightPrimary700,
                                ),
                                const SizedBox(width: 40),
                                // Send data button.
                                CustomButton(
                                  text: AppString.sendData.localize(context) ??
                                      '',
                                  onPressed: _validateAndSubmit,
                                  backgroundColor:
                                      colors(context).colorPrimary1 ??
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
    );
  }

  // Returns the cubit instance for managing state.
  @override
  BaseCubit<BaseState> getCubit() {
    return _cubit;
  }
}
