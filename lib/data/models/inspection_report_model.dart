import 'dart:convert';

class InspectionReportModel {
  final int? inspectionReportId;
  final int? reportId;
  final String masterFileId;
  final String masterFileRefNo;
  final DateTime inspectionDate;
  final String dsDivision;
  final String district;
  final String province;
  final String gnDivision;
  final String village;
  final List<InspectionReportBuilding> buildings;
  final String otherInformation;
  final String otherConstructionDetails;
  final String detailsOfAssestsInventoryItems;
  final String detailsOfBusiness;
  final String remark;
  final DateTime? createdAt;

  InspectionReportModel({
    this.inspectionReportId,
    this.reportId,
    required this.masterFileId,
    required this.masterFileRefNo,
    required this.inspectionDate,
    required this.dsDivision,
    required this.district,
    required this.province,
    required this.gnDivision,
    required this.village,
    required this.buildings,
    required this.otherInformation,
    required this.otherConstructionDetails,
    required this.detailsOfAssestsInventoryItems,
    required this.detailsOfBusiness,
    required this.remark,
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      if (inspectionReportId != null) 'inspectionReportId': inspectionReportId,
      if (reportId != null) 'reportId': reportId,
      'masterFileId': masterFileId,
      'masterFileRefNo': masterFileRefNo,
      'inspectionDate': inspectionDate.toUtc().toIso8601String(),
      'dsDivision': dsDivision,
      'district': district,
      'province': province,
      'gnDivision': gnDivision,
      'village': village,
      'buildings': buildings.map((building) => building.toJson()).toList(),
      'otherInformation': otherInformation,
      'otherConstructionDetails': otherConstructionDetails,
      'detailsOfAssestsInventoryItems': detailsOfAssestsInventoryItems,
      'detailsOfBusiness': detailsOfBusiness,
      'remark': remark,
      if (createdAt != null) 'createdAt': createdAt!.toUtc().toIso8601String(),
    };
  }

