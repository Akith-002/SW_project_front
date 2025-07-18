import 'package:dartz/dartz.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/data/models/domestic_rating_card_autofill_model.dart';
import 'package:land_asset_valuation/domain/repositories/domestic_rating_card_repository.dart';

class GetDomesticRatingCardAutofill {
  final DomesticRatingCardRepository repository;

  GetDomesticRatingCardAutofill(this.repository);

  Future<Either<Failure, DomesticRatingCardAutofillModel>> call(
      int params) async {
    return await repository.getAutofillData(params);
  }
}
