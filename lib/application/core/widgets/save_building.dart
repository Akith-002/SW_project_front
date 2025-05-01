import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_button.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_dropdown_field.dart';

// Define the callback type for saving
typedef SaveBuildingCallback = void Function(
    String buildingName, String constructionType);

class SaveBuilding extends StatefulWidget {
  final VoidCallback onCancel;
  final SaveBuildingCallback onSave;

  const SaveBuilding({
    required this.onCancel,
    required this.onSave,
    super.key,
  });

  @override
  State<SaveBuilding> createState() => _SaveBuildingState();
}

class _SaveBuildingState extends State<SaveBuilding> {
  // Use a GlobalKey<FormState> for validation
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _selectedConstructionType = 'Building 1';

  final List<String> _constructionTypes = [
    'Building 1',
    'Building 2',
    'Building 3'
  ];

  @override
  void initState() {
    super.initState();
    if (!_constructionTypes.contains(_selectedConstructionType) &&
        _constructionTypes.isNotEmpty) {
      _selectedConstructionType = _constructionTypes.first;
    } else if (_constructionTypes.isEmpty) {
      debugPrint("Warning: Construction types list is empty.");
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleSave() {
    // Validate the form using the GlobalKey
    if (_formKey.currentState?.validate() ?? false) {
      final buildingName = _nameController.text.trim();
      final constructionType = _selectedConstructionType;
      widget.onSave(buildingName, constructionType);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        // Wrap widgets needing validation with a Form widget
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Construction Details',
                  style: AppStyling.mediumTextSize18
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 24),
              // Replace LabeledTextField with direct TextFormField
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Building / other construction name:',
                    style: AppStyling.mediumTextSize14.copyWith(
                      color: colors(context).labelTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 484,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colors(context).dropDownBorderColor!,
                        width: 1.5,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextFormField(
                      controller: _nameController,
                      style: TextStyle(color: Colors.black, fontSize: 14),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter Name',
                        hintStyle: TextStyle(
                          color: colors(context).labelTextColor,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomDropdownField(
                label: 'Construction Type',
                items: _constructionTypes,
                initialValue: _selectedConstructionType,
                onChanged: (value) {
                  // No need for null check if onChanged guarantees non-null
                  setState(() {
                    _selectedConstructionType = value;
                  });
                },
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton(
                    text: 'Cancel',
                    onPressed: widget.onCancel,
                    backgroundColor: colors(context).colorGrey1!,
                  ),
                  const SizedBox(width: 16),
                  CustomButton(
                    text: 'Save',
                    onPressed: _handleSave, // Trigger form validation
                    backgroundColor: colors(context).colorPrimary6!,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
