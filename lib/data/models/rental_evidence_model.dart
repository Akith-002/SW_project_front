import 'dart:convert';

class RentalEvidenceModel {
  final int? id;
  final String masterFileId;
  final String masterFileRefNo;
  final String assessmentNo;
  final String owner;
  final String occupier;
  final String description;
  final String floorRateSQFT;
  final String ratePerSqft;
  final String ratePerMonth;
  final String locationLongitude;
  final String locationLatitude;
  final String headOfTerms;
  final String situation;
  final String remarks;
  final DateTime? createdAt;

  RentalEvidenceModel({
    this.id,
    required this.masterFileId,
    required this.masterFileRefNo,
    required this.assessmentNo,
    required this.owner,
    required this.occupier,
    required this.description,
    required this.floorRateSQFT,
    required this.ratePerSqft,
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
      if (id != null) 'id': id,
      'masterFileId': masterFileId,
      'masterFileRefNo': masterFileRefNo,
      'assessmentNo': assessmentNo,
      'owner': owner,
      'occupier': occupier,
      'description': description,
      'floorRateSQFT': floorRateSQFT,
      'ratePerSqft': ratePerSqft,
      'ratePerMonth': ratePerMonth,
      'locationLongitude': locationLongitude,
      'locationLatitude': locationLatitude,
      'headOfTerms': headOfTerms,
      'situation': situation,
      'remarks': remarks,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    };
  }

  factory RentalEvidenceModel.fromJson(Map<String, dynamic> json) {
    return RentalEvidenceModel(
      id: json['id'],
      masterFileId: json['masterFileId'] ?? '',
      masterFileRefNo: json['masterFileRefNo'] ?? '',
      assessmentNo: json['assessmentNo'] ?? '',
      owner: json['owner'] ?? '',
      occupier: json['occupier'] ?? '',
      description: json['description'] ?? '',
      floorRateSQFT: json['floorRateSQFT'] ?? '',
      ratePerSqft: json['ratePerSqft'] ?? '',
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
