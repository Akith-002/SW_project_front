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
