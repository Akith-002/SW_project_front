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
import 'package:land_asset_valuation/application/core/validators/shops_rating_card_validator.dart';

class ShopsRatingCard extends StatefulWidget {
  final int assetId;
  final MasterDataResponse masterData;
  final String? assetNo;
  final String? requestType;
  final String? ratingReferenceNo;
  
  const ShopsRatingCard({
    super.key, 
    required this.assetId,
    required this.masterData,
    this.assetNo,
    this.requestType,
    this.ratingReferenceNo,
  });

  @override
  State<ShopsRatingCard> createState() => _ShopsRatingCardState();
}

class _ShopsRatingCardState extends State<ShopsRatingCard> {
  final _formKey = GlobalKey<FormState>();

  // Text controllers
  final _localAuthorityController = TextEditingController();
  final _localAuthorityCodeController = TextEditingController();
  final _assessmentNumberController = TextEditingController();
  final _newNumberController = TextEditingController();
  final _obsoleteNumberController = TextEditingController();
  final _ownerController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tsBopController = TextEditingController();
  final _shopFrontController = TextEditingController();
  final _occupierController = TextEditingController();
  final _rentPMController = TextEditingController();
  final _termsController = TextEditingController();
  final _floorWiseAreaController = TextEditingController();
  final _totalFloorAreaController = TextEditingController();
  final _approvedRateFromController = TextEditingController();
  final _approvedRateToController = TextEditingController();
  final _suggestedRateController = TextEditingController();
  final _notesController = TextEditingController();
  final _ageController = TextEditingController();
  final _parkingSpaceController = TextEditingController();
  final _wardNumberController = TextEditingController();
  final _roadNameController = TextEditingController();
  final _dateController = TextEditingController();
  final _shopUnitController = TextEditingController();
  final _shopFloorAreaController = TextEditingController();
  final _storageAreaController = TextEditingController();
  final _monthlyTurnoverController = TextEditingController();
  final _shopNotesController = TextEditingController();

  // Dropdown values
  String? _buildingSelection;
  String? _propertySubCategory;
  String? _propertyType;
  String? _wallType;
  String? _floorType;
  String? _conveniences;
  String? _condition;
  String? _accessType;

