import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/widgets/labeled_text_field.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_dropdown_field.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_button.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/services/condition_report_form_service.dart';
import 'package:land_asset_valuation/application/core/widgets/labeled_date_field.dart';

import '../../validators/land_info_validator.dart';

class LandInfoForm extends StatefulWidget {
  const LandInfoForm({super.key});

  @override
  State<LandInfoForm> createState() => _LandInfoFormState();
}

class _LandInfoFormState extends State<LandInfoForm> {
  final _formService = ConditionReportFormService();

  // Text Controllers
  final _nameOfLandController = TextEditingController();
  final _atPlanNumberController = TextEditingController();
  final _atLotNumberController = TextEditingController();
  final _ppCadNumberController = TextEditingController();
  final _ppCadLotNumberController = TextEditingController();
  final _acquiredExtentController = TextEditingController();
  final _assessmentNumberController = TextEditingController();
  final _roadNameController = TextEditingController();
  final _accessCategoryDescController = TextEditingController();
  final _descriptionOfLandController = TextEditingController();
  final _landUseDescriptionController = TextEditingController();
  final _frontageFeetController = TextEditingController();
  final _depthOfLandFeetController = TextEditingController();
  final _levelWithAccessController = TextEditingController();
  final _plantationDetailsController = TextEditingController();
  final _detailsOfBusinessController = TextEditingController();
  final _acquisitionNameController = TextEditingController();
  final _dateOfPreparedController = TextEditingController();
  final _dateOfSection3BAController = TextEditingController();

  // Boundary Controllers
  final _northController = TextEditingController();
  final _eastController = TextEditingController();
  final _westController = TextEditingController();
  final _southController = TextEditingController();
  final _bottomController = TextEditingController();

  // Selected dropdown values
  String _selectedVillage = "Village A";
  String _selectedAccessCategory = "Category 1";
  String _selectedLandUseType = "Residential";

  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  @override
  void initState() {
    super.initState();
    // Load existing data if available
    _loadExistingData();
  }

  void _loadExistingData() {
    final formData = _formService.formData;

    // Load text field values
    _nameOfLandController.text = formData.nameOfTheLand;
    _atPlanNumberController.text = formData.atPlanNumber;
    _atLotNumberController.text = formData.atLotNumber;
    _ppCadNumberController.text = formData.ppCadNumber;
    _ppCadLotNumberController.text = formData.ppCadLotNumber;
    _acquiredExtentController.text = formData.acquiredExtent;
    _assessmentNumberController.text = formData.assessmentNumber;
    _roadNameController.text = formData.roadName;
    _accessCategoryDescController.text = formData.accessCategoryDescription;
    _descriptionOfLandController.text = formData.descriptionOfLand;
    _landUseDescriptionController.text = formData.landUseDescription;
    _frontageFeetController.text = formData.frontage;
    _depthOfLandFeetController.text = formData.depthOfLand;
    _levelWithAccessController.text = formData.levelWithAccess;
    _plantationDetailsController.text = formData.plantationDetails;
    _detailsOfBusinessController.text = formData.detailsOfBusiness;
    _acquisitionNameController.text = formData.acquisitionName;
    _dateOfPreparedController.text = formData.datePrepared;
    _dateOfSection3BAController.text = formData.dateOfSection3BA;

    // Load boundary data
    _northController.text = formData.boundaryNorth;
    _eastController.text = formData.boundaryEast;
    _westController.text = formData.boundaryWest;
    _southController.text = formData.boundarySouth;
    _bottomController.text = formData.boundaryBottom;

    // Load dropdown values
    if (formData.nameOfTheVillage.isNotEmpty) {
      _selectedVillage = formData.nameOfTheVillage;
    }
    if (formData.accessCategory.isNotEmpty) {
      _selectedAccessCategory = formData.accessCategory;
    }
    if (formData.landUseType.isNotEmpty) {
      _selectedLandUseType = formData.landUseType;
    }
  }

  void _saveFormData() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields correctly'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Update form service with current values
    _formService.updateLandInfo(
      nameOfTheVillage: _selectedVillage,
      nameOfTheLand: _nameOfLandController.text,
      atPlanNumber: _atPlanNumberController.text,
      atLotNumber: _atLotNumberController.text,
      ppCadNumber: _ppCadNumberController.text,
      ppCadLotNumber: _ppCadLotNumberController.text,
      acquiredExtent: _acquiredExtentController.text,
      assessmentNumber: _assessmentNumberController.text,
      roadName: _roadNameController.text,
      accessCategory: _selectedAccessCategory,
      accessCategoryDescription: _accessCategoryDescController.text,
      descriptionOfLand: _descriptionOfLandController.text,
      landUseDescription: _landUseDescriptionController.text,
      landUseType: _selectedLandUseType,
      frontage: _frontageFeetController.text,
      depthOfLand: _depthOfLandFeetController.text,
      levelWithAccess: _levelWithAccessController.text,
      plantationDetails: _plantationDetailsController.text,
      detailsOfBusiness: _detailsOfBusinessController.text,
      acquisitionName: _acquisitionNameController.text,
      datePrepared: _dateOfPreparedController.text,
      dateOfSection3BA: _dateOfSection3BAController.text,
    );

