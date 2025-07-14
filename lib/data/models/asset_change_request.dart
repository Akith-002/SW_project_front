class AssetChangeRequest {
  final int id;
  final String oldAssetNo;
  final String newAssetNo;
  final String reason;
  final String changedDate;
  final String dateOfChange;

  AssetChangeRequest({
    required this.id,
    required this.oldAssetNo,
    required this.newAssetNo,
    required this.reason,
    required this.changedDate,
    required this.dateOfChange,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'oldAssetNo': oldAssetNo,
      'newAssetNo': newAssetNo,
      'reason': reason,
      'changedDate': changedDate,
      'dateOfChange': dateOfChange,
    };
  }

  factory AssetChangeRequest.fromJson(Map<String, dynamic> json) {
    return AssetChangeRequest(
      id: json['id'] ?? 0,
      oldAssetNo: json['oldAssetNo'] ?? '',
      newAssetNo: json['newAssetNo'] ?? '',
      reason: json['reason'] ?? '',
      changedDate: json['changedDate'] ?? '',
      dateOfChange: json['dateOfChange'] ?? '',
    );
  }
}
