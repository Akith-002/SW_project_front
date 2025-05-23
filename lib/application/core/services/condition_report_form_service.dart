import 'package:flutter/material.dart';
import 'package:land_asset_valuation/data/models/condition_report_model.dart';

class ConditionReportFormData {
  // Land Info data
  String nameOfTheVillage = '';
  String nameOfTheLand = '';
  String atPlanNumber = '';
  String atLotNumber = '';
  String ppCadNumber = '';
  String ppCadLotNumber = '';
  String acquiredExtent = '';
  String assessmentNumber = '';
  String roadName = '';
  String accessCategory = '';
  String accessCategoryDescription = '';
  String descriptionOfLand = '';
  String landUseDescription = '';
  String landUseType = '';
  String frontage = '';
  String depthOfLand = '';
  String levelWithAccess = '';
  String plantationDetails = '';
  String detailsOfBusiness = '';
  String acquisitionName = '';
  String datePrepared = '';
  String dateOfSection3BA = '';

  // Boundaries
  String boundaryNorth = '';
  String boundaryEast = '';
  String boundaryWest = '';
  String boundarySouth = '';
  String boundaryBottom = '';

  // Building Info data
  String buildingDescription = '';
  String buildingInfo = '';

  // Other Constructions data
  String otherConstructionsDescription = '';
  String otherConstructionsInfo = '';

  // Signatures
  String acquiringOfficerSignature = '';
  String gramasewakaSignature = '';
  String chiefValuerRepresentativeSignature = '';

  // Convert form data to API model
  ConditionReportModel toConditionReportModel(String masterFileId) {
    return ConditionReportModel(
      masterFileId: masterFileId,
      nameOfTheVillage: nameOfTheVillage,
      nameOfTheLand: nameOfTheLand,
      atPlanNumber: atPlanNumber,
      atLotNumber: atLotNumber,
      ppCadNumber: ppCadNumber,
      ppCadLotNumber: ppCadLotNumber,
      acquiredExtent: acquiredExtent,
      assessmentNumber: assessmentNumber,
      roadName: roadName,
      accessCategory: accessCategory,
      accessCategoryDescription: accessCategoryDescription,
      descriptionOfLand: descriptionOfLand,
      landUseDescription: landUseDescription,
      landUseType: landUseType,
      frontage: frontage,
      depthOfLand: depthOfLand,
      levelWithAccess: levelWithAccess,
      plantationDetails: plantationDetails,
      detailsOfBusiness: detailsOfBusiness,
      acquisitionName: acquisitionName,
      datePrepared: datePrepared,
      dateOfSection3BA: dateOfSection3BA,
      boundaryNorth: boundaryNorth,
      boundaryEast: boundaryEast,
      boundaryWest: boundaryWest,
      boundarySouth: boundarySouth,
      boundaryBottom: boundaryBottom,
      buildingDescription: buildingDescription,
      buildingInfo: buildingInfo,
      otherConstructionsDescription: otherConstructionsDescription,
      otherConstructionsInfo: otherConstructionsInfo,
      acquiringOfficerSignature: acquiringOfficerSignature,
      gramasewakaSignature: gramasewakaSignature,
      chiefValuerRepresentativeSignature: chiefValuerRepresentativeSignature,
    );
  }

  // Generate a comprehensive notes field from all collected data (for debugging)
  String generateDetailedNotes() {
    final StringBuffer notes = StringBuffer();

    // Land Info section
    notes.writeln('LAND INFORMATION:');
    notes.writeln('Village: $nameOfTheVillage');
    notes.writeln('Land name: $nameOfTheLand');
    notes.writeln('AT Plan Number: $atPlanNumber');
    notes.writeln('AT Lot Number: $atLotNumber');
    notes.writeln('PP Cad Number: $ppCadNumber');
    notes.writeln('PP Cad Lot Number: $ppCadLotNumber');

    // Boundaries
    notes.writeln('\nBOUNDARIES:');
    notes.writeln('North: $boundaryNorth');
    notes.writeln('East: $boundaryEast');
    notes.writeln('West: $boundaryWest');
    notes.writeln('South: $boundarySouth');
    notes.writeln('Bottom: $boundaryBottom');

    // Building section
    notes.writeln('\nBUILDING INFORMATION:');
    notes.writeln('Description: $buildingDescription');
    notes.writeln('Info: $buildingInfo');

    // Other Constructions section
    notes.writeln('\nOTHER CONSTRUCTIONS:');
    notes.writeln('Description: $otherConstructionsDescription');
    notes.writeln('Info: $otherConstructionsInfo');

    return notes.toString();
  }
}

// Global service to manage form data across all tabs
class ConditionReportFormService {
  static final ConditionReportFormService _instance =
      ConditionReportFormService._internal();
  factory ConditionReportFormService() => _instance;
  ConditionReportFormService._internal();

  final ConditionReportFormData formData = ConditionReportFormData();

