import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:land_asset_valuation/application/core/error/exceptions.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/data/datasource/remote/condition_report_remote_data_source.dart';
import 'package:land_asset_valuation/data/models/condition_report_model.dart';
import 'package:land_asset_valuation/domain/repositories/condition_report_repository.dart';

class ConditionReportRepositoryImpl implements ConditionReportRepository {
  final ConditionReportRemoteDataSource remoteDataSource;
  final Logger _logger = Logger();

  ConditionReportRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, bool>> sendConditionReport(
      ConditionReportModel report) async {
    try {
      // Debug: Log in repository before sending to remote data source
      _logger.d('======= REPOSITORY: SENDING TO REMOTE DATA SOURCE =======');
      _logger.d('Report ID: ${report.id}');
      _logger.d('Master File ID: ${report.masterFileId}');
      _logger.d('Data being sent to API...');
      _logger.d('===========================================');

      final result = await remoteDataSource.sendConditionReport(report);

      // Debug: Log result from remote data source
      _logger.d(
          '======= REPOSITORY: RECEIVED RESULT FROM REMOTE DATA SOURCE =======');
      _logger.d('Success: $result');
      _logger.d('===========================================');

      return Right(result);
    } on ServerException {
      _logger.e('======= REPOSITORY: SERVER EXCEPTION OCCURRED =======');
      return const Left(ServerFailure('Server error occurred'));
    } on DioErrorException {
      _logger.e('======= REPOSITORY: DIO ERROR EXCEPTION OCCURRED =======');
      return const Left(NetworkFailure('Network error occurred'));
    } catch (e) {
      _logger.e('======= REPOSITORY: UNEXPECTED ERROR OCCURRED =======');
      _logger.e('Error: $e');
      _logger.e('===========================================');
      return Left(ServerFailure(e.toString()));
    }
  }
}
