import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:land_asset_valuation/application/core/error/exceptions.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/data/datasource/remote/la_lot_remote_data_source.dart';
import 'package:land_asset_valuation/data/models/la_lot_model.dart';
import 'package:land_asset_valuation/domain/repositories/la_lot_repository.dart';

class LALotRepositoryImpl implements LALotRepository {
  final LALotRemoteDataSource remoteDataSource;
  final Logger _logger = Logger();

  LALotRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, LALotResponse>> saveLot(LALotModel lot) async {
    try {
      _logger.d('======= LA LOT REPOSITORY: SAVING LOT =======');
      _logger.d('Master File ID: ${lot.masterFileId}');
      _logger.d('Coordinates: ${lot.coordinates}');
      _logger.d('===========================================');

      final response = await remoteDataSource.saveLot(lot);

      _logger.d('======= LA LOT REPOSITORY: SUCCESS =======');
      _logger.d('Response: ${response.message}');
      _logger.d('===========================================');

      return Right(response);
    } on ServerException {
      _logger.e('======= LA LOT REPOSITORY: SERVER ERROR =======');
      return const Left(ServerFailure('Server error occurred'));
    } on DioErrorException {
      _logger.e('======= LA LOT REPOSITORY: NETWORK ERROR =======');
      return const Left(NetworkFailure('Network error occurred'));
    } catch (e) {
      _logger.e('======= LA LOT REPOSITORY: UNEXPECTED ERROR =======');
      _logger.e('Error: $e');
      _logger.e('===========================================');
      return Left(ServerFailure(e.toString()));
    }
  }
}
