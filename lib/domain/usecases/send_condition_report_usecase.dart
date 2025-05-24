import 'package:dartz/dartz.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/data/models/condition_report_model.dart';
import 'package:land_asset_valuation/domain/repositories/condition_report_repository.dart';

class SendConditionReportUseCase {
  final ConditionReportRepository repository;

  SendConditionReportUseCase(this.repository);

  Future<Either<Failure, bool>> call(ConditionReportModel report) async {
    return await repository.sendConditionReport(report);
  }
}
