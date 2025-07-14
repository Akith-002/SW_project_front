import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:land_asset_valuation/application/core/error/exceptions.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/data/datasource/remote/asset_remote_data_source.dart';
import 'package:land_asset_valuation/data/models/asset.dart';
import 'package:land_asset_valuation/data/models/paginated_response.dart';
import 'package:land_asset_valuation/domain/repositories/asset_repository.dart';

class AssetRepositoryImpl implements AssetRepository {
  final AssetRemoteDataSource remoteDataSource;
  final Logger _logger = Logger();

  AssetRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Asset>>> getAssets({
    required int requestId,
    required String requestType,
  }) async {
    try {
      // Debug: Log in repository before sending to remote data source
      _logger.d('======= ASSET REPOSITORY: FETCHING ASSETS =======');
      _logger.d('Request ID: $requestId');
      _logger.d('Request Type: $requestType');
      _logger.d('===========================================');

      final response = await remoteDataSource.getAssets(
        requestId: requestId,
        requestType: requestType,
      );

      // Debug: Log result from remote data source
      _logger.d('======= ASSET REPOSITORY: RECEIVED RESULT =======');
      _logger.d('Success: ${response.isSuccess}');
      _logger.d('Assets count: ${response.data?.length ?? 0}');
      _logger.d('===========================================');

      if (response.isSuccess == true && response.data != null) {
        return Right(response.data!);
      } else {
        _logger.e('API returned unsuccessful response: ${response.message}');
        return Left(
            ServerFailure(response.message ?? 'Failed to fetch assets'));
      }
    } on ServerException {
      _logger.e('======= ASSET REPOSITORY: SERVER EXCEPTION =======');
      return const Left(ServerFailure('Server error occurred'));
    } on DioErrorException {
      _logger.e('======= ASSET REPOSITORY: DIO ERROR EXCEPTION =======');
      return const Left(NetworkFailure('Network error occurred'));
    } catch (e) {
      _logger.e('======= ASSET REPOSITORY: UNEXPECTED ERROR =======');
      _logger.e('Error: $e');
      _logger.e('===========================================');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaginatedResponse<Asset>>> getAssetsPaginated({
    required int requestId,
    required String requestType,
    required int pageSize,
    String? pageToken,
  }) async {
    try {
      _logger.d('======= ASSET REPOSITORY: FETCHING PAGINATED ASSETS =======');
      _logger.d('Request ID: $requestId');
      _logger.d('Request Type: $requestType');
      _logger.d('Page Size: $pageSize');
      _logger.d('Page Token: $pageToken');
      _logger.d('===========================================');

      final response = await remoteDataSource.getAssets(
        requestId: requestId,
        requestType: requestType,
        page: pageToken != null ? int.tryParse(pageToken) : 1,
        pageSize: pageSize,
      );
      if (response.isSuccess == true && response.data != null) {
        // Simple pagination implementation
        // In a real scenario, the API would provide pagination metadata
        final assets = response.data!;
        final currentPageNum =
            pageToken != null ? int.tryParse(pageToken) ?? 1 : 1;
        final totalCount =
            assets.length; // This would come from API in real scenario
        final hasNext = assets.length >= pageSize;

        final paginatedResponse = PaginatedResponse(
          items: assets,
          totalCount: totalCount,
          currentPage: currentPageNum,
          pageSize: pageSize,
          totalPages: (totalCount / pageSize).ceil(),
          hasPrevious: currentPageNum > 1,
          hasNext: hasNext,
        );

        return Right(paginatedResponse);
      } else {
        return Left(
            ServerFailure(response.message ?? 'Failed to fetch assets'));
      }
    } on ServerException {
      return const Left(ServerFailure('Server error occurred'));
    } on DioErrorException {
      return const Left(NetworkFailure('Network error occurred'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Asset>>> searchAssets({
    required int requestId,
    required String requestType,
    required String query,
  }) async {
    try {
      _logger.d('======= ASSET REPOSITORY: SEARCHING ASSETS =======');
      _logger.d('Request ID: $requestId');
      _logger.d('Request Type: $requestType');
      _logger.d('Query: $query');
      _logger.d('===========================================');

      final response = await remoteDataSource.searchAssets(
        requestId: requestId,
        requestType: requestType,
        query: query,
      );

      if (response.isSuccess == true && response.data != null) {
        return Right(response.data!);
      } else {
        return Left(
            ServerFailure(response.message ?? 'Failed to search assets'));
      }
    } on ServerException {
      return const Left(ServerFailure('Server error occurred'));
    } on DioErrorException {
      return const Left(NetworkFailure('Network error occurred'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
