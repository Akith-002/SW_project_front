import 'dart:convert';

class LaBuildingRatesModel {
  final int? id;
  final String masterFileId;
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

  LaBuildingRatesModel({
    this.id,
    required this.masterFileId,
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
      'masterFileId': masterFileId,
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

  factory LaBuildingRatesModel.fromJson(Map<String, dynamic> json) {
    return LaBuildingRatesModel(
      id: json['id'],
      masterFileId: json['masterFileId'] ?? '',
      assessmentNumber: json['assessmentNumber'] ?? '',
      owner: json['owner'] ?? '',
      constructedBy: json['constructedBy'] ?? '',
      yearOfConstruction: json['yearOfConstruction'] ?? '',
      descriptionOfProperty: json['descriptionOfProperty'] ?? '',
      floorAreaSQFT: json['floorAreaSQFT'] ?? '',
      ratePerSQFT: json['ratePerSQFT'] ?? '',
      cost: json['cost'] ?? '',
      remarks: json['remarks'] ?? '',
      locationLatitude: json['locationLatitude'] ?? '',
      locationLongitude: json['locationLongitude'] ?? '',
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  String toJsonString() => json.encode(toJson());

  factory LaBuildingRatesModel.fromJsonString(String jsonString) {
    return LaBuildingRatesModel.fromJson(json.decode(jsonString));
  }

  LaBuildingRatesModel copyWith({
    int? id,
    String? masterFileId,
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
    return LaBuildingRatesModel(
      id: id ?? this.id,
      masterFileId: masterFileId ?? this.masterFileId,
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
    return 'LaBuildingRatesModel(id: $id, masterFileId: $masterFileId, assessmentNumber: $assessmentNumber, owner: $owner, constructedBy: $constructedBy, yearOfConstruction: $yearOfConstruction, descriptionOfProperty: $descriptionOfProperty, floorAreaSQFT: $floorAreaSQFT, ratePerSQFT: $ratePerSQFT, cost: $cost, remarks: $remarks, locationLatitude: $locationLatitude, locationLongitude: $locationLongitude, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LaBuildingRatesModel &&
        other.id == id &&
        other.masterFileId == masterFileId &&
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
        masterFileId.hashCode ^
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
