class OfficesRatingCardAutofillModel {
  final String owner;
  final String description;
  final String newNumber;

  OfficesRatingCardAutofillModel({
    required this.owner,
    required this.description,
    required this.newNumber,
  });

  factory OfficesRatingCardAutofillModel.fromJson(Map<String, dynamic> json) {
    return OfficesRatingCardAutofillModel(
      owner: json['owner'] ?? '',
      description: json['description'] ?? '',
      newNumber: json['newNumber'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'owner': owner,
      'description': description,
      'newNumber': newNumber,
    };
  }
}