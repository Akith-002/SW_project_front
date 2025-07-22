import 'dart:async';
import 'package:logger/logger.dart';
import 'package:land_asset_valuation/data/datasource/local/inspection_report_local_data_source.dart';
import 'package:land_asset_valuation/data/datasource/remote/inspection_report_remote_data_source.dart';
import 'package:land_asset_valuation/data/services/connectivity_service.dart';

enum SyncStatus { syncing, completed, failed }

class InspectionReportSyncService {
  final InspectionReportRemoteDataSource remoteDataSource;
  final InspectionReportLocalDataSource localDataSource;
  final ConnectivityService connectivityService;
  final Logger _logger = Logger();

  final _syncStatusController = StreamController<SyncStatus>.broadcast();
  Stream<SyncStatus> get syncStatusStream => _syncStatusController.stream;

  bool _isSyncing = false;

  InspectionReportSyncService({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectivityService,
  });

  Future<void> startSyncIfPossible() async {
    if (_isSyncing) {
      _logger.w('Sync already in progress');
      return;
    }

    final isConnected = await connectivityService.isConnected;
    if (!isConnected) {
      _logger.d('No internet connection, skipping sync');
      return;
    }

    final pendingReports = await localDataSource.getPendingReports();
    if (pendingReports.isEmpty) {
      _logger.d('No pending reports to sync');
      return;
    }

    await _performSync(pendingReports);
  }

  Future<void> _performSync(List<dynamic> pendingReports) async {
    _isSyncing = true;
    _syncStatusController.add(SyncStatus.syncing);

    try {
      _logger.d('Starting sync of ${pendingReports.length} pending reports');

      int syncedCount = 0;
      for (final report in pendingReports) {
        try {
          // Convert to InspectionReportModel and send
          await remoteDataSource.sendInspectionReport(report);

          // Mark as synced in local database
          if (report.id != null) {
            await localDataSource.markReportAsSynced(report.id!);
          }

          syncedCount++;
          _logger.d('Successfully synced report ${report.id}');
        } catch (e) {
          _logger.e('Failed to sync report ${report.id}: $e');
          // Mark as failed in local database
          if (report.id != null) {
            await localDataSource.markReportAsFailed(report.id!, e.toString());
          }
        }
      }

      _logger.d(
          'Sync completed: $syncedCount/${pendingReports.length} reports synced');
      _syncStatusController.add(SyncStatus.completed);
    } catch (e) {
      _logger.e('Sync process failed: $e');
      _syncStatusController.add(SyncStatus.failed);
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> retryFailedReports() async {
    final failedReports = await localDataSource.getFailedReports();
    if (failedReports.isNotEmpty) {
      await _performSync(failedReports);
    }
  }

  void dispose() {
    _syncStatusController.close();
  }
}
