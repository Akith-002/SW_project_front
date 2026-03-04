import 'dart:io';
import 'package:flutter/material.dart';
import 'package:land_asset_valuation/data/models/building.dart';

class InspectionFormHelpers {
  /// Check if building form is completely empty
  static bool isBuildingFormEmpty({
    required TextEditingController buildingDetailsController,
    required TextEditingController noOfFloorsGPlusController,
    required TextEditingController noOfFloorsGMinusController,
    required TextEditingController ageController,
    required TextEditingController expectedLifePeriodController,
    required TextEditingController structureController,
    required TextEditingController parkingSpaceController,
    required TextEditingController designController,
    required TextEditingController conveniencesController,
    required String? selectedBuildingCategory,
    required String? selectedBuildingClass,
    required String? selectedNatureOfConstruction,
    required String? selectedBuildingConditions,
    required List<dynamic> uploadedImages,
  }) {
    // Don't count building ID and name as they are auto-filled when building is selected
    // Check if all user-entered required text controllers are empty
    bool userTextFieldsEmpty = buildingDetailsController.text.trim().isEmpty &&
        noOfFloorsGPlusController.text.trim().isEmpty &&
        noOfFloorsGMinusController.text.trim().isEmpty &&
        ageController.text.trim().isEmpty &&
        expectedLifePeriodController.text.trim().isEmpty &&
        structureController.text.trim().isEmpty;

    // Check if all required dropdowns are empty
    bool dropdownsEmpty = selectedBuildingCategory == null &&
        selectedBuildingClass == null &&
        selectedNatureOfConstruction == null &&
        selectedBuildingConditions == null;

    // Check if optional fields are also empty
    bool optionalFieldsEmpty = parkingSpaceController.text.trim().isEmpty &&
        designController.text.trim().isEmpty &&
        conveniencesController.text.trim().isEmpty;

    // Check if no images are uploaded
    bool noImages = uploadedImages.isEmpty;

    // Form is considered empty if all user-filled required fields and dropdowns are empty
    return userTextFieldsEmpty &&
        dropdownsEmpty &&
        optionalFieldsEmpty &&
        noImages;
  }

  /// Check if user has started filling form but hasn't completed it
  static bool isBuildingFormPartiallyFilled({
    required TextEditingController noOfFloorsGPlusController,
    required TextEditingController noOfFloorsGMinusController,
    required TextEditingController ageController,
    required TextEditingController expectedLifePeriodController,
    required TextEditingController structureController,
    required String? selectedBuildingCategory,
    required String? selectedBuildingClass,
    required String? selectedNatureOfConstruction,
    required String? selectedBuildingConditions,
  }) {
    // Count filled required fields (excluding auto-filled Building ID and Name)
    int filledRequiredFields = 0;
    int totalRequiredFields =
        9; // Floors G+, Floors G-, Age, Expected Life, Structure + 4 dropdowns

    // Don't count auto-filled fields: buildingIdController and buildingNameController
    if (noOfFloorsGPlusController.text.trim().isNotEmpty) {
      filledRequiredFields++;
    }
    if (noOfFloorsGMinusController.text.trim().isNotEmpty) {
      filledRequiredFields++;
    }
    if (ageController.text.trim().isNotEmpty) filledRequiredFields++;
    if (expectedLifePeriodController.text.trim().isNotEmpty) {
      filledRequiredFields++;
    }
    if (structureController.text.trim().isNotEmpty) filledRequiredFields++;
    if (selectedBuildingCategory != null) filledRequiredFields++;
    if (selectedBuildingClass != null) filledRequiredFields++;
    if (selectedNatureOfConstruction != null) filledRequiredFields++;
    if (selectedBuildingConditions != null) filledRequiredFields++;

    // Return true if some but not all required fields are filled
    return filledRequiredFields > 0 &&
        filledRequiredFields < totalRequiredFields;
  }

  /// Get appropriate save button text based on form state
  static String getSaveButtonText({
    required bool isEmpty,
    required bool isPartiallyFilled,
    required String defaultText,
  }) {
    if (isEmpty) {
      return 'Fill Form to Save';
    } else if (isPartiallyFilled) {
      return 'Complete Required Fields';
    } else {
      return defaultText;
    }
  }