  // Methods to update specific sections
  void updateLandInfo({
    String? nameOfTheVillage,
    String? nameOfTheLand,
    String? atPlanNumber,
    String? atLotNumber,
    String? ppCadNumber,
    String? ppCadLotNumber,
    String? acquiredExtent,
    String? assessmentNumber,
    String? roadName,
    String? accessCategory,
    String? accessCategoryDescription,
    String? descriptionOfLand,
    String? landUseDescription,
    String? landUseType,
    String? frontage,
    String? depthOfLand,
    String? levelWithAccess,
    String? plantationDetails,
    String? detailsOfBusiness,
    String? acquisitionName,
    String? datePrepared,
    String? dateOfSection3BA,
  }) {
    if (nameOfTheVillage != null) formData.nameOfTheVillage = nameOfTheVillage;
    if (nameOfTheLand != null) formData.nameOfTheLand = nameOfTheLand;
    if (atPlanNumber != null) formData.atPlanNumber = atPlanNumber;
    if (atLotNumber != null) formData.atLotNumber = atLotNumber;
    if (ppCadNumber != null) formData.ppCadNumber = ppCadNumber;
    if (ppCadLotNumber != null) formData.ppCadLotNumber = ppCadLotNumber;
    if (acquiredExtent != null) formData.acquiredExtent = acquiredExtent;
    if (assessmentNumber != null) formData.assessmentNumber = assessmentNumber;
    if (roadName != null) formData.roadName = roadName;
    if (accessCategory != null) formData.accessCategory = accessCategory;
    if (accessCategoryDescription != null)
      formData.accessCategoryDescription = accessCategoryDescription;
    if (descriptionOfLand != null)
      formData.descriptionOfLand = descriptionOfLand;
    if (landUseDescription != null)
      formData.landUseDescription = landUseDescription;
    if (landUseType != null) formData.landUseType = landUseType;
    if (frontage != null) formData.frontage = frontage;
    if (depthOfLand != null) formData.depthOfLand = depthOfLand;
    if (levelWithAccess != null) formData.levelWithAccess = levelWithAccess;
    if (plantationDetails != null)
      formData.plantationDetails = plantationDetails;
    if (detailsOfBusiness != null)
      formData.detailsOfBusiness = detailsOfBusiness;
    if (acquisitionName != null) formData.acquisitionName = acquisitionName;
    if (datePrepared != null) formData.datePrepared = datePrepared;
    if (dateOfSection3BA != null) formData.dateOfSection3BA = dateOfSection3BA;
  }

  void updateBoundaries({
    String? north,
    String? east,
    String? west,
    String? south,
    String? bottom,
  }) {
    if (north != null) formData.boundaryNorth = north;
    if (east != null) formData.boundaryEast = east;
    if (west != null) formData.boundaryWest = west;
    if (south != null) formData.boundarySouth = south;
    if (bottom != null) formData.boundaryBottom = bottom;
  }

  void updateBuildingInfo({
    String? buildingDescription,
    String? buildingInfo,
  }) {
    if (buildingDescription != null)
      formData.buildingDescription = buildingDescription;
    if (buildingInfo != null) formData.buildingInfo = buildingInfo;
  }

  void updateOtherConstructions({
    String? otherConstructionsDescription,
    String? otherConstructionsInfo,
  }) {
    if (otherConstructionsDescription != null)
      formData.otherConstructionsDescription = otherConstructionsDescription;
    if (otherConstructionsInfo != null)
      formData.otherConstructionsInfo = otherConstructionsInfo;
  }

  void updateSignatures({
    String? acquiringOfficerSignature,
    String? gramasewakaSignature,
    String? chiefValuerRepresentativeSignature,
  }) {
    if (acquiringOfficerSignature != null)
      formData.acquiringOfficerSignature = acquiringOfficerSignature;
    if (gramasewakaSignature != null)
      formData.gramasewakaSignature = gramasewakaSignature;
    if (chiefValuerRepresentativeSignature != null)
      formData.chiefValuerRepresentativeSignature =
          chiefValuerRepresentativeSignature;
  }

  // Clear all form data
  void reset() {
    formData.nameOfTheVillage = '';
    formData.nameOfTheLand = '';
    formData.atPlanNumber = '';
    formData.atLotNumber = '';
    formData.ppCadNumber = '';
    formData.ppCadLotNumber = '';
    formData.acquiredExtent = '';
    formData.assessmentNumber = '';
    formData.roadName = '';
    formData.accessCategory = '';
    formData.accessCategoryDescription = '';
    formData.descriptionOfLand = '';
    formData.landUseDescription = '';
    formData.landUseType = '';
    formData.frontage = '';
    formData.depthOfLand = '';
    formData.levelWithAccess = '';
    formData.plantationDetails = '';
    formData.detailsOfBusiness = '';
    formData.acquisitionName = '';
    formData.datePrepared = '';
    formData.dateOfSection3BA = '';

    formData.boundaryNorth = '';
    formData.boundaryEast = '';
    formData.boundaryWest = '';
    formData.boundarySouth = '';
    formData.boundaryBottom = '';

    formData.buildingDescription = '';
    formData.buildingInfo = '';

    formData.otherConstructionsDescription = '';
    formData.otherConstructionsInfo = '';

    formData.acquiringOfficerSignature = '';
    formData.gramasewakaSignature = '';
    formData.chiefValuerRepresentativeSignature = '';
  }
}
