import 'package:dartz/dartz.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/data/models/domestic_rating_card_model.dart';
import 'package:land_asset_valuation/domain/repositories/domestic_rating_card_repository.dart';

class SaveDomesticRatingCard {
  final DomesticRatingCardRepository repository;

  SaveDomesticRatingCard(this.repository);

  Future<Either<Failure, void>> call(DomesticRatingCardModel params) async {
    return await repository.saveDomesticRatingCard(params);
  }
}