    // Update boundaries
    _formService.updateBoundaries(
      north: _northController.text,
      east: _eastController.text,
      west: _westController.text,
      south: _southController.text,
      bottom: _bottomController.text,
    );

    // Show save confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Land information saved'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose all controllers to prevent memory leaks
    _nameOfLandController.dispose();
    _atPlanNumberController.dispose();
    _atLotNumberController.dispose();
    _ppCadNumberController.dispose();
    _ppCadLotNumberController.dispose();
    _acquiredExtentController.dispose();
    _assessmentNumberController.dispose();
    _roadNameController.dispose();
    _accessCategoryDescController.dispose();
    _descriptionOfLandController.dispose();
    _landUseDescriptionController.dispose();
    _frontageFeetController.dispose();
    _depthOfLandFeetController.dispose();
    _levelWithAccessController.dispose();
    _plantationDetailsController.dispose();
    _detailsOfBusinessController.dispose();
    _acquisitionNameController.dispose();
    _dateOfPreparedController.dispose();
    _dateOfSection3BAController.dispose();

    _northController.dispose();
    _eastController.dispose();
    _westController.dispose();
    _southController.dispose();
    _bottomController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode:
          _autoValidate ? AutovalidateMode.always : AutovalidateMode.disabled,
      child: LayoutBuilder(
        builder: (context, constraints) {
          double formWidth =
              constraints.maxWidth - 32; // Adjust for sidebar changes
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRow([
                  CustomDropdownField(
                    label: AppString.nameOfVillage.localize(context)!,
                    items: ["Village A", "Village B", "Village C"],
                    initialValue: _selectedVillage,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedVillage = value;
                        });
                      }
                    },
                    validator: (value) => LandInfoValidator.validateRequired(
                      value,
                      'Name of village',
                    ),
                  ),
                  LabeledTextField(
                    label: AppString.nameOfLand.localize(context)!,
                    placeholder: AppString.nameOfLand.localize(context)!,
                    controller: _nameOfLandController,
                    validator: (value) => LandInfoValidator.validateRequired(
                        value, 'Name of Land'),
                  ),
                ]),
                _buildRow([
                  LabeledTextField(
                    label: AppString.atPlanNumber.localize(context)!,
                    placeholder: "123456789",
                    controller: _atPlanNumberController,
                    validator: (value) => LandInfoValidator.validateNumeric(
                        value, 'AT Plan Number'),
                  ),
                  LabeledTextField(
                    label: AppString.atLotNumber.localize(context)!,
                    placeholder: "AT Lot 01",
                    controller: _atLotNumberController,
                  ),
                ]),
                _buildRow([
                  LabeledTextField(
                    label: AppString.ppCadNumber.localize(context)!,
                    placeholder: "123456789",
                    controller: _ppCadNumberController,
                  ),
                  LabeledTextField(
                    label: AppString.ppCadLotNumber.localize(context)!,
                    placeholder: "SLA 01",
                    controller: _ppCadLotNumberController,
                  ),
                ]),
                _buildRow([
                  LabeledTextField(
                    label: AppString.acquiredExtent.localize(context)!,
                    placeholder: AppString.acquiredExtent.localize(context)!,
                    controller: _acquiredExtentController,
                    validator: (value) => LandInfoValidator.validateNumeric(
                        value, 'Acquired Extent'),
                  ),
                  LabeledTextField(
                    label: AppString.assessmentNumber.localize(context)!,
                    placeholder: AppString.assessmentNumber.localize(context)!,
                    controller: _assessmentNumberController,
                    validator: (value) => LandInfoValidator.validateNumeric(
                        value, 'Assessment Number'),
                  ),
                ]),
                _buildRow([
                  LabeledTextField(
                    label: AppString.roadName.localize(context)!,
                    placeholder: AppString.roadName.localize(context)!,
                    controller: _roadNameController,
                    validator: (value) =>
                        LandInfoValidator.validateAlphaNumeric(
                            value, 'Road Name'),
                  ),
                  CustomDropdownField(
                    label: AppString.accessCategory.localize(context)!,
                    items: ["Category 1", "Category 2", "Category 3"],
                    initialValue: _selectedAccessCategory,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedAccessCategory = value;
                        });
                      }
                    },
                    validator: (value) => LandInfoValidator.validateRequired(
                      value,
                      'Access Category',
                    ),
                  ),
                ]),
                _buildRow([
                  LabeledTextField(
                    label:
                        AppString.accessCategoryDescription.localize(context)!,
                    placeholder:
                        AppString.accessCategoryDescription.localize(context)!,
                    controller: _accessCategoryDescController,
                  ),
                  LabeledTextField(
                    label: AppString.descriptionOfLand.localize(context)!,
                    placeholder: AppString.descriptionOfLand.localize(context)!,
                    controller: _descriptionOfLandController,
                  ),
                ]),

                // "Add PR" button
                _buildRow([
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppString.situation.localize(context)!,
                        style: AppStyling.mediumTextSize14
                            .copyWith(color: colors(context).labelTextColor),
                      ),
                      const SizedBox(height: 8),
                      CustomButton(
                        text: AppString.addPr.localize(context)!,
                        backgroundColor: colors(context).colorPrimary1!,
                        onPressed: () {},
                        width: 484,
                        height: 48,
                      ),
                    ],
                  ),
                  LabeledTextField(
                    label: AppString.landUseDescription.localize(context)!,
                    placeholder:
                        AppString.landUseDescription.localize(context)!,
                    controller: _landUseDescriptionController,
                  ),
                ]),
                _buildRow([
                  CustomDropdownField(
                    label: AppString.landUseType.localize(context)!,
                    items: ["Residential", "Commercial", "Agricultural"],
                    initialValue: _selectedLandUseType,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedLandUseType = value;
                        });
                      }
                    },
                    validator: (value) => LandInfoValidator.validateRequired(
                      value,
                      'Land Use Type',
                    ),
                  ),
                  LabeledTextField(
                    label: AppString.frontageFeet.localize(context)!,
                    placeholder: AppString.frontageFeet.localize(context)!,
                    controller: _frontageFeetController,
                    validator: (value) =>
                        LandInfoValidator.validateNumeric(value, 'Frontage'),
                  ),
                ]),
                _buildRow([
                  LabeledTextField(
                    label: AppString.depthOfLandFeet.localize(context)!,
                    placeholder: AppString.depthOfLandFeet.localize(context)!,
                    controller: _depthOfLandFeetController,
                    validator: (value) => LandInfoValidator.validateNumeric(
                        value, 'Depth of Land'),
                  ),
                  LabeledTextField(
                    label: AppString.levelWithAccess.localize(context)!,
                    placeholder: AppString.levelWithAccess.localize(context)!,
                    controller: _levelWithAccessController,
                  ),
                ]),
                _buildRow([
                  LabeledTextField(
                    label: AppString.plantationDetails.localize(context)!,
                    placeholder: AppString.plantationDetails.localize(context)!,
                    controller: _plantationDetailsController,
                  ),
                  LabeledTextField(
                    label: AppString.detailsOfBusiness.localize(context)!,
                    placeholder: AppString.detailsOfBusiness.localize(context)!,
                    controller: _detailsOfBusinessController,
                  ),
                ]),
                _buildRow([
                  LabeledTextField(
                    label: AppString.acquisitionName.localize(context)!,
                    placeholder: AppString.acquisitionName.localize(context)!,
                    controller: _acquisitionNameController,
                  ),
                  LabeledDateField(
                    label: AppString.dateOfPrepared.localize(context)!,
                    placeholder: "YYYY-MM-DD",
                    controller: _dateOfPreparedController,
                    validator: (value) => LandInfoValidator.validateDate(
                        value, 'Date of Prepared'),
                  ),
                ]),
                // Fixed: Put both date fields in the same row with an empty spacer
                _buildRow([
                  LabeledDateField(
                    label: AppString.dateOfSection3BA.localize(context)!,
                    placeholder: "YYYY-MM-DD",
                    controller: _dateOfSection3BAController,
                    validator: (value) => LandInfoValidator.validateDate(
                        value, 'Date of Section 3BA'),
                  ),
                  const SizedBox(), // Empty spacer to maintain row structure
                ]),

                // Boundaries Section
                const SizedBox(height: 16),
                Text(
                  AppString.boundaries.localize(context)!,
                  style: AppStyling.mediumTextSize14
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSmallInput(
                        AppString.north.localize(context)!, _northController),
                    _buildSmallInput(
                        AppString.east.localize(context)!, _eastController),
                    _buildSmallInput(
                        AppString.west.localize(context)!, _westController),
                    _buildSmallInput(
                        AppString.south.localize(context)!, _southController),
                    _buildSmallInput(
                        AppString.bottom.localize(context)!, _bottomController),
                  ],
                ),

                // **🚀 NEW: Extra Space Before Line Break**
                const SizedBox(height: 32),

                // **Divider Section (Fixed Position)**
                Container(
                  width: formWidth,
                  height: 1.5,
                  color: colors(context).colorGrey5,
                ),

                const SizedBox(height: 16), // Extra space before buttons

                // Save & Cancel Buttons
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 16.0), // Ensures spacing at bottom
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomButton(
                        text: AppString.cancel.localize(context)!,
                        backgroundColor: colors(context).colorGrey1!,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        width: 120,
                        height: 48,
                      ),
                      CustomButton(
                        text: AppString.save.localize(context)!,
                        backgroundColor: colors(context).colorPrimary5!,
                        onPressed: _saveFormData,
                        width: 120,
                        height: 48,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Helper method to create rows of input fields
  Widget _buildRow(List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: children.map((widget) => Expanded(child: widget)).toList(),
      ),
    );
  }

  // Helper method to create small input fields in "Boundaries"
  Widget _buildSmallInput(String label, TextEditingController controller) {
    return SizedBox(
      width: 186,
      child: LabeledTextField(
        label: label,
        placeholder: label,
        controller: controller,
      ),
    );
  }
}