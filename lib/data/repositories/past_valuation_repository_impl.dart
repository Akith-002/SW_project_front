import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:land_asset_valuation/application/core/error/exceptions.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/data/datasource/remote/past_valuation_remote_data_source.dart';
import 'package:land_asset_valuation/data/models/past_valuation_model.dart';
import 'package:land_asset_valuation/domain/repositories/past_valuation_repository.dart';

class PastValuationRepositoryImpl implements PastValuationRepository {
  final PastValuationRemoteDataSource remoteDataSource;
  final Logger _logger = Logger();

  PastValuationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, String>> sendPastValuation(
      PastValuationModel report) async {
    try {
      // Debug: Log in repository before sending to remote data source
      _logger.d('======= REPOSITORY: SENDING TO REMOTE DATA SOURCE =======');
      _logger.d('Report ID: ${report.id}');
      _logger.d('Master File Ref: ${report.masterFileRef}');
      _logger.d('Situation: ${report.situation}');
      _logger.d('Data being sent to API...');
      _logger.d('===========================================');

      final reportId = await remoteDataSource.sendPastValuation(report);

      // Debug: Log result from remote data source
      _logger.d(
          '======= REPOSITORY: RECEIVED RESULT FROM REMOTE DATA SOURCE =======');
      _logger.d('Report ID: $reportId');
      _logger.d('===========================================');

      return Right(reportId);
    } on ServerException {
      _logger.e('======= REPOSITORY: SERVER EXCEPTION OCCURRED =======');
      return const Left(ServerFailure('Server error occurred'));
    } catch (e) {
      _logger.e('======= REPOSITORY: UNEXPECTED ERROR OCCURRED =======');
      _logger.e('Error: $e');
      _logger.e('===========================================');
      return Left(ServerFailure(e.toString()));
    }
  }
}
