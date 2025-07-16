import 'package:land_asset_valuation/data/models/asset_change_request.dart';
import 'package:land_asset_valuation/data/models/asset_change_response.dart';
import 'package:land_asset_valuation/domain/repositories/asset_change_repository.dart';

class ChangeAssetNumberUseCase {
  final AssetChangeRepository repository;

  ChangeAssetNumberUseCase(this.repository);

  Future<AssetChangeResponse> call(AssetChangeRequest request) async {
    return await repository.changeAssetNumber(request);
  }
}
