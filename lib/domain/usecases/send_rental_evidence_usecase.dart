import 'package:dartz/dartz.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/data/models/rental_evidence_model.dart';
import 'package:land_asset_valuation/domain/repositories/rental_evidence_repository.dart';

class SendRentalEvidenceUseCase {
  final RentalEvidenceRepository repository;

  SendRentalEvidenceUseCase(this.repository);

  Future<Either<Failure, String>> call(RentalEvidenceModel report) async {
    return await repository.sendRentalEvidence(report);
  }
}
