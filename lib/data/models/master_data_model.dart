class MasterDataResponse {
  final List<String> buildingCategory;
  final List<String> buildingClass;
  final List<String> conviences;
  final List<String> natureOfConstruction;
  final List<String> roofMaterial;
  final List<String> roofFrame;
  final List<String> roofFinisher;
  final List<String> celing;
  final List<String> foundationStructure;
  final List<String> wallStructure;
  final List<String> floorStructure;
  final List<String> door;
  final List<String> window;
  final List<String> windowProtection;
  final List<String> doorsBathroomAndToiletFittings;
  final List<String> doorsHandRail;
  final List<String> doorsPantryCupboard;
  final List<String> doorsOther;
  final List<String> wallFinisher;
  final List<String> floorFinisher;
  final List<String> bathroomAndToilet;
  final List<String> services;

  MasterDataResponse({
    required this.buildingCategory,
    required this.buildingClass,
    required this.conviences,
    required this.natureOfConstruction,
    required this.roofMaterial,
    required this.roofFrame,
    required this.roofFinisher,
    required this.celing,
    required this.foundationStructure,
    required this.wallStructure,
    required this.floorStructure,
    required this.door,
    required this.window,
    required this.windowProtection,
    required this.doorsBathroomAndToiletFittings,
    required this.doorsHandRail,
    required this.doorsPantryCupboard,
    required this.doorsOther,
    required this.wallFinisher,
    required this.floorFinisher,
    required this.bathroomAndToilet,
    required this.services,
  });

  factory MasterDataResponse.fromJson(Map<String, dynamic> json) {
    List<String> parseList(dynamic value) {
      if (value == null) return [];
      return List<String>.from(value);
    }

    return MasterDataResponse(
      buildingCategory: parseList(json['buildingCategory']),
      buildingClass: parseList(json['buildingClass']),
      conviences: parseList(json['conviences']),
      natureOfConstruction: parseList(json['natureOfConstruction']),
      roofMaterial: parseList(json['roofMaterial']),
      roofFrame: parseList(json['roofFrame']),
      roofFinisher: parseList(json['roofFinisher']),
      celing: parseList(json['celing']),
      foundationStructure: parseList(json['foundationStructure']),
      wallStructure: parseList(json['wallStructure']),
      floorStructure: parseList(json['floorStructure']),
      door: parseList(json['door']),
      window: parseList(json['window']),
      windowProtection: parseList(json['windowProtection']),
      doorsBathroomAndToiletFittings:
          parseList(json['doorsBathroomAndToiletFittings']),
      doorsHandRail: parseList(json['doorsHandRail']),
      doorsPantryCupboard: parseList(json['doorsPantryCupboard']),
      doorsOther: parseList(json['doorsOther']),
      wallFinisher: parseList(json['wallFinisher']),
      floorFinisher: parseList(json['floorFinisher']),
      bathroomAndToilet: parseList(json['bathroomAndToilet']),
      services: parseList(json['services']),
    );
  }
}
