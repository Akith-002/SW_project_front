import 'package:land_asset_valuation/data/models/rental_assesment_model.dart';
import 'package:land_asset_valuation/domain/repositories/rental_assessment_repository.dart';

class GetRentalAssessmentsUseCase {
  final RentalAssessmentRepository repository;

  GetRentalAssessmentsUseCase(this.repository);

  Future<List<RentalAssessment>> call() async {
    return await repository.getRentalAssessments();
  }
}
