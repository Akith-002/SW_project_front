import 'package:land_asset_valuation/data/models/asset_change_request.dart';
import 'package:land_asset_valuation/data/models/asset_change_response.dart';

abstract class AssetChangeRepository {
  Future<AssetChangeResponse> changeAssetNumber(AssetChangeRequest request);
}
