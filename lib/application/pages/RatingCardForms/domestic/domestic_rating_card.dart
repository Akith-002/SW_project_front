import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:land_asset_valuation/application/core/widgets/breadcrumb.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_app_bar.dart';
import 'package:land_asset_valuation/application/core/widgets/labeled_text_field.dart';
import 'package:land_asset_valuation/application/core/widgets/labeled_date_field.dart';
import 'package:land_asset_valuation/application/core/widgets/labeled_numeric_field.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_dropdown_field.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_button.dart';
import 'package:land_asset_valuation/application/core/widgets/saved_succesfully_dialogbox.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/pages/RatingCardForms/domestic/cubit/domestic_rating_card_cubit.dart';
import 'package:land_asset_valuation/application/core/validators/domestic_rating_card_validator.dart';
import 'package:land_asset_valuation/data/models/domestic_rating_card_model.dart';
import 'package:land_asset_valuation/injection.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:land_asset_valuation/application/core/router/pages.dart';
import 'package:land_asset_valuation/data/models/master_data_model.dart';

class DomesticRatingCard extends StatefulWidget {
  final int assetId;
  final MasterDataResponse masterData;
  final String? assetNo;
  final String? requestType;
  final String? ratingReferenceNo;

  const DomesticRatingCard({
    super.key,
    required this.assetId,
    required this.masterData,
    this.assetNo,
    this.requestType,
    this.ratingReferenceNo,
  });

  @override
  State<DomesticRatingCard> createState() => _DomesticRatingCardState();
}

class _DomesticRatingCardState extends State<DomesticRatingCard> {
  final _cubit = injection<DomesticRatingCardCubit>();
  final _formKey = GlobalKey<FormState>();

  // Text controllers
  final _newNumberController = TextEditingController();
  final _ownerController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _ageController = TextEditingController();
  final _tsBopController = TextEditingController();
  final _parkingSpaceController = TextEditingController();
  final _plantationsController = TextEditingController();
  final _wardNumberController = TextEditingController();
  final _roadNameController = TextEditingController();
  final _dateController = TextEditingController();
  final _occupierController = TextEditingController();
  final _rentPMController = TextEditingController();
  final _termsController = TextEditingController();
  final _suggestedRateController = TextEditingController();
  final _notesController = TextEditingController();

  // Dropdown values
  String? _selectedWalls;
  String? _selectedFloor;
  String? _selectedConveniences;
  String? _selectedCondition;
  String? _selectedAccess;
  String? _selectedPropertySubCategory;
  String? _selectedPropertyType;

  @override
  void initState() {
    super.initState();
    _cubit.loadAutofillData(widget.assetId);
    
    // Debug: Print the values being passed
    debugPrint('DomesticRatingCard - requestType: ${widget.requestType}');
    debugPrint('DomesticRatingCard - ratingReferenceNo: ${widget.ratingReferenceNo}');
    debugPrint('DomesticRatingCard - assetNo: ${widget.assetNo}');
  }

