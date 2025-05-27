import 'package:dartz/dartz.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/application/core/error/exceptions.dart';
import 'package:land_asset_valuation/data/datasource/remote/domestic_rating_card_remote_data_source.dart';
import 'package:land_asset_valuation/data/models/domestic_rating_card_autofill_model.dart';
import 'package:land_asset_valuation/data/models/domestic_rating_card_model.dart';
import 'package:land_asset_valuation/domain/repositories/domestic_rating_card_repository.dart';

class DomesticRatingCardRepositoryImpl implements DomesticRatingCardRepository {
  final DomesticRatingCardRemoteDataSource remoteDataSource;

  DomesticRatingCardRepositoryImpl({
    required this.remoteDataSource,
  });
  @override
  Future<Either<Failure, void>> saveDomesticRatingCard(
      DomesticRatingCardModel domesticRatingCard) async {
    try {
      await remoteDataSource.saveDomesticRatingCard(domesticRatingCard);
      return const Right(null);
    } on ServerException {
      return const Left(ServerFailure('Failed to save domestic rating card'));
    } on DioErrorException {
      return const Left(NetworkFailure('Network error occurred'));
    } catch (e) {
      return const Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, DomesticRatingCardAutofillModel>> getAutofillData(
      int assetId) async {
    try {
      final result = await remoteDataSource.getAutofillData(assetId);
      return Right(result);
    } on ServerException {
      return const Left(ServerFailure('Failed to get autofill data'));
    } on DioErrorException {
      return const Left(NetworkFailure('Network error occurred'));
    } catch (e) {
      return const Left(ServerFailure('An unexpected error occurred'));
    }
  }
}
