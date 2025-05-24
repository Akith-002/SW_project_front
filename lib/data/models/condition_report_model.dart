import 'dart:convert';

class ConditionReportModel {
  final int? id;
  final String masterFileId;
  final String nameOfTheVillage;
  final String nameOfTheLand;
  final String atPlanNumber;
  final String atLotNumber;
  final String ppCadNumber;
  final String ppCadLotNumber;
  final String acquiredExtent;
  final String assessmentNumber;
  final String roadName;
  final String accessCategory;
  final String accessCategoryDescription;
  final String descriptionOfLand;
  final String landUseDescription;
  final String landUseType;
  final String frontage;
  final String depthOfLand;
  final String levelWithAccess;
  final String plantationDetails;
  final String detailsOfBusiness;
  final String acquisitionName;
  final String datePrepared;
  final String dateOfSection3BA;
  final String boundaryNorth;
  final String boundaryEast;
  final String boundaryWest;
  final String boundarySouth;
  final String boundaryBottom;
  final String buildingDescription;
  final String buildingInfo;
  final String otherConstructionsDescription;
  final String otherConstructionsInfo;
  final String acquiringOfficerSignature;
  final String gramasewakaSignature;
  final String chiefValuerRepresentativeSignature;
  final DateTime? createdAt;

  ConditionReportModel({
    this.id,
    required this.masterFileId,
    required this.nameOfTheVillage,
    required this.nameOfTheLand,
    required this.atPlanNumber,
    required this.atLotNumber,
    required this.ppCadNumber,
    required this.ppCadLotNumber,
    required this.acquiredExtent,
    required this.assessmentNumber,
    required this.roadName,
    required this.accessCategory,
    required this.accessCategoryDescription,
    required this.descriptionOfLand,
    required this.landUseDescription,
    required this.landUseType,
    required this.frontage,
    required this.depthOfLand,
    required this.levelWithAccess,
    required this.plantationDetails,
    required this.detailsOfBusiness,
    required this.acquisitionName,
    required this.datePrepared,
    required this.dateOfSection3BA,
    required this.boundaryNorth,
    required this.boundaryEast,
    required this.boundaryWest,
    required this.boundarySouth,
    required this.boundaryBottom,
    required this.buildingDescription,
    required this.buildingInfo,
    required this.otherConstructionsDescription,
    required this.otherConstructionsInfo,
    required this.acquiringOfficerSignature,
    required this.gramasewakaSignature,
    required this.chiefValuerRepresentativeSignature,
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'masterFileId': masterFileId,
      'nameOfTheVillage': nameOfTheVillage,
      'nameOfTheLand': nameOfTheLand,
      'atPlanNumber': atPlanNumber,
      'atLotNumber': atLotNumber,
      'ppCadNumber': ppCadNumber,
      'ppCadLotNumber': ppCadLotNumber,
      'acquiredExtent': acquiredExtent,
      'assessmentNumber': assessmentNumber,
      'roadName': roadName,
      'accessCategory': accessCategory,
      'accessCategoryDescription': accessCategoryDescription,
      'descriptionOfLand': descriptionOfLand,
      'landUseDescription': landUseDescription,
      'landUseType': landUseType,
      'frontage': frontage,
      'depthOfLand': depthOfLand,
      'levelWithAccess': levelWithAccess,
      'plantationDetails': plantationDetails,
      'detailsOfBusiness': detailsOfBusiness,
      'acquisitionName': acquisitionName,
      'datePrepared': datePrepared,
      'dateOfSection3BA': dateOfSection3BA,
      'boundaryNorth': boundaryNorth,
      'boundaryEast': boundaryEast,
      'boundaryWest': boundaryWest,
      'boundarySouth': boundarySouth,
      'boundaryBottom': boundaryBottom,
      'buildingDescription': buildingDescription,
      'buildingInfo': buildingInfo,
      'otherConstructionsDescription': otherConstructionsDescription,
      'otherConstructionsInfo': otherConstructionsInfo,
      'acquiringOfficerSignature': acquiringOfficerSignature,
      'gramasewakaSignature': gramasewakaSignature,
      'chiefValuerRepresentativeSignature': chiefValuerRepresentativeSignature,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    };
  }

  factory ConditionReportModel.fromJson(Map<String, dynamic> json) {
    return ConditionReportModel(
      id: json['id'],
      masterFileId: json['masterFileId'] ?? '',
      nameOfTheVillage: json['nameOfTheVillage'] ?? '',
      nameOfTheLand: json['nameOfTheLand'] ?? '',
      atPlanNumber: json['atPlanNumber'] ?? '',
      atLotNumber: json['atLotNumber'] ?? '',
      ppCadNumber: json['ppCadNumber'] ?? '',
      ppCadLotNumber: json['ppCadLotNumber'] ?? '',
      acquiredExtent: json['acquiredExtent'] ?? '',
      assessmentNumber: json['assessmentNumber'] ?? '',
      roadName: json['roadName'] ?? '',
      accessCategory: json['accessCategory'] ?? '',
      accessCategoryDescription: json['accessCategoryDescription'] ?? '',
      descriptionOfLand: json['descriptionOfLand'] ?? '',
      landUseDescription: json['landUseDescription'] ?? '',
      landUseType: json['landUseType'] ?? '',
      frontage: json['frontage'] ?? '',
      depthOfLand: json['depthOfLand'] ?? '',
      levelWithAccess: json['levelWithAccess'] ?? '',
      plantationDetails: json['plantationDetails'] ?? '',
      detailsOfBusiness: json['detailsOfBusiness'] ?? '',
      acquisitionName: json['acquisitionName'] ?? '',
      datePrepared: json['datePrepared'] ?? '',
      dateOfSection3BA: json['dateOfSection3BA'] ?? '',
      boundaryNorth: json['boundaryNorth'] ?? '',
      boundaryEast: json['boundaryEast'] ?? '',
      boundaryWest: json['boundaryWest'] ?? '',
      boundarySouth: json['boundarySouth'] ?? '',
      boundaryBottom: json['boundaryBottom'] ?? '',
      buildingDescription: json['buildingDescription'] ?? '',
      buildingInfo: json['buildingInfo'] ?? '',
      otherConstructionsDescription:
          json['otherConstructionsDescription'] ?? '',
      otherConstructionsInfo: json['otherConstructionsInfo'] ?? '',
      acquiringOfficerSignature: json['acquiringOfficerSignature'] ?? '',
      gramasewakaSignature: json['gramasewakaSignature'] ?? '',
      chiefValuerRepresentativeSignature:
          json['chiefValuerRepresentativeSignature'] ?? '',
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
