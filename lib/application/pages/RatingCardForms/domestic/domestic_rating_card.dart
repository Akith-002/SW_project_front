import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/widgets/breadcrumb.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_app_bar.dart';
import 'package:land_asset_valuation/application/core/widgets/labeled_text_field.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_dropdown_field.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_button.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class DomesticRatingCard extends StatelessWidget {
  const DomesticRatingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Rating Card-Domestic',
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
                    BreadcrumbItem(label: "Mass Rating"),
                    BreadcrumbItem(label: "Rating Card - Domestic"),
                  ],
                ),
              ),

              _buildRow([
                LabeledTextField(
                  label: AppString.newNumber.l10n(context)!,
                  placeholder: AppString.newNumber.l10n(context)!,
                ),
                LabeledTextField(
                  label: AppString.owner.l10n(context)!,
                  placeholder: AppString.owner.l10n(context)!,
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.description.l10n(context)!,
                  placeholder: AppString.description.l10n(context)!,
                ),
                CustomDropdownField(
                  label: AppString.selectWalls.l10n(context)!,
                  items: ["Select Walls", "Brick", "Concrete", "Wood"],
                  initialValue: "Select Walls",
                  onChanged: (value) {
                    debugPrint(value);
                  },
                ),
              ]),
              _buildRow([
                CustomDropdownField(
                  label: AppString.floor.l10n(context)!,
                  items: ["Floor", "Tile", "Concrete", "Wood"],
                  initialValue: "Floor",
                  onChanged: (value) {
                    debugPrint(value);
                  },
                ),
                CustomDropdownField(
                  label: AppString.conveniences.l10n(context)!,
                  items: ["Select Conveniences", "Basic", "Modern", "Luxury"],
                  initialValue: "Select Conveniences",
                  onChanged: (value) {
                    debugPrint(value);
                  },
                ),
              ]),
              _buildRow([
                CustomDropdownField(
                  label: AppString.condition.l10n(context)!,
                  items: ["Select Condition", "Good", "Fair", "Poor"],
                  initialValue: "Select Condition",
                  onChanged: (value) {
                    debugPrint(value);
                  },
                ),
                LabeledTextField(
                  label: AppString.age.l10n(context)!,
                  placeholder: AppString.age.l10n(context)!,
                ),
              ]),
              _buildRow([
                CustomDropdownField(
                  label: AppString.access.l10n(context)!,
                  items: ["Select Access", "Road", "Lane", "Path"],
                  initialValue: "Select Access",
                  onChanged: (value) {
                    debugPrint(value);
                  },
                ),
                LabeledTextField(
                  label: AppString.tsBop.l10n(context)!,
                  placeholder: AppString.tsBop.l10n(context)!,
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.parkingSpace.l10n(context)!,
                  placeholder: AppString.parkingSpace.l10n(context)!,
                ),
                CustomDropdownField(
                  label: AppString.propertySubCategory.l10n(context)!,
                  items: [
                    "Select Property Sub Category",
                    "Single Family",
                    "Apartment",
                    "Townhouse"
                  ],
                  initialValue: "Select Property Sub Category",
                  onChanged: (value) {
                    debugPrint(value);
                  },
                ),
              ]),
              _buildRow([
                CustomDropdownField(
                  label: AppString.propertyType.l10n(context)!,
                  items: ["Select Property Type", "Residential", "Mixed Use"],
                  initialValue: "Select Property Type",
                  onChanged: (value) {
                    debugPrint(value);
                  },
                ),
                LabeledTextField(
                  label: "Plantations",
                  placeholder: "Enter plantations",
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.wardNumber.l10n(context)!,
                  placeholder: AppString.wardNumber.l10n(context)!,
                ),
                LabeledTextField(
                  label: AppString.roadName.l10n(context)!,
                  placeholder: AppString.roadName.l10n(context)!,
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.date.l10n(context)!,
                  placeholder: AppString.date.l10n(context)!,
                ),
                LabeledTextField(
                  label: AppString.occupier.l10n(context)!,
                  placeholder: AppString.occupier.l10n(context)!,
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.rentPM.l10n(context)!,
                  placeholder: AppString.rentPM.l10n(context)!,
                ),
                LabeledTextField(
                  label: AppString.terms.l10n(context)!,
                  placeholder: AppString.terms.l10n(context)!,
                ),
              ]),
              SizedBox(height: 16),
          
              _buildRow([
                LabeledTextField(
                  label: AppString.suggestedRate.l10n(context)!,
                  placeholder: AppString.suggestedRate.l10n(context)!,
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.notes.l10n(context)!,
                  placeholder: AppString.notes.l10n(context)!,
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
                        text: AppString.cancel.l10n(context)!,
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
                            text: AppString.save.l10n(context)!,
                            backgroundColor: colors(context).colorPrimary1!,
                            onPressed: () {
                              // TODO: Implement save functionality
                              debugPrint("Domestic Rating Card saved");
                            },
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
        );
      }),
    );
  }
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
