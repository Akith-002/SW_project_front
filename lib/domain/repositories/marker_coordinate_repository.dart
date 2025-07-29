import 'package:dartz/dartz.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/data/models/marker_coordinate_model.dart';

abstract class MarkerCoordinateRepository {
  Future<Either<Failure, MarkerCoordinateResponse>> saveBuildingRatesCoordinate(
      MarkerCoordinateModel marker);
  Future<Either<Failure, MarkerCoordinateResponse>>
      savePastValuationsCoordinate(MarkerCoordinateModel marker);
  Future<Either<Failure, MarkerCoordinateResponse>>
      saveRentalEvidenceCoordinate(MarkerCoordinateModel marker);
  Future<Either<Failure, MarkerCoordinateResponse>> saveSalesEvidenceCoordinate(
      MarkerCoordinateModel marker);

  // GET methods for existing markers
  Future<Either<Failure, List<ExistingMarkerModel>>>
      getBuildingRatesCoordinates(int masterfileId);
  Future<Either<Failure, List<ExistingMarkerModel>>>
      getPastValuationsCoordinates(int masterfileId);
  Future<Either<Failure, List<ExistingMarkerModel>>>
      getRentalEvidenceCoordinates(int masterfileId);
  Future<Either<Failure, List<ExistingMarkerModel>>>
      getSalesEvidenceCoordinates(int masterfileId);
}
