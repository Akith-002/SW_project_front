import 'package:dartz/dartz.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/data/models/asset.dart';
import 'package:land_asset_valuation/data/models/paginated_response.dart';
import 'package:land_asset_valuation/domain/repositories/asset_repository.dart';

class GetAssetsUseCase {
  final AssetRepository repository;

  GetAssetsUseCase(this.repository);

  Future<Either<Failure, List<Asset>>> call({
    required int requestId,
    required String requestType,
  }) async {
    return await repository.getAssets(
      requestId: requestId,
      requestType: requestType,
    );
  }
}

class GetAssetsPaginatedUseCase {
  final AssetRepository repository;

  GetAssetsPaginatedUseCase(this.repository);

  Future<Either<Failure, PaginatedResponse<Asset>>> call({
    required int requestId,
    required String requestType,
    required int pageSize,
    String? pageToken,
  }) async {
    return await repository.getAssetsPaginated(
      requestId: requestId,
      requestType: requestType,
      pageSize: pageSize,
      pageToken: pageToken,
    );
  }
}

class SearchAssetsUseCase {
  final AssetRepository repository;

  SearchAssetsUseCase(this.repository);

  Future<Either<Failure, List<Asset>>> call({
    required int requestId,
    required String requestType,
    required String query,
  }) async {
    return await repository.searchAssets(
      requestId: requestId,
      requestType: requestType,
      query: query,
    );
  }
}
