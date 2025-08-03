import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
import 'package:land_asset_valuation/application/pages/LA_Sales_Evidence/cubit/la_sales_evidence_state.dart';
import 'package:land_asset_valuation/application/core/validators/la_sales_evidence_validator.dart';
import 'package:land_asset_valuation/application/core/widgets/data_send_successfully_dialogbox.dart';
import 'package:land_asset_valuation/data/models/la_sales_evidence_model.dart';
import 'package:land_asset_valuation/injection.dart';

/// Sales Evidence form screen for Land Acquisition module
/// Allows users to input and manage land sales evidence data
class LaSalesEvidence extends BasePage {
  const LaSalesEvidence({super.key});

  @override
  State<LaSalesEvidence> createState() => _LaSalesEvidenceState();
}

class _LaSalesEvidenceState extends BasePageState<LaSalesEvidence> {
  final _cubit = injection<LaSalesEvidenceCubit>();

  // Form validation key
  final _formKey = GlobalKey<FormState>();

  // Auto-validation mode
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

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

  // Master file data from query parameters
  String? _masterFileId;
  String? _masterFileRefNo;
  double? _initialLatitude;
  double? _initialLongitude;

  @override
  void initState() {
    super.initState();
    // Schedule the data extraction for the next frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _extractMasterFileData();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _extractMasterFileData();
  }

