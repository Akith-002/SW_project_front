import 'package:land_asset_valuation/data/datasource/local/inspection_report_local_database.dart';
import 'package:land_asset_valuation/data/models/inspection_report_model.dart';

abstract class InspectionReportLocalDataSource {
  Future<int> saveInspectionReport(InspectionReportModel report);
  Future<List<InspectionReportModel>> getAllReports();
  Future<List<InspectionReportModel>> getPendingReports();
  Future<List<InspectionReportModel>> getFailedReports();
  Future<int> getPendingReportsCount();
  Future<void> deleteReport(int localId);
  Future<void> clearSyncedReports();
  Future<void> markReportAsSynced(int localId);
  Future<void> markReportAsFailed(int localId, String errorMessage);
}

class InspectionReportLocalDataSourceImpl
    implements InspectionReportLocalDataSource {
  final InspectionReportLocalDatabase database;

  InspectionReportLocalDataSourceImpl({required this.database});

  @override
  Future<int> saveInspectionReport(InspectionReportModel report) async {
    return await database.insertInspectionReport(report);
  }

  @override
  Future<List<InspectionReportModel>> getAllReports() async {
    return await database.getAllReports();
  }

  @override
  Future<List<InspectionReportModel>> getPendingReports() async {
    return await database.getPendingReports();
  }

  @override
  Future<int> getPendingReportsCount() async {
    return await database.getPendingReportsCount();
  }

  @override
  Future<void> deleteReport(int localId) async {
    return await database.deleteReport(localId);
  }

  @override
  Future<void> clearSyncedReports() async {
    return await database.clearSyncedReports();
  }

  @override
  Future<List<InspectionReportModel>> getFailedReports() async {
    return await database.getFailedReports();
  }

  @override
  Future<void> markReportAsSynced(int localId) async {
    return await database.markReportAsSynced(localId);
  }

  @override
  Future<void> markReportAsFailed(int localId, String errorMessage) async {
    return await database.markReportAsFailed(localId, errorMessage);
  }
}
