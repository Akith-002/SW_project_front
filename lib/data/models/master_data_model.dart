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
    List<String> _parseList(dynamic value) {
      if (value == null) return [];
      return List<String>.from(value);
    }

    return MasterDataResponse(
      buildingCategory: _parseList(json['buildingCategory']),
      buildingClass: _parseList(json['buildingClass']),
      conviences: _parseList(json['conviences']),
      natureOfConstruction: _parseList(json['natureOfConstruction']),
      roofMaterial: _parseList(json['roofMaterial']),
      roofFrame: _parseList(json['roofFrame']),
      roofFinisher: _parseList(json['roofFinisher']),
      celing: _parseList(json['celing']),
      foundationStructure: _parseList(json['foundationStructure']),
      wallStructure: _parseList(json['wallStructure']),
      floorStructure: _parseList(json['floorStructure']),
      door: _parseList(json['door']),
      window: _parseList(json['window']),
      windowProtection: _parseList(json['windowProtection']),
      doorsBathroomAndToiletFittings:
          _parseList(json['doorsBathroomAndToiletFittings']),
      doorsHandRail: _parseList(json['doorsHandRail']),
      doorsPantryCupboard: _parseList(json['doorsPantryCupboard']),
      doorsOther: _parseList(json['doorsOther']),
      wallFinisher: _parseList(json['wallFinisher']),
      floorFinisher: _parseList(json['floorFinisher']),
      bathroomAndToilet: _parseList(json['bathroomAndToilet']),
      services: _parseList(json['services']),
    );
  }
}
