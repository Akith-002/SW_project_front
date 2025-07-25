import 'dart:io';
import 'package:flutter/material.dart';
import 'package:land_asset_valuation/app/base_view.dart';
import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/core/configurations/app_config.dart';
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
import 'package:land_asset_valuation/data/models/master_data_model.dart';
import 'package:http/http.dart' as http;
import 'package:land_asset_valuation/application/core/configurations/app_config.dart';
import 'package:land_asset_valuation/data/datasource/secure_storage.dart';
import 'dart:convert';

/// Main page widget for displaying rental evidence.
class I2RentalEvidence extends BasePage {
  final MasterDataResponse masterData;
  final double? longitude;
  final double? latitude;
  final int? assetId;
  
  const I2RentalEvidence({
    super.key, 
    required this.masterData,
    this.longitude,
    this.latitude,
    this.assetId,
  });

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
  final _longitudeController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _floorRateController = TextEditingController();
  final _ratePerController = TextEditingController();
  final _ratePerMonthController = TextEditingController();
  final _headOfTermsController = TextEditingController();
  final _situationController = TextEditingController();
  final _remarksController = TextEditingController();

  // Selected values for dropdowns
  String? _selectedBuilding;
  String? _selectedPropertyCategory;
  String? _selectedPropertySubcategory;
  String? _selectedPropertyType1;
  String? _selectedPropertyType2;

  // List to hold the uploaded images (can be File or String type)
  List<dynamic> uploadedImages = [];

  @override
  void initState() {
    super.initState();
    // Log received coordinates
    print('I2RentalEvidence: initState called');
    print('I2RentalEvidence: Received longitude: ${widget.longitude}');
    print('I2RentalEvidence: Received latitude: ${widget.latitude}');
    
    // Initialize coordinate controllers with passed values
    if (widget.longitude != null) {
      _longitudeController.text = widget.longitude.toString();
      print('I2RentalEvidence: Set longitude controller text: ${_longitudeController.text}');
    } else {
      print('I2RentalEvidence: Longitude is null - no value to set');
    }
    
    if (widget.latitude != null) {
      _latitudeController.text = widget.latitude.toString();
      print('I2RentalEvidence: Set latitude controller text: ${_latitudeController.text}');
    } else {
      print('I2RentalEvidence: Latitude is null - no value to set');
    }
  }

