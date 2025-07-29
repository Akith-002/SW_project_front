import 'package:dartz/dartz.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/data/models/marker_coordinate_model.dart';
import 'package:land_asset_valuation/domain/repositories/marker_coordinate_repository.dart';

class SaveSalesEvidenceCoordinateUseCase {
  final MarkerCoordinateRepository repository;

  SaveSalesEvidenceCoordinateUseCase(this.repository);

  Future<Either<Failure, MarkerCoordinateResponse>> call({
    required int masterfileId,
    required String coordinates,
  }) async {
    final marker = MarkerCoordinateModel(
      masterfileId: masterfileId,
      coordinates: coordinates,
    );

    return await repository.saveSalesEvidenceCoordinate(marker);
  }
}