  /// Validate required fields manually
  static List<String> validateRequiredFields({
    required TextEditingController buildingIdController,
    required TextEditingController buildingNameController,
    required TextEditingController noOfFloorsGPlusController,
    required TextEditingController noOfFloorsGMinusController,
    required TextEditingController ageController,
    required TextEditingController expectedLifePeriodController,
    required TextEditingController structureController,
    required String? selectedBuildingCategory,
    required String? selectedBuildingClass,
    required String? selectedNatureOfConstruction,
    required String? selectedBuildingConditions,
  }) {
    List<String> errors = [];

    // Check required text fields
    if (buildingIdController.text.trim().isEmpty) {
      errors.add('Building ID');
    }
    if (buildingNameController.text.trim().isEmpty) {
      errors.add('Building Name');
    }
    if (noOfFloorsGPlusController.text.trim().isEmpty) {
      errors.add('Number of Floors (G+)');
    }
    if (noOfFloorsGMinusController.text.trim().isEmpty) {
      errors.add('Number of Floors (G-)');
    }
    if (ageController.text.trim().isEmpty) {
      errors.add('Age');
    }
    if (expectedLifePeriodController.text.trim().isEmpty) {
      errors.add('Expected Life Period');
    }
    if (structureController.text.trim().isEmpty) {
      errors.add('Structure');
    }

    // Check required dropdown fields
    if (selectedBuildingCategory == null || selectedBuildingCategory.isEmpty) {
      errors.add('Building Category');
    }
    if (selectedBuildingClass == null || selectedBuildingClass.isEmpty) {
      errors.add('Building Class');
    }
    if (selectedNatureOfConstruction == null ||
        selectedNatureOfConstruction.isEmpty) {
      errors.add('Nature of Construction');
    }
    if (selectedBuildingConditions == null ||
        selectedBuildingConditions.isEmpty) {
      errors.add('Building Conditions');
    }

    return errors;
  }

  /// Collect all form data
  static Map<String, dynamic> collectFormData({
    required TextEditingController masterFileRefController,
    required TextEditingController inspectionDateController,
    required TextEditingController dsDivisionController,
    required TextEditingController districtController,
    required TextEditingController provinceController,
    required TextEditingController buildingIdController,
    required TextEditingController buildingNameController,
    required TextEditingController buildingDetailsController,
    required TextEditingController noOfFloorsGPlusController,
    required TextEditingController noOfFloorsGMinusController,
    required TextEditingController ageController,
    required TextEditingController expectedLifePeriodController,
    required TextEditingController parkingSpaceController,
    required TextEditingController designController,
    required TextEditingController conveniencesController,
    required TextEditingController structureController,
    required String? selectedBuildingConditions,
    required String? selectedBuildingCategory,
    required String? selectedBuildingClass,
    required String? selectedNatureOfConstruction,
    required String? selectedRoofMaterial,
    required String? selectedRoofFrame,
    required String? selectedRoofFinisher,
    required String? selectedCeiling,
    required String? selectedFoundationStructure,
    required String? selectedWallStructure,
    required String? selectedFloorStructure,
    required String? selectedDoor,
    required String? selectedWindow,
    required String? selectedWindowProtection,
    required String? selectedBathroomToiletDoorsFittings,
    required String? selectedHandRail,
    required String? selectedPantryCupboard,
    required String? selectedOtherDoors,
    required String? selectedWallFinisher,
    required String? selectedFloorFinisher,
    required String? selectedBathroomToilet,
    required String? selectedServices,
    required Building? selectedBuilding,
    required List<dynamic> uploadedImages,
  }) {
    return {
      'masterFileRef': masterFileRefController.text,
      'inspectionDate': inspectionDateController.text,
      'dsDivision': dsDivisionController.text,
      'district': districtController.text,
      'province': provinceController.text,
      'buildingId': buildingIdController.text,
      'buildingName': buildingNameController.text,
      'buildingDetails': buildingDetailsController.text,
      'noOfFloorsGPlus': noOfFloorsGPlusController.text,
      'noOfFloorsGMinus': noOfFloorsGMinusController.text,
      'age': ageController.text,
      'expectedLifePeriod': expectedLifePeriodController.text,
      'parkingSpace': parkingSpaceController.text,
      'design': designController.text,
      'conveniences': conveniencesController.text,
      'structure': structureController.text,
      'buildingConditions': selectedBuildingConditions,
      'buildingCategory': selectedBuildingCategory,
      'buildingClass': selectedBuildingClass,
      'natureOfConstruction': selectedNatureOfConstruction,
      // Building specification fields
      'roofMaterial': selectedRoofMaterial,
      'roofFrame': selectedRoofFrame,
      'roofFinisher': selectedRoofFinisher,
      'ceiling': selectedCeiling,
      'foundationStructure': selectedFoundationStructure,
      'wallStructure': selectedWallStructure,
      'floorStructure': selectedFloorStructure,
      'door': selectedDoor,
      'window': selectedWindow,
      'windowProtection': selectedWindowProtection,
      'bathroomToiletDoorsFittings': selectedBathroomToiletDoorsFittings,
      'handRail': selectedHandRail,
      'pantryCupboard': selectedPantryCupboard,
      'otherDoors': selectedOtherDoors,
      'wallFinisher': selectedWallFinisher,
      'floorFinisher': selectedFloorFinisher,
      'bathroomToilet': selectedBathroomToilet,
      'services': selectedServices,
      'selectedBuilding': selectedBuilding?.toJson(),
      'images': uploadedImages
          .map((img) => img is File ? img.path : img.toString())
          .toList(),
      'savedAt': DateTime.now().toIso8601String(),
    };
  }