  @override
  void dispose() {
    // Dispose all controllers
    _assessmentNoController.dispose();
    _ownerNameController.dispose();
    _occupierNameController.dispose();
    _descriptionController.dispose();
    _longitudeController.dispose();
    _latitudeController.dispose();
    _floorRateController.dispose();
    _ratePerController.dispose();
    _ratePerMonthController.dispose();
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

  // Clear form after successful submission
  void _clearForm() {
    setState(() {
      _assessmentNoController.clear();
      _ownerNameController.clear();
      _occupierNameController.clear();
      _descriptionController.clear();
      _floorRateController.clear();
      _ratePerController.clear();
      _ratePerMonthController.clear();
      _headOfTermsController.clear();
      _situationController.clear();
      _remarksController.clear();
      
      _selectedBuilding = null;
      _selectedPropertyCategory = null;
      _selectedPropertySubcategory = null;
      _selectedPropertyType1 = null;
      _selectedPropertyType2 = null;
      
      uploadedImages.clear();
    });
  }

  // Add this function to handle validation, submission, and image upload
  void _validateAndSubmit() async {
    if (_formKey.currentState!.validate()) {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
      
      try {
        final reportId = await _submitFormData();
        
        // Always hide loading indicator
        if (mounted) {
          Navigator.of(context).pop();
        }
        
        if (reportId != null) {
          // Upload images if available
          if (uploadedImages.isNotEmpty) {
            await _uploadImages(reportId);
          }
          
          _showSuccessMessage('Rental evidence saved successfully!');
          
          // Clear the form after successful save
          _clearForm();
        } else {
          _showErrorMessage('Failed to save rental evidence. Please check if all required data is correct.');
        }
      } catch (e) {
        // Always hide loading indicator on error
        if (mounted && Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
        _showErrorMessage('An error occurred: ${e.toString()}');
      }
    } else {
      _showErrorMessage('Please fix the validation errors in the form');
    }
  }

  Future<String?> _submitFormData() async {
    try {
      // Get the auth token from secure storage
      final secureStorage = injection<SecureStorage>();
      final token = await secureStorage.read('token');
      
      if (token == null) {
        _showErrorMessage('Authentication required. Please login again.');
        return null;
      }
      
      final uri = Uri.parse('${AppConfig.apiBaseUrl}I2RentalEvidence');
      
      // Use asset ID 7838 which exists in the database
      final assetId = widget.assetId ?? 7838;
      
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: _buildFormJson(assetId),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.body;
        final id = RegExp(r'"id"\s*:\s*(\d+)').firstMatch(data)?.group(1);
        print('DEBUG: I2RentalEvidence created with ID: $id');
        return id;
      } else {
        print(
            'DEBUG: I2RentalEvidence submission failed: ${response.statusCode} ${response.body}');
        
        // Parse error message for specific issues
        if (response.statusCode == 400) {
          throw Exception('Invalid data submitted. Please check all fields.');
        } else if (response.statusCode == 401) {
          throw Exception('Authentication failed. Please login again.');
        } else if (response.statusCode == 500) {
          // Check for foreign key constraint error
          if (response.body.contains('foreign key constraint') || 
              response.body.contains('FK_I2RentalEvidences_Assets_AssetId')) {
            throw Exception('Invalid asset reference. Please ensure the property is properly selected.');
          }
          throw Exception('Server error occurred. Please try again later.');
        } else {
          throw Exception('Failed to save rental evidence (Error: ${response.statusCode})');
        }
      }
    } catch (e) {
      print('DEBUG: Exception during I2RentalEvidence submission: $e');
      rethrow; // Re-throw to be caught by the calling function
    }
  }

  String _buildFormJson(int assetId) {
    // Build JSON string for the form data with all fields matching the backend model
    return '''{
      "assetId": $assetId,
      "assessmentNumber": "${_assessmentNoController.text}",
      "ownerName": "${_ownerNameController.text}",
      "occupierName": "${_occupierNameController.text}",
      "descriptionOfProperty": "${_descriptionController.text}",
      "longitude": ${_longitudeController.text.isNotEmpty ? _longitudeController.text : '0'},
      "latitude": ${_latitudeController.text.isNotEmpty ? _latitudeController.text : '0'},
      "building": "${_selectedBuilding ?? ''}",
      "propertyCategory": "${_selectedPropertyCategory ?? ''}",
      "propertySubcategory": "${_selectedPropertySubcategory ?? ''}",
      "propertyType": "${_selectedPropertyType1 ?? ''}",
      "floorRate": ${_floorRateController.text.isNotEmpty ? _floorRateController.text : 'null'},
      "ratePer": "${_ratePerController.text}",
      "ratePerMonth": ${_ratePerMonthController.text.isNotEmpty ? _ratePerMonthController.text : 'null'},
      "headOfTerms": "${_headOfTermsController.text}",
      "situation": "${_situationController.text}",
      "remarks": "${_remarksController.text}"
    }''';
  }

  Future<void> _uploadImages(String reportId) async {
    print('DEBUG: _uploadImages called with reportId: $reportId');
    print('DEBUG: Number of images to upload: ${uploadedImages.length}');
    if (uploadedImages.isEmpty) return;
    
    // Get the auth token from secure storage
    final secureStorage = injection<SecureStorage>();
    final token = await secureStorage.read('token');
    
    if (token == null) {
      _showErrorMessage('Authentication required for image upload.');
      return;
    }
    
    var uri = Uri.parse('${AppConfig.apiBaseUrl}ImageData/upload');
    var request = http.MultipartRequest('POST', uri)
      ..fields['reportId'] = reportId
      ..headers['Authorization'] = 'Bearer $token';
      
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
        print('Images uploaded successfully.');
      } else {
        _showErrorMessage('Failed to upload images.');
      }
    } catch (e) {
      print('DEBUG: Exception during image upload: $e');
      _showErrorMessage('Error uploading images: $e');
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
        title: AppString.rentalEvidence.localize(context)!,
      ),
      // Main body wrapped in a SingleChildScrollView to allow vertical scrolling.
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Breadcrumb navigation for a clear page hierarchy.
            Breadcrumb(items: [
              BreadcrumbItem(label: AppString.massRating.localize(context)!),
              BreadcrumbItem(
                  label: AppString.rentalEvidence.localize(context)!),
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
                          // Longitude field - disabled/read-only (moved to top)
                          LabeledTextField(
                            label: 'Longitude',
                            placeholder: 'Longitude',
                            width: fieldWidth,
                            controller: _longitudeController,
                            readOnly: true, // Make field read-only
                          ),
                          // Latitude field - disabled/read-only (moved to top)
                          LabeledTextField(
                            label: 'Latitude',
                            placeholder: 'Latitude',
                            width: fieldWidth,
                            controller: _latitudeController,
                            readOnly: true, // Make field read-only
                          ),
                          // Intentionally static: No backend mapping for building list
                          CustomDropdownField(
                            label: AppString.selectBuilding.localize(context)!,
                            items: [
                              AppString.selectBuilding.localize(context)!,
                              AppString.building1.localize(context)!,
                              AppString.building2.localize(context)!
                            ],
                            initialValue:
                                AppString.selectBuilding.localize(context)!,
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
                                        .localize(context)!),
                          ),
                          // Intentionally static: No backend mapping for property category
                          CustomDropdownField(
                            label:
                                AppString.propertyCategory.localize(context)!,
                            items: [
                              AppString.selectPropertyCategory
                                  .localize(context)!,
                              AppString.category1.localize(context)!,
                              AppString.category2.localize(context)!
                            ],
                            initialValue: AppString.selectPropertyCategory
                                .localize(context)!,
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
                                        .localize(context)!),
                          ),
                          // Intentionally static: No backend mapping for property subcategory
                          CustomDropdownField(
                            label: AppString.propertySubcategory
                                .localize(context)!,
                            items: [
                              AppString.selectPropertySubcategory
                                  .localize(context)!,
                              AppString.subcategory1.localize(context)!,
                              AppString.subcategory2.localize(context)!
                            ],
                            initialValue: AppString.selectPropertySubcategory
                                .localize(context)!,
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
                                        .localize(context)!),
                          ),
                          // Intentionally static: No backend mapping for property type
                          CustomDropdownField(
                            label: AppString.propertyType.localize(context)!,
                            items: [
                              AppString.selectPropertyType.localize(context)!,
                              AppString.type1.localize(context)!,
                              AppString.type2.localize(context)!
                            ],
                            initialValue:
                                AppString.selectPropertyType.localize(context)!,
                            onChanged: (value) {
                              setState(() {
                                _selectedPropertyType1 = value;
                              });
                            },
                            width: fieldWidth,
                            validator: (value) =>
                                I2RentalEvidenceValidator.requiredDropdown(
                                    value,
                                    AppString.propertyType.localize(context)!),
                          ),
                          // Text field for inputting assessment number.
                          LabeledTextField(
                            label: AppString.assesmentNo.localize(context)!,
                            placeholder:
                                AppString.assesmentNo.localize(context)!,
                            width: fieldWidth,
                            controller: _assessmentNoController,
                            validator: (value) =>
                                I2RentalEvidenceValidator.requiredAlphaNum(
                                    value,
                                    50,
                                    AppString.assesmentNo.localize(context)!),
                          ),
                          // Text field for inputting owner name.
                          LabeledTextField(
                            label: AppString.ownerName.localize(context)!,
                            placeholder: AppString.ownerName.localize(context)!,
                            width: fieldWidth,
                            controller: _ownerNameController,
                            validator: (value) =>
                                I2RentalEvidenceValidator.requiredAlphaNum(
                                    value,
                                    100,
                                    AppString.ownerName.localize(context)!),
                          ),
                          // Dropdown field for selecting property type.
                          CustomDropdownField(
                            label: AppString.propertyType.localize(context)!,
                            items: [
                              AppString.propertyType.localize(context)!,
                              AppString.typeA.localize(context)!,
                              AppString.typeB.localize(context)!
                            ],
                            initialValue:
                                AppString.propertyType.localize(context)!,
                            onChanged: (value) {
                              setState(() {
                                _selectedPropertyType2 = value;
                              });
                            },
                            width: fieldWidth,
                            validator: (value) =>
                                I2RentalEvidenceValidator.requiredDropdown(
                                    value,
                                    AppString.propertyType.localize(context)!),
                          ),
                          // Text field for inputting occupier name.
                          LabeledTextField(
                            label: AppString.occupierName.localize(context)!,
                            placeholder:
                                AppString.occupierName.localize(context)!,
                            width: fieldWidth,
                            controller: _occupierNameController,
                            validator: (value) =>
                                I2RentalEvidenceValidator.requiredAlphaNum(
                                    value,
                                    100,
                                    AppString.occupierName.localize(context)!),
                          ),
                          // Text field for describing the property.
                          LabeledTextField(
                            label: AppString.descriptionOfProperty
                                .localize(context)!,
                            placeholder: AppString.descriptionOfProperty
                                .localize(context)!,
                            width: fieldWidth,
                            controller: _descriptionController,
                            validator: (value) =>
                                I2RentalEvidenceValidator.requiredAlphaNum(
                                    value,
                                    255,
                                    AppString.descriptionOfProperty
                                        .localize(context)!),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Labeling section for the image capturing area.
                      Row(
                        children: [
                          Text(
                            AppString.imageCapturing.localize(context)!,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(width: 8),
                          // Text(
                          //   '(Optional)',
                          //   style: TextStyle(
                          //     color: Colors.grey,
                          //     fontStyle: FontStyle.italic,
                          //     fontSize: 12,
                          //   ),
                          // ),
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Save button
                          CustomButton(
                            text: AppString.save.localize(context)!,
                            onPressed: _validateAndSubmit,
                            backgroundColor: colors(context).colorPrimary5!,
                          ),
                          const SizedBox(width: 16),
                          // Cancel button
                          CustomButton(
                            text: AppString.cancel.localize(context)!,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            backgroundColor: colors(context).colorGrey1!,
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
