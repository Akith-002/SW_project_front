class AssetDivisionRequest {
  final String assetId;
  final List<DivisionPart> divisionParts;
  final String reason;
  final Map<String, dynamic>? metadata;

  AssetDivisionRequest({
    required this.assetId,
    required this.divisionParts,
    required this.reason,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'assetId': assetId,
      'divisionParts': divisionParts.map((part) => part.toJson()).toList(),
      'reason': reason,
      if (metadata != null) 'metadata': metadata,
    };
  }

  factory AssetDivisionRequest.fromJson(Map<String, dynamic> json) {
    return AssetDivisionRequest(
      assetId: json['assetId'],
      divisionParts: (json['divisionParts'] as List)
          .map((part) => DivisionPart.fromJson(part))
          .toList(),
      reason: json['reason'],
      metadata: json['metadata'],
    );
  }
}

class DivisionPart {
  final String newAssetNumber;
  final double area;
  final String description;
  final String? landType;
  final String? coordinates;
  final Map<String, dynamic>? additionalProperties;

  DivisionPart({
    required this.newAssetNumber,
    required this.area,
    required this.description,
    this.landType,
    this.coordinates,
    this.additionalProperties,
  });

  Map<String, dynamic> toJson() {
    return {
      'newAssetNumber': newAssetNumber,
      'area': area,
      'description': description,
      if (landType != null) 'landType': landType,
      if (coordinates != null) 'coordinates': coordinates,
      if (additionalProperties != null)
        'additionalProperties': additionalProperties,
    };
  }

  factory DivisionPart.fromJson(Map<String, dynamic> json) {
    return DivisionPart(
      newAssetNumber: json['newAssetNumber'],
      area: json['area']?.toDouble() ?? 0.0,
      description: json['description'],
      landType: json['landType'],
      coordinates: json['coordinates'],
      additionalProperties: json['additionalProperties'],
    );
  }
}

class AssetDivisionResponse {
  final bool success;
  final String message;
  final List<String>? newAssetIds;
  final Map<String, dynamic>? data;

  AssetDivisionResponse({
    required this.success,
    required this.message,
    this.newAssetIds,
    this.data,
  });

  factory AssetDivisionResponse.fromJson(Map<String, dynamic> json) {
    return AssetDivisionResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      newAssetIds: json['newAssetIds']?.cast<String>(),
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      if (newAssetIds != null) 'newAssetIds': newAssetIds,
      if (data != null) 'data': data,
    };
  }
}

class AssetDivisionValidation {
  final bool isValid;
  final List<String> errors;
  final List<String> warnings;

  AssetDivisionValidation({
    required this.isValid,
    this.errors = const [],
    this.warnings = const [],
  });

  factory AssetDivisionValidation.fromJson(Map<String, dynamic> json) {
    return AssetDivisionValidation(
      isValid: json['isValid'] ?? false,
      errors: (json['errors'] as List?)?.cast<String>() ?? [],
      warnings: (json['warnings'] as List?)?.cast<String>() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isValid': isValid,
      'errors': errors,
      'warnings': warnings,
    };
  }
}