  factory InspectionReportModel.fromJson(Map<String, dynamic> json) {
    return InspectionReportModel(
      inspectionReportId: json['inspectionReportId'],
      reportId: json['reportId'],
      masterFileId: json['masterFileId'] ?? '',
      masterFileRefNo: json['masterFileRefNo'] ?? '',
      inspectionDate: DateTime.parse(json['inspectionDate']),
      dsDivision: json['dsDivision'] ?? '',
      district: json['district'] ?? '',
      province: json['province'] ?? '',
      gnDivision: json['gnDivision'] ?? '',
      village: json['village'] ?? '',
      buildings: (json['buildings'] as List<dynamic>?)
              ?.map((building) => InspectionReportBuilding.fromJson(building))
              .toList() ??
          [],
      otherInformation: json['otherInformation'] ?? '',
      otherConstructionDetails: json['otherConstructionDetails'] ?? '',
      detailsOfAssestsInventoryItems:
          json['detailsOfAssestsInventoryItems'] ?? '',
      detailsOfBusiness: json['detailsOfBusiness'] ?? '',
      remark: json['remark'] ?? '',
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class InspectionReportBuilding {
  final int? id;
  final String buildingId;
  final String buildingName;
  final String buildingCategory;
  final String buildingClass;
  final String detailOfBuilding;
  final String noOfFloorsAboveGround;
  final String noOfFloorsBelowGround;
  final String ageYears;
  final String expectedLifePeriodYears;
  final String parkingSpace;
  final String design;
  final String conveniences;
  final String structure;
  final String buildingConditions;
  final String natureOfConstruction;
  final String condition;
  final String roofMaterial;
  final String roofFrame;
  final String roofFinisher;
  final String ceiling;
  final String foundationStructure;
  final String wallStructure;
  final String floorStructure;
  final String door;
  final String window;
  final String windowProtection;
  final String bathroomToiletDoorsFittings;
  final String handRail;
  final String pantryCupboard;
  final String otherDoors;
  final String wallFinisher;
  final String floorFinisher;
  final String bathroomToilet;
  final String services;

  InspectionReportBuilding({
    this.id,
    required this.buildingId,
    required this.buildingName,
    required this.buildingCategory,
    required this.buildingClass,
    required this.detailOfBuilding,
    required this.noOfFloorsAboveGround,
    required this.noOfFloorsBelowGround,
    required this.ageYears,
    required this.expectedLifePeriodYears,
    required this.parkingSpace,
    required this.design,
    required this.conveniences,
    required this.structure,
    required this.buildingConditions,
    required this.natureOfConstruction,
    required this.condition,
    required this.roofMaterial,
    required this.roofFrame,
    required this.roofFinisher,
    required this.ceiling,
    required this.foundationStructure,
    required this.wallStructure,
    required this.floorStructure,
    required this.door,
    required this.window,
    required this.windowProtection,
    required this.bathroomToiletDoorsFittings,
    required this.handRail,
    required this.pantryCupboard,
    required this.otherDoors,
    required this.wallFinisher,
    required this.floorFinisher,
    required this.bathroomToilet,
    required this.services,
  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'buildingId': buildingId,
      'buildingName': buildingName,
      'buildingCategory': buildingCategory,
      'buildingClass': buildingClass,
      'detailOfBuilding': detailOfBuilding,
      'noOfFloorsAboveGround': noOfFloorsAboveGround,
      'noOfFloorsBelowGround': noOfFloorsBelowGround,
      'ageYears': ageYears,
      'expectedLifePeriodYears': expectedLifePeriodYears,
      'parkingSpace': parkingSpace,
      'design': design,
      'conveniences': conveniences,
      'structure': structure,
      'buildingConditions': buildingConditions,
      'natureOfConstruction': natureOfConstruction,
      'condition': condition,
      'roofMaterial': roofMaterial,
      'roofFrame': roofFrame,
      'roofFinisher': roofFinisher,
      'ceiling': ceiling,
      'foundationStructure': foundationStructure,
      'wallStructure': wallStructure,
      'floorStructure': floorStructure,
      'door': door,
      'window': window,
      'windowProtection': windowProtection,
      'bathroomToiletDoorsFittings': bathroomToiletDoorsFittings,
      'handRail': handRail,
      'pantryCupboard': pantryCupboard,
      'otherDoors': otherDoors,
      'wallFinisher': wallFinisher,
      'floorFinisher': floorFinisher,
      'bathroomToilet': bathroomToilet,
      'services': services,
    };
  }

  factory InspectionReportBuilding.fromJson(Map<String, dynamic> json) {
    return InspectionReportBuilding(
      id: json['id'],
      buildingId: json['buildingId'] ?? '',
      buildingName: json['buildingName'] ?? '',
      buildingCategory: json['buildingCategory'] ?? '',
      buildingClass: json['buildingClass'] ?? '',
      detailOfBuilding: json['detailOfBuilding'] ?? '',
      noOfFloorsAboveGround: json['noOfFloorsAboveGround'] ?? '',
      noOfFloorsBelowGround: json['noOfFloorsBelowGround'] ?? '',
      ageYears: json['ageYears'] ?? '',
      expectedLifePeriodYears: json['expectedLifePeriodYears'] ?? '',
      parkingSpace: json['parkingSpace'] ?? '',
      design: json['design'] ?? '',
      conveniences: json['conveniences'] ?? '',
      structure: json['structure'] ?? '',
      buildingConditions: json['buildingConditions'] ?? '',
      natureOfConstruction: json['natureOfConstruction'] ?? '',
      condition: json['condition'] ?? '',
      roofMaterial: json['roofMaterial'] ?? '',
      roofFrame: json['roofFrame'] ?? '',
      roofFinisher: json['roofFinisher'] ?? '',
      ceiling: json['ceiling'] ?? '',
      foundationStructure: json['foundationStructure'] ?? '',
      wallStructure: json['wallStructure'] ?? '',
      floorStructure: json['floorStructure'] ?? '',
      door: json['door'] ?? '',
      window: json['window'] ?? '',
      windowProtection: json['windowProtection'] ?? '',
      bathroomToiletDoorsFittings: json['bathroomToiletDoorsFittings'] ?? '',
      handRail: json['handRail'] ?? '',
      pantryCupboard: json['pantryCupboard'] ?? '',
      otherDoors: json['otherDoors'] ?? '',
      wallFinisher: json['wallFinisher'] ?? '',
      floorFinisher: json['floorFinisher'] ?? '',
      bathroomToilet: json['bathroomToilet'] ?? '',
      services: json['services'] ?? '',
    );
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
