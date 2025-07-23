import 'package:dartz/dartz.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/data/models/marker_coordinate_model.dart';
import 'package:land_asset_valuation/domain/repositories/marker_coordinate_repository.dart';

class GetBuildingRatesCoordinatesUseCase {
  final MarkerCoordinateRepository repository;

  GetBuildingRatesCoordinatesUseCase(this.repository);

  Future<Either<Failure, List<ExistingMarkerModel>>> call({
    required int masterfileId,
  }) async {
    return await repository.getBuildingRatesCoordinates(masterfileId);
  }
}
