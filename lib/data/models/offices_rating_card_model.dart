class OfficesRatingCardModel {
  final int assetId;
  final String buildingSelection;
  final String localAuthority;
  final String localAuthorityCode;
  final String assessmentNumber;
  final String newNumber;
  final String obsoleteNumber;
  final String owner;
  final String description;
  final String wallType;
  final String floorType;
  final String conveniences;
  final String condition;
  final int age;
  final String accessType;
  final String officeGrade;
  final String parkingSpace;
  final String propertySubCategory;
  final String propertyType;
  final int wardNumber;
  final String roadName;
  final DateTime date;
  final String occupier;
  final double rentPM;
  final String terms;
  final int floorNumber;
  final double ceilingHeight;
  final String officeSuite;
  final double totalArea;
  final double usableFloorArea;
  final double suggestedRate;
  final String notes;

  OfficesRatingCardModel({
    required this.assetId,
    required this.buildingSelection,
    required this.localAuthority,
    required this.localAuthorityCode,
    required this.assessmentNumber,
    required this.newNumber,
    required this.obsoleteNumber,
    required this.owner,
    required this.description,
    required this.wallType,
    required this.floorType,
    required this.conveniences,
    required this.condition,
    required this.age,
    required this.accessType,
    required this.officeGrade,
    required this.parkingSpace,
    required this.propertySubCategory,
    required this.propertyType,
    required this.wardNumber,
    required this.roadName,
    required this.date,
    required this.occupier,
    required this.rentPM,
    required this.terms,
    required this.floorNumber,
    required this.ceilingHeight,
    required this.officeSuite,
    required this.totalArea,
    required this.usableFloorArea,
    required this.suggestedRate,
    required this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'assetId': assetId,
      'buildingSelection': buildingSelection,
      'localAuthority': localAuthority,
      'localAuthorityCode': localAuthorityCode,
      'assessmentNumber': assessmentNumber,
      'newNumber': newNumber,
      'obsoleteNumber': obsoleteNumber,
      'owner': owner,
      'description': description,
      'wallType': wallType,
      'floorType': floorType,
      'conveniences': conveniences,
      'condition': condition,
      'age': age,
      'accessType': accessType,
      'officeGrade': officeGrade,
      'parkingSpace': parkingSpace,
      'propertySubCategory': propertySubCategory,
      'propertyType': propertyType,
      'wardNumber': wardNumber,
      'roadName': roadName,
      'date': date.toIso8601String(),
      'occupier': occupier,
      'rentPM': rentPM,
      'terms': terms,
      'floorNumber': floorNumber,
      'ceilingHeight': ceilingHeight,
      'officeSuite': officeSuite,
      'totalArea': totalArea,
      'usableFloorArea': usableFloorArea,
      'suggestedRate': suggestedRate,
      'notes': notes,
    };
  }

  factory OfficesRatingCardModel.fromJson(Map<String, dynamic> json) {
    return OfficesRatingCardModel(
      assetId: json['assetId'] as int,
      buildingSelection: json['buildingSelection'] as String,
      localAuthority: json['localAuthority'] as String,
      localAuthorityCode: json['localAuthorityCode'] as String,
      assessmentNumber: json['assessmentNumber'] as String,
      newNumber: json['newNumber'] as String,
      obsoleteNumber: json['obsoleteNumber'] as String,
      owner: json['owner'] as String,
      description: json['description'] as String,
      wallType: json['wallType'] as String,
      floorType: json['floorType'] as String,
      conveniences: json['conveniences'] as String,
      condition: json['condition'] as String,
      age: json['age'] as int,
      accessType: json['accessType'] as String,
      officeGrade: json['officeGrade'] as String,
      parkingSpace: json['parkingSpace'] as String,
      propertySubCategory: json['propertySubCategory'] as String,
      propertyType: json['propertyType'] as String,
      wardNumber: json['wardNumber'] as int,
      roadName: json['roadName'] as String,
      date: DateTime.parse(json['date'] as String),
      occupier: json['occupier'] as String,
      rentPM: (json['rentPM'] as num).toDouble(),
      terms: json['terms'] as String,
      floorNumber: json['floorNumber'] as int,
      ceilingHeight: (json['ceilingHeight'] as num).toDouble(),
      officeSuite: json['officeSuite'] as String,
      totalArea: (json['totalArea'] as num).toDouble(),
      usableFloorArea: (json['usableFloorArea'] as num).toDouble(),
      suggestedRate: (json['suggestedRate'] as num).toDouble(),
      notes: json['notes'] as String,
    );
  }
}