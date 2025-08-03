import 'package:dartz/dartz.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/data/models/la_lot_model.dart';
import 'package:land_asset_valuation/domain/repositories/la_lot_repository.dart';

class GetLALotsUseCase {
  final LALotRepository repository;

  GetLALotsUseCase(this.repository);

  Future<Either<Failure, List<LALotModel>>> call({
    required int masterFileId,
  }) async {
    return await repository.getLotsByMasterFileId(masterFileId);
  }
}
