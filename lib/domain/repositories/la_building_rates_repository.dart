import 'package:dartz/dartz.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/data/models/la_building_rates_model.dart';

abstract class LaBuildingRatesRepository {
  Future<Either<Failure, bool>> sendLaBuildingRates(
      LaBuildingRatesModel report);
}
