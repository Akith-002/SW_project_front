import 'package:dartz/dartz.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/data/models/lm_building_rates_model.dart';
import 'package:land_asset_valuation/domain/repositories/lm_building_rates_repository.dart';

class SendLmBuildingRatesUseCase {
  final LmBuildingRatesRepository repository;

  SendLmBuildingRatesUseCase(this.repository);

  Future<Either<Failure, bool>> call(LmBuildingRatesModel report) async {
    return await repository.sendLmBuildingRates(report);
  }
}
