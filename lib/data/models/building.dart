import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class Building {
  final String id;
  final String name;
  final String constructionType;
  final String lotId;
  final String masterFileNo;
  final List<Position> coordinates;
  final DateTime createdAt;

  Building({
    required this.id,
    required this.name,
    required this.constructionType,
    required this.lotId,
    required this.masterFileNo,
    required this.coordinates,
    required this.createdAt,
  });

  // Convert Building to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'constructionType': constructionType,
      'lotId': lotId,
      'masterFileNo': masterFileNo,
      'coordinates': coordinates
          .map((coord) => {
                'lat': coord.lat,
                'lng': coord.lng,
              })
          .toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create Building from JSON
  factory Building.fromJson(Map<String, dynamic> json) {
    return Building(
      id: json['id'],
      name: json['name'],
      constructionType: json['constructionType'],
      lotId: json['lotId'],
      masterFileNo: json['masterFileNo'],
      coordinates: (json['coordinates'] as List)
          .map((coord) => Position(coord['lng'], coord['lat']))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  @override
  String toString() {
    return 'Building(id: $id, name: $name, constructionType: $constructionType, lotId: $lotId, masterFileNo: $masterFileNo)';
  }
}
