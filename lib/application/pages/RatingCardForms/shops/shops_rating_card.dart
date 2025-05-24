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

class ShopsRatingCard extends StatelessWidget {
  const ShopsRatingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Rating Card-Shops',
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
                    BreadcrumbItem(label: "Rating Card - Shops"),
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
                    debugPrint(value);
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
                  placeholder: "500",
                ),
                LabeledTextField(
                  label: AppString.obsoleteNumber.localize(context)!,
                  placeholder: AppString.obsoleteNumber.localize(context)!,
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.owner.localize(context)!,
                  placeholder: "John Doe",
                ),
                LabeledTextField(
                  label: AppString.description.localize(context)!,
                  placeholder: "Two-story residential house",
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.tsBop.localize(context)!,
                  placeholder: "Available",
                ),
                CustomDropdownField(
                  label: AppString.propertySubCategory.localize(context)!,
                  items: [
                    "Select Property Sub Category",
                    "Villa",
                    "Apartment",
                    "Townhouse",
                    "Commercial Shop"
                  ],
                  initialValue: "Select Property Sub Category",
                  onChanged: (value) {
                    debugPrint(value);
                  },
                ),
              ]),
              _buildRow([
                CustomDropdownField(
                  label: AppString.propertyType.localize(context)!,
                  items: [
                    "Select Property Type",
                    "Luxury",
                    "Standard",
                    "Commercial",
                    "Mixed Use"
                  ],
                  initialValue: "Select Property Type",
                  onChanged: (value) {
                    debugPrint(value);
                  },
                ),
                LabeledTextField(
                  label: "Shop Front",
                  placeholder: "Enter shop front details (optional)",
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.occupier.localize(context)!,
                  placeholder: "John Doe",
                ),
                LabeledTextField(
                  label: AppString.rentPM.localize(context)!,
                  placeholder: "50000",
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.terms.localize(context)!,
                  placeholder: "Yearly Renewal",
                ),
                LabeledTextField(
                  label: "Floor Wise Area",
                  placeholder: "100 sqm",
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.totalFloorArea.localize(context)!,
                  placeholder: "200 sqm",
                ),
                LabeledTextField(
                  label: "Approved Rate From",
                  placeholder: "120",
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: "Approved Rate To",
                  placeholder: "150",
                ),
                LabeledTextField(
                  label: AppString.suggestedRate.localize(context)!,
                  placeholder: "135",
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.notes.localize(context)!,
                  placeholder: "Additional notes or observations",
                ),
              ]),
              _buildRow([
                CustomDropdownField(
                  label: AppString.selectWalls.localize(context)!,
                  items: ["Select Walls", "Brick", "Concrete", "Glass Front"],
                  initialValue: "Select Walls",
                  onChanged: (value) {
                    debugPrint(value);
                  },
                ),
                CustomDropdownField(
                  label: AppString.floor.localize(context)!,
                  items: ["Select Floor", "Tile", "Marble", "Concrete", "Wood"],
                  initialValue: "Select Floor",
                  onChanged: (value) {
                    debugPrint(value);
                  },
                ),
              ]),
              _buildRow([
                CustomDropdownField(
                  label: AppString.conveniences.localize(context)!,
                  items: [
                    "Select Conveniences",
                    "AC",
                    "Parking",
                    "Display Window",
                    "Storage"
                  ],
                  initialValue: "Select Conveniences",
                  onChanged: (value) {
                    debugPrint(value);
                  },
                ),
                CustomDropdownField(
                  label: AppString.condition.localize(context)!,
                  items: [
                    "Select Condition",
                    "Excellent",
                    "Good",
                    "Fair",
                    "Poor"
                  ],
                  initialValue: "Select Condition",
                  onChanged: (value) {
                    debugPrint(value);
                  },
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.age.localize(context)!,
                  placeholder: "Building age",
                ),
                CustomDropdownField(
                  label: AppString.access.localize(context)!,
                  items: ["Select Access", "Main Road", "Side Road", "Lane"],
                  initialValue: "Select Access",
                  onChanged: (value) {
                    debugPrint(value);
                  },
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.parkingSpace.localize(context)!,
                  placeholder: "Available parking spaces",
                ),
                LabeledTextField(
                  label: AppString.wardNumber.localize(context)!,
                  placeholder: AppString.wardNumber.localize(context)!,
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.roadName.localize(context)!,
                  placeholder: AppString.roadName.localize(context)!,
                ),
                LabeledTextField(
                  label: AppString.date.localize(context)!,
                  placeholder: AppString.date.localize(context)!,
                ),
              ]),
              _buildRow([
                Text(
                  'Shop Space Details',
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
                          label: "Shop Unit",
                          placeholder: "Enter shop unit details",
                        ),
                      ),
                      SizedBox(width: 8),
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
                  label: "Shop Floor Area",
                  placeholder: "Total shop area",
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: "Storage Area",
                  placeholder: "Storage/back room area",
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: "Monthly Turnover",
                  placeholder: "Average monthly sales",
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.notes.localize(context)!,
                  placeholder: "Shop-specific notes and features",
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
                            onPressed: () {
                              // TODO: Implement save functionality
                              debugPrint("Shops Rating Card saved");
                            },
                            width: 120,
                            height: 48,
                          ),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Implement send functionality
                            debugPrint("Shops Rating Card sent");
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children.map((widget) => Expanded(child: widget)).toList(),
    ),
  );
}
