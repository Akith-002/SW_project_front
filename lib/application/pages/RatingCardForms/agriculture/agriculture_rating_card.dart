import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:land_asset_valuation/application/core/widgets/breadcrumb.dart';
import 'package:land_asset_valuation/application/core/router/pages.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_app_bar.dart';
import 'package:land_asset_valuation/application/core/widgets/labeled_text_field.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_dropdown_field.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_button.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:land_asset_valuation/data/models/master_data_model.dart';
import 'package:land_asset_valuation/application/core/validators/agriculture_rating_card_validator.dart';

class AgricultureRatingCard extends StatefulWidget {
  final int assetId;
  final MasterDataResponse masterData;
  final String? assetNo;
  final String? requestType;
  final String? ratingReferenceNo;
  
  const AgricultureRatingCard({
    super.key, 
    required this.assetId,
    required this.masterData,
    this.assetNo,
    this.requestType,
    this.ratingReferenceNo,
  });

  @override
  State<AgricultureRatingCard> createState() => _AgricultureRatingCardState();
}

class _AgricultureRatingCardState extends State<AgricultureRatingCard> {
  final _formKey = GlobalKey<FormState>();

  // Text controllers
  final _localAuthorityController = TextEditingController();
  final _localAuthorityCodeController = TextEditingController();
  final _assessmentNumberController = TextEditingController();
  final _newNumberController = TextEditingController();
  final _obsoleteNumberController = TextEditingController();
  final _ownerController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _plantationAgeController = TextEditingController();
  final _accessController = TextEditingController();
  final _yieldPerAcreController = TextEditingController();
  final _waterSourceController = TextEditingController();
  final _wardNumberController = TextEditingController();
  final _villageDistrictController = TextEditingController();
  final _dateController = TextEditingController();
  final _cultivatorController = TextEditingController();
  final _annualIncomeController = TextEditingController();
  final _leaseTermsController = TextEditingController();
  final _landPlotController = TextEditingController();
  final _totalLandAreaController = TextEditingController();
  final _cultivatedAreaController = TextEditingController();
  final _marketValueController = TextEditingController();
  final _notesController = TextEditingController();

  // Dropdown values
  String? _landType;
  String? _soilType;
  String? _irrigationType;

