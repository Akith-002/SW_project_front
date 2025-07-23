import 'package:dartz/dartz.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/data/models/lm_rental_evidences_model.dart';

abstract class LmRentalEvidencesRepository {
  Future<Either<Failure, String>> sendLmRentalEvidence(
      LmRentalEvidencesModel report);
}
