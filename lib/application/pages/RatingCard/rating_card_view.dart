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

class RatingCard extends StatelessWidget {
  const RatingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Rating Card-Domestic #1234',
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity, // Makes it full width like the App Bar
                color: colors(context)
                    .colorGrey9, // Matches the Breadcrumb's background
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
                child: Breadcrumb(
                  items: [
                    BreadcrumbItem(label: "Mass Rating"),
                    BreadcrumbItem(label: "Rating Card - Domestic #1234"),
                  ],
                ),
              ),
              _buildRow([
                CustomDropdownField(
                  label: AppString.selectBuilding.localize(context)!,
                  items: [
                    "Select Building",
                    "Building A",
                    "Building B",
                    "Building C"
                  ],
                  initialValue: "Select Building",
                  onChanged: (value) {
                    "Building A";
                  },
                ),
                LabeledTextField(
                  label: AppString.localAuthority.localize(context)!,
                  placeholder: AppString.localAuthority.localize(context)!,
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.localAuthorityCode.localize(context)!,
                  placeholder: "123456789",
                ),
                LabeledTextField(
                  label: AppString.assessmentNumber.localize(context)!,
                  placeholder: AppString.assessmentNumber.localize(context)!,
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.newNumber.localize(context)!,
                  placeholder: AppString.newNumber.localize(context)!,
                ),
                LabeledTextField(
                  label: AppString.obsoleteNumber.localize(context)!,
                  placeholder: AppString.obsoleteNumber.localize(context)!,
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.owner.localize(context)!,
                  placeholder: AppString.owner.localize(context)!,
                ),
                LabeledTextField(
                  label: AppString.description.localize(context)!,
                  placeholder: AppString.description.localize(context)!,
                ),
              ]),
              _buildRow([
                CustomDropdownField(
                  label: AppString.selectWalls.localize(context)!,
                  items: ["Select Walls", "Type 1", "Type 2", "Type 3"],
                  initialValue: "Select Walls",
                  onChanged: (value) {
                    debugPrint(value);
                  },
                ),
                CustomDropdownField(
                  label: AppString.floor.localize(context)!,
                  items: ["Select Floor", "Type 1", "Type 2", "Type 3"],
                  initialValue: "Select Floor",
                  onChanged: (value) {
                    debugPrint(value);
                  },
                ),
              ]),
              _buildRow([
                CustomDropdownField(
                  label: AppString.conveniences.localize(context)!,
                  items: ["Select Conveniences", "Type 1", "Type 2", "Type 3"],
                  initialValue: "Select Conveniences",
                  onChanged: (value) {
                    debugPrint(value);
                  },
                ),
                CustomDropdownField(
                  label: AppString.condition.localize(context)!,
                  items: ["Select Condition", "Type 1", "Type 2", "Type 3"],
                  initialValue: "Select Condition",
                  onChanged: (value) {
                    debugPrint(value);
                  },
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.age.localize(context)!,
                  placeholder: AppString.age.localize(context)!,
                ),
                CustomDropdownField(
                  label: AppString.access.localize(context)!,
                  items: ["Select Access", "Building B", "Building C"],
                  initialValue: "Select Access",
                  onChanged: (value) {
                    debugPrint(value);
                  },
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.tsBop.localize(context)!,
                  placeholder: AppString.tsBop.localize(context)!,
                ),
                LabeledTextField(
                  label: AppString.parkingSpace.localize(context)!,
                  placeholder: AppString.parkingSpace.localize(context)!,
                ),
              ]),
              _buildRow([
                CustomDropdownField(
                  label: AppString.propertySubCategory.localize(context)!,
                  items: [
                    "Select Property Sub Category",
                    "Building B",
                    "Building C"
                  ],
                  initialValue: "Select Property Sub Category",
                  onChanged: (value) {
                    debugPrint(value);
                  },
                ),
                CustomDropdownField(
                  label: AppString.propertyType.localize(context)!,
                  items: ["Select Property Type", "Building B", "Building C"],
                  initialValue: "Select Property Type",
                  onChanged: (value) {
                    debugPrint(value);
                  },
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.wardNumber.localize(context)!,
                  placeholder: AppString.wardNumber.localize(context)!,
                ),
                LabeledTextField(
                  label: AppString.roadName.localize(context)!,
                  placeholder: AppString.roadName.localize(context)!,
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.date.localize(context)!,
                  placeholder: AppString.date.localize(context)!,
                ),
                LabeledTextField(
                  label: AppString.occupier.localize(context)!,
                  placeholder: AppString.occupier.localize(context)!,
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.rentPM.localize(context)!,
                  placeholder: AppString.rentPM.localize(context)!,
                ),
                LabeledTextField(
                  label: AppString.terms.localize(context)!,
                  placeholder: AppString.terms.localize(context)!,
                ),
              ]),
              _buildRow([
                Text(
                  'Floor wise Area',
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
                    mainAxisAlignment: MainAxisAlignment
                        .start, // Aligns both elements in the center
                    crossAxisAlignment: CrossAxisAlignment.end,

                    children: [
                      // Input Field wrapped inside Flexible
                      Flexible(
                        child: LabeledTextField(
                          label: AppString.building.localize(context)!,
                          placeholder: "Enter building name",
                        ),
                      ),
                      SizedBox(
                          width: 8), // Space between input field and button
                      // "Set"
                      // Button with proper alignment
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
                  label: AppString.totalArea.localize(context)!,
                  placeholder: AppString.totalArea.localize(context)!,
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.totalFloorArea.localize(context)!,
                  placeholder: AppString.totalFloorArea.localize(context)!,
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.suggestedRate.localize(context)!,
                  placeholder: AppString.suggestedRate.localize(context)!,
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.notes.localize(context)!,
                  placeholder: AppString.notes.localize(context)!,
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.terms.localize(context)!,
                  placeholder: AppString.terms.localize(context)!,
                ),
              ]),
              // Save & Cancel Buttons (Ensure correct layout)
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 16.0), // Ensure space at the bottom
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Cancel Button on the left
                    SizedBox(
                      width:
                          120, // Ensuring the Cancel button takes up the desired space
                      child: CustomButton(
                        text: AppString.cancel.localize(context)!,
                        backgroundColor: colors(context).colorGrey1!,
                        onPressed: () {},
                        width: 120,
                        height: 48,
                      ),
                    ),
                    // Right section for Save and Send buttons
                    Row(
                      children: [
                        // Save Button
                        SizedBox(
                          width: 120,
                          child: CustomButton(
                            text: AppString.save.localize(context)!,
                            backgroundColor: colors(context).colorPrimary1!,
                            onPressed: () {},
                            width: 120,
                            height: 48,
                          ),
                        ),
                        SizedBox(width: 8), // Space between the buttons
                        // Send Button with icon
                        ElevatedButton.icon(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: colors(context).colorPrimary5!,
                            foregroundColor: colors(context).colorWhite,
                            minimumSize: Size(120, 48), // Same width and height
                            padding: EdgeInsets.zero,
                          ),
                          label: Text(
                            '',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          icon: Row(
                            mainAxisSize: MainAxisSize
                                .min, // This keeps the icon's size as small as the content inside it
                            children: [
                              Text(
                                'Send',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              SizedBox(
                                  width:
                                      8), // Add some space between the text and the icon
                              Icon(
                                PhosphorIcons
                                    .arrowRight(), // Add the icon you want
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

// // Helper method to create rows of input fields
Widget _buildRow(List<Widget> children) {
  return Padding(
    padding: const EdgeInsets.symmetric(
      vertical: 8.0,
    ),
    child: Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween, // Align elements to the start
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
