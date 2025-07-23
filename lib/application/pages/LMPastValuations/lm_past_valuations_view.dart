import 'dart:io';
import 'package:flutter/material.dart';
import 'package:land_asset_valuation/app/base_view.dart';
import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/core/configurations/app_config.dart';
import 'package:land_asset_valuation/injection.dart';
import 'package:land_asset_valuation/application/pages/LMPastValuations/cubit/lm_past_valuations_cubit.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_app_bar.dart';
import 'package:land_asset_valuation/application/core/widgets/breadcrumb.dart';
import 'package:land_asset_valuation/application/core/widgets/labeled_text_field.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_dropdown_field.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_button.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';
import 'package:land_asset_valuation/application/core/widgets/image_upload.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/validators/lm_past_valuations_validator.dart';
import 'package:land_asset_valuation/data/models/master_data_model.dart';
import 'package:http/http.dart' as http;

class LmPastValuationsView extends BasePage {
  final MasterDataResponse masterData;
  const LmPastValuationsView({super.key, required this.masterData});

  @override
  _LmPastValuationsViewState createState() => _LmPastValuationsViewState();
}

class _LmPastValuationsViewState extends BasePageState<LmPastValuationsView> {
  final _cubit = injection<LmPastValuationsCubit>();
  final _formKey = GlobalKey<FormState>();
  List<dynamic> uploadedImages = [];

  void _onImagePicked(File? file) {
    if (file != null) {
      setState(() {
        uploadedImages.add(file);
      });
    }
  }

  void _deleteImage(int index) {
    setState(() {
      uploadedImages.removeAt(index);
    });
  }

