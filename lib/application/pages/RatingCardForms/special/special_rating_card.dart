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
import 'package:land_asset_valuation/data/models/master_data_model.dart';

class SpecialRatingCard extends StatefulWidget {
  final MasterDataResponse masterData;
  const SpecialRatingCard({super.key, required this.masterData});

  @override
  State<SpecialRatingCard> createState() => _SpecialRatingCardState();
}

class _SpecialRatingCardState extends State<SpecialRatingCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Rating Card-Special',
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
                    BreadcrumbItem(label: "Rating Card - Special"),
                  ],
                ),
              ),
              _buildRow([
                CustomDropdownField(
                  label: "Special Property Type",
                  items: widget.masterData.natureOfConstruction,
                  initialValue:
                      widget.masterData.natureOfConstruction.isNotEmpty
                          ? widget.masterData.natureOfConstruction.first
                          : null,
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
                  placeholder: "Organization/Institution name",
                ),
                LabeledTextField(
                  label: AppString.description.localize(context)!,
                  placeholder: "Purpose and function",
                ),
              ]),
              _buildRow([
                CustomDropdownField(
                  label: "Construction Type",
                  items: widget.masterData.foundationStructure,
                  initialValue: widget.masterData.foundationStructure.isNotEmpty
                      ? widget.masterData.foundationStructure.first
                      : null,
                  onChanged: (value) {
                    debugPrint(value);
                  },
                ),
                CustomDropdownField(
                  label: "Special Features",
                  items: widget.masterData.services,
                  initialValue: widget.masterData.services.isNotEmpty
                      ? widget.masterData.services.first
                      : null,
                  onChanged: (value) {
                    debugPrint(value);
                  },
                ),
              ]),
              // Remove dropdowns for usageClassification, condition, propertySubCategory, ownershipType
              // Leave as text fields or static for now
              _buildRow([
                LabeledTextField(
                  label: AppString.age.localize(context)!,
                  placeholder: "Building age",
                ),
                LabeledTextField(
                  label: "Capacity",
                  placeholder: "Maximum occupancy/capacity",
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: "Special Equipment",
                  placeholder: "Medical/Industrial equipment",
                ),
                LabeledTextField(
                  label: AppString.parkingSpace.localize(context)!,
                  placeholder: "Parking facilities",
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
                  label: "Administrator",
                  placeholder: "Current administrator/manager",
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: "Operating Budget",
                  placeholder: "Annual operating budget",
                ),
                LabeledTextField(
                  label: "License/Registration",
                  placeholder: "Official registration number",
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: "Service Area",
                  placeholder: "Geographic area served",
                ),
                LabeledTextField(
                  label: "Staff Count",
                  placeholder: "Number of employees",
                ),
              ]),
              _buildRow([
                Text(
                  'Special Property Details',
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
                          label: "Facility Details",
                          placeholder: "Enter facility specifications",
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
                  label: "Total Built Area",
                  placeholder: "Total building area",
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: "Functional Area",
                  placeholder: "Area used for primary function",
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: "Special Valuation Rate",
                  placeholder: "Rate considering special use",
                ),
              ]),
              _buildRow([
                LabeledTextField(
                  label: AppString.notes.localize(context)!,
                  placeholder: "Special considerations and restrictions",
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
                              debugPrint("Special Rating Card saved");
                            },
                            width: 120,
                            height: 48,
                          ),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Implement send functionality
                            debugPrint("Special Rating Card sent");
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
