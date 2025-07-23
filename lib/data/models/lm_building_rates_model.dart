import 'dart:convert';

class LmBuildingRatesModel {
  final int? id;
  final String assessmentNumber;
  final String owner;
  final String constructedBy;
  final String yearOfConstruction;
  final String descriptionOfProperty;
  final String floorAreaSQFT;
  final String ratePerSQFT;
  final String cost;
  final String remarks;
  final String locationLatitude;
  final String locationLongitude;
  final DateTime? createdAt;

  LmBuildingRatesModel({
    this.id,
    required this.assessmentNumber,
    required this.owner,
    required this.constructedBy,
    required this.yearOfConstruction,
    required this.descriptionOfProperty,
    required this.floorAreaSQFT,
    required this.ratePerSQFT,
    required this.cost,
    required this.remarks,
    required this.locationLatitude,
    required this.locationLongitude,
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'assessmentNumber': assessmentNumber,
      'owner': owner,
      'constructedBy': constructedBy,
      'yearOfConstruction': yearOfConstruction,
      'descriptionOfProperty': descriptionOfProperty,
      'floorAreaSQFT': floorAreaSQFT,
      'ratePerSQFT': ratePerSQFT,
      'cost': cost,
      'remarks': remarks,
      'locationLatitude': locationLatitude,
      'locationLongitude': locationLongitude,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    };
  }

  factory LmBuildingRatesModel.fromJson(Map<String, dynamic> json) {
    return LmBuildingRatesModel(
      id: json['id'] as int?,
      assessmentNumber: json['assessmentNumber'] as String? ?? '',
      owner: json['owner'] as String? ?? '',
      constructedBy: json['constructedBy'] as String? ?? '',
      yearOfConstruction: json['yearOfConstruction'] as String? ?? '',
      descriptionOfProperty: json['descriptionOfProperty'] as String? ?? '',
      floorAreaSQFT: json['floorAreaSQFT'] as String? ?? '',
      ratePerSQFT: json['ratePerSQFT'] as String? ?? '',
      cost: json['cost'] as String? ?? '',
      remarks: json['remarks'] as String? ?? '',
      locationLatitude: json['locationLatitude'] as String? ?? '',
      locationLongitude: json['locationLongitude'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  factory LmBuildingRatesModel.fromJsonString(String jsonString) {
    return LmBuildingRatesModel.fromJson(jsonDecode(jsonString));
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

  LmBuildingRatesModel copyWith({
    int? id,
    String? assessmentNumber,
    String? owner,
    String? constructedBy,
    String? yearOfConstruction,
    String? descriptionOfProperty,
    String? floorAreaSQFT,
    String? ratePerSQFT,
    String? cost,
    String? remarks,
    String? locationLatitude,
    String? locationLongitude,
    DateTime? createdAt,
  }) {
    return LmBuildingRatesModel(
      id: id ?? this.id,
      assessmentNumber: assessmentNumber ?? this.assessmentNumber,
      owner: owner ?? this.owner,
      constructedBy: constructedBy ?? this.constructedBy,
      yearOfConstruction: yearOfConstruction ?? this.yearOfConstruction,
      descriptionOfProperty:
          descriptionOfProperty ?? this.descriptionOfProperty,
      floorAreaSQFT: floorAreaSQFT ?? this.floorAreaSQFT,
      ratePerSQFT: ratePerSQFT ?? this.ratePerSQFT,
      cost: cost ?? this.cost,
      remarks: remarks ?? this.remarks,
      locationLatitude: locationLatitude ?? this.locationLatitude,
      locationLongitude: locationLongitude ?? this.locationLongitude,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'LmBuildingRatesModel(id: $id, assessmentNumber: $assessmentNumber, owner: $owner, constructedBy: $constructedBy, yearOfConstruction: $yearOfConstruction, descriptionOfProperty: $descriptionOfProperty, floorAreaSQFT: $floorAreaSQFT, ratePerSQFT: $ratePerSQFT, cost: $cost, remarks: $remarks, locationLatitude: $locationLatitude, locationLongitude: $locationLongitude, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LmBuildingRatesModel &&
        other.id == id &&
        other.assessmentNumber == assessmentNumber &&
        other.owner == owner &&
        other.constructedBy == constructedBy &&
        other.yearOfConstruction == yearOfConstruction &&
        other.descriptionOfProperty == descriptionOfProperty &&
        other.floorAreaSQFT == floorAreaSQFT &&
        other.ratePerSQFT == ratePerSQFT &&
        other.cost == cost &&
        other.remarks == remarks &&
        other.locationLatitude == locationLatitude &&
        other.locationLongitude == locationLongitude &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        assessmentNumber.hashCode ^
        owner.hashCode ^
        constructedBy.hashCode ^
        yearOfConstruction.hashCode ^
        descriptionOfProperty.hashCode ^
        floorAreaSQFT.hashCode ^
        ratePerSQFT.hashCode ^
        cost.hashCode ^
        remarks.hashCode ^
        locationLatitude.hashCode ^
        locationLongitude.hashCode ^
        createdAt.hashCode;
  }
}
