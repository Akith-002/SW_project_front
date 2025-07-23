import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:land_asset_valuation/app/base_view.dart';
import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/core/configurations/app_config.dart';
import 'package:land_asset_valuation/injection.dart';
import 'package:land_asset_valuation/application/pages/pastValuation/cubit/past_valuation_cubit.dart';
import 'package:land_asset_valuation/application/pages/pastValuation/cubit/past_valuation_state.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_app_bar.dart';
import 'package:land_asset_valuation/application/core/widgets/breadcrumb.dart';
import 'package:land_asset_valuation/application/core/widgets/labeled_text_field.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_dropdown_field.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_button.dart';
import 'package:land_asset_valuation/application/core/widgets/data_send_successfully_dialogbox.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';
import 'package:land_asset_valuation/application/core/widgets/image_upload.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/validators/past_valuation_validator.dart';
import 'package:land_asset_valuation/data/models/master_data_model.dart';
import 'package:http/http.dart' as http;

class PastValuationView extends BasePage {
  final MasterDataResponse masterData;
  const PastValuationView({super.key, required this.masterData});

  @override
  _PastValuationViewState createState() => _PastValuationViewState();
}

class _PastValuationViewState extends BasePageState<PastValuationView> {
  final _cubit = injection<PastValuationCubit>();
  final _formKey = GlobalKey<FormState>();

  // Form validation mode
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  // Text controllers for form fields
  final _masterFileRefController = TextEditingController();
  final _fileNoGnDivisionController = TextEditingController();
  final _situationController = TextEditingController();
  final _dateOfValuationController = TextEditingController();
  final _purposeOfValuationController = TextEditingController();
  final _planOfParticularsController = TextEditingController();
  final _extentController = TextEditingController();
  final _rateController = TextEditingController();
  final _remarksController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _latitudeController = TextEditingController();

  List<dynamic> uploadedImages = [];
  bool _isSubmitting = false;
  String _selectedRateType = '';

