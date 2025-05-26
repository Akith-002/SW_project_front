import 'package:land_asset_valuation/data/datasources/remote/asset_division_remote_data_source.dart';
import 'package:land_asset_valuation/data/models/asset_division.dart';
import 'package:land_asset_valuation/domain/repositories/asset_division_repository.dart';

class AssetDivisionRepositoryImpl implements AssetDivisionRepository {
  final AssetDivisionRemoteDataSource remoteDataSource;

  AssetDivisionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AssetDivisionResponse> divideAsset(
      AssetDivisionRequest request) async {
    return await remoteDataSource.divideAsset(request);
  }

  @override
  Future<AssetDivisionValidation> validateDivision(
      AssetDivisionRequest request) async {
    return await remoteDataSource.validateDivision(request);
  }
}
