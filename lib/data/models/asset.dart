class Asset {
  final int id;
  final String assetNo;
  final String ward;
  final String rdSt;
  final String description;
  final String owner;
  final AssetStatus status;
  final bool isRatingCard;
  final double? area;
  final String? location;

  Asset({
    required this.id,
    required this.assetNo,
    required this.ward,
    required this.rdSt,
    required this.description,
    required this.owner,
    required this.status,
    this.isRatingCard = false,
    this.area,
    this.location,
  });
  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      id: json['id'] ?? 0,
      assetNo: json['assetNo'] ?? '',
      ward: json['ward'] ?? '',
      rdSt: json['rdSt'] ?? '',
      description: json['description'] ?? '',
      owner: json['owner'] ?? '',
      status: AssetStatusExtension.fromString(json['status'] ?? 'pending'),
      isRatingCard: json['isRatingCard'] ?? false,
      area: json['area']?.toDouble(),
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'assetNo': assetNo,
      'ward': ward,
      'rdSt': rdSt,
      'description': description,
      'owner': owner,
      'status': status.name,
      'isRatingCard': isRatingCard,
      if (area != null) 'area': area,
      if (location != null) 'location': location,
    };
  }

  // Convenience getters for backward compatibility
  String get assetNumber => assetNo;
}

enum AssetStatus { pending, completed, active, inactive }

extension AssetStatusExtension on AssetStatus {
  String get displayName {
    switch (this) {
      case AssetStatus.pending:
        return "Pending";
      case AssetStatus.completed:
        return "Completed";
      case AssetStatus.active:
        return "Active";
      case AssetStatus.inactive:
        return "Inactive";
    }
  }

  static AssetStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return AssetStatus.completed;
      case 'active':
        return AssetStatus.active;
      case 'inactive':
        return AssetStatus.inactive;
      case 'pending':
      default:
        return AssetStatus.pending;
    }
  }
}
