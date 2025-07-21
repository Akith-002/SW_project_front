import 'package:dartz/dartz.dart';
import 'package:land_asset_valuation/data/models/inspection_report_model.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/domain/repositories/inspection_report_repository.dart';

class SendInspectionReportUseCase {
  final InspectionReportRepository repository;

  SendInspectionReportUseCase(this.repository);

  Future<Either<Failure, InspectionReportModel>> call(
      InspectionReportModel report) async {
    try {
      return await repository.sendInspectionReport(report);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
