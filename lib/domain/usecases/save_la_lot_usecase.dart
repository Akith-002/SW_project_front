import 'package:dartz/dartz.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/data/models/la_lot_model.dart';
import 'package:land_asset_valuation/domain/repositories/la_lot_repository.dart';

class SaveLALotUseCase {
  final LALotRepository repository;

  SaveLALotUseCase(this.repository);

  Future<Either<Failure, LALotResponse>> call({
    required int masterFileId,
    required String coordinates,
  }) {
    final lot = LALotModel(
      masterFileId: masterFileId,
      coordinates: coordinates,
    );

    return repository.saveLot(lot);
  }
}