  @override
  void dispose() {
    _localAuthorityController.dispose();
    _localAuthorityCodeController.dispose();
    _assessmentNumberController.dispose();
    _newNumberController.dispose();
    _obsoleteNumberController.dispose();
    _ownerController.dispose();
    _descriptionController.dispose();
    _tsBopController.dispose();
    _shopFrontController.dispose();
    _occupierController.dispose();
    _rentPMController.dispose();
    _termsController.dispose();
    _floorWiseAreaController.dispose();
    _totalFloorAreaController.dispose();
    _approvedRateFromController.dispose();
    _approvedRateToController.dispose();
    _suggestedRateController.dispose();
    _notesController.dispose();
    _ageController.dispose();
    _parkingSpaceController.dispose();
    _wardNumberController.dispose();
    _roadNameController.dispose();
    _dateController.dispose();
    _shopUnitController.dispose();
    _shopFloorAreaController.dispose();
    _storageAreaController.dispose();
    _monthlyTurnoverController.dispose();
    _shopNotesController.dispose();
    super.dispose();
  }

  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: colors(context).colorNegative1,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement actual save logic
      debugPrint("Shops Rating Card validated and saved");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Shops Rating Card saved successfully'),
          backgroundColor: colors(context).colorPositive1,
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      _showValidationError('Please fill in all required fields correctly');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Rating Card-Shops',
        leftIcon: (style) => PhosphorIcons.pencilRuler(),
        onLeftIconPressed: () {},
        rightIcon1: (style) => PhosphorIcons.bell(style),
        onRightIcon1Pressed: () {},
        rightIcon2: (style) => PhosphorIcons.user(style),
        onRightIcon2Pressed: () {},
      ),
      body: LayoutBuilder(builder: (context, constraints) {
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
                      label: widget.requestType ?? "Request type",
                      onTap: widget.requestType != null ? () {
                        // Navigate back to the appropriate request type page
                        String selectedIndex = '2';
                        switch (widget.requestType) {
                          case 'MR':
                            selectedIndex = '2';
                            break;
                          case 'RA':
                            selectedIndex = '3';
                            break;
                          case 'RB':
                            selectedIndex = '4';
                            break;
                          case 'RO':
                            selectedIndex = '5';
                            break;
                        }
                        context.goNamed(
                          Pages.routeI3MasterFileList.toPathName(),
                          queryParameters: {'selectedIndex': selectedIndex},
                        );
                      } : null,
                    ),
                    BreadcrumbItem(
                      label: widget.ratingReferenceNo ?? "Rating reference no",
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
                    BreadcrumbItem(
                      label: widget.assetNo ?? "Asset no",
                      onTap: () {
                        // This is the current asset, no navigation needed
                      },
                    ),
                    BreadcrumbItem(label: "Shops - Rating card"),
                  ],
                ),
              ),
              _buildRow([
                // Intentionally static: No backend mapping for building list
                CustomDropdownField(
                  label: AppString.selectBuilding.localize(context)!,
                  items: [
                    "Select Building",
                    "Building A",
                    "Building B",
                    "Building C"
                  ],
                  initialValue: _buildingSelection ?? "Select Building",
                  validator: (value) => ShopsRatingCardValidator.validateDropdown(
                      value, 'building'),
                  onChanged: (value) {
                    setState(() {
                      _buildingSelection = value;
                    });
                  },
                ),
                LabeledTextField(
                  label: AppString.localAuthority.localize(context)!,
                  placeholder: AppString.localAuthority.localize(context)!,
                  controller: _localAuthorityController,
                  validator: (value) => ShopsRatingCardValidator.validateRequired(
                      value, 'Local Authority'),
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.localAuthorityCode.localize(context)!,
                  placeholder: "123456789",
                  controller: _localAuthorityCodeController,
                  validator: (value) => ShopsRatingCardValidator.validateAlphaNumeric(
                      value, 'Local Authority Code'),
                ),
                LabeledTextField(
                  label: AppString.assessmentNumber.localize(context)!,
                  placeholder: AppString.assessmentNumber.localize(context)!,
                  controller: _assessmentNumberController,
                  validator: (value) => ShopsRatingCardValidator.validateAlphaNumeric(
                      value, 'Assessment Number'),
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.newNumber.localize(context)!,
                  placeholder: "500",
                  controller: _newNumberController,
                  validator: (value) => ShopsRatingCardValidator.validateOptionalText(
                      value, 'New Number'),
                ),
                LabeledTextField(
                  label: AppString.obsoleteNumber.localize(context)!,
                  placeholder: AppString.obsoleteNumber.localize(context)!,
                  controller: _obsoleteNumberController,
                  validator: (value) => ShopsRatingCardValidator.validateOptionalText(
                      value, 'Obsolete Number'),
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.owner.localize(context)!,
                  placeholder: "John Doe",
                  controller: _ownerController,
                  validator: (value) => ShopsRatingCardValidator.validateRequired(
                      value, 'Owner'),
                ),
                LabeledTextField(
                  label: AppString.description.localize(context)!,
                  placeholder: "Two-story residential house",
                  controller: _descriptionController,
                  validator: (value) => ShopsRatingCardValidator.validateRequiredTextWithLength(
                      value, 500, 'Description'),
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.tsBop.localize(context)!,
                  placeholder: "Available",
                  controller: _tsBopController,
                  validator: (value) => ShopsRatingCardValidator.validateOptionalText(
                      value, 'TS BOP'),
                ),
                CustomDropdownField(
                  label: AppString.propertySubCategory.localize(context)!,
                  items: [
                    "Select Property Sub Category",
                    "Villa",
                    "Apartment",
                    "Townhouse",
                    "Commercial Shop"
                  ],
                  initialValue: _propertySubCategory ?? "Select Property Sub Category",
                  validator: (value) => ShopsRatingCardValidator.validateDropdown(
                      value, 'property sub category'),
                  onChanged: (value) {
                    setState(() {
                      _propertySubCategory = value;
                    });
                  },
                ),
              ]),
              _buildRow([
                CustomDropdownField(
                  label: AppString.propertyType.localize(context)!,
                  items: [
                    "Select Property Type",
                    "Luxury",
                    "Standard",
                    "Commercial",
                    "Mixed Use"
                  ],
                  initialValue: _propertyType ?? "Select Property Type",
                  validator: (value) => ShopsRatingCardValidator.validateDropdown(
                      value, 'property type'),
                  onChanged: (value) {
                    setState(() {
                      _propertyType = value;
                    });
                  },
                ),
                LabeledTextField(
                  label: "Shop Front",
                  placeholder: "Enter shop front details (optional)",
                  controller: _shopFrontController,
                  validator: (value) => ShopsRatingCardValidator.validateOptionalText(
                      value, 'Shop Front'),
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.occupier.localize(context)!,
                  placeholder: "John Doe",
                  controller: _occupierController,
                  validator: (value) => ShopsRatingCardValidator.validateRequired(
                      value, 'Occupier'),
                ),
                LabeledTextField(
                  label: AppString.rentPM.localize(context)!,
                  placeholder: "50000",
                  controller: _rentPMController,
                  validator: (value) => ShopsRatingCardValidator.validatePositiveDecimal(
                      value, 'Rent per Month'),
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.terms.localize(context)!,
                  placeholder: "Yearly Renewal",
                  controller: _termsController,
                  validator: (value) => ShopsRatingCardValidator.validateOptionalText(
                      value, 'Terms'),
                ),
                LabeledTextField(
                  label: "Floor Wise Area",
                  placeholder: "100 sqm",
                  controller: _floorWiseAreaController,
                  validator: (value) => ShopsRatingCardValidator.validateFloorArea(
                      value, 'Floor Wise Area'),
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.totalFloorArea.localize(context)!,
                  placeholder: "200 sqm",
                  controller: _totalFloorAreaController,
                  validator: (value) => ShopsRatingCardValidator.validateFloorArea(
                      value, 'Total Floor Area'),
                ),
                LabeledTextField(
                  label: "Approved Rate From",
                  placeholder: "120",
                  controller: _approvedRateFromController,
                  validator: (value) => ShopsRatingCardValidator.validatePositiveDecimal(
                      value, 'Approved Rate From'),
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: "Approved Rate To",
                  placeholder: "150",
                  controller: _approvedRateToController,
                  validator: (value) => ShopsRatingCardValidator.validatePositiveDecimal(
                      value, 'Approved Rate To'),
                ),
                LabeledTextField(
                  label: AppString.suggestedRate.localize(context)!,
                  placeholder: "135",
                  controller: _suggestedRateController,
                  validator: (value) => ShopsRatingCardValidator.validatePositiveDecimal(
                      value, 'Suggested Rate'),
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.notes.localize(context)!,
                  placeholder: "Additional notes or observations",
                  controller: _notesController,
                  validator: (value) => ShopsRatingCardValidator.validateOptionalTextWithLength(
                      value, 1000, 'Notes'),
                ),
              ]),
              _buildRow([
                CustomDropdownField(
                  label: AppString.selectWalls.localize(context)!,
                  items: widget.masterData.wallStructure,
                  initialValue: _wallType ?? (widget.masterData.wallStructure.isNotEmpty
                      ? widget.masterData.wallStructure.first
                      : null),
                  validator: (value) => ShopsRatingCardValidator.validateDropdown(
                      value, 'wall type'),
                  onChanged: (value) {
                    setState(() {
                      _wallType = value;
                    });
                  },
                ),
                CustomDropdownField(
                  label: AppString.floor.localize(context)!,
                  items: widget.masterData.floorStructure,
                  initialValue: _floorType ?? (widget.masterData.floorStructure.isNotEmpty
                      ? widget.masterData.floorStructure.first
                      : null),
                  validator: (value) => ShopsRatingCardValidator.validateDropdown(
                      value, 'floor type'),
                  onChanged: (value) {
                    setState(() {
                      _floorType = value;
                    });
                  },
                ),
              ]),
              _buildRow([
                CustomDropdownField(
                  label: AppString.conveniences.localize(context)!,
                  items: widget.masterData.conviences,
                  initialValue: _conveniences ?? (widget.masterData.conviences.isNotEmpty
                      ? widget.masterData.conviences.first
                      : null),
                  validator: (value) => ShopsRatingCardValidator.validateDropdown(
                      value, 'conveniences'),
                  onChanged: (value) {
                    setState(() {
                      _conveniences = value;
                    });
                  },
                ),
                // Intentionally static: No backend mapping for condition
                CustomDropdownField(
                  label: AppString.condition.localize(context)!,
                  items: [
                    "Select Condition",
                    "Excellent",
                    "Good",
                    "Fair",
                    "Poor"
                  ],
                  initialValue: _condition ?? "Select Condition",
                  validator: (value) => ShopsRatingCardValidator.validateDropdown(
                      value, 'condition'),
                  onChanged: (value) {
                    setState(() {
                      _condition = value;
                    });
                  },
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.age.localize(context)!,
                  placeholder: "Building age",
                  controller: _ageController,
                  validator: (value) => ShopsRatingCardValidator.validateAge(
                      value, 'Age'),
                ),
                // Intentionally static: No backend mapping for access
                CustomDropdownField(
                  label: AppString.access.localize(context)!,
                  items: ["Select Access", "Main Road", "Side Road", "Lane"],
                  initialValue: _accessType ?? "Select Access",
                  validator: (value) => ShopsRatingCardValidator.validateDropdown(
                      value, 'access'),
                  onChanged: (value) {
                    setState(() {
                      _accessType = value;
                    });
                  },
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.parkingSpace.localize(context)!,
                  placeholder: "Available parking spaces",
                  controller: _parkingSpaceController,
                  validator: (value) => ShopsRatingCardValidator.validateOptionalText(
                      value, 'Parking Space'),
                ),
                LabeledTextField(
                  label: AppString.wardNumber.localize(context)!,
                  placeholder: AppString.wardNumber.localize(context)!,
                  controller: _wardNumberController,
                  validator: (value) => ShopsRatingCardValidator.validateAlphaNumeric(
                      value, 'Ward Number'),
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.roadName.localize(context)!,
                  placeholder: AppString.roadName.localize(context)!,
                  controller: _roadNameController,
                  validator: (value) => ShopsRatingCardValidator.validateRequired(
                      value, 'Road Name'),
                ),
                LabeledTextField(
                  label: AppString.date.localize(context)!,
                  placeholder: AppString.date.localize(context)!,
                  controller: _dateController,
                  validator: (value) => ShopsRatingCardValidator.validateDate(
                      value, 'Date'),
                ),
              ]),
              _buildRow([
                Text(
                  'Shop Space Details',
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
                          label: "Shop Unit",
                          placeholder: "Enter shop unit details",
                          controller: _shopUnitController,
                          validator: (value) => ShopsRatingCardValidator.validateShopNumber(
                              value, 'Shop Unit'),
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
                  label: "Shop Floor Area",
                  placeholder: "Total shop area",
                  controller: _shopFloorAreaController,
                  validator: (value) => ShopsRatingCardValidator.validateFloorArea(
                      value, 'Shop Floor Area'),
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: "Storage Area",
                  placeholder: "Storage/back room area",
                  controller: _storageAreaController,
                  validator: (value) => ShopsRatingCardValidator.validateOptionalText(
                      value, 'Storage Area'),
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: "Monthly Turnover",
                  placeholder: "Average monthly sales",
                  controller: _monthlyTurnoverController,
                  validator: (value) => ShopsRatingCardValidator.validatePositiveDecimal(
                      value, 'Monthly Turnover'),
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.notes.localize(context)!,
                  placeholder: "Shop-specific notes and features",
                  controller: _shopNotesController,
                  validator: (value) => ShopsRatingCardValidator.validateOptionalTextWithLength(
                      value, 1000, 'Shop Notes'),
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
                            onPressed: _saveForm,
                            width: 120,
                            height: 48,
                          ),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Implement send functionality
                            debugPrint("Shops Rating Card sent");
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
}
