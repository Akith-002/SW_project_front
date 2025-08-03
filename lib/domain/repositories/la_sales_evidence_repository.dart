import 'package:dartz/dartz.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/data/models/la_sales_evidence_model.dart';

/// Repository interface for LA Sales Evidence operations
/// Defines the contract for sales evidence data operations
abstract class LaSalesEvidenceRepository {
  /// Sends LA Sales Evidence data to the backend
  /// Returns Either<Failure, bool> - Left for error, Right for success
  Future<Either<Failure, bool>> sendLaSalesEvidence(
      LaSalesEvidenceModel salesEvidenceData);
}
