import 'package:dartz/dartz.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/data/models/past_valuation_model.dart';
import 'package:land_asset_valuation/domain/repositories/past_valuation_repository.dart';

class SendPastValuationUseCase {
  final PastValuationRepository repository;

  SendPastValuationUseCase(this.repository);

  Future<Either<Failure, String>> call(PastValuationModel report) async {
    return await repository.sendPastValuation(report);
  }
}
