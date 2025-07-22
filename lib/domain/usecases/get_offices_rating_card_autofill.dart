import 'package:dartz/dartz.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/data/models/offices_rating_card_autofill_model.dart';
import 'package:land_asset_valuation/domain/repositories/offices_rating_card_repository.dart';

class GetOfficesRatingCardAutofill {
  final OfficesRatingCardRepository repository;

  GetOfficesRatingCardAutofill(this.repository);

  Future<Either<Failure, OfficesRatingCardAutofillModel>> call(
      int params) async {
    return await repository.getAutofillData(params);
  }
}