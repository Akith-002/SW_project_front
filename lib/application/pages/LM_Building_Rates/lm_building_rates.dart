import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
import 'package:land_asset_valuation/application/pages/LM_Building_Rates/cubit/lm_building_rates_cubit.dart';
import 'package:land_asset_valuation/application/core/validators/lm_building_rates_validator.dart';
import 'package:land_asset_valuation/injection.dart';

/// LM Building Rates form page for collecting building valuation data
class LmBuildingRates extends BasePage {
  const LmBuildingRates({super.key});

  @override
  State<LmBuildingRates> createState() => _LmBuildingRatesState();
}

class _LmBuildingRatesState extends BasePageState<LmBuildingRates> {
  final _cubit = injection<LmBuildingRatesCubit>();

  // Form validation key
  final _formKey = GlobalKey<FormState>();

  // Auto-validation mode
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  // Master file data from navigation
  String? _masterFileNo;

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    _extractMasterFileData();
    _loadSavedDataIfExists(); // Try to load previously saved data
  }

  void _extractMasterFileData() {
    final GoRouterState state = GoRouterState.of(context);
    final queryParams = state.uri.queryParameters;
    _masterFileNo = queryParams['masterFileNo'];

    // Extract coordinates if available
    final latStr = queryParams['latitude'];
    final lngStr = queryParams['longitude'];

    if (latStr != null && lngStr != null) {
      _locationLatitudeController.text = latStr;
      _locationLongitudeController.text = lngStr;
      debugPrint(
          "LmBuildingRates: Auto-filled coordinates - Lat: $latStr, Lng: $lngStr");
    }

    debugPrint("LmBuildingRates: Extracted Master File No: $_masterFileNo");
  }

  /// Attempts to load previously saved data for this master file
  Future<void> _loadSavedDataIfExists() async {
    if (_masterFileNo == null) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final String key = 'lm_building_rates_$_masterFileNo';
      final String? savedDataJson = prefs.getString(key);

      if (savedDataJson != null) {
        final Map<String, dynamic> savedData = jsonDecode(savedDataJson);

        // Only load if controllers are empty (don't overwrite coordinates from URL)
        if (_assessmentNumberController.text.isEmpty) {
          _assessmentNumberController.text =
              savedData['assessmentNumber'] ?? '';
          _ownerController.text = savedData['owner'] ?? '';
          _constructedByController.text = savedData['constructedBy'] ?? '';
          _yearOfConstructionController.text =
              savedData['yearOfConstruction'] ?? '';
          _descriptionOfPropertyController.text =
              savedData['descriptionOfProperty'] ?? '';
          _floorAreaSQFTController.text = savedData['floorAreaSQFT'] ?? '';
          _ratePerSQFTController.text = savedData['ratePerSQFT'] ?? '';
          _costController.text = savedData['cost'] ?? '';
          _remarksController.text = savedData['remarks'] ?? '';

          // Only load coordinates if not already set from URL parameters
          if (_locationLatitudeController.text.isEmpty) {
            _locationLatitudeController.text =
                savedData['locationLatitude'] ?? '';
          }
          if (_locationLongitudeController.text.isEmpty) {
            _locationLongitudeController.text =
                savedData['locationLongitude'] ?? '';
          }

          debugPrint('LM Building Rates: Loaded previously saved data');
        }
      }
    } catch (e) {
      debugPrint('Error loading saved data: $e');
    }
  }

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
    return BlocProvider<LmBuildingRatesCubit>.value(
      value: _cubit,
      child: BlocConsumer<LmBuildingRatesCubit, dynamic>(
        listener: (context, state) {
          // Handle state changes if needed in the future
        },
        builder: (context, state) {
          return Scaffold(
            appBar: CustomAppBar(title: 'Building Rates'),
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
                            BreadcrumbItem(label: 'Land Miscellaneous'),
                            BreadcrumbItem(
                                label: _masterFileNo != null
                                    ? '${AppString.masterFile.localize(context) ?? 'Master File'} - #$_masterFileNo'
                                    : AppString.masterFile.localize(context) ??
                                        'Master File'),
                            BreadcrumbItem(label: 'LM Building Rates'),
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
                                            .localize(context) ??
                                        'Assessment Number',
                                    placeholder: AppString.assessmentNumber
                                            .localize(context) ??
                                        'Assessment Number',
                                    width: fieldWidth,
                                    controller: _assessmentNumberController,
                                    validator: (value) =>
                                        LmBuildingRatesValidator
                                            .requiredAssessmentNumber(
                                                value, 50, "Assessment Number"),
                                  ),
                                  LabeledTextField(
                                    label: AppString.owner.localize(context) ??
                                        'Owner',
                                    placeholder: AppString.nameOfTheOwner
                                            .localize(context) ??
                                        'Name of the Owner',
                                    width: fieldWidth,
                                    controller: _ownerController,
                                    validator: (value) =>
                                        LmBuildingRatesValidator.requiredOwner(
                                            value, 100, "Owner"),
                                  ),
                                  LabeledTextField(
                                    label: AppString.constructedBy
                                            .localize(context) ??
                                        'Constructed By',
                                    placeholder: AppString.constructedBy
                                            .localize(context) ??
                                        'Constructed By',
                                    width: fieldWidth,
                                    controller: _constructedByController,
                                    validator: (value) =>
                                        LmBuildingRatesValidator
                                            .requiredConstructedBy(
                                                value, 100, "Constructed By"),
                                  ),
                                  LabeledTextField(
                                    label: AppString.yearofConstruction
                                            .localize(context) ??
                                        'Year of Construction',
                                    placeholder: AppString.yearofConstruction
                                            .localize(context) ??
                                        'Year of Construction',
                                    width: fieldWidth,
                                    controller: _yearOfConstructionController,
                                    validator: (value) =>
                                        LmBuildingRatesValidator
                                            .requiredYearOfConstruction(
                                                value, "Year of Construction"),
                                  ),
                                  LabeledTextField(
                                    label: AppString.descriptionofProperty
                                            .localize(context) ??
                                        'Description of Property',
                                    placeholder: AppString.propertyDescription
                                            .localize(context) ??
                                        'Property Description',
                                    width: fieldWidth,
                                    controller:
                                        _descriptionOfPropertyController,
                                    validator: (value) =>
                                        LmBuildingRatesValidator
                                            .optionalDescription(value, 500,
                                                "Property Description"),
                                  ),
                                  LabeledTextField(
                                    label: AppString.floorAreaSQFT
                                            .localize(context) ??
                                        'Floor Area SQFT',
                                    placeholder: AppString.floorAreaSQFT
                                            .localize(context) ??
                                        'Floor Area SQFT',
                                    width: fieldWidth,
                                    controller: _floorAreaSQFTController,
                                    validator: (value) =>
                                        LmBuildingRatesValidator
                                            .requiredFloorArea(
                                                value, "Floor Area SQFT"),
                                  ),
                                  LabeledTextField(
                                    label: AppString.ratePerSQFT
                                            .localize(context) ??
                                        'Rate Per SQFT',
                                    placeholder: AppString.ratePerSQFT
                                            .localize(context) ??
                                        'Rate Per SQFT',
                                    width: fieldWidth,
                                    controller: _ratePerSQFTController,
                                    validator: (value) =>
                                        LmBuildingRatesValidator
                                            .requiredRatePerSQFT(
                                                value, "Rate Per SQFT"),
                                  ),
                                  LabeledTextField(
                                    label: AppString.cost.localize(context) ??
                                        'Cost',
                                    placeholder:
                                        AppString.cost.localize(context) ??
                                            'Cost',
                                    width: fieldWidth,
                                    controller: _costController,
                                    validator: (value) =>
                                        LmBuildingRatesValidator.requiredCost(
                                            value, "Cost"),
                                  ),
                                  LabeledTextField(
                                    label:
                                        AppString.remarks.localize(context) ??
                                            'Remarks',
                                    placeholder:
                                        AppString.remarks.localize(context) ??
                                            'Remarks',
                                    width: fieldWidth,
                                    controller: _remarksController,
                                    validator: (value) =>
                                        LmBuildingRatesValidator
                                            .optionalRemarks(
                                                value, 500, "Remarks"),
                                  ),
                                  LabeledTextField(
                                    label: AppString.locationLatitude
                                            .localize(context) ??
                                        'Location Latitude',
                                    placeholder: AppString.locationLatitude
                                            .localize(context) ??
                                        'Location Latitude',
                                    width: fieldWidth,
                                    controller: _locationLatitudeController,
                                    validator: (value) =>
                                        LmBuildingRatesValidator
                                            .optionalLocationLatitude(
                                                value, "Location Latitude"),
                                  ),
                                  LabeledTextField(
                                    label: AppString.locationLongitude
                                            .localize(context) ??
                                        'Location Longitude',
                                    placeholder: AppString.locationLongitude
                                            .localize(context) ??
                                        'Location Longitude',
                                    width: fieldWidth,
                                    controller: _locationLongitudeController,
                                    validator: (value) =>
                                        LmBuildingRatesValidator
                                            .optionalLocationLongitude(
                                                value, "Location Longitude"),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              // Image upload section
                              Text(
                                AppString.imageCapturing.localize(context) ??
                                    'Image Capturing and Upload',
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
                                    text: AppString.cancel.localize(context) ??
                                        'Cancel',
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    backgroundColor:
                                        colors(context).colorGrey1 ??
                                            Colors.grey.shade300,
                                  ),
                                  Spacer(),
                                  CustomButton(
                                    text: AppString.save.localize(context) ??
                                        'Save',
                                    onPressed: _validateAndSave,
                                    backgroundColor:
                                        colors(context).colorPrimary1 ??
                                            Colors.blue,
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
        },
      ),
    );
  }

  /// Validates form and saves data locally
  void _validateAndSave() async {
    // Enable auto-validation mode to show validation errors
    setState(() {
      _autovalidateMode = AutovalidateMode.onUserInteraction;
    });

    // Validate the form
    bool isFormValid = _formKey.currentState?.validate() ?? false;

    if (isFormValid) {
      try {
        // Create data map for local storage
        final formData = {
          'assessmentNumber': _assessmentNumberController.text.trim(),
          'owner': _ownerController.text.trim(),
          'constructedBy': _constructedByController.text.trim(),
          'yearOfConstruction': _yearOfConstructionController.text.trim(),
          'descriptionOfProperty': _descriptionOfPropertyController.text.trim(),
          'floorAreaSQFT': _floorAreaSQFTController.text.trim(),
          'ratePerSQFT': _ratePerSQFTController.text.trim(),
          'cost': _costController.text.trim(),
          'remarks': _remarksController.text.trim(),
          'locationLatitude': _locationLatitudeController.text.trim(),
          'locationLongitude': _locationLongitudeController.text.trim(),
        };

        // Save data locally
        await _saveDataLocally(formData);
        _showSuccessMessage('Building rates data saved locally successfully');
      } catch (e) {
        debugPrint('Error saving data locally: $e');
        _showErrorMessage('Failed to save data locally. Please try again.');
      }
    } else {
      _showErrorMessage('Please fix the validation errors in the form');
    }
  }

  /// Saves the form data to local storage
  Future<void> _saveDataLocally(Map<String, String> data) async {
    final prefs = await SharedPreferences.getInstance();

    // Create a map with form data and metadata
    final localData = {
      'masterFileNo': _masterFileNo,
      ...data, // Spread the form data
      'savedAt': DateTime.now().toIso8601String(),
      'imageCount': uploadedImages.length,
    };

    // Convert to JSON string
    final jsonString = jsonEncode(localData);

    // Generate a unique key for this entry
    final String key =
        'lm_building_rates_${_masterFileNo ?? DateTime.now().millisecondsSinceEpoch}';

    // Save to SharedPreferences
    await prefs.setString(key, jsonString);

    debugPrint('LM Building Rates data saved locally with key: $key');
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

  /// Shows success dialog when form is submitted successfully
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: const Text(
            'LM Building Rates data has been submitted successfully!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Shows error message as snackbar
  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
      ),
    );
  }

  @override
  BaseCubit<BaseState> getCubit() {
    return _cubit;
  }
}
