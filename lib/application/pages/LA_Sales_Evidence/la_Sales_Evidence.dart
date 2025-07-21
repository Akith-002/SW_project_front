import 'dart:io';

import 'package:flutter/material.dart';
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
import 'package:land_asset_valuation/application/pages/LA_Sales_Evidence/cubit/la_sales_evidence_cubit.dart';
import 'package:land_asset_valuation/application/core/validators/la_sales_evidence_validator.dart';
import 'package:land_asset_valuation/application/core/widgets/data_send_successfully_dialogbox.dart';
import 'package:land_asset_valuation/injection.dart';
import 'package:http/http.dart' as http;

/// Sales Evidence form screen for Land Acquisition module
/// Allows users to input and manage land sales evidence data
class LaSalesEvidence extends BasePage {
  const LaSalesEvidence({super.key});

  @override
  State<LaSalesEvidence> createState() => _LaSalesEvidenceState();
}

class _LaSalesEvidenceState extends BasePageState<LaSalesEvidence> {
  final _cubit = injection<LaSalesEvidenceCubit>();

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final _assetNumberController = TextEditingController();
  final _masterFileRefController = TextEditingController();
  final _roadNameController = TextEditingController();
  final _villageController = TextEditingController();
  final _vendorController = TextEditingController();
  final _deedNumberController = TextEditingController();
  final _deedAttestedNumberController = TextEditingController();
  final _notaryNameController = TextEditingController();
  final _lotNumberController = TextEditingController();
  final _planNumberController = TextEditingController();
  final _planDateController = TextEditingController();
  final _extentController = TextEditingController();
  final _considerationController = TextEditingController();
  final _remarksController = TextEditingController();
  final _rateController = TextEditingController();
  final _rateTypeController = TextEditingController();
  final _locationLongitudeController = TextEditingController();
  final _locationLatitudeController = TextEditingController();
  final _landRegistryReferencesController = TextEditingController();
  final _situationController = TextEditingController();
  final _descriptionOfLandController = TextEditingController();

  // Stores both File objects (newly picked images) and String paths (previously saved images)
  List<dynamic> uploadedImages = [];

  @override
  void dispose() {
    _assetNumberController.dispose();
    _masterFileRefController.dispose();
    _roadNameController.dispose();
    _villageController.dispose();
    _vendorController.dispose();
    _deedNumberController.dispose();
    _deedAttestedNumberController.dispose();
    _notaryNameController.dispose();
    _lotNumberController.dispose();
    _planNumberController.dispose();
    _planDateController.dispose();
    _extentController.dispose();
    _considerationController.dispose();
    _remarksController.dispose();
    _rateController.dispose();
    _rateTypeController.dispose();
    _locationLongitudeController.dispose();
    _locationLatitudeController.dispose();
    _landRegistryReferencesController.dispose();
    _situationController.dispose();
    _descriptionOfLandController.dispose();
    super.dispose();
  }

  /// Adds a newly picked image to the collection
  void _onImagePicked(File file) {
    setState(() {
      uploadedImages.add(file);
    });
  }

