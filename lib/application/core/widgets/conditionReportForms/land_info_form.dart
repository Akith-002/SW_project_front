import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/widgets/labeled_text_field.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_dropdown_field.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_button.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';

class LandInfoForm extends StatelessWidget {
  const LandInfoForm({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double formWidth = constraints.maxWidth - 32; // Adjust for sidebar changes
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRow([
                CustomDropdownField(
                  label: AppString.nameOfVillage.localize(context)!,
                  items: ["Village A", "Village B", "Village C"],
                  initialValue: "Village A",
                  onChanged: (value) {},
                ),
                LabeledTextField(
                  label: AppString.nameOfLand.localize(context)!,
                  placeholder: AppString.nameOfLand.localize(context)!,
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.atPlanNumber.localize(context)!,
                  placeholder: "123456789",
                ),
                LabeledTextField(
                  label: AppString.atLotNumber.localize(context)!,
                  placeholder: "AT Lot 01",
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.ppCadNumber.localize(context)!,
                  placeholder: "123456789",
                ),
                LabeledTextField(
                  label: AppString.ppCadLotNumber.localize(context)!,
                  placeholder: "SLA 01",
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.acquiredExtent.localize(context)!,
                  placeholder: AppString.acquiredExtent.localize(context)!,
                ),
                LabeledTextField(
                  label: AppString.assessmentNumber.localize(context)!,
                  placeholder: AppString.assessmentNumber.localize(context)!,
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.roadName.localize(context)!,
                  placeholder: AppString.roadName.localize(context)!,
                ),
                CustomDropdownField(
                  label: AppString.accessCategory.localize(context)!,
                  items: ["Category 1", "Category 2", "Category 3"],
                  initialValue: "Category 1",
                  onChanged: (value) {},
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.accessCategoryDescription.localize(context)!,
                  placeholder: AppString.accessCategoryDescription.localize(context)!,
                ),
                LabeledTextField(
                  label: AppString.descriptionOfLand.localize(context)!,
                  placeholder: AppString.descriptionOfLand.localize(context)!,
                ),
              ]),

              // "Add PR" button
              _buildRow([
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.situation.localize(context)!,
                      style: AppStyling.mediumTextSize14.copyWith(color: colors(context).labelTextColor),
                    ),
                    const SizedBox(height: 8),
                    CustomButton(
                      text: AppString.addPr.localize(context)!,
                      backgroundColor: colors(context).colorPrimary1!,
                      onPressed: () {},
                      width: 484,
                      height: 48,
                    ),
                  ],
                ),
                LabeledTextField(
                  label: AppString.landUseDescription.localize(context)!,
                  placeholder: AppString.landUseDescription.localize(context)!,
                ),
              ]),

              _buildRow([
                CustomDropdownField(
                  label: AppString.landUseType.localize(context)!,
                  items: ["Residential", "Commercial", "Agricultural"],
                  initialValue: "Residential",
                  onChanged: (value) {},
                ),
                LabeledTextField(
                  label: AppString.frontageFeet.localize(context)!,
                  placeholder: AppString.frontageFeet.localize(context)!,
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.depthOfLandFeet.localize(context)!,
                  placeholder: AppString.depthOfLandFeet.localize(context)!,
                ),
                LabeledTextField(
                  label: AppString.levelWithAccess.localize(context)!,
                  placeholder: AppString.levelWithAccess.localize(context)!,
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.plantationDetails.localize(context)!,
                  placeholder: AppString.plantationDetails.localize(context)!,
                ),
                LabeledTextField(
                  label: AppString.detailsOfBusiness.localize(context)!,
                  placeholder: AppString.detailsOfBusiness.localize(context)!,
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.acquisitionName.localize(context)!,
                  placeholder: AppString.acquisitionName.localize(context)!,
                ),
                LabeledTextField(
                  label: AppString.dateOfPrepared.localize(context)!,
                  placeholder: "26-12-2024",
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.dateOfSection3BA.localize(context)!,
                  placeholder: "DD-MM-YYYY",
                ),
              ]),

              // Boundaries Section
              const SizedBox(height: 16),
              Text(
                AppString.boundaries.localize(context)!,
                style: AppStyling.mediumTextSize14.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSmallInput(AppString.north.localize(context)!),
                  _buildSmallInput(AppString.east.localize(context)!),
                  _buildSmallInput(AppString.west.localize(context)!),
                  _buildSmallInput(AppString.south.localize(context)!),
                  _buildSmallInput(AppString.bottom.localize(context)!),
                ],
              ),

              // **🚀 NEW: Extra Space Before Line Break**
              const SizedBox(height: 32), 

              // **Divider Section (Fixed Position)**
              Container(
                width: formWidth,
                height: 1.5,
                color: colors(context).colorGrey5,
              ),

              const SizedBox(height: 16), // Extra space before buttons

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

  // Helper method to create rows of input fields
  Widget _buildRow(List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: children.map((widget) => Expanded(child: widget)).toList(),
      ),
    );
  }

  // Helper method to create small input fields in "Boundaries"
  Widget _buildSmallInput(String label) {
    return SizedBox(
      width: 186,
      child: LabeledTextField(label: label, placeholder: label),
    );
  }
}
