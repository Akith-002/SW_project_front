class AssetChangeResponse {
  final bool isSuccess;
  final String? message;
  final int? id;

  AssetChangeResponse({
    required this.isSuccess,
    this.message,
    this.id,
  });

  factory AssetChangeResponse.fromJson(Map<String, dynamic> json) {
    return AssetChangeResponse(
      isSuccess: json['isSuccess'] ?? false,
      message: json['message'],
      id: json['id'],
    );
  }
}
