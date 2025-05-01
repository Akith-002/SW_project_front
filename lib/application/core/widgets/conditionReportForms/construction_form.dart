import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/widgets/labeled_text_field.dart';
import 'package:land_asset_valuation/application/core/widgets/read_only_labeled_field.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_button.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';

class ConstructionForm extends StatelessWidget {
  final List<Map<String, String>> constructions = [
    const {"label": AppString.constructionName, "value": "Construction One"},
    const {"label": AppString.constructionName, "value": "Construction Two"},
    const {"label": AppString.constructionName, "value": "Construction Two"},
    const {"label": AppString.constructionName, "value": "Building Two"},
  ];

   ConstructionForm({super.key});

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
                      label: AppString.buildingDescription.localize(context)!,
                      placeholder: AppString.buildingDescription.localize(context)!,
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
                padding: const EdgeInsets.only(bottom: 16.0), // Ensures spacing at bottom
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                      text: AppString.cancel.localize(context)!,
                      backgroundColor: colors(context).colorGrey1!,
                      onPressed: () {},
                      width: 120,
                      height: 48,
                    ),
                    CustomButton(
                      text: AppString.save.localize(context)!,
                      backgroundColor: colors(context).colorPrimary5!,
                      onPressed: () {},
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
