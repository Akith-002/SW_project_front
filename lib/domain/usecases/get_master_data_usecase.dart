import 'package:land_asset_valuation/data/models/master_data_model.dart';
import 'package:land_asset_valuation/domain/repositories/master_data_repository.dart';

class GetMasterDataUseCase {
  final MasterDataRepository repository;

  GetMasterDataUseCase(this.repository);

  Future<MasterDataResponse> call() {
    return repository.fetchMasterData();
  }
}
