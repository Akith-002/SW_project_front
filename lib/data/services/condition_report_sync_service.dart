import 'dart:async';
import 'package:logger/logger.dart';
import 'package:land_asset_valuation/data/datasource/local/condition_report_local_database.dart';
import 'package:land_asset_valuation/data/datasource/remote/condition_report_remote_data_source.dart';
import 'package:land_asset_valuation/data/services/connectivity_service.dart';
import 'package:land_asset_valuation/data/models/condition_report_model.dart';

class ConditionReportSyncService {
  final ConditionReportLocalDatabase _localDatabase;
  final ConditionReportRemoteDataSource _remoteDataSource;
  final ConnectivityService _connectivityService;
  final Logger _logger = Logger();

  StreamSubscription<bool>? _connectivitySubscription;
  Timer? _syncTimer;
  bool _isSyncing = false;

  // Stream controller for sync status
  final StreamController<SyncStatus> _syncStatusController =
      StreamController<SyncStatus>.broadcast();

  ConditionReportSyncService({
    required ConditionReportLocalDatabase localDatabase,
    required ConditionReportRemoteDataSource remoteDataSource,
    required ConnectivityService connectivityService,
  })  : _localDatabase = localDatabase,
        _remoteDataSource = remoteDataSource,
        _connectivityService = connectivityService;

  Stream<SyncStatus> get syncStatusStream => _syncStatusController.stream;

  void initialize() {
    // Listen to connectivity changes
    _connectivitySubscription = _connectivityService.connectivityStream.listen(
      (bool isConnected) {
        if (isConnected && !_isSyncing) {
          _logger.i('Internet connection restored. Starting sync...');
          syncPendingReports();
        }
      },
    );

    // Set up periodic sync (every 5 minutes when connected)
    _syncTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      if (!_isSyncing) {
        syncPendingReports();
      }
    });
  }

  Future<void> syncPendingReports() async {
    if (_isSyncing) {
      _logger.w('Sync already in progress, skipping...');
      return;
    }

    final isConnected = await _connectivityService.isConnected;
    if (!isConnected) {
      _logger.w('No internet connection, sync skipped');
      return;
    }

    _isSyncing = true;
    _syncStatusController.add(SyncStatus.syncing);

    try {
      final pendingReports = await _localDatabase.getPendingReports();
      _logger.i('Found ${pendingReports.length} pending reports to sync');

      if (pendingReports.isEmpty) {
        _syncStatusController.add(SyncStatus.idle);
        _isSyncing = false;
        return;
      }

      int successCount = 0;
      int failureCount = 0;

      for (final report in pendingReports) {
        try {
          // Attempt to send to remote
          final success = await _remoteDataSource.sendConditionReport(report);

          if (success) {
            // Mark as synced in local database
            await _localDatabase.markReportAsSynced(report.id!);
            successCount++;
            _logger.i('Successfully synced report with local ID: ${report.id}');
          } else {
            await _localDatabase.markReportAsFailed(
                report.id!, 'Server returned failure response');
            failureCount++;
          }
        } catch (e) {
          // Mark as failed with error message
          await _localDatabase.markReportAsFailed(report.id!, e.toString());
          failureCount++;
          _logger.e(
              'Failed to sync report with local ID: ${report.id}, Error: $e');
        }
      }

      _logger
          .i('Sync completed: $successCount succeeded, $failureCount failed');
      _syncStatusController.add(SyncStatus.completed);
    } catch (e) {
      _logger.e('Error during sync: $e');
      _syncStatusController.add(SyncStatus.failed);
    } finally {
      _isSyncing = false;
    }
  }

  Future<int> getPendingReportsCount() async {
    return await _localDatabase.getPendingReportsCount();
  }

  Future<void> retryFailedReports() async {
    final db = await _localDatabase.database;
    await db.update(
      'condition_reports',
      {'syncStatus': 'pending'},
      where: 'syncStatus = ?',
      whereArgs: ['failed'],
    );

    if (await _connectivityService.isConnected) {
      syncPendingReports();
    }
  }

  void dispose() {
    _connectivitySubscription?.cancel();
    _syncTimer?.cancel();
    _syncStatusController.close();
  }
}

enum SyncStatus {
  idle,
  syncing,
  completed,
  failed,
}
