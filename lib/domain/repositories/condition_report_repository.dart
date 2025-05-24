import 'package:dartz/dartz.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/data/models/condition_report_model.dart';

abstract class ConditionReportRepository {
  Future<Either<Failure, bool>> sendConditionReport(
      ConditionReportModel report);
}