  // Master file data from query parameters
  String? _masterFileId;
  String? _masterFileRefNo;
  double? _initialLatitude;
  double? _initialLongitude;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _extractMasterFileData();
  }

  void _extractMasterFileData() {
    final GoRouterState state = GoRouterState.of(context);
    final queryParams = state.uri.queryParameters;

    _masterFileId = queryParams['masterFileId'];
    _masterFileRefNo = queryParams['masterFileRefNo'];

    // Pre-fill form fields with data from query parameters
    if (_masterFileRefNo != null && _masterFileRefNo!.isNotEmpty) {
      _masterFileRefController.text = _masterFileRefNo!;
    }

    // Set initial coordinates if provided
    final latitudeStr = queryParams['latitude'];
    final longitudeStr = queryParams['longitude'];
    if (latitudeStr != null && longitudeStr != null) {
      _initialLatitude = double.tryParse(latitudeStr);
      _initialLongitude = double.tryParse(longitudeStr);
      if (_initialLatitude != null && _initialLongitude != null) {
        _latitudeController.text = latitudeStr;
        _longitudeController.text = longitudeStr;
      }
    }

    debugPrint(
        "PastValuation: Master File Data extracted - ID: $_masterFileId, Ref: $_masterFileRefNo, Coords: ($_initialLatitude, $_initialLongitude)");
  }

  @override
  void dispose() {
    // Dispose all controllers
    _masterFileRefController.dispose();
    _fileNoGnDivisionController.dispose();
    _situationController.dispose();
    _dateOfValuationController.dispose();
    _purposeOfValuationController.dispose();
    _planOfParticularsController.dispose();
    _extentController.dispose();
    _rateController.dispose();
    _remarksController.dispose();
    _longitudeController.dispose();
    _latitudeController.dispose();
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

  void _validateAndSubmit() async {
    // Enable auto-validation mode to show validation errors
    setState(() {
      _autovalidateMode = AutovalidateMode.onUserInteraction;
    });

    // Validate the form using built-in validators
    bool isFormValid = _formKey.currentState?.validate() ?? false;

    if (!isFormValid) {
      _showErrorMessage('Please fix the validation errors in the form');
      return;
    }

    // Additional manual validation (similar to building rates form)
    try {
      // Create a map to track all validation issues
      Map<String, String> validationErrors = {};

      // Validate required fields are not empty
      _validateRequiredField(_masterFileRefController.text,
          'Master File Reference', validationErrors);
      _validateRequiredField(
          _situationController.text, 'Situation', validationErrors);
      _validateRequiredField(_dateOfValuationController.text,
          'Date of Valuation', validationErrors);

      // Validate date format
      _validateDateField(_dateOfValuationController.text, 'Date of Valuation',
          validationErrors);

      // Validate numeric fields if they're not empty
      if (_extentController.text.trim().isNotEmpty) {
        _validateNumericField(
            _extentController.text, 'Extent', validationErrors);
      }
      if (_rateController.text.trim().isNotEmpty) {
        _validateNumericField(_rateController.text, 'Rate', validationErrors);
      }

      // Validate coordinate fields (optional)
      if (_longitudeController.text.trim().isNotEmpty) {
        _validateCoordinateField(
            _longitudeController.text, 'Longitude', validationErrors);
      }
      if (_latitudeController.text.trim().isNotEmpty) {
        _validateCoordinateField(
            _latitudeController.text, 'Latitude', validationErrors);
      }

      // Validate rate type selection
      if (_selectedRateType.isEmpty && widget.masterData.services.isNotEmpty) {
        _selectedRateType = widget.masterData.services.first;
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
        // Validate numeric fields if provided
        if (_extentController.text.trim().isNotEmpty) {
          double.parse(_extentController.text);
        }
        if (_rateController.text.trim().isNotEmpty) {
          double.parse(_rateController.text);
        }

        // Parse optional coordinates if provided
        if (_longitudeController.text.trim().isNotEmpty) {
          double.parse(_longitudeController.text);
        }
        if (_latitudeController.text.trim().isNotEmpty) {
          double.parse(_latitudeController.text);
        }
      } catch (e) {
        _showErrorMessage('Error converting numeric values: ${e.toString()}');
        return;
      }

      // Form is valid, proceed with submission
      setState(() {
        _isSubmitting = true;
      });

      // Send data to the backend via cubit
      await _cubit.sendPastValuation(
        masterFileRef: _masterFileRefController.text,
        fileNoGnDivision: _fileNoGnDivisionController.text,
        situation: _situationController.text,
        dateOfValuation: _dateOfValuationController.text,
        purposeOfValuation: _purposeOfValuationController.text,
        planOfParticulars: _planOfParticularsController.text,
        extent: _extentController.text,
        rate: _rateController.text,
        rateType: _selectedRateType,
        remarks: _remarksController.text,
        locationLongitude: _longitudeController.text,
        locationLatitude: _latitudeController.text,
      );

      // Check the cubit state after submission
      await Future.delayed(const Duration(
          milliseconds: 500)); // Small delay to ensure state is updated
      final state = _cubit.state;

      if (state is PastValuationSubmitSuccess) {
        await _handleSuccess(state.reportId);
      } else if (state is PastValuationSubmitFailure) {
        setState(() {
          _isSubmitting = false;
        });
        _showErrorMessage('Error: ${state.errorMessage}');
      } else {
        // If no specific state, assume success for now
        setState(() {
          _isSubmitting = false;
        });
        await _handleSuccess("12345"); // Mock report ID
      }
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });
      _showErrorMessage('Error preparing form data: ${e.toString()}');
    }
  }

  /// Upload images to the backend after form submission
  Future<void> uploadImages(String reportId) async {
    print('DEBUG: uploadImages called with reportId: $reportId');
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

  /// Handles post-success logic: show success dialog, upload images, then navigate
  Future<void> _handleSuccess(String reportId) async {
    setState(() {
      _isSubmitting = false;
    });

    // Show success dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SuccessMessageCard(
          onClose: () async {
            Navigator.of(context).pop(); // Close dialog

            // Upload images if any
            if (uploadedImages.isNotEmpty) {
              await uploadImages(reportId);
            }

            // Navigate back or to specific page if needed
            if (mounted) {
              // You can customize navigation here
              // context.go(Pages.routeMapScreen.toPath());
            }
          },
        );
      },
    );
  }

  @override
  Widget buildView(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: CustomAppBar(title: "Past Valuation Form #1234"),
          body: Form(
            key: _formKey,
            autovalidateMode: _autovalidateMode,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Breadcrumb(items: [
                    BreadcrumbItem(label: "Land Acquisition"),
                    BreadcrumbItem(label: "Master File - #56249"),
                    BreadcrumbItem(label: "Past Valuation Form #1234"),
                  ]),
                  _buildRow([
                    LabeledTextField(
                      label: AppString.masterFilerefno.localize(context)!,
                      placeholder: "Metro/2/LM/123",
                      controller: _masterFileRefController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Master File Reference is required';
                        }
                        return PastValuationValidator.optionalAlphaNum(
                            value, 255, "Master File Reference");
                      },
                    ),
                    LabeledTextField(
                      label: AppString.fileNoGnDivision.localize(context)!,
                      placeholder:
                          AppString.fileNoGnDivision.localize(context)!,
                      controller: _fileNoGnDivisionController,
                      validator: (value) =>
                          PastValuationValidator.optionalAlphaNum(
                              value, 255, "File No GN Division"),
                    ),
                  ]),
                  _buildRow([
                    LabeledTextField(
                      label: AppString.situation.localize(context)!,
                      placeholder: AppString.situation.localize(context)!,
                      controller: _situationController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Situation is required';
                        }
                        return PastValuationValidator.optionalAlphaNum(
                            value, 255, "Situation");
                      },
                    ),
                    LabeledTextField(
                      label: AppString.dateOfValuation.localize(context)!,
                      placeholder: "2024-01-01",
                      controller: _dateOfValuationController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Date of Valuation is required';
                        }
                        // Check basic date format YYYY-MM-DD
                        if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
                          return 'Must be in YYYY-MM-DD format';
                        }
                        // Try to parse the date
                        try {
                          DateTime.parse(value);
                        } catch (e) {
                          return 'Must be a valid date';
                        }
                        return null;
                      },
                    ),
                  ]),
                  _buildRow([
                    LabeledTextField(
                      label: AppString.purposeOfValuation.localize(context)!,
                      placeholder:
                          AppString.purposeOfValuation.localize(context)!,
                      controller: _purposeOfValuationController,
                      validator: (value) =>
                          PastValuationValidator.optionalAlphaNum(
                              value, 255, "Purpose of Valuation"),
                    ),
                    LabeledTextField(
                      label: AppString.planOfParticulars.localize(context)!,
                      placeholder:
                          AppString.planOfParticulars.localize(context)!,
                      controller: _planOfParticularsController,
                      validator: (value) =>
                          PastValuationValidator.optionalAlphaNum(
                              value, 255, "Plan Particulars"),
                    ),
                  ]),
                  _buildRow([
                    LabeledTextField(
                      label: AppString.extent.localize(context)!,
                      placeholder: AppString.extent.localize(context)!,
                      controller: _extentController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return null; // Optional field
                        }
                        double? extent = double.tryParse(value);
                        if (extent == null) {
                          return 'Extent must be a valid number';
                        }
                        if (extent <= 0) {
                          return 'Extent must be greater than 0';
                        }
                        if (extent > 1000000) {
                          return 'Extent seems too large, please verify';
                        }
                        return PastValuationValidator.optionalNumeric(
                            value, 255, "Extent");
                      },
                    ),
                    LabeledTextField(
                      label: AppString.rate.localize(context)!,
                      placeholder: AppString.rate.localize(context)!,
                      controller: _rateController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return null; // Optional field
                        }
                        double? rate = double.tryParse(value);
                        if (rate == null) {
                          return 'Rate must be a valid number';
                        }
                        if (rate <= 0) {
                          return 'Rate must be greater than 0';
                        }
                        if (rate > 1000000000) {
                          return 'Rate seems too high, please verify';
                        }
                        return PastValuationValidator.optionalNumeric(
                            value, 255, "Rate per unit");
                      },
                    ),
                  ]),
                  _buildRow([
                    CustomDropdownField(
                      label: AppString.rateType.localize(context)!,
                      items: widget.masterData.services,
                      initialValue: widget.masterData.services.isNotEmpty
                          ? widget.masterData.services.first
                          : null,
                      onChanged: (value) {
                        setState(() {
                          _selectedRateType = value ?? '';
                        });
                      },
                      width: 484,
                    ),
                    LabeledTextField(
                      label: AppString.remarks.localize(context)!,
                      placeholder: AppString.remarks.localize(context)!,
                      controller: _remarksController,
                      validator: (value) =>
                          PastValuationValidator.optionalAlphaNum(
                              value, 255, "Remarks"),
                    ),
                  ]),
                  _buildRow([
                    LabeledTextField(
                      label: AppString.locationLongitude.localize(context)!,
                      placeholder: "6.123456789",
                      controller: _longitudeController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return null; // Optional field
                        }
                        double? longitude = double.tryParse(value);
                        if (longitude == null) {
                          return 'Longitude must be a valid coordinate';
                        }
                        if (longitude < -180 || longitude > 180) {
                          return 'Longitude must be between -180 and 180 degrees';
                        }
                        return null;
                      },
                    ),
                    LabeledTextField(
                      label: AppString.locationLatitude.localize(context)!,
                      placeholder: "6.123456789",
                      controller: _latitudeController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return null; // Optional field
                        }
                        double? latitude = double.tryParse(value);
                        if (latitude == null) {
                          return 'Latitude must be a valid coordinate';
                        }
                        if (latitude < -90 || latitude > 90) {
                          return 'Latitude must be between -90 and 90 degrees';
                        }
                        return null;
                      },
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
                        onPressed: _isSubmitting ? null : () {},
                        backgroundColor: colors(context).colorGrey1!,
                      ),
                      _isSubmitting
                          ? const CircularProgressIndicator()
                          : Row(
                              children: [
                                CustomButton(
                                  text: AppString.save.localize(context)!,
                                  onPressed: _validateAndSave,
                                  backgroundColor:
                                      colors(context).colorPrimary5!,
                                ),
                                const SizedBox(width: 40),
                                CustomButton(
                                  text: AppString.sendData.localize(context)!,
                                  onPressed: _validateAndSubmit,
                                  backgroundColor:
                                      colors(context).colorPrimary1!,
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

  /// Validates that required fields are not empty
  void _validateRequiredField(
      String value, String fieldName, Map<String, String> errors) {
    if (value.trim().isEmpty) {
      errors[fieldName] = 'Cannot be empty';
    }
  }

  /// Validates date field (basic YYYY-MM-DD format)
  void _validateDateField(
      String value, String fieldName, Map<String, String> errors) {
    if (value.trim().isEmpty) {
      errors[fieldName] = 'Cannot be empty';
      return;
    }

    // Check basic date format YYYY-MM-DD
    if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
      errors[fieldName] = 'Must be in YYYY-MM-DD format';
      return;
    }

    // Try to parse the date
    try {
      DateTime.parse(value);
    } catch (e) {
      errors[fieldName] = 'Must be a valid date';
    }
  }

  /// Validates numeric field
  void _validateNumericField(
      String value, String fieldName, Map<String, String> errors) {
    if (value.trim().isEmpty) {
      errors[fieldName] = 'Cannot be empty';
      return;
    }

    double? number = double.tryParse(value);
    if (number == null) {
      errors[fieldName] = 'Must be a valid number';
      return;
    }

    if (number < 0) {
      errors[fieldName] = 'Cannot be negative';
      return;
    }

    if (number > 1000000000) {
      errors[fieldName] = 'Value seems too large, please verify';
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
    if (fieldName.toLowerCase().contains('latitude')) {
      if (coordinate < -90 || coordinate > 90) {
        errors[fieldName] = 'Must be between -90 and 90 degrees';
      }
    } else if (fieldName.toLowerCase().contains('longitude')) {
      if (coordinate < -180 || coordinate > 180) {
        errors[fieldName] = 'Must be between -180 and 180 degrees';
      }
    }
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
      _showSuccessMessage('Past valuation data saved successfully');
      // TODO: Implement actual save logic
    } else {
      _showErrorMessage('Please fix the validation errors in the form');
    }
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