  @override
  void dispose() {
    _localAuthorityController.dispose();
    _localAuthorityCodeController.dispose();
    _assessmentNumberController.dispose();
    _newNumberController.dispose();
    _obsoleteNumberController.dispose();
    _ownerController.dispose();
    _descriptionController.dispose();
    _plantationAgeController.dispose();
    _accessController.dispose();
    _yieldPerAcreController.dispose();
    _waterSourceController.dispose();
    _wardNumberController.dispose();
    _villageDistrictController.dispose();
    _dateController.dispose();
    _cultivatorController.dispose();
    _annualIncomeController.dispose();
    _leaseTermsController.dispose();
    _landPlotController.dispose();
    _totalLandAreaController.dispose();
    _cultivatedAreaController.dispose();
    _marketValueController.dispose();
    _notesController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Rating Card-Agriculture',
        leftIcon: (style) => PhosphorIcons.pencilRuler(),
        onLeftIconPressed: () {},
        rightIcon1: (style) => PhosphorIcons.bell(style),
        onRightIcon1Pressed: () {},
        rightIcon2: (style) => PhosphorIcons.user(style),
        onRightIcon2Pressed: () {},
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        double formWidth = constraints.maxWidth - 32;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
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
                    BreadcrumbItem(
                      label: "Mass rating",
                      onTap: () {
                        context.goNamed(
                          Pages.routeI3MasterFileList.toPathName(),
                          queryParameters: {'selectedIndex': '2'},
                        );
                      },
                    ),
                    BreadcrumbItem(
                      label: "${widget.ratingReferenceNo ?? 'MR-2022-003'} - ${widget.assetNo ?? 'AST_030-2022'}",
                      onTap: widget.ratingReferenceNo != null && widget.requestType != null ? () {
                        // Navigate back to assets list
                        String route;
                        switch (widget.requestType) {
                          case 'MR':
                            route = Pages.routeMrAssetsList.toPathName();
                            break;
                          case 'RA':
                            route = Pages.routeRaAssetsList.toPathName();
                            break;
                          case 'RB':
                            route = Pages.routeRbAssetsList.toPathName();
                            break;
                          case 'RO':
                            route = Pages.routeRoAssetsList.toPathName();
                            break;
                          default:
                            route = Pages.routeMrAssetsList.toPathName();
                        }
                        
                        // Determine source based on request type
                        String source = 'massRating';
                        switch (widget.requestType) {
                          case 'RA':
                            source = 'ratingAssessment';
                            break;
                          case 'RB':
                            source = 'ratingBuilding';
                            break;
                          case 'RO':
                            source = 'ratingObject';
                            break;
                        }
                        
                        context.goNamed(
                          route,
                          queryParameters: {
                            'source': source,
                            if (GoRouterState.of(context).uri.queryParameters['requestId'] != null)
                              'requestId': GoRouterState.of(context).uri.queryParameters['requestId']!,
                          },
                        );
                      } : null,
                    ),
                    BreadcrumbItem(label: "Agriculture - Rating Card"),
                  ],
                ),
              ),
              _buildRow([
                CustomDropdownField(
                  label: "Land Type",
                  items: widget.masterData.natureOfConstruction,
                  initialValue:
                      widget.masterData.natureOfConstruction.isNotEmpty
                          ? widget.masterData.natureOfConstruction.first
                          : null,
                  onChanged: (value) {
                    setState(() {
                      _landType = value;
                    });
                  },
                  validator: (value) =>
                      AgricultureRatingCardValidator.validateDropdown(
                          value, 'Land Type'),
                ),
                LabeledTextField(
                  label: AppString.localAuthority.localize(context)!,
                  placeholder: AppString.localAuthority.localize(context)!,
                  controller: _localAuthorityController,
                  validator: (value) =>
                      AgricultureRatingCardValidator.validateRequiredTextWithLength(
                          value, 100, 'Local Authority'),
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.localAuthorityCode.localize(context)!,
                  placeholder: "123456789",
                  controller: _localAuthorityCodeController,
                  validator: (value) =>
                      AgricultureRatingCardValidator.validateAlphaNumeric(
                          value, 'Local Authority Code'),
                ),
                LabeledTextField(
                  label: AppString.assessmentNumber.localize(context)!,
                  placeholder: AppString.assessmentNumber.localize(context)!,
                  controller: _assessmentNumberController,
                  validator: (value) =>
                      AgricultureRatingCardValidator.validateAlphaNumeric(
                          value, 'Assessment Number'),
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.newNumber.localize(context)!,
                  placeholder: AppString.newNumber.localize(context)!,
                  controller: _newNumberController,
                  validator: (value) =>
                      AgricultureRatingCardValidator.validateOptionalTextWithLength(
                          value, 50, 'New Number'),
                ),
                LabeledTextField(
                  label: AppString.obsoleteNumber.localize(context)!,
                  placeholder: AppString.obsoleteNumber.localize(context)!,
                  controller: _obsoleteNumberController,
                  validator: (value) =>
                      AgricultureRatingCardValidator.validateOptionalTextWithLength(
                          value, 50, 'Obsolete Number'),
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.owner.localize(context)!,
                  placeholder: AppString.owner.localize(context)!,
                  controller: _ownerController,
                  validator: (value) =>
                      AgricultureRatingCardValidator.validateRequiredTextWithLength(
                          value, 100, 'Owner'),
                ),
                LabeledTextField(
                  label: AppString.description.localize(context)!,
                  placeholder: "Land use description",
                  controller: _descriptionController,
                  validator: (value) =>
                      AgricultureRatingCardValidator.validateRequiredTextWithLength(
                          value, 200, 'Description'),
                ),
              ]),
              _buildRow([
                CustomDropdownField(
                  label: "Soil Type",
                  items: widget.masterData.floorStructure,
                  initialValue: widget.masterData.floorStructure.isNotEmpty
                      ? widget.masterData.floorStructure.first
                      : null,
                  onChanged: (value) {
                    setState(() {
                      _soilType = value;
                    });
                  },
                  validator: (value) =>
                      AgricultureRatingCardValidator.validateDropdown(
                          value, 'Soil Type'),
                ),
                CustomDropdownField(
                  label: "Irrigation Type",
                  items: widget.masterData.services,
                  initialValue: widget.masterData.services.isNotEmpty
                      ? widget.masterData.services.first
                      : null,
                  onChanged: (value) {
                    setState(() {
                      _irrigationType = value;
                    });
                  },
                  validator: (value) =>
                      AgricultureRatingCardValidator.validateDropdown(
                          value, 'Irrigation Type'),
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: "Plantation Age",
                  placeholder: "Age of crops/plantation",
                  controller: _plantationAgeController,
                  validator: (value) =>
                      AgricultureRatingCardValidator.validatePlantationAge(
                          value, 'Plantation Age'),
                ),
                LabeledTextField(
                  label: AppString.access.localize(context)!,
                  placeholder: "Access type",
                  controller: _accessController,
                  validator: (value) =>
                      AgricultureRatingCardValidator.validateRequiredTextWithLength(
                          value, 100, 'Access'),
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: "Yield per Acre",
                  placeholder: "Annual yield",
                  controller: _yieldPerAcreController,
                  validator: (value) =>
                      AgricultureRatingCardValidator.validateYield(
                          value, 'Yield per Acre'),
                ),
                LabeledTextField(
                  label: "Water Source",
                  placeholder: "Primary water source",
                  controller: _waterSourceController,
                  validator: (value) =>
                      AgricultureRatingCardValidator.validateRequiredTextWithLength(
                          value, 100, 'Water Source'),
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.wardNumber.localize(context)!,
                  placeholder: AppString.wardNumber.localize(context)!,
                  controller: _wardNumberController,
                  validator: (value) =>
                      AgricultureRatingCardValidator.validateOptionalTextWithLength(
                          value, 50, 'Ward Number'),
                ),
                LabeledTextField(
                  label: "Village/District",
                  placeholder: "Village or district name",
                  controller: _villageDistrictController,
                  validator: (value) =>
                      AgricultureRatingCardValidator.validateRequiredTextWithLength(
                          value, 100, 'Village/District'),
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.date.localize(context)!,
                  placeholder: AppString.date.localize(context)!,
                  controller: _dateController,
                  validator: (value) =>
                      AgricultureRatingCardValidator.validateDate(
                          value, 'Date'),
                ),
                LabeledTextField(
                  label: "Cultivator",
                  placeholder: "Current cultivator name",
                  controller: _cultivatorController,
                  validator: (value) =>
                      AgricultureRatingCardValidator.validateOptionalTextWithLength(
                          value, 100, 'Cultivator'),
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: "Annual Income",
                  placeholder: "Expected annual income",
                  controller: _annualIncomeController,
                  validator: (value) =>
                      AgricultureRatingCardValidator.validatePositiveDecimal(
                          value, 'Annual Income'),
                ),
                LabeledTextField(
                  label: "Lease Terms",
                  placeholder: "Lease conditions if applicable",
                  controller: _leaseTermsController,
                  validator: (value) =>
                      AgricultureRatingCardValidator.validateOptionalTextWithLength(
                          value, 200, 'Lease Terms'),
                ),
              ]),
              _buildRow([
                Text(
                  'Land Area Details',
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
                          label: "Land Plot",
                          placeholder: "Enter plot details",
                          controller: _landPlotController,
                          validator: (value) =>
                              AgricultureRatingCardValidator.validateOptionalTextWithLength(
                                  value, 100, 'Land Plot'),
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {},
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
                  label: "Total Land Area (Acres)",
                  placeholder: "Total area in acres",
                  controller: _totalLandAreaController,
                  validator: (value) =>
                      AgricultureRatingCardValidator.validateLandArea(
                          value, 'Total Land Area'),
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: "Cultivated Area",
                  placeholder: "Currently cultivated area",
                  controller: _cultivatedAreaController,
                  validator: (value) =>
                      AgricultureRatingCardValidator.validateLandArea(
                          value, 'Cultivated Area'),
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: "Market Value per Acre",
                  placeholder: "Current market rate",
                  controller: _marketValueController,
                  validator: (value) =>
                      AgricultureRatingCardValidator.validatePositiveDecimal(
                          value, 'Market Value per Acre'),
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.notes.localize(context)!,
                  placeholder: "Agricultural land notes and features",
                  controller: _notesController,
                  validator: (value) =>
                      AgricultureRatingCardValidator.validateOptionalTextWithLength(
                          value, 500, 'Notes'),
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
                            onPressed: _saveRatingCard,
                            width: 120,
                            height: 48,
                          ),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () {
                            // First validate the form
                            _saveRatingCard();
                            // TODO: If validation passes, implement send functionality
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
                                color: colors(context).colorWhite,
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

  void _saveRatingCard() {
    // Manual validation for dropdowns that don't have validators
    final List<String> validationErrors = [];

    // Check dropdown selections
    if (_landType == null || _landType!.startsWith('Select')) {
      validationErrors.add('Please select a Land Type');
    }
    if (_soilType == null || _soilType!.startsWith('Select')) {
      validationErrors.add('Please select a Soil Type');
    }
    if (_irrigationType == null || _irrigationType!.startsWith('Select')) {
      validationErrors.add('Please select an Irrigation Type');
    }

    // Check if form validation passes and no manual validation errors
    final isFormValid = _formKey.currentState?.validate() ?? false;

    if (!isFormValid || validationErrors.isNotEmpty) {
      // Show validation error snack bar
      _showValidationErrorSnackBar(validationErrors);
      return;
    }

    // TODO: Implement actual save functionality
    // For now, just show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Agriculture Rating Card saved successfully'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
    debugPrint("Agriculture Rating Card validated and ready to save");
  }

  void _showValidationErrorSnackBar(List<String> errors) {
    if (errors.isEmpty) return;

    final errorMessage = errors.length == 1
        ? errors.first
        : 'Please fix the following errors:\n• ${errors.join('\n• ')}';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          constraints: const BoxConstraints(maxHeight: 200),
          child: SingleChildScrollView(
            child: Text(
              errorMessage,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.red.shade600,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
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
