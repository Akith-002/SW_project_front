import 'package:dartz/dartz.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/data/models/inspection_report_model.dart';

abstract class InspectionReportRepository {
  Future<Either<Failure, InspectionReportModel>> sendInspectionReport(
      InspectionReportModel report);

  Future<int> getPendingReportsCount();

  Future<List<InspectionReportModel>> getPendingReports();
}
