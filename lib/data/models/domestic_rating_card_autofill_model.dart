class DomesticRatingCardAutofillModel {
  final String owner;
  final String description;
  final String newNumber;

  DomesticRatingCardAutofillModel({
    required this.owner,
    required this.description,
    required this.newNumber,
  });

  factory DomesticRatingCardAutofillModel.fromJson(Map<String, dynamic> json) {
    return DomesticRatingCardAutofillModel(
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
