import 'package:dartz/dartz.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/data/models/lm_building_rates_model.dart';

abstract class LmBuildingRatesRepository {
  Future<Either<Failure, bool>> sendLmBuildingRates(
      LmBuildingRatesModel report);
}
