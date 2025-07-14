import 'package:land_asset_valuation/data/datasource/remote/rental_assessment_remote_datasource.dart';
import 'package:land_asset_valuation/data/models/rental_assesment_model.dart';
import 'package:land_asset_valuation/domain/repositories/rental_assessment_repository.dart';

class RentalAssessmentRepositoryImpl implements RentalAssessmentRepository {
  final RentalAssessmentRemoteDataSource remoteDataSource;

  RentalAssessmentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<RentalAssessment>> getRentalAssessments() async {
    try {
      return await remoteDataSource.getRentalAssessments();
    } catch (e) {
      throw Exception('Failed to get rental assessments: $e');
    }
  }
}

