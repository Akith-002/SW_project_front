import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:land_asset_valuation/application/core/error/exceptions.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/data/datasource/remote/lm_rental_evidences_remote_data_source.dart';
import 'package:land_asset_valuation/data/models/lm_rental_evidences_model.dart';
import 'package:land_asset_valuation/domain/repositories/lm_rental_evidences_repository.dart';

class LmRentalEvidencesRepositoryImpl implements LmRentalEvidencesRepository {
  final LmRentalEvidencesRemoteDataSource remoteDataSource;
  final Logger _logger = Logger();

  LmRentalEvidencesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, String>> sendLmRentalEvidence(
      LmRentalEvidencesModel report) async {
    try {
      // Debug: Log in repository before sending to remote data source
      _logger.d(
          '======= LM RENTAL EVIDENCES REPOSITORY: SENDING TO REMOTE DATA SOURCE =======');
      _logger.d('Report ID: ${report.id}');
      _logger.d(
          'Land Miscellaneous Master File ID: ${report.landMiscellaneousMasterFileId}');
      _logger.d('Assessment No: ${report.assessmentNo}');
      _logger.d('Owner: ${report.owner}');
      _logger.d('Data being sent to API...');
      _logger.d('===========================================');

      final reportId = await remoteDataSource.sendLmRentalEvidence(report);

      // Debug: Log result from remote data source
      _logger.d(
          '======= LM RENTAL EVIDENCES REPOSITORY: RECEIVED RESULT FROM REMOTE DATA SOURCE =======');
      _logger.d('Report ID: $reportId');
      _logger.d('===========================================');

      return Right(reportId);
    } on ServerException {
      _logger.e(
          '======= LM RENTAL EVIDENCES REPOSITORY: SERVER EXCEPTION OCCURRED =======');
      return const Left(ServerFailure('Server error occurred'));
    } catch (e) {
      _logger.e(
          '======= LM RENTAL EVIDENCES REPOSITORY: UNEXPECTED ERROR OCCURRED =======');
      _logger.e('Error: $e');
      _logger.e('===========================================');
      return Left(ServerFailure(e.toString()));
    }
  }
}
