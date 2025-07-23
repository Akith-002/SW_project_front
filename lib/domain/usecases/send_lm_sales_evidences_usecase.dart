import 'package:dartz/dartz.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/data/models/lm_sales_evidences_model.dart';
import 'package:land_asset_valuation/domain/repositories/lm_sales_evidences_repository.dart';

/// Use case for sending LM Sales Evidences data
/// Encapsulates the business logic for sales evidence submission
class SendLmSalesEvidencesUseCase {
  final LmSalesEvidencesRepository repository;

  SendLmSalesEvidencesUseCase(this.repository);

  /// Executes the use case to send sales evidence data
  /// Returns Either<Failure, bool> - Left for error, Right for success
  Future<Either<Failure, bool>> call(
      LmSalesEvidencesModel salesEvidenceData) async {
    return await repository.sendLmSalesEvidences(salesEvidenceData);
  }
}
