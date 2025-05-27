class RentalAssessment {
  final int id;
  final String propertyAddress;
  // Add other fields as needed

  RentalAssessment({
    required this.id,
    required this.propertyAddress,
    // Add other fields
  });

  factory RentalAssessment.fromJson(Map<String, dynamic> json) {
    return RentalAssessment(
      id: json['id'],
      propertyAddress: json['propertyAddress'],
      // Map other fields
    );
  }
}