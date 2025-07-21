import 'package:dartz/dartz.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/data/models/offices_rating_card_model.dart';
import 'package:land_asset_valuation/domain/repositories/offices_rating_card_repository.dart';

class SaveOfficesRatingCard {
  final OfficesRatingCardRepository repository;

  SaveOfficesRatingCard(this.repository);

  Future<Either<Failure, void>> call(OfficesRatingCardModel params) async {
    return await repository.saveOfficesRatingCard(params);
  }
}