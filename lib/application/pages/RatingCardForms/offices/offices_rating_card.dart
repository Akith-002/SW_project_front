import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:land_asset_valuation/application/core/widgets/breadcrumb.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_app_bar.dart';
import 'package:land_asset_valuation/application/core/widgets/labeled_text_field.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_dropdown_field.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_button.dart';
import 'package:land_asset_valuation/application/core/widgets/saved_succesfully_dialogbox.dart'; // SavedMessageCard
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/pages/RatingCardForms/offices/cubit/offices_rating_card_cubit.dart';
import 'package:land_asset_valuation/application/core/validators/offices_rating_card_validator.dart';
import 'package:land_asset_valuation/data/models/offices_rating_card_model.dart';
import 'package:land_asset_valuation/injection.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:land_asset_valuation/application/core/router/pages.dart';
import 'package:land_asset_valuation/data/models/master_data_model.dart';

class OfficesRatingCard extends StatefulWidget {
  final int assetId;
  final MasterDataResponse masterData;
  
  const OfficesRatingCard({
    super.key,
    required this.assetId,
    required this.masterData,
  });

  @override
  State<OfficesRatingCard> createState() => _OfficesRatingCardState();
}

class _OfficesRatingCardState extends State<OfficesRatingCard> {
  final _cubit = injection<OfficesRatingCardCubit>();
  final _formKey = GlobalKey<FormState>();

  // Helper method to transform mock data to meaningful office data
  List<String> _transformMockData(List<String> items, String category) {
    if (items.isEmpty) return [];
    
    // Map mock data to meaningful office-related values
    switch (category) {
      case 'wall':
        return ['Select Wall Type', 'Glass Curtain Wall', 'Concrete Block', 'Drywall Partition', 'Brick Veneer'];
      case 'floor':
        return ['Select Floor Type', 'Polished Concrete', 'Hardwood', 'Carpet Tiles', 'Vinyl Plank'];
      case 'conveniences':
        return ['Select Conveniences', 'Central AC', 'Elevators', 'Security System', 'Parking Garage'];
      default:
        return items;
    }
  }

  // Text controllers
  final _localAuthorityController = TextEditingController();
  final _localAuthorityCodeController = TextEditingController();
  final _assessmentNumberController = TextEditingController();
  final _newNumberController = TextEditingController();
  final _obsoleteNumberController = TextEditingController();
  final _ownerController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _ageController = TextEditingController();
  final _floorNumberController = TextEditingController();
  final _wardNumberController = TextEditingController();
  final _roadNameController = TextEditingController();
  final _dateController = TextEditingController();
  final _occupierController = TextEditingController();
  final _rentPMController = TextEditingController();
  final _termsController = TextEditingController();
  final _ceilingHeightController = TextEditingController();
  final _suggestedRateController = TextEditingController();
  final _notesController = TextEditingController();

  // Dropdown values
  String? _buildingSelection;
  String? _wallType;
  String? _floorType;
  String? _conveniences;
  String? _condition;
  String? _accessType;
  String? _propertySubCategory;
  String? _propertyType;

  // Additional text controllers
  final _officeSuiteController = TextEditingController();
  final _totalAreaController = TextEditingController();
  final _usableFloorAreaController = TextEditingController();
  final _officeGradeController = TextEditingController();
  final _parkingSpaceController = TextEditingController();
  
  // List to store office suite tags
  List<String> _officeSuiteTags = [];

  @override
  void initState() {
    super.initState();
    _cubit.loadAutofillData(widget.assetId);
  }

  @override
  void dispose() {
    _localAuthorityController.dispose();
    _localAuthorityCodeController.dispose();
    _assessmentNumberController.dispose();
    _newNumberController.dispose();
    _obsoleteNumberController.dispose();
    _ownerController.dispose();
    _descriptionController.dispose();
    _ageController.dispose();
    _floorNumberController.dispose();
    _wardNumberController.dispose();
    _roadNameController.dispose();
    _dateController.dispose();
    _occupierController.dispose();
    _rentPMController.dispose();
    _termsController.dispose();
    _ceilingHeightController.dispose();
    _suggestedRateController.dispose();
    _notesController.dispose();
    _officeSuiteController.dispose();
    _totalAreaController.dispose();
    _usableFloorAreaController.dispose();
    _officeGradeController.dispose();
    _parkingSpaceController.dispose();
    super.dispose();
  }

