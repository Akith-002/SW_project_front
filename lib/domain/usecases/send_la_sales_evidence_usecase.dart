import 'package:dartz/dartz.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/data/models/la_sales_evidence_model.dart';
import 'package:land_asset_valuation/domain/repositories/la_sales_evidence_repository.dart';

/// Use case for sending LA Sales Evidence data
/// Encapsulates the business logic for sales evidence submission
class SendLaSalesEvidenceUseCase {
  final LaSalesEvidenceRepository repository;

  SendLaSalesEvidenceUseCase({required this.repository});

  /// Executes the use case to send sales evidence data
  /// Returns Either<Failure, bool> - Left for error, Right for success
  Future<Either<Failure, bool>> call(
      LaSalesEvidenceModel salesEvidenceData) async {
    return await repository.sendLaSalesEvidence(salesEvidenceData);
  }
}
