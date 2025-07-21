import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/widgets/breadcrumb.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_app_bar.dart';
import 'package:land_asset_valuation/application/core/widgets/labeled_text_field.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_dropdown_field.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_button.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:land_asset_valuation/data/models/master_data_model.dart';
import 'package:land_asset_valuation/application/core/validators/special_rating_card_validator.dart';

class SpecialRatingCard extends StatefulWidget {
  final MasterDataResponse masterData;
  const SpecialRatingCard({super.key, required this.masterData});

  @override
  State<SpecialRatingCard> createState() => _SpecialRatingCardState();
}

class _SpecialRatingCardState extends State<SpecialRatingCard> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _localAuthorityController = TextEditingController();
  final _localAuthorityCodeController = TextEditingController();
  final _assessmentNumberController = TextEditingController();
  final _newNumberController = TextEditingController();
  final _obsoleteNumberController = TextEditingController();
  final _ownerController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _ageController = TextEditingController();
  final _capacityController = TextEditingController();
  final _specialEquipmentController = TextEditingController();
  final _parkingSpaceController = TextEditingController();
  final _wardNumberController = TextEditingController();
  final _roadNameController = TextEditingController();
  final _dateController = TextEditingController();
  final _administratorController = TextEditingController();
  final _operatingBudgetController = TextEditingController();
  final _licenseRegistrationController = TextEditingController();
  final _serviceAreaController = TextEditingController();
  final _staffCountController = TextEditingController();
  final _facilityDetailsController = TextEditingController();
  final _totalBuiltAreaController = TextEditingController();
  final _functionalAreaController = TextEditingController();
  final _specialValuationRateController = TextEditingController();
  final _notesController = TextEditingController();
  
  // Dropdown state variables
  String? _selectedSpecialPropertyType;
  String? _selectedConstructionType;
  String? _selectedSpecialFeatures;

  @override
  void dispose() {
    // Dispose all controllers
    _localAuthorityController.dispose();
    _localAuthorityCodeController.dispose();
    _assessmentNumberController.dispose();
    _newNumberController.dispose();
    _obsoleteNumberController.dispose();
    _ownerController.dispose();
    _descriptionController.dispose();
    _ageController.dispose();
    _capacityController.dispose();
    _specialEquipmentController.dispose();
    _parkingSpaceController.dispose();
    _wardNumberController.dispose();
    _roadNameController.dispose();
    _dateController.dispose();
    _administratorController.dispose();
    _operatingBudgetController.dispose();
    _licenseRegistrationController.dispose();
    _serviceAreaController.dispose();
    _staffCountController.dispose();
    _facilityDetailsController.dispose();
    _totalBuiltAreaController.dispose();
    _functionalAreaController.dispose();
    _specialValuationRateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _saveSpecialRatingCard() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement API call to save data
      debugPrint("Special Rating Card validated and ready to save");
      debugPrint("Special Property Type: $_selectedSpecialPropertyType");
      debugPrint("Local Authority: ${_localAuthorityController.text}");
      debugPrint("Owner: ${_ownerController.text}");
      // Add more debug prints or actual save logic here
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Special Rating Card saved successfully'),
          backgroundColor: colors(context).colorPositive1,
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      _showValidationError('Please fix the errors in the form');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Rating Card-Special',
        leftIcon: (style) => PhosphorIcons.pencilRuler(),
        onLeftIconPressed: () {},
        rightIcon1: (style) => PhosphorIcons.bell(style),
        onRightIcon1Pressed: () {},
        rightIcon2: (style) => PhosphorIcons.user(style),
        onRightIcon2Pressed: () {},
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        double formWidth = constraints.maxWidth - 32;
        return Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Container(
                width: double.infinity,
                color: colors(context).colorGrey9,
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
                child: Breadcrumb(
                  items: [
                    BreadcrumbItem(label: "Mass Rating"),
                    BreadcrumbItem(label: "Rating Card - Special"),
                  ],
                ),
              ),
              _buildRow([
                CustomDropdownField(
                  label: "Special Property Type",
                  items: widget.masterData.natureOfConstruction,
                  initialValue: _selectedSpecialPropertyType,
                  onChanged: (value) {
                    setState(() {
                      _selectedSpecialPropertyType = value;
                    });
                  },
                  validator: (value) => SpecialRatingCardValidator.validateDropdown(
                      value, "Special Property Type"),
                ),
                LabeledTextField(
                  label: AppString.localAuthority.localize(context)!,
                  placeholder: AppString.localAuthority.localize(context)!,
                  controller: _localAuthorityController,
                  validator: (value) => SpecialRatingCardValidator.validateRequired(
                      value, "Local Authority"),
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.localAuthorityCode.localize(context)!,
                  placeholder: "123456789",
                  controller: _localAuthorityCodeController,
                  validator: (value) => SpecialRatingCardValidator.validatePropertyIdentifier(
                      value, "Local Authority Code"),
                ),
                LabeledTextField(
                  label: AppString.assessmentNumber.localize(context)!,
                  placeholder: AppString.assessmentNumber.localize(context)!,
                  controller: _assessmentNumberController,
                  validator: (value) => SpecialRatingCardValidator.validatePropertyIdentifier(
                      value, "Assessment Number"),
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.newNumber.localize(context)!,
                  placeholder: AppString.newNumber.localize(context)!,
                  controller: _newNumberController,
                  validator: (value) => SpecialRatingCardValidator.validateOptionalText(
                      value, "New Number"),
                ),
                LabeledTextField(
                  label: AppString.obsoleteNumber.localize(context)!,
                  placeholder: AppString.obsoleteNumber.localize(context)!,
                  controller: _obsoleteNumberController,
                  validator: (value) => SpecialRatingCardValidator.validateOptionalText(
                      value, "Obsolete Number"),
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.owner.localize(context)!,
                  placeholder: "Organization/Institution name",
                  controller: _ownerController,
                  validator: (value) => SpecialRatingCardValidator.validateRequiredTextWithLength(
                      value, 100, "Owner"),
                ),
                LabeledTextField(
                  label: AppString.description.localize(context)!,
                  placeholder: "Purpose and function",
                  controller: _descriptionController,
                  validator: (value) => SpecialRatingCardValidator.validateRequiredTextWithLength(
                      value, 200, "Description"),
                ),
              ]),
              _buildRow([
                CustomDropdownField(
                  label: "Construction Type",
                  items: widget.masterData.foundationStructure,
                  initialValue: _selectedConstructionType,
                  onChanged: (value) {
                    setState(() {
                      _selectedConstructionType = value;
                    });
                  },
                  validator: (value) => SpecialRatingCardValidator.validateDropdown(
                      value, "Construction Type"),
                ),
                CustomDropdownField(
                  label: "Special Features",
                  items: widget.masterData.services,
                  initialValue: _selectedSpecialFeatures,
                  onChanged: (value) {
                    setState(() {
                      _selectedSpecialFeatures = value;
                    });
                  },
                  validator: (value) => SpecialRatingCardValidator.validateDropdown(
                      value, "Special Features"),
                ),
              ]),
              // Remove dropdowns for usageClassification, condition, propertySubCategory, ownershipType
              // Leave as text fields or static for now
              _buildRow([
                LabeledTextField(
                  label: AppString.age.localize(context)!,
                  placeholder: "Building age",
                  controller: _ageController,
                  validator: (value) => SpecialRatingCardValidator.validateAge(
                      value, "Age"),
                ),
                LabeledTextField(
                  label: "Capacity",
                  placeholder: "Maximum occupancy/capacity",
                  controller: _capacityController,
                  validator: (value) => SpecialRatingCardValidator.validateCapacity(
                      value, "Capacity"),
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: "Special Equipment",
                  placeholder: "Medical/Industrial equipment",
                  controller: _specialEquipmentController,
                  validator: (value) => SpecialRatingCardValidator.validateOptionalTextWithLength(
                      value, 150, "Special Equipment"),
                ),
                LabeledTextField(
                  label: AppString.parkingSpace.localize(context)!,
                  placeholder: "Parking facilities",
                  controller: _parkingSpaceController,
                  validator: (value) => SpecialRatingCardValidator.validateOptionalText(
                      value, "Parking Space"),
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.wardNumber.localize(context)!,
                  placeholder: AppString.wardNumber.localize(context)!,
                  controller: _wardNumberController,
                  validator: (value) => SpecialRatingCardValidator.validatePositiveInteger(
                      value, "Ward Number"),
                ),
                LabeledTextField(
                  label: AppString.roadName.localize(context)!,
                  placeholder: AppString.roadName.localize(context)!,
                  controller: _roadNameController,
                  validator: (value) => SpecialRatingCardValidator.validateAlphaNumeric(
                      value, "Road Name"),
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.date.localize(context)!,
                  placeholder: AppString.date.localize(context)!,
                  controller: _dateController,
                  validator: (value) => SpecialRatingCardValidator.validateDate(
                      value, "Date"),
                ),
                LabeledTextField(
                  label: "Administrator",
                  placeholder: "Current administrator/manager",
                  controller: _administratorController,
                  validator: (value) => SpecialRatingCardValidator.validateRequiredTextWithLength(
                      value, 100, "Administrator"),
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: "Operating Budget",
                  placeholder: "Annual operating budget",
                  controller: _operatingBudgetController,
                  validator: (value) => SpecialRatingCardValidator.validatePositiveDecimal(
                      value, "Operating Budget"),
                ),
                LabeledTextField(
                  label: "License/Registration",
                  placeholder: "Official registration number",
                  controller: _licenseRegistrationController,
                  validator: (value) => SpecialRatingCardValidator.validatePropertyIdentifier(
                      value, "License/Registration"),
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: "Service Area",
                  placeholder: "Geographic area served",
                  controller: _serviceAreaController,
                  validator: (value) => SpecialRatingCardValidator.validateAlphaNumeric(
                      value, "Service Area"),
                ),
                LabeledTextField(
                  label: "Staff Count",
                  placeholder: "Number of employees",
                  controller: _staffCountController,
                  validator: (value) => SpecialRatingCardValidator.validatePositiveInteger(
                      value, "Staff Count"),
                ),
              ]),
              _buildRow([
                Text(
                  'Special Property Details',
                  style: AppStyling.mediumTextSize14.copyWith(
                      color: colors(context).colorBlack,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ]),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        child: LabeledTextField(
                          label: "Facility Details",
                          placeholder: "Enter facility specifications",
                          controller: _facilityDetailsController,
                          validator: (value) => SpecialRatingCardValidator.validateOptionalTextWithLength(
                              value, 300, "Facility Details"),
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          // Validate just the facility details field
                          final facilityDetails = _facilityDetailsController.text;
                          final validation = SpecialRatingCardValidator.validateOptionalTextWithLength(
                              facilityDetails, 300, "Facility Details");
                          if (validation != null) {
                            _showValidationError(validation);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Facility details set'),
                                backgroundColor: colors(context).colorPositive1,
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: colors(context).colorPrimary1,
                          foregroundColor: colors(context).colorWhite,
                          padding: EdgeInsets.symmetric(
                              horizontal: 25, vertical: 13),
                        ),
                        child: Text("Set", textAlign: TextAlign.center),
                      ),
                    ],
                  ),
                ],
              ),
              _buildRow([
                LabeledTextField(
                  label: "Total Built Area",
                  placeholder: "Total building area",
                  controller: _totalBuiltAreaController,
                  validator: (value) => SpecialRatingCardValidator.validateArea(
                      value, "Total Built Area"),
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: "Functional Area",
                  placeholder: "Area used for primary function",
                  controller: _functionalAreaController,
                  validator: (value) => SpecialRatingCardValidator.validateArea(
                      value, "Functional Area"),
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: "Special Valuation Rate",
                  placeholder: "Rate considering special use",
                  controller: _specialValuationRateController,
                  validator: (value) => SpecialRatingCardValidator.validatePositiveDecimal(
                      value, "Special Valuation Rate"),
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.notes.localize(context)!,
                  placeholder: "Special considerations and restrictions",
                  controller: _notesController,
                  validator: (value) => SpecialRatingCardValidator.validateOptionalTextWithLength(
                      value, 500, "Notes"),
                ),
              ]),
              // Save & Cancel Buttons
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 120,
                      child: CustomButton(
                        text: AppString.cancel.localize(context)!,
                        backgroundColor: colors(context).colorGrey1!,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        width: 120,
                        height: 48,
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 120,
                          child: CustomButton(
                            text: AppString.save.localize(context)!,
                            backgroundColor: colors(context).colorPrimary1!,
                            onPressed: _saveSpecialRatingCard,
                            width: 120,
                            height: 48,
                          ),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // TODO: Implement send functionality
                              debugPrint("Special Rating Card validated and ready to send");
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Special Rating Card sent successfully'),
                                  backgroundColor: colors(context).colorPositive1,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            } else {
                              _showValidationError('Please fix the errors before sending');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: colors(context).colorPrimary5!,
                            foregroundColor: colors(context).colorWhite,
                            minimumSize: Size(120, 48),
                            padding: EdgeInsets.zero,
                          ),
                          label: Text(''),
                          icon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Send',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                PhosphorIcons.arrowRight(),
                                color: colors(context
                                ).colorWhite,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
              ],
            ),
          ),
        );
      }),
    );
  }
}

// Helper method to create rows of input fields
Widget _buildRow(List<Widget> children) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children.map((widget) => Expanded(child: widget)).toList(),
    ),
  );
}
