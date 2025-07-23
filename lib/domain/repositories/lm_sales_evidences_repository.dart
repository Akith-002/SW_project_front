import 'package:dartz/dartz.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/data/models/lm_sales_evidences_model.dart';

/// Repository interface for LM Sales Evidences operations
/// Defines the contract for sales evidence data operations
abstract class LmSalesEvidencesRepository {
  /// Sends LM Sales Evidences data to the backend
  /// Returns Either<Failure, bool> - Left for error, Right for success
  Future<Either<Failure, bool>> sendLmSalesEvidences(
      LmSalesEvidencesModel salesEvidenceData);
}
