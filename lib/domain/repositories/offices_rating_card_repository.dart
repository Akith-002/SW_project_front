import 'package:dartz/dartz.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/data/models/offices_rating_card_model.dart';
import 'package:land_asset_valuation/data/models/offices_rating_card_autofill_model.dart';

abstract class OfficesRatingCardRepository {
  Future<Either<Failure, void>> saveOfficesRatingCard(
      OfficesRatingCardModel model);
  Future<Either<Failure, OfficesRatingCardAutofillModel>> getAutofillData(
      int assetId);
}