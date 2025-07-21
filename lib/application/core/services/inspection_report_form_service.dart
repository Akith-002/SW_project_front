import 'package:land_asset_valuation/data/models/inspection_report_model.dart';

class InspectionReportFormData {
  // Inspection Report Info
  String masterFileId = '';
  String masterFileRefNo = '';
  DateTime? inspectionDate;
  String dsDivision = '';
  String district = '';
  String province = '';
  String gnDivision = '';
  String village = '';

  // Buildings data (will be built up through the form)
  List<InspectionReportBuilding> buildings = [];

  // Additional information
  String otherInformation = '';
  String otherConstructionDetails = '';
  String detailsOfAssestsInventoryItems = '';
  String detailsOfBusiness = '';
  String remark = '';

  // Convert form data to API model
  InspectionReportModel toInspectionReportModel() {
    return InspectionReportModel(
      masterFileId: masterFileId,
      masterFileRefNo: masterFileRefNo,
      inspectionDate: inspectionDate ?? DateTime.now().toUtc(),
      dsDivision: dsDivision,
      district: district,
      province: province,
      gnDivision: gnDivision,
      village: village,
      buildings: buildings,
      otherInformation: otherInformation,
      otherConstructionDetails: otherConstructionDetails,
      detailsOfAssestsInventoryItems: detailsOfAssestsInventoryItems,
      detailsOfBusiness: detailsOfBusiness,
      remark: remark,
    );
  }

  // Generate detailed notes for debugging
  String generateDetailedNotes() {
    final StringBuffer notes = StringBuffer();

    notes.writeln('INSPECTION REPORT INFORMATION:');
    notes.writeln('Master File ID: $masterFileId');
    notes.writeln('Master File Ref No: $masterFileRefNo');
    notes.writeln('Inspection Date: ${inspectionDate?.toIso8601String()}');
    notes.writeln('DS Division: $dsDivision');
    notes.writeln('District: $district');
    notes.writeln('Province: $province');
    notes.writeln('GN Division: $gnDivision');
    notes.writeln('Village: $village');

    notes.writeln('\nBUILDINGS (${buildings.length}):');
    for (int i = 0; i < buildings.length; i++) {
      final building = buildings[i];
      notes.writeln('Building ${i + 1}:');
      notes.writeln('  ID: ${building.buildingId}');
      notes.writeln('  Name: ${building.buildingName}');
      notes.writeln('  Category: ${building.buildingCategory}');
      notes.writeln('  Class: ${building.buildingClass}');
      notes.writeln('  Detail: ${building.detailOfBuilding}');
      notes.writeln('  Floors Above Ground: ${building.noOfFloorsAboveGround}');
      notes.writeln('  Floors Below Ground: ${building.noOfFloorsBelowGround}');
      notes.writeln('  Age (Years): ${building.ageYears}');
      notes.writeln(
          '  Expected Life Period: ${building.expectedLifePeriodYears}');
      notes.writeln('  Structure: ${building.structure}');
      notes.writeln('  Condition: ${building.condition}');
      notes.writeln('  Building Conditions: ${building.buildingConditions}');
      notes.writeln(
          '  Nature of Construction: ${building.natureOfConstruction}');
    }

    notes.writeln('\nADDITIONAL INFORMATION:');
    notes.writeln('Other Information: $otherInformation');
    notes.writeln('Other Construction Details: $otherConstructionDetails');
    notes.writeln('Assets Inventory Items: $detailsOfAssestsInventoryItems');
    notes.writeln('Business Details: $detailsOfBusiness');
    notes.writeln('Remarks: $remark');

    return notes.toString();
  }
}

// Global service to manage form data across all tabs
class InspectionReportFormService {
  static final InspectionReportFormService _instance =
      InspectionReportFormService._internal();
  factory InspectionReportFormService() => _instance;
  InspectionReportFormService._internal();

  final InspectionReportFormData formData = InspectionReportFormData();

  // Methods to update specific sections
  void updateBasicInfo({
    String? masterFileId,
    String? masterFileRefNo,
    DateTime? inspectionDate,
    String? dsDivision,
    String? district,
    String? province,
    String? gnDivision,
    String? village,
  }) {
    if (masterFileId != null) formData.masterFileId = masterFileId;
    if (masterFileRefNo != null) formData.masterFileRefNo = masterFileRefNo;
    if (inspectionDate != null)
      formData.inspectionDate = inspectionDate.toUtc();
    if (dsDivision != null) formData.dsDivision = dsDivision;
    if (district != null) formData.district = district;
    if (province != null) formData.province = province;
    if (gnDivision != null) formData.gnDivision = gnDivision;
    if (village != null) formData.village = village;
  }

  void addBuilding(InspectionReportBuilding building) {
    formData.buildings.add(building);
  }

  void updateBuilding(int index, InspectionReportBuilding building) {
    if (index >= 0 && index < formData.buildings.length) {
      formData.buildings[index] = building;
    }
  }

  void removeBuilding(int index) {
    if (index >= 0 && index < formData.buildings.length) {
      formData.buildings.removeAt(index);
    }
  }

  void updateAdditionalInfo({
    String? otherInformation,
    String? otherConstructionDetails,
    String? detailsOfAssestsInventoryItems,
    String? detailsOfBusiness,
    String? remark,
  }) {
    if (otherInformation != null) formData.otherInformation = otherInformation;
    if (otherConstructionDetails != null) {
      formData.otherConstructionDetails = otherConstructionDetails;
    }
    if (detailsOfAssestsInventoryItems != null) {
      formData.detailsOfAssestsInventoryItems = detailsOfAssestsInventoryItems;
    }
    if (detailsOfBusiness != null)
      formData.detailsOfBusiness = detailsOfBusiness;
    if (remark != null) formData.remark = remark;
  }

  // Clear all form data
  void reset() {
    formData.masterFileId = '';
    formData.masterFileRefNo = '';
    formData.inspectionDate = null;
    formData.dsDivision = '';
    formData.district = '';
    formData.province = '';
    formData.gnDivision = '';
    formData.village = '';
    formData.buildings.clear();
    formData.otherInformation = '';
    formData.otherConstructionDetails = '';
    formData.detailsOfAssestsInventoryItems = '';
    formData.detailsOfBusiness = '';
    formData.remark = '';
  }

  // Helper methods for validation
  bool isBasicInfoComplete() {
    return formData.masterFileId.isNotEmpty &&
        formData.masterFileRefNo.isNotEmpty &&
        formData.inspectionDate != null &&
        formData.dsDivision.isNotEmpty &&
        formData.district.isNotEmpty &&
        formData.province.isNotEmpty &&
        formData.gnDivision.isNotEmpty &&
        formData.village.isNotEmpty;
  }

  bool hasBuildingData() {
    return formData.buildings.isNotEmpty;
  }

  bool isReadyForSubmission() {
    return isBasicInfoComplete() && hasBuildingData();
  }
}