  /// Collect land info data
  static Map<String, dynamic> collectLandInfoData({
    required TextEditingController masterFileRefController,
    required TextEditingController inspectionDateController,
    required TextEditingController dsDivisionController,
    required TextEditingController districtController,
    required TextEditingController provinceController,
  }) {
    return {
      'masterFileRef': masterFileRefController.text,
      'inspectionDate': inspectionDateController.text,
      'dsDivision': dsDivisionController.text,
      'district': districtController.text,
      'province': provinceController.text,
    };
  }

  /// Collect other constructions data
  static Map<String, dynamic> collectOtherConstructionsData({
    required TextEditingController otherInfoController,
    required TextEditingController otherConstructionDetailsController,
    required TextEditingController assetDetailsController,
    required TextEditingController businessDetailsController,
    required TextEditingController remarksController,
  }) {
    return {
      'otherInfo': otherInfoController.text,
      'otherConstructionDetails': otherConstructionDetailsController.text,
      'assetDetails': assetDetailsController.text,
      'businessDetails': businessDetailsController.text,
      'remarks': remarksController.text,
    };
  }

  /// Clear building form data
  static void clearBuildingForm({
    required TextEditingController buildingIdController,
    required TextEditingController buildingNameController,
    required TextEditingController buildingDetailsController,
    required TextEditingController noOfFloorsGPlusController,
    required TextEditingController noOfFloorsGMinusController,
    required TextEditingController ageController,
    required TextEditingController expectedLifePeriodController,
    required TextEditingController parkingSpaceController,
    required TextEditingController designController,
    required TextEditingController conveniencesController,
    required TextEditingController structureController,
    required TextEditingController buildingConditionsController,
    required List<dynamic> uploadedImages,
    required Function onClearDropdowns,
  }) {
    buildingIdController.clear();
    buildingNameController.clear();
    buildingDetailsController.clear();
    noOfFloorsGPlusController.clear();
    noOfFloorsGMinusController.clear();
    ageController.clear();
    expectedLifePeriodController.clear();
    parkingSpaceController.clear();
    designController.clear();
    conveniencesController.clear();
    structureController.clear();
    buildingConditionsController.clear();

    // Clear uploaded images
    uploadedImages.clear();

    // Call callback to clear dropdowns
    onClearDropdowns();
  }
}
