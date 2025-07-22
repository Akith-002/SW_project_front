/// Model class for LA Sales Evidence data
/// Used to serialize and deserialize sales evidence form data
class LaSalesEvidenceModel {
  final String assetNumber;
  final String masterFileRef;
  final String roadName;
  final String village;
  final String vendor;
  final String deedNumber;
  final String deedAttestedNumber;
  final String notaryName;
  final String lotNumber;
  final String planNumber;
  final String planDate;
  final String extent;
  final String consideration;
  final String remarks;
  final String rate;
  final String rateType;
  final String locationLongitude;
  final String locationLatitude;
  final String landRegistryReferences;
  final String situation;
  final String descriptionOfLand;

  const LaSalesEvidenceModel({
    required this.assetNumber,
    required this.masterFileRef,
    required this.roadName,
    required this.village,
    required this.vendor,
    required this.deedNumber,
    required this.deedAttestedNumber,
    required this.notaryName,
    required this.lotNumber,
    required this.planNumber,
    required this.planDate,
    required this.extent,
    required this.consideration,
    required this.remarks,
    required this.rate,
    required this.rateType,
    required this.locationLongitude,
    required this.locationLatitude,
    required this.landRegistryReferences,
    required this.situation,
    required this.descriptionOfLand,
  });

  /// Creates a model from JSON data
  factory LaSalesEvidenceModel.fromJson(Map<String, dynamic> json) {
    return LaSalesEvidenceModel(
      assetNumber: json['assetNumber'] ?? '',
      masterFileRef: json['masterFileRef'] ?? '',
      roadName: json['roadName'] ?? '',
      village: json['village'] ?? '',
      vendor: json['vendor'] ?? '',
      deedNumber: json['deedNumber'] ?? '',
      deedAttestedNumber: json['deedAttestedNumber'] ?? '',
      notaryName: json['notaryName'] ?? '',
      lotNumber: json['lotNumber'] ?? '',
      planNumber: json['planNumber'] ?? '',
      planDate: json['planDate'] ?? '',
      extent: json['extent'] ?? '',
      consideration: json['consideration'] ?? '',
      remarks: json['remarks'] ?? '',
      rate: json['rate'] ?? '',
      rateType: json['rateType'] ?? '',
      locationLongitude: json['locationLongitude'] ?? '',
      locationLatitude: json['locationLatitude'] ?? '',
      landRegistryReferences: json['landRegistryReferences'] ?? '',
      situation: json['situation'] ?? '',
      descriptionOfLand: json['descriptionOfLand'] ?? '',
    );
  }

  /// Converts model to JSON for API submission
  Map<String, dynamic> toJson() {
    return {
      'assetNumber': assetNumber,
      'masterFileRef': masterFileRef,
      'roadName': roadName,
      'village': village,
      'vendor': vendor,
      'deedNumber': deedNumber,
      'deedAttestedNumber': deedAttestedNumber,
      'notaryName': notaryName,
      'lotNumber': lotNumber,
      'planNumber': planNumber,
      'planDate': planDate,
      'extent': extent,
      'consideration': consideration,
      'remarks': remarks,
      'rate': rate,
      'rateType': rateType,
      'locationLongitude': locationLongitude,
      'locationLatitude': locationLatitude,
      'landRegistryReferences': landRegistryReferences,
      'situation': situation,
      'descriptionOfLand': descriptionOfLand,
    };
  }

  /// Creates a copy of the model with optional field updates
  LaSalesEvidenceModel copyWith({
    String? assetNumber,
    String? masterFileRef,
    String? roadName,
    String? village,
    String? vendor,
    String? deedNumber,
    String? deedAttestedNumber,
    String? notaryName,
    String? lotNumber,
    String? planNumber,
    String? planDate,
    String? extent,
    String? consideration,
    String? remarks,
    String? rate,
    String? rateType,
    String? locationLongitude,
    String? locationLatitude,
    String? landRegistryReferences,
    String? situation,
    String? descriptionOfLand,
  }) {
    return LaSalesEvidenceModel(
      assetNumber: assetNumber ?? this.assetNumber,
      masterFileRef: masterFileRef ?? this.masterFileRef,
      roadName: roadName ?? this.roadName,
      village: village ?? this.village,
      vendor: vendor ?? this.vendor,
      deedNumber: deedNumber ?? this.deedNumber,
      deedAttestedNumber: deedAttestedNumber ?? this.deedAttestedNumber,
      notaryName: notaryName ?? this.notaryName,
      lotNumber: lotNumber ?? this.lotNumber,
      planNumber: planNumber ?? this.planNumber,
      planDate: planDate ?? this.planDate,
      extent: extent ?? this.extent,
      consideration: consideration ?? this.consideration,
      remarks: remarks ?? this.remarks,
      rate: rate ?? this.rate,
      rateType: rateType ?? this.rateType,
      locationLongitude: locationLongitude ?? this.locationLongitude,
      locationLatitude: locationLatitude ?? this.locationLatitude,
      landRegistryReferences:
          landRegistryReferences ?? this.landRegistryReferences,
      situation: situation ?? this.situation,
      descriptionOfLand: descriptionOfLand ?? this.descriptionOfLand,
    );
  }

  @override
  String toString() {
    return 'LaSalesEvidenceModel(assetNumber: $assetNumber, masterFileRef: $masterFileRef, vendor: $vendor, consideration: $consideration, rate: $rate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LaSalesEvidenceModel &&
        other.assetNumber == assetNumber &&
        other.masterFileRef == masterFileRef &&
        other.roadName == roadName &&
        other.village == village &&
        other.vendor == vendor &&
        other.deedNumber == deedNumber &&
        other.deedAttestedNumber == deedAttestedNumber &&
        other.notaryName == notaryName &&
        other.lotNumber == lotNumber &&
        other.planNumber == planNumber &&
        other.planDate == planDate &&
        other.extent == extent &&
        other.consideration == consideration &&
        other.remarks == remarks &&
        other.rate == rate &&
        other.rateType == rateType &&
        other.locationLongitude == locationLongitude &&
        other.locationLatitude == locationLatitude &&
        other.landRegistryReferences == landRegistryReferences &&
        other.situation == situation &&
        other.descriptionOfLand == descriptionOfLand;
  }

  @override
  int get hashCode {
    return assetNumber.hashCode ^
        masterFileRef.hashCode ^
        roadName.hashCode ^
        village.hashCode ^
        vendor.hashCode ^
        deedNumber.hashCode ^
        deedAttestedNumber.hashCode ^
        notaryName.hashCode ^
        lotNumber.hashCode ^
        planNumber.hashCode ^
        planDate.hashCode ^
        extent.hashCode ^
        consideration.hashCode ^
        remarks.hashCode ^
        rate.hashCode ^
        rateType.hashCode ^
        locationLongitude.hashCode ^
        locationLatitude.hashCode ^
        landRegistryReferences.hashCode ^
        situation.hashCode ^
        descriptionOfLand.hashCode;
  }
}