  // Add this function to handle validation, submission, and image upload
  void _validateAndSubmit() async {
    if (_formKey.currentState!.validate()) {
      final reportId = await _submitFormData();
      if (reportId != null) {
        await _uploadImages(reportId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('LM past valuation submitted successfully!'),
              backgroundColor: Colors.green),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to submit LM past valuation.'),
              backgroundColor: Colors.red),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fix the validation errors in the form'),
            backgroundColor: Colors.red),
      );
    }
  }

  Future<String?> _submitFormData() async {
    try {
      final uri = Uri.parse('${AppConfig.apiBaseUrl}LMPastValuations');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: _buildFormJson(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.body;
        final reportId =
            RegExp(r'"reportId"\s*:\s*(\d+)').firstMatch(data)?.group(1);
        print('DEBUG: LMPastValuations reportId: $reportId');
        return reportId;
      } else {
        print(
            'DEBUG: LMPastValuations submission failed: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      print('DEBUG: Exception during LMPastValuations submission: $e');
      return null;
    }
  }

  String _buildFormJson() {
    // Build JSON string for the form data (add more fields as needed)
    return '''{
      "masterFileRef": "", // Add actual value if needed
      "fileNoGnDivision": "", // Add actual value if needed
      "situation": "", // Add actual value if needed
      "dateOfValuation": "", // Add actual value if needed
      "purposeOfValuation": "", // Add actual value if needed
      "planOfParticulars": "", // Add actual value if needed
      "extent": "", // Add actual value if needed
      "rate": "", // Add actual value if needed
      "rateType": "", // Add actual value if needed
      "remarks": "", // Add actual value if needed
      "locationLongitude": "", // Add actual value if needed
      "locationLatitude": "" // Add actual value if needed
    }''';
  }

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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Images uploaded successfully.'),
              backgroundColor: Colors.green),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to upload images.'),
              backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      print('DEBUG: Exception during image upload: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error uploading images: $e'),
            backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget buildView(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: CustomAppBar(title: "Past Valuations"),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Breadcrumb(items: [
                    BreadcrumbItem(label: "Land Miscellaneous"),
                    BreadcrumbItem(label: "Master File - #56249"),
                    BreadcrumbItem(label: "Past Valuations"),
                  ]),
                  _buildRow([
                    LabeledTextField(
                      label: AppString.masterFilerefno.localize(context)!,
                      placeholder: "Metro/2/LM/123",
                    ),
                    LabeledTextField(
                      label: AppString.fileNoGnDivision.localize(context)!,
                      placeholder:
                          AppString.fileNoGnDivision.localize(context)!,
                      validator: (value) =>
                          LmPastValuationsValidator.optionalAlphaNum(
                              value, 255, "Assessment No"),
                    ),
                  ]),
                  _buildRow([
                    LabeledTextField(
                      label: AppString.situation.localize(context)!,
                      placeholder: AppString.situation.localize(context)!,
                      validator: (value) =>
                          LmPastValuationsValidator.optionalAlphaNum(
                              value, 255, "Situation"),
                    ),
                    LabeledTextField(
                      label: AppString.dateOfValuation.localize(context)!,
                      placeholder: "AT Lot 01",
                    ),
                  ]),
                  _buildRow([
                    LabeledTextField(
                      label: AppString.purposeOfValuation.localize(context)!,
                      placeholder:
                          AppString.purposeOfValuation.localize(context)!,
                      validator: (value) =>
                          LmPastValuationsValidator.optionalAlphaNum(
                              value, 255, "Purpose of Valuation"),
                    ),
                    LabeledTextField(
                      label: AppString.planOfParticulars.localize(context)!,
                      placeholder:
                          AppString.planOfParticulars.localize(context)!,
                      validator: (value) =>
                          LmPastValuationsValidator.optionalAlphaNum(
                              value, 255, "Plan Particulars"),
                    ),
                  ]),
                  _buildRow([
                    LabeledTextField(
                      label: AppString.extent.localize(context)!,
                      placeholder: AppString.extent.localize(context)!,
                      validator: (value) =>
                          LmPastValuationsValidator.optionalNumeric(
                              value, 255, "Extent"),
                    ),
                    LabeledTextField(
                      label: AppString.rate.localize(context)!,
                      placeholder: AppString.rate.localize(context)!,
                      validator: (value) =>
                          LmPastValuationsValidator.optionalNumeric(
                              value, 255, "Rate per unit"),
                    ),
                  ]),
                  _buildRow([
                    CustomDropdownField(
                      label: AppString.rateType.localize(context)!,
                      items: widget.masterData.services,
                      initialValue: widget.masterData.services.isNotEmpty
                          ? widget.masterData.services.first
                          : null,
                      onChanged: (value) {},
                      width: 484,
                    ),
                    LabeledTextField(
                      label: AppString.remarks.localize(context)!,
                      placeholder: AppString.remarks.localize(context)!,
                      validator: (value) =>
                          LmPastValuationsValidator.optionalAlphaNum(
                              value, 255, "Remarks"),
                    ),
                  ]),
                  _buildRow([
                    LabeledTextField(
                      label: AppString.locationLongitude.localize(context)!,
                      placeholder: "6.123456789",
                      validator: (value) =>
                          LmPastValuationsValidator.optionalNumeric(
                              value, 255, "Longitude"),
                    ),
                    LabeledTextField(
                      label: AppString.locationLatitude.localize(context)!,
                      placeholder: "6.123456789",
                      validator: (value) =>
                          LmPastValuationsValidator.optionalNumeric(
                              value, 255, "Latitude"),
                    ),
                  ]),
                  const SizedBox(height: 24),
                  Text(AppString.uploadImgs.localize(context)!,
                      style: AppStyling.mediumTextSize14),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.start,
                    children: [
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
                      ImageUpload(
                        isUploadButton: true,
                        onImagePicked: _onImagePicked,
                        onDelete: () {},
                        size: 128,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomButton(
                        text: AppString.cancel.localize(context)!,
                        onPressed: () {},
                        backgroundColor: colors(context).colorGrey1!,
                      ),
                      Row(
                        children: [
                          CustomButton(
                            text: AppString.save.localize(context)!,
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Form valid. Saving..."),
                                      backgroundColor: Colors.green),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Please fix the errors"),
                                      backgroundColor: Colors.red),
                                );
                              }
                            },
                            backgroundColor: colors(context).colorPrimary5!,
                          ),
                          const SizedBox(width: 40),
                          CustomButton(
                            text: AppString.sendData.localize(context)!,
                            onPressed: _validateAndSubmit,
                            backgroundColor: colors(context).colorPrimary1!,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  BaseCubit<BaseState> getCubit() {
    return _cubit;
  }

  Widget _buildRow(List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: children.map((widget) => Expanded(child: widget)).toList(),
      ),
    );
  }
}
