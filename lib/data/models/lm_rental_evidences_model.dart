import 'dart:convert';

class LmRentalEvidencesModel {
  final int? id;
  final int landMiscellaneousMasterFileId;
  final String masterFileRefNo;
  final String assessmentNo;
  final String owner;
  final String occupier;
  final String description;
  final String floorRate;
  final String ratePer;
  final String ratePerMonth;
  final String locationLongitude;
  final String locationLatitude;
  final String headOfTerms;
  final String situation;
  final String remarks;
  final DateTime? createdAt;

  LmRentalEvidencesModel({
    this.id,
    required this.landMiscellaneousMasterFileId,
    required this.masterFileRefNo,
    required this.assessmentNo,
    required this.owner,
    required this.occupier,
    required this.description,
    required this.floorRate,
    required this.ratePer,
    required this.ratePerMonth,
    required this.locationLongitude,
    required this.locationLatitude,
    required this.headOfTerms,
    required this.situation,
    required this.remarks,
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'masterFileRefNo': masterFileRefNo,
      'landMiscellaneousMasterFileId': landMiscellaneousMasterFileId,
      'assessmentNo': assessmentNo,
      'owner': owner,
      'occupier': occupier,
      'description': description,
      'floorRate': floorRate,
      'ratePer': ratePer,
      'ratePerMonth': ratePerMonth,
      'locationLongitude': locationLongitude,
      'locationLatitude': locationLatitude,
      'headOfTerms': headOfTerms,
      'situation': situation,
      'remarks': remarks,
    };
  }

  factory LmRentalEvidencesModel.fromJson(Map<String, dynamic> json) {
    return LmRentalEvidencesModel(
      id: json['id'],
      landMiscellaneousMasterFileId: json['landMiscellaneousMasterFileId'] ?? 0,
      masterFileRefNo: json['masterFileRefNo'] ?? '',
      assessmentNo: json['assessmentNo'] ?? '',
      owner: json['owner'] ?? '',
      occupier: json['occupier'] ?? '',
      description: json['description'] ?? '',
      floorRate: json['floorRate'] ?? '',
      ratePer: json['ratePer'] ?? '',
      ratePerMonth: json['ratePerMonth'] ?? '',
      locationLongitude: json['locationLongitude'] ?? '',
      locationLatitude: json['locationLatitude'] ?? '',
      headOfTerms: json['headOfTerms'] ?? '',
      situation: json['situation'] ?? '',
      remarks: json['remarks'] ?? '',
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
