import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:land_asset_valuation/application/core/error/exceptions.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/data/datasource/remote/marker_coordinate_remote_data_source.dart';
import 'package:land_asset_valuation/data/models/marker_coordinate_model.dart';
import 'package:land_asset_valuation/domain/repositories/marker_coordinate_repository.dart';

class MarkerCoordinateRepositoryImpl implements MarkerCoordinateRepository {
  final MarkerCoordinateRemoteDataSource remoteDataSource;
  final Logger _logger = Logger();

  MarkerCoordinateRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, MarkerCoordinateResponse>> saveBuildingRatesCoordinate(
      MarkerCoordinateModel marker) async {
    return _saveMarkerCoordinate(marker, 'Building Rates',
        () => remoteDataSource.saveBuildingRatesCoordinate(marker));
  }

  @override
  Future<Either<Failure, MarkerCoordinateResponse>>
      savePastValuationsCoordinate(MarkerCoordinateModel marker) async {
    return _saveMarkerCoordinate(marker, 'Past Valuations',
        () => remoteDataSource.savePastValuationsCoordinate(marker));
  }

  @override
  Future<Either<Failure, MarkerCoordinateResponse>>
      saveRentalEvidenceCoordinate(MarkerCoordinateModel marker) async {
    return _saveMarkerCoordinate(marker, 'Rental Evidence',
        () => remoteDataSource.saveRentalEvidenceCoordinate(marker));
  }

  @override
  Future<Either<Failure, MarkerCoordinateResponse>> saveSalesEvidenceCoordinate(
      MarkerCoordinateModel marker) async {
    return _saveMarkerCoordinate(marker, 'Sales Evidence',
        () => remoteDataSource.saveSalesEvidenceCoordinate(marker));
  }

  Future<Either<Failure, MarkerCoordinateResponse>> _saveMarkerCoordinate(
    MarkerCoordinateModel marker,
    String markerType,
    Future<MarkerCoordinateResponse> Function() remoteCall,
  ) async {
    try {
      _logger.d(
          '======= MARKER COORDINATE REPOSITORY: SAVING $markerType COORDINATE =======');
      _logger.d('Master File ID: ${marker.masterfileId}');
      _logger.d('Coordinates: ${marker.coordinates}');
      _logger.d('===========================================');

      final response = await remoteCall();

      _logger.d('======= MARKER COORDINATE REPOSITORY: SUCCESS =======');
      _logger.d('Response: ${response.message}');
      _logger.d('===========================================');

      return Right(response);
    } on ServerException {
      _logger.e('======= MARKER COORDINATE REPOSITORY: SERVER ERROR =======');
      return Left(ServerFailure(
          'Server error occurred while saving $markerType coordinate'));
    } on DioErrorException {
      _logger.e('======= MARKER COORDINATE REPOSITORY: NETWORK ERROR =======');
      return Left(NetworkFailure(
          'Network error occurred while saving $markerType coordinate'));
    } catch (e) {
      _logger
          .e('======= MARKER COORDINATE REPOSITORY: UNEXPECTED ERROR =======');
      _logger.e('Error: $e');
      _logger.e('===========================================');
      return Left(ServerFailure(e.toString()));
    }
  }
}
