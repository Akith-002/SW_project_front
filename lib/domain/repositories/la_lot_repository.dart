import 'package:dartz/dartz.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/data/models/la_lot_model.dart';

abstract class LALotRepository {
  Future<Either<Failure, LALotResponse>> saveLot(LALotModel lot);
}
