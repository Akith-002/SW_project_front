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

class OfficesRatingCard extends StatelessWidget {
  const OfficesRatingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    BreadcrumbItem(label: "Rating Card - Offices"),
                  ],
                ),
              ),
              _buildRow([
                CustomDropdownField(
                  label: AppString.selectBuilding.localize(context)!,
                  items: [
                    "Select Building",
                    "Office Complex A",
                    "Office Tower B",
                    "Business Center C"
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
                  items: [
                    "Select Walls",
                    "Glass Curtain",
                    "Concrete",
                    "Steel Frame"
                  ],
                  initialValue: "Select Walls",
                  onChanged: (value) {
                    debugPrint(value);
                  },
                ),
                CustomDropdownField(
                  label: AppString.floor.localize(context)!,
                  items: ["Floor", "Carpet", "Tile", "Hardwood", "Marble"],
                  initialValue: "Floor",
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
                    "HVAC",
                    "Elevator",
                    "Parking",
                    "Security"
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
                  placeholder: AppString.age.localize(context)!,
                ),
                CustomDropdownField(
                  label: AppString.access.localize(context)!,
                  items: [
                    "Select Access",
                    "Main Road",
                    "Business District",
                    "Highway"
                  ],
                  initialValue: "Select Access",
                  onChanged: (value) {
                    debugPrint(value);
                  },
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: "Office Grade",
                  placeholder: "Grade A/B/C",
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
                    "Commercial Office",
                    "Executive Suite",
                    "Coworking Space"
                  ],
                  initialValue: "Select Property Sub Category",
                  onChanged: (value) {
                    debugPrint(value);
                  },
                ),
                CustomDropdownField(
                  label: AppString.propertyType.localize(context)!,
                  items: [
                    "Select Property Type",
                    "Office Building",
                    "Mixed Use Commercial"
                  ],
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
                  label: "Lease Terms",
                  placeholder: "Lease duration and terms",
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: "Floor Number",
                  placeholder: "Floor level",
                ),
                LabeledTextField(
                  label: "Ceiling Height",
                  placeholder: "Height in meters",
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
                  label: AppString.totalArea.localize(context)!,
                  placeholder: AppString.totalArea.localize(context)!,
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: "Usable Floor Area",
                  placeholder: "Usable office space",
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
                  placeholder: "Office-specific notes and amenities",
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
                              debugPrint("Offices Rating Card saved");
                            },
                            width: 120,
                            height: 48,
                          ),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Implement send functionality
                            debugPrint("Offices Rating Card sent");
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
