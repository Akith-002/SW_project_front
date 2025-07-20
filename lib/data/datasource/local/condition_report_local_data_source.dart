import 'package:land_asset_valuation/data/datasource/local/condition_report_local_database.dart';
import 'package:land_asset_valuation/data/models/condition_report_model.dart';

abstract class ConditionReportLocalDataSource {
  Future<int> saveConditionReport(ConditionReportModel report);
  Future<List<ConditionReportModel>> getAllReports();
  Future<List<ConditionReportModel>> getPendingReports();
  Future<int> getPendingReportsCount();
  Future<void> deleteReport(int localId);
  Future<void> clearSyncedReports();
}

class ConditionReportLocalDataSourceImpl
    implements ConditionReportLocalDataSource {
  final ConditionReportLocalDatabase database;

  ConditionReportLocalDataSourceImpl({required this.database});

  @override
  Future<int> saveConditionReport(ConditionReportModel report) async {
    return await database.insertConditionReport(report);
  }

  @override
  Future<List<ConditionReportModel>> getAllReports() async {
    return await database.getAllReports();
  }

  @override
  Future<List<ConditionReportModel>> getPendingReports() async {
    return await database.getPendingReports();
  }

  @override
  Future<int> getPendingReportsCount() async {
    return await database.getPendingReportsCount();
  }

  @override
  Future<void> deleteReport(int localId) async {
    await database.deleteReport(localId);
  }

  @override
  Future<void> clearSyncedReports() async {
    await database.clearSyncedReports();
  }
}
