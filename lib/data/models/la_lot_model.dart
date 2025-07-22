class LALotModel {
  final int masterFileId;
  final String coordinates;

  LALotModel({
    required this.masterFileId,
    required this.coordinates,
  });

  factory LALotModel.fromJson(Map<String, dynamic> json) {
    return LALotModel(
      masterFileId: json['masterFileId'],
      coordinates: json['coordinates'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'masterFileId': masterFileId,
      'coordinates': coordinates,
    };
  }
}

class LALotResponse {
  final bool success;
  final String? message;
  final Map<String, dynamic>? data;

  LALotResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory LALotResponse.fromJson(Map<String, dynamic> json) {
    return LALotResponse(
      success: json['success'] ?? false,
      message: json['message'],
      data: json['data'],
    );
  }
}
