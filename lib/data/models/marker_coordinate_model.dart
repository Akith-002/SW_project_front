class MarkerCoordinateModel {
  final int masterfileId;
  final String coordinates;

  MarkerCoordinateModel({
    required this.masterfileId,
    required this.coordinates,
  });

  factory MarkerCoordinateModel.fromJson(Map<String, dynamic> json) {
    return MarkerCoordinateModel(
      masterfileId: json['masterfileId'],
      coordinates: json['coordinates'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'masterfileId': masterfileId,
      'coordinates': coordinates,
    };
  }
}

class ExistingMarkerModel {
  final int id;
  final int masterfileId;
  final String coordinates;
  final String? type;

  ExistingMarkerModel({
    required this.id,
    required this.masterfileId,
    required this.coordinates,
    this.type,
  });

  factory ExistingMarkerModel.fromJson(Map<String, dynamic> json) {
    return ExistingMarkerModel(
      id: json['id'],
      masterfileId: json['masterfileId'],
      coordinates: json['coordinates'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'masterfileId': masterfileId,
      'coordinates': coordinates,
      if (type != null) 'type': type,
    };
  }
}

class MarkerCoordinateResponse {
  final bool success;
  final String? message;
  final Map<String, dynamic>? data;

  MarkerCoordinateResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory MarkerCoordinateResponse.fromJson(Map<String, dynamic> json) {
    return MarkerCoordinateResponse(
      success: json['success'] ?? false,
      message: json['message'],
      data: json['data'],
    );
  }
}
