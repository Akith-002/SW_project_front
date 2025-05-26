class MrRequest {
  final int id;
  final int requestTypeId;
  final String ratingReferenceNo;
  final String localAuthority;
  final int yearOfRevision;
  final bool status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final RequestType requestType;

  MrRequest({
    required this.id,
    required this.requestTypeId,
    required this.ratingReferenceNo,
    required this.localAuthority,
    required this.yearOfRevision,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.requestType,
  });

  // Convert from JSON
  factory MrRequest.fromJson(Map<String, dynamic> json) {
    return MrRequest(
      id: json['id'],
      requestTypeId: json['requestTypeId'],
      ratingReferenceNo: json['ratingReferenceNo'],
      localAuthority: json['localAuthority'],
      yearOfRevision: json['yearOfRevision'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      requestType: RequestType.fromJson(json['requestType']),
    );
  }

  // Convert to JSON
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
      'requestType': requestType.toJson(),
    };
  }
}

class RequestType {
  final int id;
  final String code;
  final String name;

  RequestType({
    required this.id,
    required this.code,
    required this.name,
  });

  factory RequestType.fromJson(Map<String, dynamic> json) {
    return RequestType(
      id: json['id'],
      code: json['code'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
    };
  }
}

// Update the status enum to match boolean values
enum PlanStatusMR {
  active,
  inactive;

  // Convert boolean to enum
  static PlanStatusMR fromBoolean(bool status) {
    return status ? PlanStatusMR.active : PlanStatusMR.inactive;
  }

  // Convert enum to boolean
  bool toBoolean() {
    return this == PlanStatusMR.active;
  }

  String get displayName {
    switch (this) {
      case PlanStatusMR.active:
        return 'Success';
      case PlanStatusMR.inactive:
        return 'Pending';
    }
  }
}