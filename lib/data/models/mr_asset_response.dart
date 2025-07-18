import 'asset.dart';

class AssetResponse {
  final String? message;
  final bool? isSuccess;
  final List<Asset>? data;

  AssetResponse({
    this.message,
    this.isSuccess,
    this.data,
  });

  factory AssetResponse.fromJson(Map<String, dynamic> json) {
    return AssetResponse(
      message: json['message'],
      isSuccess: json['isSuccess'],
      data: json['data'] != null
          ? (json['data'] as List)
              .map((item) => Asset.fromApiJson(item))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'isSuccess': isSuccess,
      'data': data?.map((item) => item.toJson()).toList(),
    };
  }
}

class MrAssetData {
  final int? assetId;
  final String? assetNo;
  final String? ward;
  final String? rdSt;
  final String? description;
  final String? owner;
  final String? status;
  final bool? isRatingCard;
  final double? area;
  final String? location;

  MrAssetData({
    this.assetId,
    this.assetNo,
    this.ward,
    this.rdSt,
    this.description,
    this.owner,
    this.status,
    this.isRatingCard,
    this.area,
    this.location,
  });

  factory MrAssetData.fromJson(Map<String, dynamic> json) {
    return MrAssetData(
      assetId: json['assetId'],
      assetNo: json['assetNo'],
      ward: json['ward'],
      rdSt: json['rdSt'],
      description: json['description'],
      owner: json['owner'],
      status: json['status'],
      isRatingCard: json['isRatingCard'],
      area: json['area']?.toDouble(),
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'assetId': assetId,
      'assetNo': assetNo,
      'ward': ward,
      'rdSt': rdSt,
      'description': description,
      'owner': owner,
      'status': status,
      'isRatingCard': isRatingCard,
      'area': area,
      'location': location,
    };
  }

  // Convert to domain Asset model
  Asset toAsset() {
    return Asset(
      id: assetId ?? 0,
      assetNo: assetNo ?? '',
      ward: ward ?? '',
      rdSt: rdSt ?? '',
      description: description ?? '',
      owner: owner ?? '',
      status: AssetStatusExtension.fromString(status ?? 'pending'),
      isRatingCard: isRatingCard ?? false,
      area: area,
      location: location,
    );
  }
}
