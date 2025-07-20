import 'package:dartz/dartz.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/data/models/rental_evidence_model.dart';

abstract class RentalEvidenceRepository {
  Future<Either<Failure, String>> sendRentalEvidence(
      RentalEvidenceModel report);
}
