import 'package:equatable/equatable.dart';

class LmPastValuationsModel extends Equatable {
  final String? masterFileRef;
  final String? fileNoGnDivision;
  final String? situation;
  final String? dateOfValuation;
  final String? purposeOfValuation;
  final String? planOfParticulars;
  final String? extent;
  final String? rate;
  final String? rateType;
  final String? remarks;
  final String? locationLongitude;
  final String? locationLatitude;

  const LmPastValuationsModel({
    this.masterFileRef,
    this.fileNoGnDivision,
    this.situation,
    this.dateOfValuation,
    this.purposeOfValuation,
    this.planOfParticulars,
    this.extent,
    this.rate,
    this.rateType,
    this.remarks,
    this.locationLongitude,
    this.locationLatitude,
  });

  factory LmPastValuationsModel.fromJson(Map<String, dynamic> json) {
    return LmPastValuationsModel(
      masterFileRef: json['masterFileRef']?.toString(),
      fileNoGnDivision: json['fileNoGnDivision']?.toString(),
      situation: json['situation']?.toString(),
      dateOfValuation: json['dateOfValuation']?.toString(),
      purposeOfValuation: json['purposeOfValuation']?.toString(),
      planOfParticulars: json['planOfParticulars']?.toString(),
      extent: json['extent']?.toString(),
      rate: json['rate']?.toString(),
      rateType: json['rateType']?.toString(),
      remarks: json['remarks']?.toString(),
      locationLongitude: json['locationLongitude']?.toString(),
      locationLatitude: json['locationLatitude']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
    };
  }

  LmPastValuationsModel copyWith({
    String? masterFileRef,
    String? fileNoGnDivision,
    String? situation,
    String? dateOfValuation,
    String? purposeOfValuation,
    String? planOfParticulars,
    String? extent,
    String? rate,
    String? rateType,
    String? remarks,
    String? locationLongitude,
    String? locationLatitude,
  }) {
    return LmPastValuationsModel(
      masterFileRef: masterFileRef ?? this.masterFileRef,
      fileNoGnDivision: fileNoGnDivision ?? this.fileNoGnDivision,
      situation: situation ?? this.situation,
      dateOfValuation: dateOfValuation ?? this.dateOfValuation,
      purposeOfValuation: purposeOfValuation ?? this.purposeOfValuation,
      planOfParticulars: planOfParticulars ?? this.planOfParticulars,
      extent: extent ?? this.extent,
      rate: rate ?? this.rate,
      rateType: rateType ?? this.rateType,
      remarks: remarks ?? this.remarks,
      locationLongitude: locationLongitude ?? this.locationLongitude,
      locationLatitude: locationLatitude ?? this.locationLatitude,
    );
  }

  @override
  List<Object?> get props => [
        masterFileRef,
        fileNoGnDivision,
        situation,
        dateOfValuation,
        purposeOfValuation,
        planOfParticulars,
        extent,
        rate,
        rateType,
        remarks,
        locationLongitude,
        locationLatitude,
      ];

  @override
  String toString() {
    return 'LmPastValuationsModel(masterFileRef: $masterFileRef, situation: $situation, rate: $rate)';
  }
}
