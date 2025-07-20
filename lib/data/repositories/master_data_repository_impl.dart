import 'package:land_asset_valuation/data/datasource/remote/master_data_remote_data_source.dart';
import 'package:land_asset_valuation/data/models/master_data_model.dart';
import 'package:land_asset_valuation/domain/repositories/master_data_repository.dart';

class MasterDataRepositoryImpl implements MasterDataRepository {
  final MasterDataRemoteDataSource remoteDataSource;

  MasterDataRepositoryImpl({required this.remoteDataSource});

  @override
  Future<MasterDataResponse> fetchMasterData() {
    return remoteDataSource.fetchMasterData();
  }
}
