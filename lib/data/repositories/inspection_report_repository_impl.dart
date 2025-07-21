import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:land_asset_valuation/application/core/error/exceptions.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/data/datasource/remote/inspection_report_remote_data_source.dart';
import 'package:land_asset_valuation/data/datasource/local/inspection_report_local_data_source.dart';
import 'package:land_asset_valuation/data/services/connectivity_service.dart';
import 'package:land_asset_valuation/data/services/inspection_report_sync_service.dart';
import 'package:land_asset_valuation/data/models/inspection_report_model.dart';
import 'package:land_asset_valuation/domain/repositories/inspection_report_repository.dart';

class InspectionReportRepositoryImpl implements InspectionReportRepository {
  final InspectionReportRemoteDataSource remoteDataSource;
  final InspectionReportLocalDataSource localDataSource;
  final ConnectivityService connectivityService;
  final InspectionReportSyncService syncService;
  final Logger _logger = Logger();

  InspectionReportRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectivityService,
    required this.syncService,
  });

  @override
  Future<Either<Failure, InspectionReportModel>> sendInspectionReport(
      InspectionReportModel report) async {
    try {
      // Check connectivity first
      final isConnected = await connectivityService.isConnected;

      if (isConnected) {
        _logger.d(
            '======= REPOSITORY: ONLINE MODE - ATTEMPTING DIRECT SEND =======');
        try {
          // Try to send directly to remote
          final result = await remoteDataSource.sendInspectionReport(report);

          _logger.d('Successfully sent inspection report directly to server');
          return Right(result);
        } catch (e) {
          _logger.e('Direct send failed: $e, saving locally for sync');
          // Save locally if direct send fails
          await localDataSource.saveInspectionReport(report);
          return Right(InspectionReportModel(
            masterFileId: '',
            masterFileRefNo: '',
            inspectionDate: DateTime.now(),
            dsDivision: '',
            district: '',
            province: '',
            gnDivision: '',
            village: '',
            buildings: const [],
            otherInformation: '',
            otherConstructionDetails: '',
            detailsOfAssestsInventoryItems: '',
            detailsOfBusiness: '',
            remark: '',
          )); // Return a placeholder success
        }
      } else {
        _logger.d('======= REPOSITORY: OFFLINE MODE - SAVING LOCALLY =======');
        // Save locally if offline
        await localDataSource.saveInspectionReport(report);
        return Right(InspectionReportModel(
          masterFileId: '',
          masterFileRefNo: '',
          inspectionDate: DateTime.now(),
          dsDivision: '',
          district: '',
          province: '',
          gnDivision: '',
          village: '',
          buildings: const [],
          otherInformation: '',
          otherConstructionDetails: '',
          detailsOfAssestsInventoryItems: '',
          detailsOfBusiness: '',
          remark: '',
        )); // Return a placeholder success
      }
    } on ServerException {
      return const Left(ServerFailure('Server error occurred'));
    } on DioErrorException {
      return const Left(NetworkFailure('Network error occurred'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<int> getPendingReportsCount() async {
    return await localDataSource.getPendingReportsCount();
  }

  @override
  Future<List<InspectionReportModel>> getPendingReports() async {
    return await localDataSource.getPendingReports();
  }
}
