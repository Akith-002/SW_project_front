import 'package:land_asset_valuation/data/datasource/remote/asset_change_remote_data_source.dart';
import 'package:land_asset_valuation/data/models/asset_change_request.dart';
import 'package:land_asset_valuation/data/models/asset_change_response.dart';
import 'package:land_asset_valuation/domain/repositories/asset_change_repository.dart';

class AssetChangeRepositoryImpl implements AssetChangeRepository {
  final AssetChangeRemoteDataSource remoteDataSource;

  AssetChangeRepositoryImpl({required this.remoteDataSource});
  @override
  Future<AssetChangeResponse> changeAssetNumber(
      AssetChangeRequest request) async {
    return await remoteDataSource.submitAssetChange(request);
  }
}
