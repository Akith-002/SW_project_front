import 'dart:io';
import 'package:flutter/material.dart';
import 'package:land_asset_valuation/data/models/building.dart';
import 'package:land_asset_valuation/application/pages/inspectionReport/widgets/building_list_widget.dart';
import 'package:land_asset_valuation/application/pages/inspectionReport/widgets/building_form_widget.dart';

class BuildingInfoTab extends StatelessWidget {
  final bool buildingsLoaded;
  final List<Building> availableBuildings;
  final Building? selectedBuilding;

  // For building list
  final Function(Building) onBuildingSelected;
  final Function(String) isBuildingFormComplete;
  final VoidCallback onGoBack;

  // For building form
  final GlobalKey<FormState> formKey;
  final VoidCallback onBackToList;

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

  const BuildingInfoTab({
    super.key,
    required this.buildingsLoaded,
    required this.availableBuildings,
    required this.selectedBuilding,
    required this.onBuildingSelected,
    required this.isBuildingFormComplete,
    required this.onGoBack,
    required this.formKey,
    required this.onBackToList,
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

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while buildings are being loaded
    if (!buildingsLoaded) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Show empty state if no buildings found
    if (availableBuildings.isEmpty) {
      return NoBuildingsWidget(onGoBack: onGoBack);
    }

    // Show building list or form based on selection
    if (selectedBuilding == null) {
      return BuildingListWidget(
        buildings: availableBuildings,
        onBuildingSelected: onBuildingSelected,
        isBuildingFormComplete: isBuildingFormComplete,
      );
    } else {
      return BuildingFormWidget(
        formKey: formKey,
        selectedBuilding: selectedBuilding!,
        onBack: onBackToList,
        buildingIdController: buildingIdController,
        buildingNameController: buildingNameController,
        buildingDetailsController: buildingDetailsController,
        noOfFloorsGPlusController: noOfFloorsGPlusController,
        noOfFloorsGMinusController: noOfFloorsGMinusController,
        ageController: ageController,
        expectedLifePeriodController: expectedLifePeriodController,
        parkingSpaceController: parkingSpaceController,
        designController: designController,
        conveniencesController: conveniencesController,
        structureController: structureController,
        selectedBuildingCategory: selectedBuildingCategory,
        selectedBuildingClass: selectedBuildingClass,
        selectedNatureOfConstruction: selectedNatureOfConstruction,
        selectedBuildingConditions: selectedBuildingConditions,
        selectedRoofMaterial: selectedRoofMaterial,
        selectedRoofFrame: selectedRoofFrame,
        selectedRoofFinisher: selectedRoofFinisher,
        selectedCeiling: selectedCeiling,
        selectedFoundationStructure: selectedFoundationStructure,
        selectedWallStructure: selectedWallStructure,
        selectedFloorStructure: selectedFloorStructure,
        selectedDoor: selectedDoor,
        selectedWindow: selectedWindow,
        selectedWindowProtection: selectedWindowProtection,
        selectedBathroomToiletDoorsFittings:
            selectedBathroomToiletDoorsFittings,
        selectedHandRail: selectedHandRail,
        selectedPantryCupboard: selectedPantryCupboard,
        selectedOtherDoors: selectedOtherDoors,
        selectedWallFinisher: selectedWallFinisher,
        selectedFloorFinisher: selectedFloorFinisher,
        selectedBathroomToilet: selectedBathroomToilet,
        selectedServices: selectedServices,
        onBuildingCategoryChanged: onBuildingCategoryChanged,
        onBuildingClassChanged: onBuildingClassChanged,
        onNatureOfConstructionChanged: onNatureOfConstructionChanged,
        onBuildingConditionsChanged: onBuildingConditionsChanged,
        onRoofMaterialChanged: onRoofMaterialChanged,
        onRoofFrameChanged: onRoofFrameChanged,
        onRoofFinisherChanged: onRoofFinisherChanged,
        onCeilingChanged: onCeilingChanged,
        onFoundationStructureChanged: onFoundationStructureChanged,
        onWallStructureChanged: onWallStructureChanged,
        onFloorStructureChanged: onFloorStructureChanged,
        onDoorChanged: onDoorChanged,
        onWindowChanged: onWindowChanged,
        onWindowProtectionChanged: onWindowProtectionChanged,
        onBathroomToiletDoorsFittingsChanged:
            onBathroomToiletDoorsFittingsChanged,
        onHandRailChanged: onHandRailChanged,
        onPantryCupboardChanged: onPantryCupboardChanged,
        onOtherDoorsChanged: onOtherDoorsChanged,
        onWallFinisherChanged: onWallFinisherChanged,
        onFloorFinisherChanged: onFloorFinisherChanged,
        onBathroomToiletChanged: onBathroomToiletChanged,
        onServicesChanged: onServicesChanged,
        uploadedImages: uploadedImages,
        onImagePicked: onImagePicked,
        onDeleteImage: onDeleteImage,
        onSave: onSave,
        saveButtonText: saveButtonText,
        onCancel: onCancel,
      );
    }
  }
}
