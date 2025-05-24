import 'dart:io';
import 'package:flutter/material.dart';
import 'package:land_asset_valuation/app/base_view.dart';
import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/widgets/breadcrumb.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_app_bar.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_button.dart';
import 'package:land_asset_valuation/application/core/widgets/image_upload.dart';
import 'package:land_asset_valuation/application/core/widgets/labeled_text_field.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_dropdown_field.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';
import 'package:land_asset_valuation/application/pages/inspectionReport/cubit/inspection_report_cubit.dart';
import 'package:land_asset_valuation/injection.dart';

class InspectionReportView extends BasePage {
  const InspectionReportView({super.key});

  @override
  State<InspectionReportView> createState() => _InspectionReportViewState();
}

class _InspectionReportViewState extends BasePageState<InspectionReportView>
    with SingleTickerProviderStateMixin {
  final _cubit = injection<InspectionReportCubit>();
  late TabController _tabController;
  final List<String> tabTitles = [
    "Land Info",
    "Building Info",
    "Other Constructions"
  ];
  List<dynamic> uploadedImages = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabTitles.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onImagePicked(File file) {
    setState(() {
      uploadedImages.add(file);
    });
  }

  void _deleteImage(int index) {
    setState(() {
      uploadedImages.removeAt(index);
    });
  }

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Custom AppBar
          const CustomAppBar(title: "Inspection Report - #56249"),

          // Breadcrumb Navigation (Full Width)
          Container(
            width: double.infinity, // Makes it full width like the App Bar
            color:
                const Color(0xFFF3F4F6), // Matches the Breadcrumb's background
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Breadcrumb(
              items: [
                BreadcrumbItem(label: "Land Miscellaneous", onTap: () {}),
                BreadcrumbItem(label: "Master File - #56249", onTap: () {}),
                BreadcrumbItem(
                    label: "Inspection Report - #56249", onTap: () {}),
              ],
            ),
          ),

          // Tabs and Tab content
          Expanded(
            child: _buildInspectionReportTabs(),
          ),
        ],
      ),
    );
  }

  Widget _buildInspectionReportTabs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tab Bar Navigation
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 0.0),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicator: BoxDecoration(
                color: colors(context).colorPrimary6 ?? const Color(0xff007bce),
                borderRadius: BorderRadius.circular(20),
              ),
              indicatorColor: colors(context).colorBlack ?? Colors.transparent,
              dividerColor: Colors.transparent,
              labelColor: colors(context).colorWhite ?? Colors.white,
              unselectedLabelColor:
                  colors(context).colorBlack ?? Colors.black87,
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              tabs: tabTitles.map((title) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  height: 40,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.transparent, width: 0),
                    ),
                  ),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        // Spacing below the tabs
        const SizedBox(height: 24),

        // Tab View Content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildLandInfoTab(),
              _buildBuildingInfoTab(),
              _buildOtherConstructionsTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLandInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabeledTextField(
              label: "Master File Ref No",
              placeholder: "Enter Master File Reference Number"),
          LabeledTextField(
              label: "Inspection Date", placeholder: "Enter Inspection Date"),

          LabeledTextField(
              label: "DS Division", placeholder: "Enter DS Division"),
          LabeledTextField(label: "District", placeholder: "Enter District"),
          LabeledTextField(label: "Province", placeholder: "Enter Province"),

          // Village/GN Division - only title with button
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Village/GN Division",
                  style: AppStyling.mediumTextSize14.copyWith(
                    color: colors(context).labelTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                CustomButton(
                  text: "GN Division and Village",
                  onPressed: () {},
                  width: 380,
                  height: 48,
                  backgroundColor: colors(context).colorPrimary1!,
                ),
              ],
            ),
          ),

          // Spacer to push buttons to bottom
          const SizedBox(height: 24),

          // Divider
          Container(
            height: 1,
            margin: const EdgeInsets.all(16),
            width: double.infinity,
            color: Colors.grey,
          ),

          // Buttons
          Row(
            children: [
              CustomButton(
                text: AppString.cancel.localize(context) ?? 'Cancel',
                onPressed: () => Navigator.pop(context),
                backgroundColor: colors(context).colorGrey1!,
              ),
              const Spacer(),
              CustomButton(
                text: AppString.save.localize(context) ?? 'Save',
                onPressed: () {},
                backgroundColor: colors(context).colorPrimary1!,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBuildingInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRow([
            LabeledTextField(
                label: AppString.buildingId.localize(context) ?? '',
                placeholder: "Enter Building ID"),
            LabeledTextField(
                label: AppString.buildingName.localize(context) ?? '',
                placeholder: "Enter Building Name"),
          ]),

          _buildRow([
            CustomDropdownField(
              label: AppString.buildingCategory.localize(context) ?? '',
              items: ["Residential", "Commercial", "Industrial"],
              initialValue: "Select Building Category",
              onChanged: (value) {},
            ),
            CustomDropdownField(
              label: AppString.buildingClass.localize(context) ?? '',
              items: ["Class A", "Class B", "Class C"],
              initialValue: "Select Building Class",
              onChanged: (value) {},
            ),
          ]),

          _buildRow([
            LabeledTextField(
                label: AppString.detailOfBuilding.localize(context) ?? '',
                placeholder: "Enter Details"),
            LabeledTextField(
                label: AppString.noOfFloorsGPlus.localize(context) ?? '',
                placeholder: "Enter Number of Floors"),
          ]),

          _buildRow([
            LabeledTextField(
                label: AppString.noOfFloorsGMinus.localize(context) ?? '',
                placeholder: "Enter Number of Floors"),
            LabeledTextField(
                label: AppString.age.localize(context) ?? '',
                placeholder: "Enter Age"),
          ]),

          _buildRow([
            LabeledTextField(
                label: AppString.expectedLifePeriod.localize(context) ?? '',
                placeholder: "Enter Expected Life Period"),
            LabeledTextField(
                label: AppString.parkingSpace.localize(context) ?? '',
                placeholder: "Enter Parking Space"),
          ]),

          _buildRow([
            LabeledTextField(
                label: AppString.design.localize(context) ?? '',
                placeholder: "Design"),
            LabeledTextField(
                label: AppString.conveniences.localize(context) ?? '',
                placeholder: "Conveniences"),
          ]),

          _buildRow([
            LabeledTextField(
                label: AppString.structure.localize(context) ?? '',
                placeholder: "Structure"),
            LabeledTextField(
                label: AppString.buildingConditions.localize(context) ?? '',
                placeholder: "Building Conditions"),
          ]),

          _buildRow([
            CustomDropdownField(
              label: AppString.natureOfConstruction.localize(context) ?? '',
              items: ["New", "Good", "Needs Repair", "Poor"],
              initialValue: "Select Nature of Building",
              onChanged: (value) {},
            ),
            CustomDropdownField(
              label: AppString.condition.localize(context) ?? '',
              items: ["New", "Good", "Needs Repair", "Poor"],
              initialValue: "Select Building Condition",
              onChanged: (value) {},
            ),
          ]),

          /// **Roof Details**
          const SizedBox(height: 16),
          Text(
            AppString.roofDetails.localize(context) ?? '',
            style: AppStyling.mediumTextSize14
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          _buildRow([
            CustomDropdownField(
              label: AppString.roofMaterial.localize(context) ?? '',
              items: ["Concrete", "Metal", "Tiles"],
              initialValue: "Select Roof Material",
              onChanged: (value) {},
            ),
            CustomDropdownField(
              label: AppString.roofFrame.localize(context) ?? '',
              items: ["Steel", "Wood", "Concrete"],
              initialValue: "Select Roof Frame",
              onChanged: (value) {},
            ),
          ]),

          _buildRow([
            CustomDropdownField(
              label: AppString.roofFinisher.localize(context) ?? '',
              items: ["Painted", "Varnished", "Other"],
              initialValue: "Select Roof Finisher",
              onChanged: (value) {},
            ),
            CustomDropdownField(
              label: AppString.ceiling.localize(context) ?? '',
              items: ["Plasterboard", "Wood", "PVC"],
              initialValue: "Select Ceiling",
              onChanged: (value) {},
            ),
          ]),

          /// **Structure Details**
          const SizedBox(height: 16),
          Text(
            AppString.structureDetails.localize(context) ?? '',
            style: AppStyling.mediumTextSize14
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          _buildRow([
            CustomDropdownField(
              label: AppString.foundationStructure.localize(context) ?? '',
              items: ["Pile", "Raft", "Pad"],
              initialValue: "Select Foundation Structure",
              onChanged: (value) {},
            ),
            CustomDropdownField(
              label: AppString.wallStructure.localize(context) ?? '',
              items: ["Brick", "Concrete", "Wood"],
              initialValue: "Select Wall Structure",
              onChanged: (value) {},
            ),
          ]),

          _buildRow([
            CustomDropdownField(
              label: AppString.floorStructure.localize(context) ?? '',
              items: ["Concrete", "Wood", "Tile"],
              initialValue: "Select Floor Structure",
              onChanged: (value) {},
            ),
          ]),

          /// **Fixed and Fitting Details**
          Text(
            AppString.fixedAndFittingDetails.localize(context) ?? '',
            style: AppStyling.mediumTextSize14
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          _buildRow([
            CustomDropdownField(
              label: AppString.door.localize(context) ?? '',
              items: ["Wooden", "Glass", "Metal"],
              initialValue: "Select Door",
              onChanged: (value) {},
            ),
            CustomDropdownField(
              label: AppString.window.localize(context) ?? '',
              items: ["Sliding", "Casement", "Fixed"],
              initialValue: "Select Window",
              onChanged: (value) {},
            ),
          ]),

          _buildRow([
            CustomDropdownField(
              label: AppString.windowProtection.localize(context) ?? '',
              items: ["Grills", "Shutters", "None"],
              initialValue: "Select Window Protection",
              onChanged: (value) {},
            ),
            CustomDropdownField(
              label:
                  AppString.doorsBathroomToiletFittings.localize(context) ?? '',
              items: ["Standard", "Luxury", "Basic"],
              initialValue: "Select Doors Bathroom and Toilet Fittings",
              onChanged: (value) {},
            ),
          ]),

          _buildRow([
            CustomDropdownField(
              label: AppString.doorsHandRail.localize(context) ?? '',
              items: ["Steel", "Wood", "Glass"],
              initialValue: "Select Doors Hand Rail",
              onChanged: (value) {},
            ),
            CustomDropdownField(
              label: AppString.doorsPantryCupboard.localize(context) ?? '',
              items: ["Laminated", "Wood", "PVC"],
              initialValue: "Select Doors Pantry Cupboard",
              onChanged: (value) {},
            ),
          ]),

          _buildRow([
            CustomDropdownField(
              label: AppString.doorsOther.localize(context) ?? '',
              items: ["Double Door", "Sliding", "Automatic"],
              initialValue: "Select Doors Other",
              onChanged: (value) {},
            ),
          ]),

          /// **Finishers / Service Details**
          const SizedBox(height: 16),
          Text(
            AppString.finishersServiceDetails.localize(context) ?? '',
            style: AppStyling.mediumTextSize14
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          _buildRow([
            CustomDropdownField(
              label: AppString.wallFinisher.localize(context) ?? '',
              items: ["Paint", "Tiles", "Wallpaper"],
              initialValue: "Select Wall Finisher",
              onChanged: (value) {},
            ),
            CustomDropdownField(
              label: AppString.floorFinisher.localize(context) ?? '',
              items: ["Tile", "Carpet", "Wood"],
              initialValue: "Select Floor Finisher",
              onChanged: (value) {},
            ),
          ]),

          _buildRow([
            CustomDropdownField(
              label: AppString.bathroomToilet.localize(context) ?? '',
              items: ["Tiled", "PVC", "Concrete"],
              initialValue: "Select Bathroom and Toilet",
              onChanged: (value) {},
            ),
            CustomDropdownField(
              label: AppString.services.localize(context) ?? '',
              items: ["Electricity", "Plumbing", "HVAC"],
              initialValue: "Select Services",
              onChanged: (value) {},
            ),
          ]),

          /// **Add Owner Button**
          const SizedBox(height: 16),
          Text(
            AppString.finishersServiceDetails.localize(context) ?? '',
            style: AppStyling.mediumTextSize14
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          CustomButton(
            text: AppString.addOwner.localize(context) ?? '',
            onPressed: () {},
            backgroundColor: colors(context).colorGrey1!,
            width: 150,
            height: 48,
          ),

          /// **Image Capturing and Upload**
          const SizedBox(height: 16),
          Text(
            AppString.imageCapturingUpload.localize(context) ?? '',
            style: AppStyling.mediumTextSize14
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              ...List.generate(
                uploadedImages.length,
                (index) {
                  final image = uploadedImages[index];
                  return ImageUpload(
                    imageFile: image is File ? image : null,
                    imagePath: image is String ? image : null,
                    onDelete: () => _deleteImage(index),
                    size: 128,
                  );
                },
              ),
              ImageUpload(
                isUploadButton: true,
                onImagePicked: _onImagePicked,
                onDelete: () {},
                size: 128,
              ),
            ],
          ),

          /// **Divider**
          const SizedBox(height: 24),
          Container(
            height: 1,
            margin: const EdgeInsets.all(16),
            width: double.infinity,
            color: Colors.grey,
          ),

          /// **Buttons**
          Row(
            children: [
              CustomButton(
                text: AppString.cancel.localize(context) ?? '',
                onPressed: () => Navigator.pop(context),
                backgroundColor: colors(context).colorGrey1!,
              ),
              const Spacer(),
              CustomButton(
                text: AppString.save.localize(context) ?? '',
                onPressed: () {},
                backgroundColor: colors(context).colorPrimary1!,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOtherConstructionsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Other construction fields
          LabeledTextField(
              label: "Other Information",
              placeholder: "Enter other information"),

          LabeledTextField(
              label: "Other Construction Details",
              placeholder: "Enter construction details"),

          LabeledTextField(
              label: "Details of Assets/Inventory Items",
              placeholder: "Enter asset details"),

          LabeledTextField(
              label: "Details of Business",
              placeholder: "Enter business details"),

          LabeledTextField(label: "Remarks", placeholder: "Enter remarks"),

          // Spacer to push buttons to bottom
          const SizedBox(height: 24),

          // Divider
          Container(
            height: 1,
            margin: const EdgeInsets.all(16),
            width: double.infinity,
            color: Colors.grey,
          ),

          // Buttons
          Row(
            children: [
              CustomButton(
                text: AppString.cancel.localize(context) ?? 'Cancel',
                onPressed: () => Navigator.pop(context),
                backgroundColor: colors(context).colorGrey1!,
              ),
              const Spacer(),
              CustomButton(
                text: AppString.save.localize(context) ?? 'Save',
                onPressed: () {},
                backgroundColor: colors(context).colorPrimary1!,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Helper method to create rows of input fields
  Widget _buildRow(List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: children.map((widget) => Expanded(child: widget)).toList(),
      ),
    );
  }

  @override
  BaseCubit<BaseState> getCubit() {
    return _cubit;
  }
}
