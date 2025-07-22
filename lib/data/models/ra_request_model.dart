class RaRequestModel {
  final int id;
  final int requestTypeId;
  final String ratingReferenceNo;
  final String localAuthority;
  final int yearOfRevision;
  final bool status;
  final DateTime createdAt;
  final DateTime updatedAt;

  RaRequestModel({
    required this.id,
    required this.requestTypeId,
    required this.ratingReferenceNo,
    required this.localAuthority,
    required this.yearOfRevision,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RaRequestModel.fromJson(Map<String, dynamic> json) {
    return RaRequestModel(
      id: json['id'] ?? 0,
      requestTypeId: json['requestTypeId'] ?? 0,
      ratingReferenceNo: json['ratingReferenceNo'] ?? '',
      localAuthority: json['localAuthority'] ?? '',
      yearOfRevision: json['yearOfRevision'] ?? 0,
      status: json['status'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'requestTypeId': requestTypeId,
      'ratingReferenceNo': ratingReferenceNo,
      'localAuthority': localAuthority,
      'yearOfRevision': yearOfRevision,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class RaRequestResponse {
  final List<RaRequestModel> requests;

  RaRequestResponse({required this.requests});

  factory RaRequestResponse.fromJson(List<dynamic> json) {
    return RaRequestResponse(
      requests: json.map((e) => RaRequestModel.fromJson(e)).toList(),
    );
  }
}