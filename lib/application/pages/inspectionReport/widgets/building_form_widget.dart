import 'dart:io';
import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_button.dart';
import 'package:land_asset_valuation/application/core/widgets/labeled_text_field.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_dropdown_field.dart';
import 'package:land_asset_valuation/application/core/widgets/image_upload.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';
import 'package:land_asset_valuation/application/core/validators/inspection_validator.dart';
import 'package:land_asset_valuation/data/models/building.dart';
import 'package:land_asset_valuation/application/pages/inspectionReport/constants/inspection_dropdown_options.dart';

class BuildingFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final Building selectedBuilding;
  final VoidCallback onBack;

  // Controllers
  final TextEditingController buildingIdController;
  final TextEditingController buildingNameController;
  final TextEditingController buildingDetailsController;
  final TextEditingController noOfFloorsGPlusController;
  final TextEditingController noOfFloorsGMinusController;
  final TextEditingController ageController;
  final TextEditingController expectedLifePeriodController;
  final TextEditingController parkingSpaceController;
  final TextEditingController designController;
  final TextEditingController conveniencesController;
  final TextEditingController structureController;

  // Dropdown values
  final String? selectedBuildingCategory;
  final String? selectedBuildingClass;
  final String? selectedNatureOfConstruction;
  final String? selectedBuildingConditions;
  final String? selectedRoofMaterial;
  final String? selectedRoofFrame;
  final String? selectedRoofFinisher;
  final String? selectedCeiling;
  final String? selectedFoundationStructure;
  final String? selectedWallStructure;
  final String? selectedFloorStructure;
  final String? selectedDoor;
  final String? selectedWindow;
  final String? selectedWindowProtection;
  final String? selectedBathroomToiletDoorsFittings;
  final String? selectedHandRail;
  final String? selectedPantryCupboard;
  final String? selectedOtherDoors;
  final String? selectedWallFinisher;
  final String? selectedFloorFinisher;
  final String? selectedBathroomToilet;
  final String? selectedServices;

  // Callbacks
  final Function(String?) onBuildingCategoryChanged;
  final Function(String?) onBuildingClassChanged;
  final Function(String?) onNatureOfConstructionChanged;
  final Function(String?) onBuildingConditionsChanged;
  final Function(String?) onRoofMaterialChanged;
  final Function(String?) onRoofFrameChanged;
  final Function(String?) onRoofFinisherChanged;
  final Function(String?) onCeilingChanged;
  final Function(String?) onFoundationStructureChanged;
  final Function(String?) onWallStructureChanged;
  final Function(String?) onFloorStructureChanged;
  final Function(String?) onDoorChanged;
  final Function(String?) onWindowChanged;
  final Function(String?) onWindowProtectionChanged;
  final Function(String?) onBathroomToiletDoorsFittingsChanged;
  final Function(String?) onHandRailChanged;
  final Function(String?) onPantryCupboardChanged;
  final Function(String?) onOtherDoorsChanged;
  final Function(String?) onWallFinisherChanged;
  final Function(String?) onFloorFinisherChanged;
  final Function(String?) onBathroomToiletChanged;
  final Function(String?) onServicesChanged;

  // Image upload functionality
  final List<dynamic> uploadedImages;
  final Function(File) onImagePicked;
  final Function(int) onDeleteImage;

  final VoidCallback? onSave;
  final String saveButtonText;
  final VoidCallback onCancel;

  const BuildingFormWidget({
    super.key,
    required this.formKey,
    required this.selectedBuilding,
    required this.onBack,
    required this.buildingIdController,
    required this.buildingNameController,
    required this.buildingDetailsController,
    required this.noOfFloorsGPlusController,
    required this.noOfFloorsGMinusController,
    required this.ageController,
    required this.expectedLifePeriodController,
    required this.parkingSpaceController,
    required this.designController,
    required this.conveniencesController,
    required this.structureController,
    required this.selectedBuildingCategory,
    required this.selectedBuildingClass,
    required this.selectedNatureOfConstruction,
    required this.selectedBuildingConditions,
    required this.selectedRoofMaterial,
    required this.selectedRoofFrame,
    required this.selectedRoofFinisher,
    required this.selectedCeiling,
    required this.selectedFoundationStructure,
    required this.selectedWallStructure,
    required this.selectedFloorStructure,
    required this.selectedDoor,
    required this.selectedWindow,
    required this.selectedWindowProtection,
    required this.selectedBathroomToiletDoorsFittings,
    required this.selectedHandRail,
    required this.selectedPantryCupboard,
    required this.selectedOtherDoors,
    required this.selectedWallFinisher,
    required this.selectedFloorFinisher,
    required this.selectedBathroomToilet,
    required this.selectedServices,
    required this.onBuildingCategoryChanged,
    required this.onBuildingClassChanged,
    required this.onNatureOfConstructionChanged,
    required this.onBuildingConditionsChanged,
    required this.onRoofMaterialChanged,
    required this.onRoofFrameChanged,
    required this.onRoofFinisherChanged,
    required this.onCeilingChanged,
    required this.onFoundationStructureChanged,
    required this.onWallStructureChanged,
    required this.onFloorStructureChanged,
    required this.onDoorChanged,
    required this.onWindowChanged,
    required this.onWindowProtectionChanged,
    required this.onBathroomToiletDoorsFittingsChanged,
    required this.onHandRailChanged,
    required this.onPantryCupboardChanged,
    required this.onOtherDoorsChanged,
    required this.onWallFinisherChanged,
    required this.onFloorFinisherChanged,
    required this.onBathroomToiletChanged,
    required this.onServicesChanged,
    required this.uploadedImages,
    required this.onImagePicked,
    required this.onDeleteImage,
    required this.onSave,
    required this.saveButtonText,
    required this.onCancel,
  });

  Widget _buildRow(List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: children
            .map((child) => Expanded(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: child,
                )))
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button to return to building list
            Row(
              children: [
                InkWell(
                  onTap: onBack,
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_back,
                        color: colors(context).colorPrimary5,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Back to Buildings',
                        style: TextStyle(
                          color: colors(context).colorPrimary5,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Basic Building Information
            _buildRow([
              LabeledTextField(
                label:
                    "${AppString.buildingId.localize(context) ?? 'Building ID'} (${selectedBuilding.name})",
                placeholder: "Enter Building ID",
                controller: buildingIdController,
                validator: (value) =>
                    InspectionValidator.required(value, "Building ID"),
              ),
              LabeledTextField(
                label:
                    AppString.buildingName.localize(context) ?? 'Building Name',
                placeholder: "Enter Building Name",
                controller: buildingNameController,
                validator: (value) =>
                    InspectionValidator.required(value, "Building Name"),
              ),
            ]),

            _buildRow([
              CustomDropdownField(
                label: AppString.buildingCategory.localize(context) ??
                    'Building Category',
                items: InspectionDropdownOptions.getBuildingCategoryOptions(),
                initialValue: selectedBuildingCategory,
                onChanged: onBuildingCategoryChanged,
                validator: (value) => InspectionValidator.validateDropdown(
                    value, "Building Category"),
              ),
              CustomDropdownField(
                label: AppString.buildingClass.localize(context) ??
                    'Building Class',
                items: InspectionDropdownOptions.getBuildingClassOptions(),
                initialValue: selectedBuildingClass,
                onChanged: onBuildingClassChanged,
                validator: (value) => InspectionValidator.validateDropdown(
                    value, "Building Class"),
              ),
            ]),

            _buildRow([
              LabeledTextField(
                label: AppString.detailOfBuilding.localize(context) ??
                    'Detail of Building',
                placeholder: "Enter Details",
                controller: buildingDetailsController,
                validator: (value) => InspectionValidator.optionalAlphaNum(
                    value, 200, "Building Details"),
              ),
              LabeledTextField(
                label: AppString.noOfFloorsGPlus.localize(context) ??
                    'No of Floors (G+)',
                placeholder: "Enter Number of Floors",
                controller: noOfFloorsGPlusController,
                validator: (value) => InspectionValidator.required(
                    value, "Number of Floors (G+)"),
              ),
            ]),

            _buildRow([
              LabeledTextField(
                label: AppString.noOfFloorsGMinus.localize(context) ??
                    'No of Floors (G-)',
                placeholder: "Enter Number of Floors",
                controller: noOfFloorsGMinusController,
                validator: (value) => InspectionValidator.required(
                    value, "Number of Floors (G-)"),
              ),
              LabeledTextField(
                label: AppString.age.localize(context) ?? 'Age',
                placeholder: "Enter Age",
                controller: ageController,
                validator: (value) =>
                    InspectionValidator.required(value, "Age"),
              ),
            ]),

            _buildRow([
              LabeledTextField(
                label: AppString.expectedLifePeriod.localize(context) ??
                    'Expected Life Period',
                placeholder: "Enter Expected Life Period",
                controller: expectedLifePeriodController,
                validator: (value) =>
                    InspectionValidator.required(value, "Expected Life Period"),
              ),
              LabeledTextField(
                label:
                    AppString.parkingSpace.localize(context) ?? 'Parking Space',
                placeholder: "Enter Parking Space",
                controller: parkingSpaceController,
                validator: (value) => InspectionValidator.optionalAlphaNum(
                    value, 100, "Parking Space"),
              ),
            ]),

            _buildRow([
              LabeledTextField(
                label: AppString.design.localize(context) ?? 'Design',
                placeholder: "Design",
                controller: designController,
                validator: (value) =>
                    InspectionValidator.optionalAlphaNum(value, 100, "Design"),
              ),
              LabeledTextField(
                label:
                    AppString.conveniences.localize(context) ?? 'Conveniences',
                placeholder: "Conveniences",
                controller: conveniencesController,
                validator: (value) => InspectionValidator.optionalAlphaNum(
                    value, 100, "Conveniences"),
              ),
            ]),

            _buildRow([
              LabeledTextField(
                label: AppString.structure.localize(context) ?? 'Structure',
                placeholder: "Structure",
                controller: structureController,
                validator: (value) =>
                    InspectionValidator.required(value, "Structure"),
              ),
              CustomDropdownField(
                label: AppString.buildingConditions.localize(context) ??
                    'Building Conditions',
                items: InspectionDropdownOptions.getBuildingConditionsOptions(),
                initialValue: selectedBuildingConditions,
                onChanged: onBuildingConditionsChanged,
                validator: (value) => InspectionValidator.validateDropdown(
                    value, "Building Conditions"),
              ),
            ]),

            _buildRow([
              CustomDropdownField(
                label: AppString.natureOfConstruction.localize(context) ??
                    'Nature of Construction',
                items:
                    InspectionDropdownOptions.getNatureOfConstructionOptions(),
                initialValue: selectedNatureOfConstruction,
                onChanged: onNatureOfConstructionChanged,
                validator: (value) => InspectionValidator.validateDropdown(
                    value, "Nature of Building"),
              ),
            ]),

            // Roof Details Section
            const SizedBox(height: 16),
            Text(
              AppString.roofDetails.localize(context) ?? 'Roof Details',
              style: AppStyling.mediumTextSize14
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            _buildRow([
              CustomDropdownField(
                label:
                    AppString.roofMaterial.localize(context) ?? 'Roof Material',
                items: InspectionDropdownOptions.getRoofMaterialOptions(),
                initialValue: selectedRoofMaterial,
                onChanged: onRoofMaterialChanged,
                validator: (value) => InspectionValidator.validateDropdown(
                    value, "Roof Material"),
              ),
              CustomDropdownField(
                label: AppString.roofFrame.localize(context) ?? 'Roof Frame',
                items: InspectionDropdownOptions.getRoofFrameOptions(),
                initialValue: selectedRoofFrame,
                onChanged: onRoofFrameChanged,
                validator: (value) =>
                    InspectionValidator.validateDropdown(value, "Roof Frame"),
              ),
            ]),

            _buildRow([
              CustomDropdownField(
                label:
                    AppString.roofFinisher.localize(context) ?? 'Roof Finisher',
                items: InspectionDropdownOptions.getRoofFinisherOptions(),
                initialValue: selectedRoofFinisher,
                onChanged: onRoofFinisherChanged,
                validator: (value) => InspectionValidator.validateDropdown(
                    value, "Roof Finisher"),
              ),
              CustomDropdownField(
                label: AppString.ceiling.localize(context) ?? 'Ceiling',
                items: InspectionDropdownOptions.getCeilingOptions(),
                initialValue: selectedCeiling,
                onChanged: onCeilingChanged,
                validator: (value) =>
                    InspectionValidator.validateDropdown(value, "Ceiling"),
              ),
            ]),

            // Structure Details Section
            const SizedBox(height: 16),
            Text(
              AppString.structureDetails.localize(context) ??
                  'Structure Details',
              style: AppStyling.mediumTextSize14
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            _buildRow([
              CustomDropdownField(
                label: AppString.foundationStructure.localize(context) ??
                    'Foundation Structure',
                items:
                    InspectionDropdownOptions.getFoundationStructureOptions(),
                initialValue: selectedFoundationStructure,
                onChanged: onFoundationStructureChanged,
                validator: (value) => InspectionValidator.validateDropdown(
                    value, "Foundation Structure"),
              ),
              CustomDropdownField(
                label: AppString.wallStructure.localize(context) ??
                    'Wall Structure',
                items: InspectionDropdownOptions.getWallStructureOptions(),
                initialValue: selectedWallStructure,
                onChanged: onWallStructureChanged,
                validator: (value) => InspectionValidator.validateDropdown(
                    value, "Wall Structure"),
              ),
            ]),

            _buildRow([
              CustomDropdownField(
                label: AppString.floorStructure.localize(context) ??
                    'Floor Structure',
                items: InspectionDropdownOptions.getFloorStructureOptions(),
                initialValue: selectedFloorStructure,
                onChanged: onFloorStructureChanged,
                validator: (value) => InspectionValidator.validateDropdown(
                    value, "Floor Structure"),
              ),
            ]),

            // Fixture and Fitting Details Section
            const SizedBox(height: 16),
            Text(
              AppString.fixedAndFittingDetails.localize(context) ??
                  'Fixed and Fitting Details',
              style: AppStyling.mediumTextSize14
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            _buildRow([
              CustomDropdownField(
                label: AppString.door.localize(context) ?? 'Door',
                items: InspectionDropdownOptions.getDoorOptions(),
                initialValue: selectedDoor,
                onChanged: onDoorChanged,
                validator: (value) =>
                    InspectionValidator.validateDropdown(value, "Door"),
              ),
              CustomDropdownField(
                label: AppString.window.localize(context) ?? 'Window',
                items: InspectionDropdownOptions.getWindowOptions(),
                initialValue: selectedWindow,
                onChanged: onWindowChanged,
                validator: (value) =>
                    InspectionValidator.validateDropdown(value, "Window"),
              ),
            ]),

            _buildRow([
              CustomDropdownField(
                label: AppString.windowProtection.localize(context) ??
                    'Window Protection',
                items: InspectionDropdownOptions.getWindowProtectionOptions(),
                initialValue: selectedWindowProtection,
                onChanged: onWindowProtectionChanged,
                validator: (value) => InspectionValidator.validateDropdown(
                    value, "Window Protection"),
              ),
              CustomDropdownField(
                label: 'Bathroom/Toilet Doors Fittings',
                items: InspectionDropdownOptions
                    .getDoorsBathroomAndToiletFittingsOptions(),
                initialValue: selectedBathroomToiletDoorsFittings,
                onChanged: onBathroomToiletDoorsFittingsChanged,
                validator: (value) => InspectionValidator.validateDropdown(
                    value, "Bathroom/Toilet Doors Fittings"),
              ),
            ]),

            _buildRow([
              CustomDropdownField(
                label: 'Hand Rail',
                items: InspectionDropdownOptions.getDoorsHandRailOptions(),
                initialValue: selectedHandRail,
                onChanged: onHandRailChanged,
                validator: (value) =>
                    InspectionValidator.validateDropdown(value, "Hand Rail"),
              ),
              CustomDropdownField(
                label: 'Pantry Cupboard',
                items:
                    InspectionDropdownOptions.getDoorsPantryCupboardOptions(),
                initialValue: selectedPantryCupboard,
                onChanged: onPantryCupboardChanged,
                validator: (value) => InspectionValidator.validateDropdown(
                    value, "Pantry Cupboard"),
              ),
            ]),

            _buildRow([
              CustomDropdownField(
                label: 'Other Doors',
                items: InspectionDropdownOptions.getDoorsOtherOptions(),
                initialValue: selectedOtherDoors,
                onChanged: onOtherDoorsChanged,
                validator: (value) =>
                    InspectionValidator.validateDropdown(value, "Other Doors"),
              ),
            ]),

            // Finishers and Services Section
            const SizedBox(height: 16),
            Text(
              'Finishers and Services',
              style: AppStyling.mediumTextSize14
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            _buildRow([
              CustomDropdownField(
                label:
                    AppString.wallFinisher.localize(context) ?? 'Wall Finisher',
                items: InspectionDropdownOptions.getWallFinisherOptions(),
                initialValue: selectedWallFinisher,
                onChanged: onWallFinisherChanged,
                validator: (value) => InspectionValidator.validateDropdown(
                    value, "Wall Finisher"),
              ),
              CustomDropdownField(
                label: AppString.floorFinisher.localize(context) ??
                    'Floor Finisher',
                items: InspectionDropdownOptions.getFloorFinisherOptions(),
                initialValue: selectedFloorFinisher,
                onChanged: onFloorFinisherChanged,
                validator: (value) => InspectionValidator.validateDropdown(
                    value, "Floor Finisher"),
              ),
            ]),

            _buildRow([
              CustomDropdownField(
                label: AppString.bathroomToilet.localize(context) ??
                    'Bathroom/Toilet',
                items: InspectionDropdownOptions.getBathroomAndToiletOptions(),
                initialValue: selectedBathroomToilet,
                onChanged: onBathroomToiletChanged,
                validator: (value) => InspectionValidator.validateDropdown(
                    value, "Bathroom/Toilet"),
              ),
              CustomDropdownField(
                label: AppString.services.localize(context) ?? 'Services',
                items: InspectionDropdownOptions.getServicesOptions(),
                initialValue: selectedServices,
                onChanged: onServicesChanged,
                validator: (value) =>
                    InspectionValidator.validateDropdown(value, "Services"),
              ),
            ]),

            // Additional Finishers Service Details Section (duplicate from original)
            const SizedBox(height: 16),
            Text(
              'Finishers and Services',
              style: AppStyling.mediumTextSize14
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Add Owner Button Section
            const SizedBox(height: 16),
            CustomButton(
              text: AppString.addOwner.localize(context) ?? 'Add Owner',
              onPressed: () {},
              backgroundColor: colors(context).colorGrey1!,
              width: 150,
              height: 48,
            ),

            // Image Capturing/Upload Section
            const SizedBox(height: 16),
            Text(
              AppString.imageCapturingUpload.localize(context) ??
                  'Image Capturing/Upload',
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
                      onDelete: () => onDeleteImage(index),
                      size: 128,
                    );
                  },
                ),
                ImageUpload(
                  isUploadButton: true,
                  onImagePicked: onImagePicked,
                  onDelete: () {},
                  size: 128,
                ),
              ],
            ),

            const SizedBox(height: 24),
            Container(
              height: 1,
              margin: const EdgeInsets.all(16),
              width: double.infinity,
              color: Colors.grey,
            ),
            Row(
              children: [
                CustomButton(
                  text: AppString.cancel.localize(context) ?? 'Cancel',
                  onPressed: onCancel,
                  backgroundColor: colors(context).colorGrey1!,
                ),
                const Spacer(),
                CustomButton(
                  text: saveButtonText,
                  onPressed: onSave,
                  backgroundColor: onSave != null
                      ? colors(context).colorPrimary1!
                      : colors(context).colorGrey1!,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
