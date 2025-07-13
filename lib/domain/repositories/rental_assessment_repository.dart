import 'package:land_asset_valuation/data/models/rental_assesment_model.dart';

abstract class RentalAssessmentRepository {
  Future<List<RentalAssessment>> getRentalAssessments();
}
