import 'package:dartz/dartz.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/application/core/error/exceptions.dart';
import 'package:land_asset_valuation/data/datasource/remote/offices_rating_card_remote_data_source.dart';
import 'package:land_asset_valuation/data/models/offices_rating_card_autofill_model.dart';
import 'package:land_asset_valuation/data/models/offices_rating_card_model.dart';
import 'package:land_asset_valuation/domain/repositories/offices_rating_card_repository.dart';

class OfficesRatingCardRepositoryImpl implements OfficesRatingCardRepository {
  final OfficesRatingCardRemoteDataSource remoteDataSource;

  OfficesRatingCardRepositoryImpl({
    required this.remoteDataSource,
  });
  
  @override
  Future<Either<Failure, void>> saveOfficesRatingCard(
      OfficesRatingCardModel officesRatingCard) async {
    try {
      await remoteDataSource.saveOfficesRatingCard(officesRatingCard);
      return const Right(null);
    } on ServerException {
      return const Left(ServerFailure('Failed to save offices rating card'));
    } on DioErrorException {
      return const Left(NetworkFailure('Network error occurred'));
    } catch (e) {
      return const Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, OfficesRatingCardAutofillModel>> getAutofillData(
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