  void _extractMasterFileData() {
    final GoRouterState state = GoRouterState.of(context);
    final queryParams = state.uri.queryParameters;

    // Debug: Print all available query parameters
    debugPrint("SalesEvidence: All query parameters: $queryParams");

    // Try multiple possible parameter names for master file ID
    _masterFileId = queryParams['masterFileId'] ??
        queryParams['id'] ??
        queryParams['masterfile_id'];

    // Try multiple possible parameter names for master file reference
    _masterFileRefNo = queryParams['masterFileRefNo'] ??
        queryParams['masterFileNo'] ??
        queryParams['master_file_ref_no'] ??
        queryParams['masterfile_ref_no'];

    // Debug: Print extracted values
    debugPrint("SalesEvidence: Extracted masterFileId: $_masterFileId");
    debugPrint("SalesEvidence: Extracted masterFileRefNo: $_masterFileRefNo");

    // Pre-fill form fields with data from query parameters
    if (_masterFileRefNo != null && _masterFileRefNo!.isNotEmpty) {
      _masterFileRefController.text = _masterFileRefNo!;
      debugPrint(
          "SalesEvidence: Set controller text to: ${_masterFileRefController.text}");
    } else {
      debugPrint("SalesEvidence: Master file ref no is null or empty");
      // Try fallback - use masterFileNo if masterFileRefNo is not available
      final fallbackRefNo = queryParams['masterFileNo'];
      if (fallbackRefNo != null && fallbackRefNo.isNotEmpty) {
        _masterFileRefController.text = fallbackRefNo;
        _masterFileRefNo = fallbackRefNo;
        debugPrint("SalesEvidence: Used fallback masterFileNo: $fallbackRefNo");
      }
    }

    // Set initial coordinates if provided
    final latitudeStr = queryParams['latitude'];
    final longitudeStr = queryParams['longitude'];
    if (latitudeStr != null && longitudeStr != null) {
      _initialLatitude = double.tryParse(latitudeStr);
      _initialLongitude = double.tryParse(longitudeStr);
      if (_initialLatitude != null && _initialLongitude != null) {
        _locationLatitudeController.text = latitudeStr;
        _locationLongitudeController.text = longitudeStr;
      }
    }

    // Always trigger rebuild after extracting data
    if (mounted) {
      setState(() {});
    }

    debugPrint(
        "SalesEvidence: Final extracted data - ID: $_masterFileId, Ref: $_masterFileRefNo, Coords: ($_initialLatitude, $_initialLongitude)");
  }

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
    return BlocProvider<LaSalesEvidenceCubit>.value(
      value: _cubit,
      child: BlocConsumer<LaSalesEvidenceCubit, dynamic>(
        listener: (context, state) {
          if (state is LaSalesEvidenceSubmitSuccess) {
            _showSuccessDialog();
          } else if (state is LaSalesEvidenceSubmitFailure) {
            _showErrorMessage(state.errorMessage);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: CustomAppBar(
                title: AppString.salesEvidencesForm.localize(context)!),
            body: LayoutBuilder(
              builder: (context, constraints) {
                // Calculate the width for form fields based on available screen width
                double fieldWidth = constraints.maxWidth * 0.47;

                return Form(
                  key: _formKey,
                  autovalidateMode: _autovalidateMode,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
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
                                label: AppString.salesEvidences
                                    .localize(context)!),
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
                                    label: AppString.assetNumber
                                        .localize(context)!,
                                    placeholder: AppString.assetNumber
                                        .localize(context)!,
                                    width: fieldWidth,
                                    controller: _assetNumberController,
                                    validator: (value) =>
                                        LaSalesEvidenceValidator
                                            .requiredAlphaNum(
                                                value, 50, "Asset Number"),
                                  ),
                                  // Master File Reference - Read-only field
                                  SizedBox(
                                    width: fieldWidth,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppString.masterFilerefno
                                              .localize(context)!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black87,
                                              ),
                                        ),
                                        const SizedBox(height: 8),
                                        ValueListenableBuilder<
                                            TextEditingValue>(
                                          valueListenable:
                                              _masterFileRefController,
                                          builder: (context, value, child) {
                                            return Container(
                                              width: double.infinity,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 16),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: colors(context)
                                                        .colorGrey3!),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: colors(context)
                                                    .colorGrey1!
                                                    .withOpacity(0.3),
                                              ),
                                              child: Text(
                                                value.text.isEmpty
                                                    ? AppString.masterFilerefno
                                                        .localize(context)!
                                                    : value.text,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      color: value.text.isEmpty
                                                          ? colors(context)
                                                              .colorGrey4
                                                          : Colors.black87,
                                                    ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  LabeledTextField(
                                    label:
                                        AppString.roadName.localize(context)!,
                                    placeholder:
                                        AppString.owner.localize(context)!,
                                    width: fieldWidth,
                                    controller: _roadNameController,
                                    validator: (value) =>
                                        LaSalesEvidenceValidator
                                            .optionalAlphaNum(
                                                value, 100, "Road Name"),
                                  ),
                                  LabeledTextField(
                                    label: AppString.village.localize(context)!,
                                    placeholder:
                                        AppString.occupier.localize(context)!,
                                    width: fieldWidth,
                                    controller: _villageController,
                                    validator: (value) =>
                                        LaSalesEvidenceValidator
                                            .optionalAlphaNum(
                                                value, 100, "Village"),
                                  ),
                                  LabeledTextField(
                                    label: AppString.vendor.localize(context)!,
                                    placeholder:
                                        AppString.situation.localize(context)!,
                                    width: fieldWidth,
                                    controller: _vendorController,
                                    validator: (value) =>
                                        LaSalesEvidenceValidator
                                            .requiredAlphaNum(
                                                value, 100, "Vendor"),
                                  ),
                                  LabeledTextField(
                                    label:
                                        AppString.deedNumber.localize(context)!,
                                    placeholder:
                                        AppString.floorRate.localize(context)!,
                                    width: fieldWidth,
                                    controller: _deedNumberController,
                                    validator: (value) =>
                                        LaSalesEvidenceValidator
                                            .requiredDeedNumber(
                                                value, "Deed Number"),
                                  ),
                                  LabeledTextField(
                                    label: AppString.deedAttestedNumber
                                        .localize(context)!,
                                    placeholder: AppString.deedAttestedNumber
                                        .localize(context)!,
                                    width: fieldWidth,
                                    controller: _deedAttestedNumberController,
                                    validator: (value) =>
                                        LaSalesEvidenceValidator
                                            .optionalDeedNumber(value, 50,
                                                "Deed Attested Number"),
                                  ),
                                  LabeledTextField(
                                    label:
                                        AppString.notaryName.localize(context)!,
                                    placeholder:
                                        AppString.notaryName.localize(context)!,
                                    width: fieldWidth,
                                    controller: _notaryNameController,
                                    validator: (value) =>
                                        LaSalesEvidenceValidator
                                            .requiredAlphaNum(
                                                value, 100, "Notary Name"),
                                  ),
                                  LabeledTextField(
                                    label:
                                        AppString.lotNumber.localize(context)!,
                                    placeholder: AppString.noofLotNumbergiven
                                        .localize(context)!,
                                    width: fieldWidth,
                                    controller: _lotNumberController,
                                    validator: (value) =>
                                        LaSalesEvidenceValidator
                                            .optionalAlphaNum(
                                                value, 50, "Lot Number"),
                                  ),
                                  LabeledTextField(
                                    label:
                                        AppString.planNumber.localize(context)!,
                                    placeholder:
                                        AppString.planNumber.localize(context)!,
                                    width: fieldWidth,
                                    controller: _planNumberController,
                                    validator: (value) =>
                                        LaSalesEvidenceValidator
                                            .optionalAlphaNum(
                                                value, 50, "Plan Number"),
                                  ),
                                  LabeledTextField(
                                    label:
                                        AppString.planDate.localize(context)!,
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
                                    placeholder:
                                        AppString.extent.localize(context)!,
                                    width: fieldWidth,
                                    controller: _extentController,
                                    validator: (value) =>
                                        LaSalesEvidenceValidator
                                            .optionalNumeric(
                                                value, 20, "Extent"),
                                  ),
                                  LabeledTextField(
                                    label: AppString.consideration
                                        .localize(context)!,
                                    placeholder: AppString.consideration
                                        .localize(context)!,
                                    width: fieldWidth,
                                    controller: _considerationController,
                                    validator: (value) =>
                                        LaSalesEvidenceValidator
                                            .requiredNumeric(
                                                value, 20, "Consideration"),
                                  ),
                                  LabeledTextField(
                                    label: AppString.remarks.localize(context)!,
                                    placeholder:
                                        AppString.remarks.localize(context)!,
                                    width: fieldWidth,
                                    controller: _remarksController,
                                    validator: (value) =>
                                        LaSalesEvidenceValidator
                                            .optionalAlphaNum(
                                                value, 500, "Remarks"),
                                  ),
                                  LabeledTextField(
                                    label: AppString.rate.localize(context)!,
                                    placeholder:
                                        AppString.rate.localize(context)!,
                                    width: fieldWidth,
                                    controller: _rateController,
                                    validator: (value) =>
                                        LaSalesEvidenceValidator
                                            .requiredNumeric(value, 20, "Rate"),
                                  ),
                                  LabeledTextField(
                                    label:
                                        AppString.rateType.localize(context)!,
                                    placeholder:
                                        AppString.rateType.localize(context)!,
                                    width: fieldWidth,
                                    controller: _rateTypeController,
                                    validator: (value) =>
                                        LaSalesEvidenceValidator
                                            .optionalAlphaNum(
                                                value, 50, "Rate Type"),
                                  ),
                                  LabeledTextField(
                                    label: AppString.locationLongitude
                                        .localize(context)!,
                                    placeholder: AppString.locationLongitude
                                        .localize(context)!,
                                    width: fieldWidth,
                                    controller: _locationLongitudeController,
                                    validator: (value) =>
                                        LaSalesEvidenceValidator
                                            .optionalCoordinate(
                                                value, "Location Longitude"),
                                  ),
                                  LabeledTextField(
                                    label: AppString.locationLatitude
                                        .localize(context)!,
                                    placeholder: AppString.locationLatitude
                                        .localize(context)!,
                                    width: fieldWidth,
                                    controller: _locationLatitudeController,
                                    validator: (value) =>
                                        LaSalesEvidenceValidator
                                            .optionalCoordinate(
                                                value, "Location Latitude"),
                                  ),
                                  LabeledTextField(
                                    label: AppString.landRegistryReferences
                                        .localize(context)!,
                                    placeholder: AppString
                                        .landRegistryReferences
                                        .localize(context)!,
                                    width: fieldWidth,
                                    controller:
                                        _landRegistryReferencesController,
                                    validator: (value) =>
                                        LaSalesEvidenceValidator
                                            .optionalAlphaNum(value, 200,
                                                "Land Registry References"),
                                  ),
                                  LabeledTextField(
                                    label:
                                        AppString.situation.localize(context)!,
                                    placeholder:
                                        AppString.situation.localize(context)!,
                                    width: fieldWidth,
                                    controller: _situationController,
                                    validator: (value) =>
                                        LaSalesEvidenceValidator
                                            .optionalAlphaNum(
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
                                        LaSalesEvidenceValidator
                                            .optionalAlphaNum(value, 500,
                                                "Description of Land"),
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
                                        imagePath:
                                            image is String ? image : null,
                                        onDelete: () => _deleteImage(index),
                                        size: 128,
                                      );
                                    },
                                  ),
                                  // Upload button for adding new images
                                  ImageUpload(
                                    isUploadButton: true,
                                    onImagePicked: _onImagePicked,
                                    onDelete:
                                        () {}, // Not used for upload button
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
                                    backgroundColor:
                                        colors(context).colorGrey1!,
                                  ),
                                  const Spacer(),
                                  CustomButton(
                                    text: AppString.save.localize(context)!,
                                    onPressed: _validateAndSave,
                                    backgroundColor:
                                        colors(context).colorPrimary1!,
                                  ),
                                  const SizedBox(width: 40),
                                  CustomButton(
                                    text: AppString.sendData.localize(context)!,
                                    onPressed: state is LaSalesEvidenceLoading
                                        ? null
                                        : _validateAndSubmit,
                                    backgroundColor:
                                        colors(context).colorPrimary5!,
                                  ),
                                ],
                              ),
                              // Show loading indicator when submitting
                              if (state is LaSalesEvidenceLoading)
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
                        ),
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

  /// Validates and saves the form
  void _validateAndSave() {
    // Enable auto-validation mode to show validation errors
    setState(() {
      _autovalidateMode = AutovalidateMode.onUserInteraction;
    });

    // Validate the form
    bool isFormValid = _formKey.currentState?.validate() ?? false;

    if (isFormValid) {
      // Form is valid, save the data
      _showSuccessMessage('Sales evidence data saved successfully');
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

    // Validate the form using the validators
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
      _validateRequiredField(
          _assetNumberController.text, 'Asset Number', validationErrors);
      _validateRequiredField(_masterFileRefController.text,
          'Master File Reference', validationErrors);

      // Additional validation for master file reference (since it's read-only, it should always be filled from query params)
      if (_masterFileRefController.text.trim().isEmpty) {
        validationErrors['Master File Reference'] =
            'Master file reference is required but not provided from navigation';
      }

      _validateRequiredField(
          _vendorController.text, 'Vendor', validationErrors);
      _validateRequiredField(
          _deedNumberController.text, 'Deed Number', validationErrors);
      _validateRequiredField(
          _notaryNameController.text, 'Notary Name', validationErrors);
      _validateRequiredField(
          _considerationController.text, 'Consideration', validationErrors);
      _validateRequiredField(_rateController.text, 'Rate', validationErrors);

      // Validate numeric fields
      _validateNumericField(
          _considerationController.text, 'Consideration', validationErrors);
      _validateNumericField(_rateController.text, 'Rate', validationErrors);

      // Validate optional numeric fields if provided
      if (_extentController.text.trim().isNotEmpty) {
        _validateNumericField(
            _extentController.text, 'Extent', validationErrors);
      }

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
        // Ensure required numeric fields are valid
        double.parse(_considerationController.text);
        double.parse(_rateController.text);

        // Parse optional numeric fields if provided
        if (_extentController.text.trim().isNotEmpty) {
          double.parse(_extentController.text);
        }

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
      final salesEvidenceModel = LaSalesEvidenceModel(
        masterFileId: _masterFileId ?? '',
        assetNumber: _assetNumberController.text.trim(),
        masterFileRef: _masterFileRefController.text.trim(),
        roadName: _roadNameController.text.trim(),
        village: _villageController.text.trim(),
        vendor: _vendorController.text.trim(),
        deedNumber: _deedNumberController.text.trim(),
        deedAttestedNumber: _deedAttestedNumberController.text.trim(),
        notaryName: _notaryNameController.text.trim(),
        lotNumber: _lotNumberController.text.trim(),
        planNumber: _planNumberController.text.trim(),
        planDate: _planDateController.text.trim(),
        extent: _extentController.text.trim(),
        consideration: _considerationController.text.trim(),
        remarks: _remarksController.text.trim(),
        rate: _rateController.text.trim(),
        rateType: _rateTypeController.text.trim(),
        locationLongitude: _locationLongitudeController.text.trim(),
        locationLatitude: _locationLatitudeController.text.trim(),
        landRegistryReferences: _landRegistryReferencesController.text.trim(),
        situation: _situationController.text.trim(),
        descriptionOfLand: _descriptionOfLandController.text.trim(),
      );

      // Send data using cubit
      await _cubit.sendLaSalesEvidence(salesEvidenceModel);

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
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text(message),
    //     backgroundColor: Colors.green,
    //     duration: const Duration(seconds: 3),
    //   ),
    // );
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
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text(message),
    //     backgroundColor: Colors.red,
    //     duration: const Duration(seconds: 3),
    //   ),
    // );
  }

  /// Validates that required fields are not empty
  void _validateRequiredField(
      String value, String fieldName, Map<String, String> errors) {
    if (value.trim().isEmpty) {
      errors[fieldName] = 'Cannot be empty';
    }
  }

  /// Validates numeric field
  void _validateNumericField(
      String value, String fieldName, Map<String, String> errors) {
    if (value.trim().isEmpty) {
      errors[fieldName] = 'Cannot be empty';
      return;
    }

    double? numericValue = double.tryParse(value);
    if (numericValue == null) {
      errors[fieldName] = 'Must be a valid number';
      return;
    }

    if (numericValue < 0) {
      errors[fieldName] = 'Cannot be negative';
      return;
    }

    // Check for reasonableness based on field type
    if (fieldName.toLowerCase().contains('consideration') &&
        numericValue > 1000000000) {
      errors[fieldName] = 'Value seems too high, please verify';
    } else if (fieldName.toLowerCase().contains('rate') &&
        numericValue > 1000000) {
      errors[fieldName] = 'Rate seems too high, please verify';
    } else if (fieldName.toLowerCase().contains('extent') &&
        numericValue > 10000) {
      errors[fieldName] = 'Extent seems too large, please verify';
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
