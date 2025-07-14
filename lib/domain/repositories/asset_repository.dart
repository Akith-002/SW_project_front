import 'package:dartz/dartz.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/data/models/asset.dart';
import 'package:land_asset_valuation/data/models/paginated_response.dart';

abstract class AssetRepository {
  Future<Either<Failure, List<Asset>>> getAssets({
    required int requestId,
    required String requestType,
  });

  Future<Either<Failure, PaginatedResponse<Asset>>> getAssetsPaginated({
    required int requestId,
    required String requestType,
    required int pageSize,
    String? pageToken,
  });

  Future<Either<Failure, List<Asset>>> searchAssets({
    required int requestId,
    required String requestType,
    required String query,
  });
}