  /// Removes an image from the collection by index
  void _deleteImage(int index) {
    setState(() {
      uploadedImages.removeAt(index);
    });
  }

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      appBar:
          CustomAppBar(title: AppString.salesEvidencesForm.localize(context)!),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate the width for form fields based on available screen width
          double fieldWidth = constraints.maxWidth * 0.47;

          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Navigation breadcrumb
                  Breadcrumb(
                    items: [
                      BreadcrumbItem(
                          label: AppString.landAcquisition.localize(context)!),
                      BreadcrumbItem(
                          label: AppString.masterFile.localize(context)!),
                      BreadcrumbItem(
                          label: AppString.salesEvidences.localize(context)!),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Form fields section
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          alignment: WrapAlignment.start,
                          children: [
                            // Property identification fields
                            LabeledTextField(
                              label: AppString.assetNumber.localize(context)!,
                              placeholder:
                                  AppString.assetNumber.localize(context)!,
                              width: fieldWidth,
                              controller: _assetNumberController,
                              validator: (value) =>
                                  LaSalesEvidenceValidator.requiredAlphaNum(
                                      value, 50, "Asset Number"),
                            ),
                            LabeledTextField(
                              label:
                                  AppString.masterFilerefno.localize(context)!,
                              placeholder:
                                  AppString.masterFilerefno.localize(context)!,
                              width: fieldWidth,
                              controller: _masterFileRefController,
                              validator: (value) =>
                                  LaSalesEvidenceValidator.requiredAlphaNum(
                                      value, 50, "Master File Reference"),
                            ),

                            // Location information fields
                            LabeledTextField(
                              label: AppString.roadName.localize(context)!,
                              placeholder: AppString.owner.localize(context)!,
                              width: fieldWidth,
                              controller: _roadNameController,
                              validator: (value) =>
                                  LaSalesEvidenceValidator.optionalAlphaNum(
                                      value, 100, "Road Name"),
                            ),
                            LabeledTextField(
                              label: AppString.village.localize(context)!,
                              placeholder:
                                  AppString.occupier.localize(context)!,
                              width: fieldWidth,
                              controller: _villageController,
                              validator: (value) =>
                                  LaSalesEvidenceValidator.optionalAlphaNum(
                                      value, 100, "Village"),
                            ),

                            // Transaction information fields
                            LabeledTextField(
                              label: AppString.vendor.localize(context)!,
                              placeholder:
                                  AppString.situation.localize(context)!,
                              width: fieldWidth,
                              controller: _vendorController,
                              validator: (value) =>
                                  LaSalesEvidenceValidator.requiredAlphaNum(
                                      value, 100, "Vendor"),
                            ),
                            LabeledTextField(
                              label: AppString.deedNumber.localize(context)!,
                              placeholder:
                                  AppString.floorRate.localize(context)!,
                              width: fieldWidth,
                              controller: _deedNumberController,
                              validator: (value) =>
                                  LaSalesEvidenceValidator.requiredDeedNumber(
                                      value, 50, "Deed Number"),
                            ),
                            LabeledTextField(
                              label: AppString.deedAttestedNumber
                                  .localize(context)!,
                              placeholder: AppString.deedAttestedNumber
                                  .localize(context)!,
                              width: fieldWidth,
                              controller: _deedAttestedNumberController,
                              validator: (value) =>
                                  LaSalesEvidenceValidator.optionalDeedNumber(
                                      value, 50, "Deed Attested Number"),
                            ),
                            LabeledTextField(
                              label: AppString.notaryName.localize(context)!,
                              placeholder:
                                  AppString.notaryName.localize(context)!,
                              width: fieldWidth,
                              controller: _notaryNameController,
                              validator: (value) =>
                                  LaSalesEvidenceValidator.requiredAlphaNum(
                                      value, 100, "Notary Name"),
                            ),

                            // Land specification fields
                            LabeledTextField(
                              label: AppString.lotNumber.localize(context)!,
                              placeholder: AppString.noofLotNumbergiven
                                  .localize(context)!,
                              width: fieldWidth,
                              controller: _lotNumberController,
                              validator: (value) =>
                                  LaSalesEvidenceValidator.optionalAlphaNum(
                                      value, 50, "Lot Number"),
                            ),
                            LabeledTextField(
                              label: AppString.planNumber.localize(context)!,
                              placeholder:
                                  AppString.planNumber.localize(context)!,
                              width: fieldWidth,
                              controller: _planNumberController,
                              validator: (value) =>
                                  LaSalesEvidenceValidator.optionalAlphaNum(
                                      value, 50, "Plan Number"),
                            ),
                            LabeledTextField(
                              label: AppString.planDate.localize(context)!,
                              placeholder:
                                  AppString.planDate.localize(context)!,
                              width: fieldWidth,
                              controller: _planDateController,
                              validator: (value) =>
                                  LaSalesEvidenceValidator.optionalDate(
                                      value, "Plan Date"),
                            ),
                            LabeledTextField(
                              label: AppString.extent.localize(context)!,
                              placeholder: AppString.extent.localize(context)!,
                              width: fieldWidth,
                              controller: _extentController,
                              validator: (value) =>
                                  LaSalesEvidenceValidator.optionalNumeric(
                                      value, 20, "Extent"),
                            ),

                            // Financial and valuation fields
                            LabeledTextField(
                              label: AppString.consideration.localize(context)!,
                              placeholder:
                                  AppString.consideration.localize(context)!,
                              width: fieldWidth,
                              controller: _considerationController,
                              validator: (value) =>
                                  LaSalesEvidenceValidator.requiredNumeric(
                                      value, 20, "Consideration"),
                            ),
                            LabeledTextField(
                              label: AppString.remarks.localize(context)!,
                              placeholder: AppString.remarks.localize(context)!,
                              width: fieldWidth,
                              controller: _remarksController,
                              validator: (value) =>
                                  LaSalesEvidenceValidator.optionalAlphaNum(
                                      value, 500, "Remarks"),
                            ),
                            LabeledTextField(
                              label: AppString.rate.localize(context)!,
                              placeholder: AppString.rate.localize(context)!,
                              width: fieldWidth,
                              controller: _rateController,
                              validator: (value) =>
                                  LaSalesEvidenceValidator.requiredNumeric(
                                      value, 20, "Rate"),
                            ),
                            LabeledTextField(
                              label: AppString.rateType.localize(context)!,
                              placeholder:
                                  AppString.rateType.localize(context)!,
                              width: fieldWidth,
                              controller: _rateTypeController,
                              validator: (value) =>
                                  LaSalesEvidenceValidator.optionalAlphaNum(
                                      value, 50, "Rate Type"),
                            ),

                            // Geolocation fields
                            LabeledTextField(
                              label: AppString.locationLongitude
                                  .localize(context)!,
                              placeholder: AppString.locationLongitude
                                  .localize(context)!,
                              width: fieldWidth,
                              controller: _locationLongitudeController,
                              validator: (value) =>
                                  LaSalesEvidenceValidator.optionalCoordinate(
                                      value, "Location Longitude"),
                            ),
                            LabeledTextField(
                              label:
                                  AppString.locationLatitude.localize(context)!,
                              placeholder:
                                  AppString.locationLatitude.localize(context)!,
                              width: fieldWidth,
                              controller: _locationLatitudeController,
                              validator: (value) =>
                                  LaSalesEvidenceValidator.optionalCoordinate(
                                      value, "Location Latitude"),
                            ),

                            // Additional reference and description fields
                            LabeledTextField(
                              label: AppString.landRegistryReferences
                                  .localize(context)!,
                              placeholder: AppString.landRegistryReferences
                                  .localize(context)!,
                              width: fieldWidth,
                              controller: _landRegistryReferencesController,
                              validator: (value) =>
                                  LaSalesEvidenceValidator.optionalAlphaNum(
                                      value, 200, "Land Registry References"),
                            ),
                            LabeledTextField(
                              label: AppString.situation.localize(context)!,
                              placeholder:
                                  AppString.situation.localize(context)!,
                              width: fieldWidth,
                              controller: _situationController,
                              validator: (value) =>
                                  LaSalesEvidenceValidator.optionalAlphaNum(
                                      value, 200, "Situation"),
                            ),
                            LabeledTextField(
                              label: AppString.descriptionOfLand
                                  .localize(context)!,
                              placeholder: AppString.descriptionOfLand
                                  .localize(context)!,
                              width: fieldWidth,
                              controller: _descriptionOfLandController,
                              validator: (value) =>
                                  LaSalesEvidenceValidator.optionalAlphaNum(
                                      value, 500, "Description of Land"),
                            ),
                          ],
                        ),

                        // Image upload section
                        const SizedBox(height: 24),
                        Text(
                          AppString.imageCapturing.localize(context)!,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: [
                            // Display all previously uploaded images
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
                            // Upload button for adding new images
                            ImageUpload(
                              isUploadButton: true,
                              onImagePicked: _onImagePicked,
                              onDelete: () {}, // Not used for upload button
                              size: 128,
                            ),
                          ],
                        ),

                        // Divider
                        Container(
                          height: 1,
                          margin: const EdgeInsets.all(16),
                          width: double.infinity,
                          color: Colors.grey,
                        ),

                        // Action buttons section
                        Row(
                          children: [
                            CustomButton(
                              text: AppString.cancel.localize(context)!,
                              onPressed: () {},
                              backgroundColor: colors(context).colorGrey1!,
                            ),
                            const Spacer(),
                            CustomButton(
                              text: AppString.save.localize(context)!,
                              onPressed: _validateAndSave,
                              backgroundColor: colors(context).colorPrimary1!,
                            ),
                            const SizedBox(width: 40),
                            CustomButton(
                              text: AppString.sendData.localize(context)!,
                              onPressed: _validateAndSubmit,
                              backgroundColor: colors(context).colorPrimary5!,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  BaseCubit<BaseState> getCubit() {
    return _cubit;
  }

  /// Validates and saves the form
  void _validateAndSave() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, save the data
      _showSuccessMessage('Sales evidence data saved successfully');
      // TODO: Implement actual save logic
    } else {
      _showErrorMessage('Please fix the validation errors in the form');
    }
  }

  /// Validates and submits the form
  void _validateAndSubmit() async {
    if (_formKey.currentState!.validate()) {
      // 1. Submit form data to backend
      final reportId = await _submitFormData();
      if (reportId != null) {
        // 2. Upload images with reportId
        await _uploadImages(reportId);
        _showSuccessDialog();
      } else {
        _showErrorMessage('Failed to submit sales evidence data.');
      }
    } else {
      _showErrorMessage('Please fix the validation errors in the form');
    }
  }

  /// Submits the form data to the backend and returns the new reportId
  Future<String?> _submitFormData() async {
    try {
      final uri = Uri.parse('http://10.0.2.2:5221/api/SalesEvidenceLA');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: _buildFormJson(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.body;
        // Expecting { msg: "success", reportId: ... }
        final reportId =
            RegExp(r'"reportId"\s*:\s*(\d+)').firstMatch(data)?.group(1);
        print('DEBUG: SalesEvidenceLA reportId: $reportId');
        return reportId;
      } else {
        print(
            'DEBUG: SalesEvidenceLA submission failed: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      print('DEBUG: Exception during SalesEvidenceLA submission: $e');
      return null;
    }
  }

  /// Builds the JSON string for the form data
  String _buildFormJson() {
    return '''{
      "assetNumber": "${_assetNumberController.text}",
      "masterFileRef": "${_masterFileRefController.text}",
      "roadName": "${_roadNameController.text}",
      "village": "${_villageController.text}",
      "vendor": "${_vendorController.text}",
      "deedNumber": "${_deedNumberController.text}",
      "deedAttestedNumber": "${_deedAttestedNumberController.text}",
      "notaryName": "${_notaryNameController.text}",
      "lotNumber": "${_lotNumberController.text}",
      "planNumber": "${_planNumberController.text}",
      "planDate": "${_planDateController.text}",
      "extent": "${_extentController.text}",
      "consideration": "${_considerationController.text}",
      "remarks": "${_remarksController.text}",
      "rate": "${_rateController.text}",
      "rateType": "${_rateTypeController.text}",
      "locationLongitude": "${_locationLongitudeController.text}",
      "locationLatitude": "${_locationLatitudeController.text}",
      "landRegistryReferences": "${_landRegistryReferencesController.text}",
      "situation": "${_situationController.text}",
      "descriptionOfLand": "${_descriptionOfLandController.text}"
    }''';
  }

  /// Uploads images to the backend after form submission
  Future<void> _uploadImages(String reportId) async {
    print('DEBUG: _uploadImages called with reportId: $reportId');
    print('DEBUG: Number of images to upload: ${uploadedImages.length}');
    if (uploadedImages.isEmpty) return;
    var uri = Uri.parse('http://10.0.2.2:5221/api/ImageData/upload');
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

  /// Shows success message to user
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

  /// Shows error message to user
  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
