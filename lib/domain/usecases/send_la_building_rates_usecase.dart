import 'package:dartz/dartz.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/data/models/la_building_rates_model.dart';
import 'package:land_asset_valuation/domain/repositories/la_building_rates_repository.dart';

class SendLaBuildingRatesUseCase {
  final LaBuildingRatesRepository repository;

  SendLaBuildingRatesUseCase(this.repository);

  Future<Either<Failure, bool>> call(LaBuildingRatesModel report) async {
    return await repository.sendLaBuildingRates(report);
  }
}
