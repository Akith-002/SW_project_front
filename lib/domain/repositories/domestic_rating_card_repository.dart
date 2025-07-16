import 'package:dartz/dartz.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/data/models/domestic_rating_card_model.dart';
import 'package:land_asset_valuation/data/models/domestic_rating_card_autofill_model.dart';

abstract class DomesticRatingCardRepository {
  Future<Either<Failure, void>> saveDomesticRatingCard(
      DomesticRatingCardModel model);
  Future<Either<Failure, DomesticRatingCardAutofillModel>> getAutofillData(
      int assetId);
}
