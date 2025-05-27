import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/widgets/labeled_text_field.dart';
import 'package:land_asset_valuation/application/core/widgets/read_only_labeled_field.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_button.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/services/condition_report_form_service.dart';
import 'package:land_asset_valuation/application/core/validators/construction_form_validator.dart';

class ConstructionForm extends StatefulWidget {
  final int tabIndex; // 1 for Building Info, 2 for Other Constructions
  final TabController tabController; // Add TabController

  const ConstructionForm({
    super.key,
    required this.tabIndex,
    required this.tabController, // Add required TabController
  });

  @override
  State<ConstructionForm> createState() => _ConstructionFormState();
}

class _ConstructionFormState extends State<ConstructionForm> {
  final _formService = ConditionReportFormService();
  final _formKey = GlobalKey<FormState>();
  final _buildingDescriptionController = TextEditingController();
  bool _autoValidate = false;

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
      if (formData.buildingDescription.isNotEmpty) {
        _buildingDescriptionController.text = formData.buildingDescription;
      }
    } else {
      if (formData.otherConstructionsDescription.isNotEmpty) {
        _buildingDescriptionController.text =
            formData.otherConstructionsDescription;
      }
    }
  }

  void _saveFormData() {
    setState(() {
      _autoValidate = true;
    });

    // Check if form is valid
    if (!(_formKey.currentState?.validate() ?? false)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields correctly'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Check if description is empty
    if (_buildingDescriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a description'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    String constructionsInfo = constructions.map((c) => c["value"]!).join(", ");

    if (widget.tabIndex == 1) {
      _formService.updateBuildingInfo(
        buildingDescription: _buildingDescriptionController.text,
        buildingInfo: constructionsInfo,
      );
    } else {
      _formService.updateOtherConstructions(
        otherConstructionsDescription: _buildingDescriptionController.text,
        otherConstructionsInfo: constructionsInfo,
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Information saved successfully'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    // Move to next tab after successful save
    if (widget.tabController.index < widget.tabController.length - 1) {
      widget.tabController.animateTo(widget.tabController.index + 1);
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
        double formWidth = constraints.maxWidth - 32;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            autovalidateMode: _autoValidate
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 992,
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LabeledTextField(
                        label: widget.tabIndex == 1
                            ? AppString.buildingDescription.localize(context)!
                            : "Other Constructions Description",
                        placeholder: widget.tabIndex == 1
                            ? AppString.buildingDescription.localize(context)!
                            : "Enter other constructions description",
                        controller: _buildingDescriptionController,
                        validator: (value) =>
                            ConstructionFormValidator.validateDescription(
                          value,
                          fieldName: widget.tabIndex == 1
                              ? "Building Description"
                              : "Other Constructions Description",
                        ),
                      ),
                      const SizedBox(height: 24),
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
                const SizedBox(height: 32),
                Container(
                  width: formWidth,
                  height: 1.5,
                  color: colors(context).colorGrey5,
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
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
          ),
        );
      },
    );
  }
}