  void _fillAutofillData(dynamic autofillData) {
    setState(() {
      _ownerController.text = autofillData.owner ?? '';
      _descriptionController.text = autofillData.description ?? '';
      _newNumberController.text = autofillData.newNumber ?? '';
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: SavedMessageCard(
            onClose: () {
              Navigator.of(context).pop(); // Close dialog
              // Navigate back to the dashboard or MR assets list with proper parameters
              final source = 'ratingObject'; // For offices rating card
              
              // Try to get requestId from current route or use default
              final currentRoute = GoRouterState.of(context);
              final requestIdStr = currentRoute.uri.queryParameters['requestId'];
              final requestId = requestIdStr != null ? int.tryParse(requestIdStr) : 1;
              
              context.go('${Pages.routeMrAssetsList.toPath()}?source=$source&requestId=$requestId');
            },
          ),
        );
      },
    );
  }

  void _showValidationError(List<String> errors) {
    if (errors.isEmpty) {
      _showValidationErrorMessage(
          'Please fill in all required fields correctly');
      return;
    }

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

  void _showValidationErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: colors(context).colorNegative1,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: colors(context).colorPrimary1!,
              onPrimary: colors(context).colorWhite!,
              onSurface: colors(context).colorBlack!,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateController.text = picked.toIso8601String().split('T')[0];
      });
    }
  }

  void _saveForm() {
    // Validate form first
    final isFormValid = _formKey.currentState?.validate() ?? false;

    // Collect validation errors for dropdowns and required fields
    final List<String> validationErrors = [];

    // Check required fields that are now read-only but must have values
    if (_ownerController.text.trim().isEmpty) {
      validationErrors.add('Owner is required');
    }
    if (_descriptionController.text.trim().isEmpty) {
      validationErrors.add('Description is required');
    }

    // Validate dropdown selections
    if (_buildingSelection == null || _buildingSelection == "Select Building") {
      validationErrors.add('Please select a Building');
    }
    if (_wallType == null || _wallType!.startsWith('Select')) {
      validationErrors.add('Please select Wall Type');
    }
    if (_floorType == null || _floorType!.startsWith('Select')) {
      validationErrors.add('Please select Floor Type');
    }
    if (_conveniences == null || _conveniences!.startsWith('Select')) {
      validationErrors.add('Please select Conveniences');
    }
    if (_condition == null || _condition == "Select Condition") {
      validationErrors.add('Please select Condition');
    }
    if (_accessType == null || _accessType == "Select Access") {
      validationErrors.add('Please select Access Type');
    }
    if (_propertySubCategory == null ||
        _propertySubCategory == "Select Property Sub Category") {
      validationErrors.add('Please select Property Sub Category');
    }
    if (_propertyType == null || _propertyType == "Select Property Type") {
      validationErrors.add('Please select Property Type');
    }

    if (!isFormValid || validationErrors.isNotEmpty) {
      _showValidationError(validationErrors);
      return;
    }

    // Parse the date from the controller text
    DateTime parseDate() {
      if (_dateController.text.isNotEmpty) {
        try {
          // Parse the date and convert to UTC
          final date = DateTime.parse(_dateController.text);
          return DateTime.utc(date.year, date.month, date.day);
        } catch (e) {
          return DateTime.now().toUtc();
        }
      }
      return DateTime.now().toUtc();
    }

    final ratingCard = OfficesRatingCardModel(
      assetId: widget.assetId,
      buildingSelection: _buildingSelection ?? '',
      localAuthority: _localAuthorityController.text.trim(),
      localAuthorityCode: _localAuthorityCodeController.text.trim(),
      assessmentNumber: _assessmentNumberController.text.trim(),
      newNumber: _newNumberController.text.trim(),
      obsoleteNumber: _obsoleteNumberController.text.trim(),
      owner: _ownerController.text.trim(),
      description: _descriptionController.text.trim(),
      wallType: _wallType ?? '',
      floorType: _floorType ?? '',
      conveniences: _conveniences ?? '',
      condition: _condition ?? '',
      age: int.tryParse(_ageController.text) ?? 0,
      accessType: _accessType ?? '',
      officeGrade: _officeGradeController.text.trim(),
      parkingSpace: _parkingSpaceController.text.trim(),
      propertySubCategory: _propertySubCategory ?? '',
      propertyType: _propertyType ?? '',
      wardNumber: int.tryParse(_wardNumberController.text) ?? 0,
      roadName: _roadNameController.text.trim(),
      date: parseDate(),
      occupier: _occupierController.text.trim(),
      rentPM: double.tryParse(_rentPMController.text) ?? 0.0,
      terms: _termsController.text.trim(),
      floorNumber: int.tryParse(_floorNumberController.text) ?? 0,
      ceilingHeight: double.tryParse(_ceilingHeightController.text) ?? 0.0,
      officeSuite: _officeSuiteTags.join(', '), // Join all tags with comma
      totalArea: double.tryParse(_totalAreaController.text) ?? 0.0,
      usableFloorArea: double.tryParse(_usableFloorAreaController.text) ?? 0.0,
      suggestedRate: double.tryParse(_suggestedRateController.text) ?? 0.0,
      notes: _notesController.text.trim(),
    );

    _cubit.saveRatingCard(ratingCard);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<OfficesRatingCardCubit, OfficesRatingCardState>(
        listener: (context, state) {
          if (state is OfficesRatingCardAutofillLoaded) {
            _fillAutofillData(state.autofillData);
          } else if (state is OfficesRatingCardSaved) {
            _showSuccessDialog();
          } else if (state is OfficesRatingCardError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: colors(context).colorNegative1,
              ),
            );
          }
        },
        child: Scaffold(
      appBar: CustomAppBar(
        title: 'Rating Card-Offices',
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 0),
                    child: Breadcrumb(
                      items: [
                        BreadcrumbItem(label: "Mass Rating"),
                        BreadcrumbItem(label: "Rating Card - Offices"),
                      ],
                    ),
                  ),
                  _buildRow([
                    _buildReadOnlyField(
                      context: context,
                      label: AppString.newNumber.localize(context)!,
                      controller: _newNumberController,
                      isAutoFilled: true,
                    ),
                     _buildReadOnlyField(
                      context: context,
                      label: AppString.owner.localize(context)!,
                      controller: _ownerController,
                      isAutoFilled: true,
                    ),
                 
                  ]),
                  _buildRow([
                    _buildReadOnlyField(
                      context: context,
                      label: AppString.description.localize(context)!,
                      controller: _descriptionController,
                      isAutoFilled: true,
                    ),
                    // Intentionally static: No backend mapping for building list
                    CustomDropdownField(
                      label: AppString.selectBuilding.localize(context)!,
                      items: [
                        "Select Building",
                        "Office Complex A",
                        "Office Tower B",
                        "Business Center C"
                      ],
                      initialValue: _buildingSelection ?? "Select Building",
                      validator: (value) =>
                          OfficesRatingCardValidator.validateDropdown(
                              value, 'building'),
                      onChanged: (value) {
                        setState(() {
                          _buildingSelection = value;
                        });
                      },
                    ),
                  ]),
                  _buildRow([
                       LabeledTextField(
                      label: AppString.localAuthority.localize(context)!,
                      placeholder: AppString.localAuthority.localize(context)!,
                      controller: _localAuthorityController,
                      validator: (value) =>
                          OfficesRatingCardValidator.validateRequired(
                              value, 'Local Authority'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    LabeledTextField(
                      label: AppString.localAuthorityCode.localize(context)!,
                      placeholder: "123456789",
                      controller: _localAuthorityCodeController,
                      validator: (value) =>
                          OfficesRatingCardValidator.validateAlphaNumeric(
                              value, 'Local Authority Code'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                  ]),
                  _buildRow([

                    LabeledTextField(
                      label: AppString.assessmentNumber.localize(context)!,
                      placeholder:
                          AppString.assessmentNumber.localize(context)!,
                      controller: _assessmentNumberController,
                      validator: (value) =>
                          OfficesRatingCardValidator.validateAlphaNumeric(
                              value, 'Assessment Number'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),                    LabeledTextField(
                      label: AppString.obsoleteNumber.localize(context)!,
                      placeholder: AppString.obsoleteNumber.localize(context)!,
                      controller: _obsoleteNumberController,
                      validator: (value) =>
                          OfficesRatingCardValidator.validateOptionalText(
                              value, 'Obsolete Number'),
                    ),
                  ]),
           
                  _buildRow([
                    CustomDropdownField(
                      label: AppString.selectWalls.localize(context)!,
                      items: _transformMockData(widget.masterData.wallStructure, 'wall'),
                      initialValue: _wallType ??
                          (_transformMockData(widget.masterData.wallStructure, 'wall').isNotEmpty
                              ? _transformMockData(widget.masterData.wallStructure, 'wall').first
                              : null),
                      validator: (value) =>
                          OfficesRatingCardValidator.validateDropdown(
                              value, 'wall type'),
                      onChanged: (value) {
                        setState(() {
                          _wallType = value;
                        });
                      },
                    ),
                    CustomDropdownField(
                      label: AppString.floor.localize(context)!,
                      items: _transformMockData(widget.masterData.floorStructure, 'floor'),
                      initialValue: _floorType ??
                          (_transformMockData(widget.masterData.floorStructure, 'floor').isNotEmpty
                              ? _transformMockData(widget.masterData.floorStructure, 'floor').first
                              : null),
                      validator: (value) =>
                          OfficesRatingCardValidator.validateDropdown(
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
                      items: _transformMockData(widget.masterData.conviences, 'conveniences'),
                      initialValue: _conveniences ??
                          (_transformMockData(widget.masterData.conviences, 'conveniences').isNotEmpty
                              ? _transformMockData(widget.masterData.conviences, 'conveniences').first
                              : null),
                      validator: (value) =>
                          OfficesRatingCardValidator.validateDropdown(
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
                      validator: (value) =>
                          OfficesRatingCardValidator.validateDropdown(
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
                      placeholder: AppString.age.localize(context)!,
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                      validator: (value) =>
                          OfficesRatingCardValidator.validateAge(value, 'Age'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    // Intentionally static: No backend mapping for access
                    CustomDropdownField(
                      label: AppString.access.localize(context)!,
                      items: [
                        "Select Access",
                        "Main Road",
                        "Business District",
                        "Highway"
                      ],
                      initialValue: _accessType ?? "Select Access",
                      validator: (value) =>
                          OfficesRatingCardValidator.validateDropdown(
                              value, 'access type'),
                      onChanged: (value) {
                        setState(() {
                          _accessType = value;
                        });
                      },
                    ),
                  ]),
                  _buildRow([
                    LabeledTextField(
                      label: "Office Grade",
                      placeholder: "Grade A/B/C",
                      controller: _officeGradeController,
                      validator: (value) =>
                          OfficesRatingCardValidator.validateRequired(
                              value, 'Office Grade'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    LabeledTextField(
                      label: AppString.parkingSpace.localize(context)!,
                      placeholder: AppString.parkingSpace.localize(context)!,
                      controller: _parkingSpaceController,
                      validator: (value) =>
                          OfficesRatingCardValidator.validateOptionalText(
                              value, 'Parking Space'),
                    ),
                  ]),
                  _buildRow([
                    // Intentionally static: No backend mapping for property subcategory
                    CustomDropdownField(
                      label: AppString.propertySubCategory.localize(context)!,
                      items: [
                        "Select Property Sub Category",
                        "Commercial Office",
                        "Executive Suite",
                        "Coworking Space"
                      ],
                      initialValue: _propertySubCategory ??
                          "Select Property Sub Category",
                      validator: (value) =>
                          OfficesRatingCardValidator.validateDropdown(
                              value, 'property sub category'),
                      onChanged: (value) {
                        setState(() {
                          _propertySubCategory = value;
                        });
                      },
                    ),
                    // Intentionally static: No backend mapping for property type
                    CustomDropdownField(
                      label: AppString.propertyType.localize(context)!,
                      items: [
                        "Select Property Type",
                        "Office Building",
                        "Mixed Use Commercial"
                      ],
                      initialValue: _propertyType ?? "Select Property Type",
                      validator: (value) =>
                          OfficesRatingCardValidator.validateDropdown(
                              value, 'property type'),
                      onChanged: (value) {
                        setState(() {
                          _propertyType = value;
                        });
                      },
                    ),
                  ]),
                  _buildRow([
                    LabeledTextField(
                      label: AppString.wardNumber.localize(context)!,
                      placeholder: AppString.wardNumber.localize(context)!,
                      controller: _wardNumberController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(5),
                      ],
                      validator: (value) =>
                          OfficesRatingCardValidator.validatePositiveInteger(
                              value, 'Ward Number'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    LabeledTextField(
                      label: AppString.roadName.localize(context)!,
                      placeholder: AppString.roadName.localize(context)!,
                      controller: _roadNameController,
                      validator: (value) =>
                          OfficesRatingCardValidator.validateRequired(
                              value, 'Road Name'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                  ]),
                  _buildRow([
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            AppString.date.localize(context)!,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: colors(context).colorBlack,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _selectDate(context),
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: _dateController,
                              decoration: InputDecoration(
                                hintText: 'Select date',
                                filled: true,
                                fillColor: colors(context).colorWhite,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: colors(context).colorGrey3!,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: colors(context).colorGrey3!,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: colors(context).colorPrimary1!,
                                    width: 2,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: colors(context).colorNegative1!,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: colors(context).colorNegative1!,
                                    width: 2,
                                  ),
                                ),
                                suffixIcon: Icon(
                                  PhosphorIcons.calendar(),
                                  color: colors(context).colorGrey5,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                              validator: (value) =>
                                  OfficesRatingCardValidator.validateDate(
                                      value, 'Date'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    LabeledTextField(
                      label: AppString.occupier.localize(context)!,
                      placeholder: AppString.occupier.localize(context)!,
                      controller: _occupierController,
                      validator: (value) =>
                          OfficesRatingCardValidator.validateRequired(
                              value, 'Occupier'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                  ]),
                  _buildRow([
                    LabeledTextField(
                      label: AppString.rentPM.localize(context)!,
                      placeholder: AppString.rentPM.localize(context)!,
                      controller: _rentPMController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      validator: (value) =>
                          OfficesRatingCardValidator.validatePositiveDecimal(
                              value, 'Rent P.M.'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    LabeledTextField(
                      label: "Lease Terms",
                      placeholder: "Lease duration and terms",
                      controller: _termsController,
                      validator: (value) => OfficesRatingCardValidator
                          .validateOptionalTextWithLength(
                              value, 200, 'Lease Terms'),
                    ),
                  ]),
                  _buildRow([
                    LabeledTextField(
                      label: "Floor Number",
                      placeholder: "Floor level",
                      controller: _floorNumberController,
                      keyboardType: TextInputType.numberWithOptions(signed: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^-?\d*')),
                        LengthLimitingTextInputFormatter(4),
                      ],
                      validator: (value) =>
                          OfficesRatingCardValidator.validateFloorNumber(
                              value, 'Floor Number'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    LabeledTextField(
                      label: "Ceiling Height",
                      placeholder: "Height in meters",
                      controller: _ceilingHeightController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      validator: (value) =>
                          OfficesRatingCardValidator.validateCeilingHeight(
                              value, 'Ceiling Height'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                  ]),
                  _buildRow([
                    Text(
                      'Office Space Details',
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
                              label: "Office Suite",
                              placeholder: "Enter office suite details",
                              controller: _officeSuiteController,
                              validator: (value) => null, // No validation needed as it's added to tags
                            ),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              final suiteText = _officeSuiteController.text.trim();
                              if (suiteText.isNotEmpty && !_officeSuiteTags.contains(suiteText)) {
                                setState(() {
                                  _officeSuiteTags.add(suiteText);
                                  _officeSuiteController.clear();
                                });
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
                      // Display tags
                      if (_officeSuiteTags.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _officeSuiteTags.map((tag) {
                              return Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: colors(context).colorPrimary1?.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: colors(context).colorPrimary1!,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      tag,
                                      style: TextStyle(
                                        color: colors(context).colorPrimary1,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _officeSuiteTags.remove(tag);
                                        });
                                      },
                                      child: Icon(
                                        PhosphorIcons.x(),
                                        size: 16,
                                        color: colors(context).colorPrimary1,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                    ],
                  ),
                  _buildRow([
                    LabeledTextField(
                      label: AppString.totalArea.localize(context)!,
                      placeholder: AppString.totalArea.localize(context)!,
                      controller: _totalAreaController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      validator: (value) =>
                          OfficesRatingCardValidator.validatePositiveDecimal(
                              value, 'Total Area'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                  ]),
                  _buildRow([
                    LabeledTextField(
                      label: "Usable Floor Area",
                      placeholder: "Usable office space",
                      controller: _usableFloorAreaController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      validator: (value) =>
                          OfficesRatingCardValidator.validatePositiveDecimal(
                              value, 'Usable Floor Area'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                  ]),
                  _buildRow([
                    LabeledTextField(
                      label: AppString.suggestedRate.localize(context)!,
                      placeholder: AppString.suggestedRate.localize(context)!,
                      controller: _suggestedRateController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      validator: (value) =>
                          OfficesRatingCardValidator.validatePositiveDecimal(
                              value, 'Suggested Rate'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                  ]),
                  _buildRow([
                    LabeledTextField(
                      label: AppString.notes.localize(context)!,
                      placeholder: "Office-specific notes and amenities",
                      controller: _notesController,
                      validator: (value) => OfficesRatingCardValidator
                          .validateOptionalTextWithLength(value, 1000, 'Notes'),
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
                                if (_formKey.currentState!.validate()) {
                                  // TODO: Implement actual send logic
                                  debugPrint(
                                      "Offices Rating Card validated and sent");
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Offices Rating Card sent successfully'),
                                      backgroundColor:
                                          colors(context).colorPositive1,
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                } else {
                                  _showValidationErrorMessage(
                                      'Please fill in all required fields correctly before sending');
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
            ));
      }),
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

// Helper method to create read-only fields for autofilled data
Widget _buildReadOnlyField({
  required BuildContext context,
  required String label,
  required TextEditingController controller,
  bool isAutoFilled = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          isAutoFilled ? '$label (Auto-filled)' : label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: colors(context).colorBlack,
          ),
        ),
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isAutoFilled
              ? colors(context).colorGrey9
              : colors(context).colorWhite,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: colors(context).colorGrey3!,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                controller.text.isEmpty ? 'Not available' : controller.text,
                style: TextStyle(
                  fontSize: 14,
                  color: controller.text.isEmpty
                      ? colors(context).colorGrey5
                      : colors(context).colorBlack,
                ),
              ),
            ),
            if (isAutoFilled)
              Icon(
                PhosphorIcons.lock(),
                size: 16,
                color: colors(context).colorGrey5,
              ),
          ],
        ),
      ),
    ],
  );
}
