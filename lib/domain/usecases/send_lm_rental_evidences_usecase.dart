import 'package:dartz/dartz.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/data/models/lm_rental_evidences_model.dart';
import 'package:land_asset_valuation/domain/repositories/lm_rental_evidences_repository.dart';

class SendLmRentalEvidencesUseCase {
  final LmRentalEvidencesRepository repository;

  SendLmRentalEvidencesUseCase(this.repository);

  Future<Either<Failure, String>> call(LmRentalEvidencesModel report) async {
    return await repository.sendLmRentalEvidence(report);
  }
}
