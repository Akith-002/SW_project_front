import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:land_asset_valuation/application/core/widgets/breadcrumb.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_app_bar.dart';
import 'package:land_asset_valuation/application/core/widgets/labeled_text_field.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_dropdown_field.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_button.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/pages/RatingCardForms/domestic/cubit/domestic_rating_card_cubit.dart';
import 'package:land_asset_valuation/data/models/domestic_rating_card_model.dart';
import 'package:land_asset_valuation/injection.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class DomesticRatingCard extends StatefulWidget {
  final int assetId;

  const DomesticRatingCard({
    super.key,
    required this.assetId,
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
    if (_formKey.currentState?.validate() ?? false) {
      final ratingCard = DomesticRatingCardModel(
        assetId: widget.assetId,
        newNumber: _newNumberController.text,
        owner: _ownerController.text,
        description: _descriptionController.text,
        selectWalls: int.tryParse(_selectedWalls ?? '0') ?? 0,
        floor: int.tryParse(_selectedFloor ?? '0') ?? 0,
        conveniences: int.tryParse(_selectedConveniences ?? '0') ?? 0,
        condition: int.tryParse(_selectedCondition ?? '0') ?? 0,
        age: int.tryParse(_ageController.text) ?? 0,
        access: int.tryParse(_selectedAccess ?? '0') ?? 0,
        tsBop: _tsBopController.text,
        parkingSpace: _parkingSpaceController.text,
        propertySubCategory:
            int.tryParse(_selectedPropertySubCategory ?? '0') ?? 0,
        propertyType: int.tryParse(_selectedPropertyType ?? '0') ?? 0,
        plantations: _plantationsController.text,
        wardNumber: _wardNumberController.text,
        roadName: _roadNameController.text,
        date: _dateController.text.isNotEmpty
            ? DateTime.tryParse(_dateController.text) ?? DateTime.now()
            : DateTime.now(),
        occupier: _occupierController.text,
        rentPM: double.tryParse(_rentPMController.text) ?? 0.0,
        terms: _termsController.text,
        suggestedRate: double.tryParse(_suggestedRateController.text) ?? 0.0,
        notes: _notesController.text,
      );

      _cubit.saveRatingCard(ratingCard);
    }
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
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Rating card saved successfully!')),
            );
            Navigator.pop(context);
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
                              BreadcrumbItem(label: "Mass Rating"),
                              BreadcrumbItem(label: "Rating Card - Domestic"),
                            ],
                          ),
                        ),
                        _buildRow([
                          LabeledTextField(
                            label: AppString.newNumber.localize(context)!,
                            placeholder: AppString.newNumber.localize(context)!,
                            controller: _newNumberController,
                          ),
                          LabeledTextField(
                            label: AppString.owner.localize(context)!,
                            placeholder: AppString.owner.localize(context)!,
                            controller: _ownerController,
                          ),
                        ]),
                        _buildRow([
                          LabeledTextField(
                            label: AppString.description.localize(context)!,
                            placeholder:
                                AppString.description.localize(context)!,
                            controller: _descriptionController,
                          ),
                          CustomDropdownField(
                            label: AppString.selectWalls.localize(context)!,
                            items: ["1", "2", "3", "4"],
                            initialValue: _selectedWalls ?? "1",
                            onChanged: (value) {
                              setState(() {
                                _selectedWalls = value;
                              });
                            },
                          ),
                        ]),
                        _buildRow([
                          CustomDropdownField(
                            label: AppString.floor.localize(context)!,
                            items: ["1", "2", "3", "4"],
                            initialValue: _selectedFloor ?? "1",
                            onChanged: (value) {
                              setState(() {
                                _selectedFloor = value;
                              });
                            },
                          ),
                          CustomDropdownField(
                            label: AppString.conveniences.localize(context)!,
                            items: ["1", "2", "3", "4"],
                            initialValue: _selectedConveniences ?? "1",
                            onChanged: (value) {
                              setState(() {
                                _selectedConveniences = value;
                              });
                            },
                          ),
                        ]),
                        _buildRow([
                          CustomDropdownField(
                            label: AppString.condition.localize(context)!,
                            items: ["1", "2", "3", "4"],
                            initialValue: _selectedCondition ?? "1",
                            onChanged: (value) {
                              setState(() {
                                _selectedCondition = value;
                              });
                            },
                          ),
                          LabeledTextField(
                            label: AppString.age.localize(context)!,
                            placeholder: AppString.age.localize(context)!,
                            controller: _ageController,
                          ),
                        ]),
                        _buildRow([
                          CustomDropdownField(
                            label: AppString.access.localize(context)!,
                            items: ["1", "2", "3", "4"],
                            initialValue: _selectedAccess ?? "1",
                            onChanged: (value) {
                              setState(() {
                                _selectedAccess = value;
                              });
                            },
                          ),
                          LabeledTextField(
                            label: AppString.tsBop.localize(context)!,
                            placeholder: AppString.tsBop.localize(context)!,
                            controller: _tsBopController,
                          ),
                        ]),
                        _buildRow([
                          LabeledTextField(
                            label: AppString.parkingSpace.localize(context)!,
                            placeholder:
                                AppString.parkingSpace.localize(context)!,
                            controller: _parkingSpaceController,
                          ),
                          CustomDropdownField(
                            label: AppString.propertySubCategory
                                .localize(context)!,
                            items: ["1", "2", "3", "4"],
                            initialValue: _selectedPropertySubCategory ?? "1",
                            onChanged: (value) {
                              setState(() {
                                _selectedPropertySubCategory = value;
                              });
                            },
                          ),
                        ]),
                        _buildRow([
                          CustomDropdownField(
                            label: AppString.propertyType.localize(context)!,
                            items: ["1", "2", "3", "4"],
                            initialValue: _selectedPropertyType ?? "1",
                            onChanged: (value) {
                              setState(() {
                                _selectedPropertyType = value;
                              });
                            },
                          ),
                          LabeledTextField(
                            label: "Plantations",
                            placeholder: "Enter plantations",
                            controller: _plantationsController,
                          ),
                        ]),
                        _buildRow([
                          LabeledTextField(
                            label: AppString.wardNumber.localize(context)!,
                            placeholder:
                                AppString.wardNumber.localize(context)!,
                            controller: _wardNumberController,
                          ),
                          LabeledTextField(
                            label: AppString.roadName.localize(context)!,
                            placeholder: AppString.roadName.localize(context)!,
                            controller: _roadNameController,
                          ),
                        ]),
                        _buildRow([
                          LabeledTextField(
                            label: AppString.date.localize(context)!,
                            placeholder: AppString.date.localize(context)!,
                            controller: _dateController,
                          ),
                          LabeledTextField(
                            label: AppString.occupier.localize(context)!,
                            placeholder: AppString.occupier.localize(context)!,
                            controller: _occupierController,
                          ),
                        ]),
                        _buildRow([
                          LabeledTextField(
                            label: AppString.rentPM.localize(context)!,
                            placeholder: AppString.rentPM.localize(context)!,
                            controller: _rentPMController,
                          ),
                          LabeledTextField(
                            label: AppString.terms.localize(context)!,
                            placeholder: AppString.terms.localize(context)!,
                            controller: _termsController,
                          ),
                        ]),
                        SizedBox(height: 16),
                        _buildRow([
                          LabeledTextField(
                            label: AppString.suggestedRate.localize(context)!,
                            placeholder:
                                AppString.suggestedRate.localize(context)!,
                            controller: _suggestedRateController,
                          ),
                        ]),
                        _buildRow([
                          LabeledTextField(
                            label: AppString.notes.localize(context)!,
                            placeholder: AppString.notes.localize(context)!,
                            controller: _notesController,
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
}
