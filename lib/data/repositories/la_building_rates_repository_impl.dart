import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:land_asset_valuation/application/core/error/exceptions.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/data/datasource/remote/la_building_rates_remote_data_source.dart';
import 'package:land_asset_valuation/data/models/la_building_rates_model.dart';
import 'package:land_asset_valuation/domain/repositories/la_building_rates_repository.dart';

class LaBuildingRatesRepositoryImpl implements LaBuildingRatesRepository {
  final LaBuildingRatesRemoteDataSource remoteDataSource;
  final Logger _logger = Logger();

  LaBuildingRatesRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, bool>> sendLaBuildingRates(
      LaBuildingRatesModel report) async {
    try {
      _logger.d('======= LA BUILDING RATES REPOSITORY: SENDING DATA =======');
      _logger.d('Report Assessment Number: ${report.assessmentNumber}');
      _logger.d('Report Owner: ${report.owner}');
      _logger.d('===========================================');

      final result = await remoteDataSource.sendLaBuildingRates(report);

      if (result) {
        _logger.d('======= LA BUILDING RATES REPOSITORY: SUCCESS =======');
        _logger.d('Successfully sent LA Building Rates data to server');
        _logger.d('===========================================');
        return const Right(true);
      } else {
        _logger.e('======= LA BUILDING RATES REPOSITORY: FAILED =======');
        _logger.e('Failed to send LA Building Rates data to server');
        _logger.e('===========================================');
        return const Left(
            ServerFailure('Failed to send LA Building Rates data'));
      }
    } on ServerException {
      _logger.e('======= LA BUILDING RATES REPOSITORY: SERVER ERROR =======');
      _logger.e('Server exception occurred');
      _logger.e('===========================================');
      return const Left(ServerFailure('Server error occurred'));
    } on DioErrorException {
      _logger.e('======= LA BUILDING RATES REPOSITORY: NETWORK ERROR =======');
      _logger.e('Network exception occurred');
      _logger.e('===========================================');
      return const Left(NetworkFailure('Network error occurred'));
    } catch (e) {
      _logger
          .e('======= LA BUILDING RATES REPOSITORY: UNEXPECTED ERROR =======');
      _logger.e('Error: $e');
      _logger.e('===========================================');
      return Left(ServerFailure(e.toString()));
    }
  }
}
