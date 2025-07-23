import 'package:dartz/dartz.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/data/models/past_valuation_model.dart';

abstract class PastValuationRepository {
  Future<Either<Failure, String>> sendPastValuation(PastValuationModel report);
}
