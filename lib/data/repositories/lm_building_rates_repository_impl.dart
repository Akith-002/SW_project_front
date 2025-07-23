import 'package:dartz/dartz.dart';
import 'package:land_asset_valuation/application/core/error/exceptions.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/data/datasource/remote/lm_building_rates_remote_data_source.dart';
import 'package:land_asset_valuation/data/models/lm_building_rates_model.dart';
import 'package:land_asset_valuation/domain/repositories/lm_building_rates_repository.dart';

class LmBuildingRatesRepositoryImpl implements LmBuildingRatesRepository {
  final LmBuildingRatesRemoteDataSource remoteDataSource;

  LmBuildingRatesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, bool>> sendLmBuildingRates(
      LmBuildingRatesModel report) async {
    try {
      final result = await remoteDataSource.sendLmBuildingRates(report);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure('Failed to submit LM building rates data'));
    } on DioErrorException {
      return Left(NetworkFailure(
          'Network error. Please check your internet connection'));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: $e'));
    }
  }
}
