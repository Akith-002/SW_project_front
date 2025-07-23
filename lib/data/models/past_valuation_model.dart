import 'dart:convert';

class PastValuationModel {
  final int? id;
  final String masterFileRef;
  final String fileNoGnDivision;
  final String situation;
  final String dateOfValuation;
  final String purposeOfValuation;
  final String planOfParticulars;
  final String extent;
  final String rate;
  final String rateType;
  final String remarks;
  final String locationLongitude;
  final String locationLatitude;
  final DateTime? createdAt;

  PastValuationModel({
    this.id,
    required this.masterFileRef,
    required this.fileNoGnDivision,
    required this.situation,
    required this.dateOfValuation,
    required this.purposeOfValuation,
    required this.planOfParticulars,
    required this.extent,
    required this.rate,
    required this.rateType,
    required this.remarks,
    required this.locationLongitude,
    required this.locationLatitude,
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'masterFileRef': masterFileRef,
      'fileNoGnDivision': fileNoGnDivision,
      'situation': situation,
      'dateOfValuation': dateOfValuation,
      'purposeOfValuation': purposeOfValuation,
      'planOfParticulars': planOfParticulars,
      'extent': extent,
      'rate': rate,
      'rateType': rateType,
      'remarks': remarks,
      'locationLongitude': locationLongitude,
      'locationLatitude': locationLatitude,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    };
  }

  factory PastValuationModel.fromJson(Map<String, dynamic> json) {
    return PastValuationModel(
      id: json['id'],
      masterFileRef: json['masterFileRef'] ?? '',
      fileNoGnDivision: json['fileNoGnDivision'] ?? '',
      situation: json['situation'] ?? '',
      dateOfValuation: json['dateOfValuation'] ?? '',
      purposeOfValuation: json['purposeOfValuation'] ?? '',
      planOfParticulars: json['planOfParticulars'] ?? '',
      extent: json['extent'] ?? '',
      rate: json['rate'] ?? '',
      rateType: json['rateType'] ?? '',
      remarks: json['remarks'] ?? '',
      locationLongitude: json['locationLongitude'] ?? '',
      locationLatitude: json['locationLatitude'] ?? '',
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
