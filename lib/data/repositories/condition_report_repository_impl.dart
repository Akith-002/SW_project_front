import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:land_asset_valuation/application/core/error/exceptions.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/data/datasource/remote/condition_report_remote_data_source.dart';
import 'package:land_asset_valuation/data/datasource/local/condition_report_local_data_source.dart';
import 'package:land_asset_valuation/data/services/connectivity_service.dart';
import 'package:land_asset_valuation/data/services/condition_report_sync_service.dart';
import 'package:land_asset_valuation/data/models/condition_report_model.dart';
import 'package:land_asset_valuation/domain/repositories/condition_report_repository.dart';

class ConditionReportRepositoryImpl implements ConditionReportRepository {
  final ConditionReportRemoteDataSource remoteDataSource;
  final ConditionReportLocalDataSource localDataSource;
  final ConnectivityService connectivityService;
  final ConditionReportSyncService syncService;
  final Logger _logger = Logger();

  ConditionReportRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectivityService,
    required this.syncService,
  });

  @override
  Future<Either<Failure, bool>> sendConditionReport(
      ConditionReportModel report) async {
    try {
      // Check connectivity first
      final isConnected = await connectivityService.isConnected;

      if (isConnected) {
        _logger.d(
            '======= REPOSITORY: ONLINE MODE - ATTEMPTING DIRECT SEND =======');
        try {
          // Try to send directly to remote
          final result = await remoteDataSource.sendConditionReport(report);

          if (result) {
            _logger.d('Successfully sent report directly to server');
            return const Right(true);
          } else {
            // If direct send fails, save locally
            _logger.w('Direct send failed, saving locally for sync');
            await localDataSource.saveConditionReport(report);
            return const Right(true);
          }
        } catch (e) {
          _logger.e('Direct send failed: $e, saving locally for sync');
          // Save locally if direct send fails
          await localDataSource.saveConditionReport(report);
          return const Right(true);
        }
      } else {
        _logger.d('======= REPOSITORY: OFFLINE MODE - SAVING LOCALLY =======');
        // Save locally for later sync
        final localId = await localDataSource.saveConditionReport(report);
        _logger.d('Saved report locally with ID: $localId');

        return const Right(true);
      }
    } catch (e) {
      _logger.e('======= REPOSITORY: UNEXPECTED ERROR =======');
      _logger.e('Error: $e');
      _logger.e('===========================================');
      return Left(ServerFailure(e.toString()));
    }
  }

  // Additional methods for offline functionality
  Future<List<ConditionReportModel>> getPendingReports() async {
    return await localDataSource.getPendingReports();
  }

  Future<int> getPendingReportsCount() async {
    return await localDataSource.getPendingReportsCount();
  }

  Future<void> syncPendingReports() async {
    await syncService.syncPendingReports();
  }
}
