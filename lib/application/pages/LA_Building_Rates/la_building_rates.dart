import 'dart:io';
import 'package:flutter/material.dart';
import 'package:land_asset_valuation/app/base_view.dart';
import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/core/configurations/app_config.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/widgets/breadcrumb.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_app_bar.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_button.dart';
import 'package:land_asset_valuation/application/core/widgets/image_upload.dart';
import 'package:land_asset_valuation/application/core/widgets/labeled_text_field.dart';
import 'package:land_asset_valuation/application/pages/LA_Building_Rates/cubit/la_building_rates_cubit.dart';
import 'package:land_asset_valuation/application/core/validators/la_building_rates_validator.dart';
import 'package:land_asset_valuation/application/core/widgets/data_send_successfully_dialogbox.dart';
import 'package:land_asset_valuation/injection.dart';
import 'package:http/http.dart' as http;

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
    return Scaffold(
      appBar:
          CustomAppBar(title: AppString.buildingRatesForm.localize(context)!),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate responsive field width (47% of screen width)
          double fieldWidth = constraints.maxWidth * 0.47;

          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Navigation breadcrumb
                  Breadcrumb(
                    items: [
                      BreadcrumbItem(
                          label: AppString.landAcquisition.localize(context)!),
                      BreadcrumbItem(
                          label: AppString.masterFile.localize(context)!),
                      BreadcrumbItem(
                          label: AppString.buildingRates.localize(context)!),
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
                              label:
                                  AppString.assessmentNumber.localize(context)!,
                              placeholder:
                                  AppString.assessmentNumber.localize(context)!,
                              width: fieldWidth,
                              controller: _assessmentNumberController,
                              validator: (value) => LaBuildingRatesValidator
                                  .requiredAssessmentNumber(
                                      value, 50, "Assessment Number"),
                            ),
                            LabeledTextField(
                              label: AppString.owner.localize(context)!,
                              placeholder:
                                  AppString.nameOfTheOwner.localize(context)!,
                              width: fieldWidth,
                              controller: _ownerController,
                              validator: (value) =>
                                  LaBuildingRatesValidator.requiredAlphaNum(
                                      value, 100, "Owner"),
                            ),
                            LabeledTextField(
                              label: AppString.constructedBy.localize(context)!,
                              placeholder:
                                  AppString.constructedBy.localize(context)!,
                              width: fieldWidth,
                              controller: _constructedByController,
                              validator: (value) =>
                                  LaBuildingRatesValidator.optionalAlphaNum(
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
                              controller: _descriptionOfPropertyController,
                              validator: (value) =>
                                  LaBuildingRatesValidator.optionalAlphaNum(
                                      value, 500, "Property Description"),
                            ),
                            LabeledTextField(
                              label: AppString.floorAreaSQFT.localize(context)!,
                              placeholder:
                                  AppString.floorAreaSQFT.localize(context)!,
                              width: fieldWidth,
                              controller: _floorAreaSQFTController,
                              validator: (value) =>
                                  LaBuildingRatesValidator.requiredArea(
                                      value, "Floor Area (SQFT)"),
                            ),
                            LabeledTextField(
                              label: AppString.ratePerSQFT.localize(context)!,
                              placeholder:
                                  AppString.ratePerSQFT.localize(context)!,
                              width: fieldWidth,
                              controller: _ratePerSQFTController,
                              validator: (value) =>
                                  LaBuildingRatesValidator.requiredRate(
                                      value, "Rate Per SQFT"),
                            ),
                            LabeledTextField(
                              label: AppString.cost.localize(context)!,
                              placeholder: AppString.cost.localize(context)!,
                              width: fieldWidth,
                              controller: _costController,
                              validator: (value) =>
                                  LaBuildingRatesValidator.requiredCost(
                                      value, "Cost"),
                            ),
                            LabeledTextField(
                              label: AppString.remarks.localize(context)!,
                              placeholder: AppString.remarks.localize(context)!,
                              width: fieldWidth,
                              controller: _remarksController,
                              validator: (value) =>
                                  LaBuildingRatesValidator.optionalAlphaNum(
                                      value, 500, "Remarks"),
                            ),
                            LabeledTextField(
                              label:
                                  AppString.locationLatitude.localize(context)!,
                              placeholder:
                                  AppString.locationLatitude.localize(context)!,
                              width: fieldWidth,
                              controller: _locationLatitudeController,
                              validator: (value) =>
                                  LaBuildingRatesValidator.optionalCoordinate(
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
                                  LaBuildingRatesValidator.optionalCoordinate(
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
                                  imagePath: image is String ? image : null,
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
                              backgroundColor: colors(context).colorGrey1!,
                            ),
                            Spacer(),
                            CustomButton(
                              text: AppString.save.localize(context)!,
                              onPressed: _validateAndSave,
                              backgroundColor: colors(context).colorPrimary1!,
                            ),
                            SizedBox(width: 40),
                            CustomButton(
                              text: AppString.sendData.localize(context)!,
                              onPressed: _validateAndSubmit,
                              backgroundColor: colors(context).colorPrimary5!,
                            ),
                          ],
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
  }

  /// Validates form and saves data locally
  void _validateAndSave() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, save the data
      _showSuccessMessage('Building rates data saved successfully');
      // TODO: Implement actual save logic
    } else {
      _showErrorMessage('Please fix the validation errors in the form');
    }
  }

  /// Validates form and submits data to server
  void _validateAndSubmit() async {
    if (_formKey.currentState!.validate()) {
      // 1. Submit form data to backend
      final reportId = await _submitFormData();
      if (reportId != null) {
        // 2. Upload images with reportId
        await _uploadImages(reportId);
        _showSuccessDialog();
      } else {
        _showErrorMessage('Failed to submit building rates data.');
      }
    } else {
      _showErrorMessage('Please fix the validation errors in the form');
    }
  }

  /// Submits the form data to the backend and returns the new reportId
  Future<String?> _submitFormData() async {
    try {
      final uri = Uri.parse('${AppConfig.apiBaseUrl}BuildingRatesLA');
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
        print('DEBUG: BuildingRatesLA reportId: $reportId');
        return reportId;
      } else {
        print(
            'DEBUG: BuildingRatesLA submission failed: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      print('DEBUG: Exception during BuildingRatesLA submission: $e');
      return null;
    }
  }

  /// Builds the JSON string for the form data
  String _buildFormJson() {
    return '''{
      "assessmentNumber": "${_assessmentNumberController.text}",
      "owner": "${_ownerController.text}",
      "constructedBy": "${_constructedByController.text}",
      "yearOfConstruction": "${_yearOfConstructionController.text}",
      "descriptionOfProperty": "${_descriptionOfPropertyController.text}",
      "floorAreaSQFT": "${_floorAreaSQFTController.text}",
      "ratePerSQFT": "${_ratePerSQFTController.text}",
      "cost": "${_costController.text}",
      "remarks": "${_remarksController.text}",
      "locationLatitude": "${_locationLatitudeController.text}",
      "locationLongitude": "${_locationLongitudeController.text}"
    }''';
  }

  /// Uploads images to the backend after form submission
  Future<void> _uploadImages(String reportId) async {
    print('DEBUG: _uploadImages called with reportId: $reportId');
    print('DEBUG: Number of images to upload: ${uploadedImages.length}');
    if (uploadedImages.isEmpty) return;
    var uri = Uri.parse('${AppConfig.apiBaseUrl}ImageData/upload');
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

  @override
  BaseCubit<BaseState> getCubit() {
    return _cubit;
  }
}
