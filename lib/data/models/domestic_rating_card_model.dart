class DomesticRatingCardModel {
  final int assetId;
  final String newNumber;
  final String owner;
  final String description;
  final String selectWalls;
  final String floor;
  final String conveniences;
  final String condition;
  final int age;
  final String access;
  final String tsBop;
  final String parkingSpace;
  final String propertySubCategory;
  final String propertyType;
  final String plantations;
  final String wardNumber;
  final String roadName;
  final DateTime date;
  final String occupier;
  final double rentPM;
  final String terms;
  final double suggestedRate;
  final String notes;
  DomesticRatingCardModel({
    required this.assetId,
    required this.newNumber,
    required this.owner,
    required this.description,
    required this.selectWalls,
    required this.floor,
    required this.conveniences,
    required this.condition,
    required this.age,
    required this.access,
    required this.tsBop,
    required this.parkingSpace,
    required this.propertySubCategory,
    required this.propertyType,
    required this.plantations,
    required this.wardNumber,
    required this.roadName,
    required this.date,
    required this.occupier,
    required this.rentPM,
    required this.terms,
    required this.suggestedRate,
    required this.notes,
  });
  Map<String, dynamic> toJson() {
    return {
      'assetId': assetId,
      'newNumber': newNumber,
      'owner': owner,
      'description': description,
      'selectWalls': selectWalls,
      'floor': floor,
      'conveniences': conveniences,
      'condition': condition,
      'age': age,
      'access': access,
      'tsBop': tsBop,
      'parkingSpace': parkingSpace,
      'propertySubCategory': propertySubCategory,
      'propertyType': propertyType,
      'plantations': plantations,
      'wardNumber': wardNumber,
      'roadName': roadName,
      'date': date.toIso8601String(),
      'occupier': occupier,
      'rentPM': rentPM,
      'terms': terms,
      'suggestedRate': suggestedRate,
      'notes': notes,
    };
  }

  factory DomesticRatingCardModel.fromJson(Map<String, dynamic> json) {
    return DomesticRatingCardModel(
      assetId: json['assetId'] ?? 0,
      newNumber: json['newNumber'] ?? '',
      owner: json['owner'] ?? '',
      description: json['description'] ?? '',
      selectWalls: json['selectWalls'] ?? '',
      floor: json['floor'] ?? '',
      conveniences: json['conveniences'] ?? '',
      condition: json['condition'] ?? '',
      age: json['age'] ?? 0,
      access: json['access'] ?? '',
      tsBop: json['tsBop'] ?? '',
      parkingSpace: json['parkingSpace'] ?? '',
      propertySubCategory: json['propertySubCategory'] ?? '',
      propertyType: json['propertyType'] ?? '',
      plantations: json['plantations'] ?? '',
      wardNumber: json['wardNumber'] ?? '',
      roadName: json['roadName'] ?? '',
      date:
          json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      occupier: json['occupier'] ?? '',
      rentPM: (json['rentPM'] ?? 0).toDouble(),
      terms: json['terms'] ?? '',
      suggestedRate: (json['suggestedRate'] ?? 0).toDouble(),
      notes: json['notes'] ?? '',
    );
  }
}
