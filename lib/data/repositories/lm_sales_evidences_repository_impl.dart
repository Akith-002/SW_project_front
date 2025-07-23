import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:land_asset_valuation/application/core/error/exceptions.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/data/datasource/remote/lm_sales_evidences_remote_data_source.dart';
import 'package:land_asset_valuation/data/models/lm_sales_evidences_model.dart';
import 'package:land_asset_valuation/domain/repositories/lm_sales_evidences_repository.dart';

/// Implementation of LM Sales Evidences repository
/// Handles data operations and error mapping for sales evidence
class LmSalesEvidencesRepositoryImpl implements LmSalesEvidencesRepository {
  final LmSalesEvidencesRemoteDataSource remoteDataSource;
  final Logger _logger = Logger();

  LmSalesEvidencesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, bool>> sendLmSalesEvidences(
      LmSalesEvidencesModel salesEvidenceData) async {
    try {
      // Debug: Log in repository before sending to remote data source
      _logger.d(
          '======= LM SALES EVIDENCES REPOSITORY: SENDING TO REMOTE DATA SOURCE =======');
      _logger.d('Asset Number: ${salesEvidenceData.assetNumber}');
      _logger.d('Master File Ref: ${salesEvidenceData.masterFileRef}');
      _logger.d('Vendor: ${salesEvidenceData.vendor}');
      _logger.d('Consideration: ${salesEvidenceData.consideration}');
      _logger.d('Rate: ${salesEvidenceData.rate}');
      _logger.d('===========================================');

      // Attempt to send sales evidence data to the remote data source
      final result =
          await remoteDataSource.sendLmSalesEvidences(salesEvidenceData);

      // Debug: Log successful result
      _logger.d('======= LM SALES EVIDENCES REPOSITORY: SUCCESS =======');
      _logger.d('Data sent successfully: $result');
      _logger.d('===========================================');

      // Return success with the result
      return Right(result);
    } on ServerException {
      _logger
          .e('======= LM SALES EVIDENCES REPOSITORY: SERVER EXCEPTION =======');
      _logger
          .e('Server exception occurred during LM sales evidence submission');
      _logger.e('===========================================');
      return Left(ServerFailure('Failed to submit sales evidence data'));
    } catch (e, stackTrace) {
      _logger
          .e('======= LM SALES EVIDENCES REPOSITORY: UNEXPECTED ERROR =======');
      _logger.e('Unexpected error: $e');
      _logger.e('Stack trace: $stackTrace');
      _logger.e('===========================================');
      return Left(ServerFailure('An unexpected error occurred: $e'));
    }
  }
}
