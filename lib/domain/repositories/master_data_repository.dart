import 'package:land_asset_valuation/data/models/master_data_model.dart';

abstract class MasterDataRepository {
  Future<MasterDataResponse> fetchMasterData();
}
