import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/widgets/labeled_text_field.dart';
import 'package:land_asset_valuation/application/core/widgets/read_only_labeled_field.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_button.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/services/condition_report_form_service.dart';

class ConstructionForm extends StatefulWidget {
  final int tabIndex; // 1 for Building Info, 2 for Other Constructions

  const ConstructionForm({super.key, required this.tabIndex});

  @override
  State<ConstructionForm> createState() => _ConstructionFormState();
}

class _ConstructionFormState extends State<ConstructionForm> {
  final _formService = ConditionReportFormService();
  final _buildingDescriptionController = TextEditingController();

  final List<Map<String, String>> constructions = [
    const {"label": AppString.constructionName, "value": "Construction One"},
    const {"label": AppString.constructionName, "value": "Construction Two"},
    const {"label": AppString.constructionName, "value": "Construction Three"},
    const {"label": AppString.constructionName, "value": "Building Two"},
  ];

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  void _loadExistingData() {
    final formData = _formService.formData;
    if (widget.tabIndex == 1) {
      // Building Info tab
      if (formData.buildingDescription.isNotEmpty) {
        _buildingDescriptionController.text = formData.buildingDescription;
      }
    } else {
      // Other Constructions tab
      if (formData.otherConstructionsDescription.isNotEmpty) {
        _buildingDescriptionController.text =
            formData.otherConstructionsDescription;
      }
    }
  }

  void _saveFormData() {
    // Get construction data for display
    String constructionsInfo = constructions.map((c) => c["value"]!).join(", ");

    // Update form service with current values
    if (widget.tabIndex == 1) {
      // Building Info tab
      _formService.updateBuildingInfo(
        buildingDescription: _buildingDescriptionController.text,
        buildingInfo: constructionsInfo,
      );

      // Show save confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Building information saved'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      // Other Constructions tab
      _formService.updateOtherConstructions(
        otherConstructionsDescription: _buildingDescriptionController.text,
        otherConstructionsInfo: constructionsInfo,
      );

      // Show save confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Other constructions information saved'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    _buildingDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double formWidth = constraints.maxWidth - 32; // Adjust dynamically
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Form Container (992 x 252)
              Container(
                width: 992,
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Construction Description Field
                    LabeledTextField(
                      label: widget.tabIndex == 1
                          ? AppString.buildingDescription.localize(context)!
                          : "Other Constructions Description",
                      placeholder: widget.tabIndex == 1
                          ? AppString.buildingDescription.localize(context)!
                          : "Enter other constructions description",
                      controller: _buildingDescriptionController,
                    ),
                    const SizedBox(height: 24),

                    // ReadOnly Fields List
                    Column(
                      children: constructions.map((construction) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ReadOnlyLabeledField(
                            label: construction["label"]!.localize(context)!,
                            value: construction["value"]!,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              // **🚀 NEW: Extra Space Before Line Break**
              const SizedBox(height: 32),

              // **Divider Section**
              Container(
                width: formWidth,
                height: 1.5,
                color: colors(context).colorGrey5,
              ),

              const SizedBox(height: 16), // Extra spacing before buttons

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
    );
  }
}