  @override
  void dispose() {
    _newNumberController.dispose();
    _ownerController.dispose();
    _descriptionController.dispose();
    _ageController.dispose();
    _tsBopController.dispose();
    _parkingSpaceController.dispose();
    _plantationsController.dispose();
    _wardNumberController.dispose();
    _roadNameController.dispose();
    _dateController.dispose();
    _occupierController.dispose();
    _rentPMController.dispose();
    _termsController.dispose();
    _suggestedRateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _fillAutofillData(dynamic autofillData) {
    setState(() {
      _ownerController.text = autofillData.owner ?? '';
      _descriptionController.text = autofillData.description ?? '';
      _newNumberController.text = autofillData.newNumber ?? '';
    });
  }

  void _saveForm() {
    // Collect all validation errors
    List<String> validationErrors = []; // Validate dropdown fields
    if (_selectedWalls == null || _selectedWalls == "Select Wall Type") {
      validationErrors.add('Wall Type is required');
    }
    if (_selectedFloor == null || _selectedFloor == "Select Floor Type") {
      validationErrors.add('Floor Type is required');
    }
    if (_selectedConveniences == null ||
        _selectedConveniences == "Select Conveniences") {
      validationErrors.add('Conveniences is required');
    }
    if (_selectedCondition == null ||
        _selectedCondition == "Select Condition") {
      validationErrors.add('Condition is required');
    }
    if (_selectedAccess == null || _selectedAccess == "Select Access Type") {
      validationErrors.add('Access Type is required');
    }
    if (_selectedPropertySubCategory == null ||
        _selectedPropertySubCategory == "Select Property Sub Category") {
      validationErrors.add('Property Sub Category is required');
    }
    if (_selectedPropertyType == null ||
        _selectedPropertyType == "Select Property Type") {
      validationErrors.add('Property Type is required');
    } // Validate text fields using the validator
    final ageValidation =
        DomesticRatingCardValidator.validateAge(_ageController.text, 'Age');
    if (ageValidation != null) validationErrors.add(ageValidation);

    final roadNameValidation =
        DomesticRatingCardValidator.validateRequiredTextWithLength(
            _roadNameController.text, 100, 'Road Name');
    if (roadNameValidation != null) validationErrors.add(roadNameValidation);

    final dateValidation =
        DomesticRatingCardValidator.validateDate(_dateController.text, 'Date');
    if (dateValidation != null) validationErrors.add(dateValidation);

    final rentValidation = DomesticRatingCardValidator.validatePositiveDecimal(
        _rentPMController.text, 'Rent Per Month');
    if (rentValidation != null) validationErrors.add(rentValidation);

    final suggestedRateValidation =
        DomesticRatingCardValidator.validatePositiveDecimal(
            _suggestedRateController.text, 'Suggested Rate');
    if (suggestedRateValidation != null) {
      validationErrors.add(suggestedRateValidation);
    }

    // Check if form validation passes and no manual validation errors
    final isFormValid = _formKey.currentState?.validate() ?? false;

    if (!isFormValid || validationErrors.isNotEmpty) {
      // Show validation error snack bar
      _showValidationErrorSnackBar(validationErrors);
      return;
    }

    // Parse the date from the controller text
    DateTime parseDate() {
      if (_dateController.text.isNotEmpty) {
        try {
          return DateTime.parse(_dateController.text);
        } catch (e) {
          return DateTime.now();
        }
      }
      return DateTime.now();
    }

    final ratingCard = DomesticRatingCardModel(
      assetId: widget.assetId,
      newNumber: _newNumberController.text.trim(),
      owner: _ownerController.text.trim(),
      description: _descriptionController.text.trim(),
      selectWalls: _selectedWalls ?? '',
      floor: _selectedFloor ?? '',
      conveniences: _selectedConveniences ?? '',
      condition: _selectedCondition ?? '',
      age: int.tryParse(_ageController.text) ?? 0,
      access: _selectedAccess ?? '',
      tsBop: _tsBopController.text.trim(),
      parkingSpace: _parkingSpaceController.text.trim(),
      propertySubCategory: _selectedPropertySubCategory ?? '',
      propertyType: _selectedPropertyType ?? '',
      plantations: _plantationsController.text.trim(),
      wardNumber: _wardNumberController.text.trim(),
      roadName: _roadNameController.text.trim(),
      date: parseDate(),
      occupier: _occupierController.text.trim(),
      rentPM: double.tryParse(_rentPMController.text) ?? 0.0,
      terms: _termsController.text.trim(),
      suggestedRate: double.tryParse(_suggestedRateController.text) ?? 0.0,
      notes: _notesController.text.trim(),
    );

    _cubit.saveRatingCard(ratingCard);
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
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        action: SnackBarAction(
          label: 'DISMISS',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: SavedMessageCard(
            onClose: () {
              debugPrint('Success dialog onClose called');
              debugPrint('Widget requestType: ${widget.requestType}');
              
              Navigator.of(dialogContext).pop(); // Close dialog
              
              // Navigate back to the assets list with proper parameters
              if (widget.requestType != null && widget.requestType!.isNotEmpty) {
                String route;
                String source = 'massRating';
                
                switch (widget.requestType) {
                  case 'MR':
                    route = Pages.routeMrAssetsList.toPathName();
                    source = 'massRating';
                    break;
                  case 'RA':
                    route = Pages.routeRaAssetsList.toPathName();
                    source = 'ratingAssessment';
                    break;
                  case 'RB':
                    route = Pages.routeRbAssetsList.toPathName();
                    source = 'ratingBuilding';
                    break;
                  case 'RO':
                    route = Pages.routeRoAssetsList.toPathName();
                    source = 'ratingObject';
                    break;
                  default:
                    route = Pages.routeMrAssetsList.toPathName();
                    source = 'massRating';
                }
                
                // Get the requestId from the current route
                final currentRequestId = GoRouterState.of(context).uri.queryParameters['requestId'];
                
                debugPrint('Navigating to route: $route');
                debugPrint('With source: $source');
                debugPrint('With requestId: $currentRequestId');
                
                context.goNamed(
                  route,
                  queryParameters: {
                    'source': source,
                    if (currentRequestId != null) 'requestId': currentRequestId,
                  },
                );
              } else {
                // If no request type, navigate to MR assets list
                debugPrint('No request type, navigating to default MR assets list');
                
                // Get the requestId from the current route
                final currentRequestId = GoRouterState.of(context).uri.queryParameters['requestId'];
                
                context.goNamed(
                  Pages.routeMrAssetsList.toPathName(),
                  queryParameters: {
                    'source': 'massRating',
                    if (currentRequestId != null) 'requestId': currentRequestId,
                  },
                );
              }
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubit,
      child: BlocListener<DomesticRatingCardCubit, DomesticRatingCardState>(
        listener: (context, state) {
          if (state is DomesticRatingCardAutofillLoaded) {
            _fillAutofillData(state.autofillData);
          } else if (state is DomesticRatingCardSaved) {
            _showSuccessDialog();
          } else if (state is DomesticRatingCardError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        child: Scaffold(
          appBar: CustomAppBar(
            title: 'Rating Card-Domestic',
            leftIcon: (style) => PhosphorIcons.pencilRuler(),
            onLeftIconPressed: () {},
            rightIcon1: (style) => PhosphorIcons.bell(style),
            onRightIcon1Pressed: () {},
            rightIcon2: (style) => PhosphorIcons.user(style),
            onRightIcon2Pressed: () {},
          ),
          body: BlocBuilder<DomesticRatingCardCubit, DomesticRatingCardState>(
            builder: (context, state) {
              if (state is DomesticRatingCardLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              return LayoutBuilder(builder: (context, constraints) {
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 0),
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
                              BreadcrumbItem(label: "Domestic - Rating Card"),
                            ],
                          ),
                        ),
                        _buildRow([
                          _buildReadOnlyField(
                            label: AppString.newNumber.localize(context)!,
                            controller: _newNumberController,
                          ),
                          _buildReadOnlyField(
                            label: AppString.owner.localize(context)!,
                            controller: _ownerController,
                          ),
                        ]),
                        _buildRow([
                          _buildReadOnlyField(
                            label: AppString.description.localize(context)!,
                            controller: _descriptionController,
                          ),
                          CustomDropdownField(
                            label: AppString.selectWalls.localize(context)!,
                            items: widget.masterData.wallStructure,
                            initialValue: _selectedWalls ??
                                (widget.masterData.wallStructure.isNotEmpty
                                    ? widget.masterData.wallStructure.first
                                    : null),
                            onChanged: (value) {
                              setState(() {
                                _selectedWalls = value ==
                                        (widget.masterData.wallStructure
                                                .isNotEmpty
                                            ? widget
                                                .masterData.wallStructure.first
                                            : null)
                                    ? null
                                    : value;
                              });
                            },
                            validator: (value) =>
                                DomesticRatingCardValidator.validateDropdown(
                                    value, 'Wall Type'),
                          ),
                        ]),
                        _buildRow([
                          CustomDropdownField(
                            label: AppString.floor.localize(context)!,
                            items: widget.masterData.floorStructure,
                            initialValue: _selectedFloor ??
                                (widget.masterData.floorStructure.isNotEmpty
                                    ? widget.masterData.floorStructure.first
                                    : null),
                            onChanged: (value) {
                              setState(() {
                                _selectedFloor = value ==
                                        (widget.masterData.floorStructure
                                                .isNotEmpty
                                            ? widget
                                                .masterData.floorStructure.first
                                            : null)
                                    ? null
                                    : value;
                              });
                            },
                            validator: (value) =>
                                DomesticRatingCardValidator.validateDropdown(
                                    value, 'Floor Type'),
                          ),
                          CustomDropdownField(
                            label: AppString.conveniences.localize(context)!,
                            items: widget.masterData.conviences,
                            initialValue: _selectedConveniences ??
                                (widget.masterData.conviences.isNotEmpty
                                    ? widget.masterData.conviences.first
                                    : null),
                            onChanged: (value) {
                              setState(() {
                                _selectedConveniences = value ==
                                        (widget.masterData.conviences.isNotEmpty
                                            ? widget.masterData.conviences.first
                                            : null)
                                    ? null
                                    : value;
                              });
                            },
                            validator: (value) =>
                                DomesticRatingCardValidator.validateDropdown(
                                    value, 'Conveniences'),
                          ),
                        ]),
                        _buildRow([
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
                            initialValue:
                                _selectedCondition ?? "Select Condition",
                            onChanged: (value) {
                              setState(() {
                                _selectedCondition =
                                    value == "Select Condition" ? null : value;
                              });
                            },
                            validator: (value) =>
                                DomesticRatingCardValidator.validateDropdown(
                                    value, 'Condition'),
                          ),
                          LabeledNumericField(
                            label: AppString.age.localize(context)!,
                            placeholder: "Enter age in years",
                            controller: _ageController,
                            validator: (value) =>
                                DomesticRatingCardValidator.validateAge(
                                    value, 'Age'),
                          ),
                        ]),
                        _buildRow([
                          CustomDropdownField(
                            label: AppString.access.localize(context)!,
                            items: [
                              "Select Access Type",
                              "Main Road",
                              "Side Road",
                              "Lane",
                              "Private Road"
                            ],
                            initialValue:
                                _selectedAccess ?? "Select Access Type",
                            onChanged: (value) {
                              setState(() {
                                _selectedAccess = value == "Select Access Type"
                                    ? null
                                    : value;
                              });
                            },
                            validator: (value) =>
                                DomesticRatingCardValidator.validateDropdown(
                                    value, 'Access Type'),
                          ),
                          LabeledTextField(
                            label: AppString.tsBop.localize(context)!,
                            placeholder: AppString.tsBop.localize(context)!,
                            controller: _tsBopController,
                            validator: (value) => DomesticRatingCardValidator
                                .validateOptionalTextWithLength(
                                    value, 100, 'TS/BOP'),
                          ),
                        ]),
                        _buildRow([
                          LabeledTextField(
                            label: AppString.parkingSpace.localize(context)!,
                            placeholder:
                                AppString.parkingSpace.localize(context)!,
                            controller: _parkingSpaceController,
                            validator: (value) => DomesticRatingCardValidator
                                .validateOptionalTextWithLength(
                                    value, 100, 'Parking Space'),
                          ),
                          CustomDropdownField(
                            label: AppString.propertySubCategory
                                .localize(context)!,
                            items: [
                              "Select Property Sub Category",
                              "Villa",
                              "Apartment",
                              "Townhouse",
                              "Bungalow"
                            ],
                            initialValue: _selectedPropertySubCategory ??
                                "Select Property Sub Category",
                            onChanged: (value) {
                              setState(() {
                                _selectedPropertySubCategory =
                                    value == "Select Property Sub Category"
                                        ? null
                                        : value;
                              });
                            },
                            validator: (value) =>
                                DomesticRatingCardValidator.validateDropdown(
                                    value, 'Property Sub Category'),
                          ),
                        ]),
                        _buildRow([
                          // Intentionally static: No backend mapping for property type
                          CustomDropdownField(
                            label: AppString.propertyType.localize(context)!,
                            items: [
                              "Select Property Type",
                              "Single Family Home",
                              "Apartment/Condominium"
                            ],
                            initialValue:
                                _selectedPropertyType ?? "Select Property Type",
                            onChanged: (value) {
                              setState(() {
                                _selectedPropertyType =
                                    value == "Select Property Type"
                                        ? null
                                        : value;
                              });
                            },
                            validator: (value) =>
                                DomesticRatingCardValidator.validateDropdown(
                                    value, 'Property Type'),
                          ),
                          LabeledTextField(
                            label: "Plantations",
                            placeholder: "Enter plantations",
                            controller: _plantationsController,
                            validator: (value) => DomesticRatingCardValidator
                                .validateOptionalTextWithLength(
                                    value, 200, 'Plantations'),
                          ),
                        ]),
                        _buildRow([
                          LabeledTextField(
                            label: AppString.wardNumber.localize(context)!,
                            placeholder:
                                AppString.wardNumber.localize(context)!,
                            controller: _wardNumberController,
                            validator: (value) => DomesticRatingCardValidator
                                .validateOptionalTextWithLength(
                                    value, 50, 'Ward Number'),
                          ),
                          LabeledTextField(
                            label: AppString.roadName.localize(context)!,
                            placeholder: AppString.roadName.localize(context)!,
                            controller: _roadNameController,
                            validator: (value) => DomesticRatingCardValidator
                                .validateRequiredTextWithLength(
                                    value, 100, 'Road Name'),
                          ),
                        ]),
                        _buildRow([
                          LabeledDateField(
                            label: AppString.date.localize(context)!,
                            placeholder: "Select date",
                            controller: _dateController,
                            validator: (value) =>
                                DomesticRatingCardValidator.validateDate(
                                    value, 'Date'),
                          ),
                          LabeledTextField(
                            label: AppString.occupier.localize(context)!,
                            placeholder: AppString.occupier.localize(context)!,
                            controller: _occupierController,
                            validator: (value) => DomesticRatingCardValidator
                                .validateOptionalTextWithLength(
                                    value, 100, 'Occupier'),
                          ),
                        ]),
                        _buildRow([
                          LabeledNumericField(
                            label: AppString.rentPM.localize(context)!,
                            placeholder: "Enter rent per month",
                            controller: _rentPMController,
                            allowDecimals: true,
                            validator: (value) => DomesticRatingCardValidator
                                .validatePositiveDecimal(
                                    value, 'Rent Per Month'),
                          ),
                          LabeledTextField(
                            label: AppString.terms.localize(context)!,
                            placeholder: AppString.terms.localize(context)!,
                            controller: _termsController,
                            validator: (value) => DomesticRatingCardValidator
                                .validateOptionalTextWithLength(
                                    value, 200, 'Terms'),
                          ),
                        ]),
                        SizedBox(height: 16),
                        _buildRow([
                          LabeledNumericField(
                            label: AppString.suggestedRate.localize(context)!,
                            placeholder: "Enter suggested rate",
                            controller: _suggestedRateController,
                            allowDecimals: true,
                            validator: (value) => DomesticRatingCardValidator
                                .validatePositiveDecimal(
                                    value, 'Suggested Rate'),
                          ),
                        ]),
                        _buildRow([
                          LabeledTextField(
                            label: AppString.notes.localize(context)!,
                            placeholder: AppString.notes.localize(context)!,
                            controller: _notesController,
                            validator: (value) => DomesticRatingCardValidator
                                .validateOptionalTextWithLength(
                                    value, 500, 'Notes'),
                          ),
                        ]), // Save & Cancel Buttons
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
                                      backgroundColor:
                                          colors(context).colorPrimary1!,
                                      onPressed: _saveForm,
                                      width: 120,
                                      height: 48,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      // TODO: Implement send functionality
                                      debugPrint("Domestic Rating Card sent");
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      backgroundColor:
                                          colors(context).colorPrimary5!,
                                      foregroundColor:
                                          colors(context).colorWhite,
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
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
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
              });
            },
          ),
        ),
      ),
    );
  }

  // Helper method to create rows of input fields
  Widget _buildRow(List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(child: children[0]),
          if (children.length > 1) ...[
            SizedBox(width: 16),
            Expanded(child: children[1]),
          ],
        ],
      ),
    );
  }

  // Helper method to create read-only fields for autofilled data
  Widget _buildReadOnlyField({
    required String label,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            '$label ',
            style: TextStyle(
              color: colors(context).labelTextColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        Container(
          width: 484,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colors(context).colorGrey5!,
              width: 1.5,
            ),
            color: colors(context).colorGrey1,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  enabled: false,
                  style: TextStyle(
                    color: colors(context).colorGrey6,
                    fontSize: 14,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              Icon(
                Icons.lock,
                color: colors(context).colorGrey5,
                size: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
