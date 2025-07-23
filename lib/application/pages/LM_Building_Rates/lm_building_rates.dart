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
import 'package:land_asset_valuation/application/pages/LM_Building_Rates/cubit/lm_building_rates_cubit.dart';
import 'package:land_asset_valuation/application/pages/LM_Building_Rates/cubit/lm_building_rates_state.dart';
import 'package:land_asset_valuation/application/core/validators/lm_building_rates_validator.dart';
import 'package:land_asset_valuation/data/models/lm_building_rates_model.dart';
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

  @override
  Widget buildView(BuildContext context) {
    return BlocProvider<LmBuildingRatesCubit>.value(
      value: _cubit,
      child: BlocConsumer<LmBuildingRatesCubit, dynamic>(
        listener: (context, state) {
          if (state is LmBuildingRatesSubmitSuccess) {
            _showSuccessDialog();
          } else if (state is LmBuildingRatesSubmitFailure) {
            _showErrorMessage(state.errorMessage);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: CustomAppBar(title: 'LM Building Rates Form'),
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
                                label: AppString.masterFile.localize(context) ??
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
                                        'Floor Area (SQFT)',
                                    placeholder: AppString.floorAreaSQFT
                                            .localize(context) ??
                                        'Floor Area (SQFT)',
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
                                ],
                              ),
                              const SizedBox(height: 24),

                              // Location section
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: colors(context).colorPrimary6,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Location',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: colors(context).colorBlack,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              Wrap(
                                spacing: 16,
                                runSpacing: 16,
                                children: [
                                  LabeledTextField(
                                    label: AppString.locationLatitude
                                            .localize(context) ??
                                        'Latitude',
                                    placeholder: AppString.locationLatitude
                                            .localize(context) ??
                                        'Latitude',
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
                                        'Longitude',
                                    placeholder: AppString.locationLongitude
                                            .localize(context) ??
                                        'Longitude',
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
                              Row(
                                children: [
                                  Icon(
                                    Icons.camera_alt,
                                    color: colors(context).colorPrimary6,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Upload Images',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: colors(context).colorBlack,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              ImageUpload(
                                onImagePicked: _onImagePicked,
                                onDelete: () {},
                                isUploadButton: true,
                              ),
                              const SizedBox(height: 32),

                              // Action buttons
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: CustomButton(
                                      text:
                                          AppString.cancel.localize(context) ??
                                              'Cancel',
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      backgroundColor: Colors.grey.shade300,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: CustomButton(
                                      text: AppString.save.localize(context) ??
                                          'Save',
                                      onPressed: state is LmBuildingRatesLoading
                                          ? null
                                          : _handleSubmit,
                                      backgroundColor:
                                          colors(context).colorPrimary6 ??
                                              Colors.blue,
                                      isLoading:
                                          state is LmBuildingRatesLoading,
                                    ),
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
        },
      ),
    );
  }

  /// Handles form submission with validation
  void _handleSubmit() {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });

    if (_formKey.currentState?.validate() ?? false) {
      final formData = LmBuildingRatesModel(
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

      _cubit.sendLmBuildingRates(formData);
    }
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
