import 'package:dartz/dartz.dart';

import '../../application/core/error/failures.dart';
import '../../domain/repositories/land_miscellaneous_repository.dart';
import '../models/land_miscellaneous_master_file_model.dart';
import '../models/paginated_response.dart';
import '../datasource/remote/land_miscellaneous_remote_datasource.dart';

class LandMiscellaneousRepositoryImpl implements LandMiscellaneousRepository {
  final LandMiscellaneousRemoteDatasource remoteDatasource;

  LandMiscellaneousRepositoryImpl(this.remoteDatasource);
  @override
  Future<Either<Failure, PaginatedResponse<LandMiscellaneousMasterFile>>>
      getAllMasterFiles() async {
    try {
      final result = await remoteDatasource.getAllMasterFiles();
      // Convert List to PaginatedResponse for consistency
      final paginatedResponse = PaginatedResponse<LandMiscellaneousMasterFile>(
        items: result,
        totalCount: result.length,
        currentPage: 1,
        pageSize: result.length,
        totalPages: 1,
        hasNext: false,
        hasPrevious: false,
      );
      return Right(paginatedResponse);
    } catch (e) {
      return Left(
          ServerFailure('Failed to fetch all master files: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, PaginatedResponse<LandMiscellaneousMasterFile>>>
      getPaginatedMasterFiles({
    required int page,
    required int limit,
  }) async {
    try {
      final result = await remoteDatasource.getPaginatedMasterFiles(
          page: page, pageSize: limit);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(
          'Failed to fetch paginated master files: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, PaginatedResponse<LandMiscellaneousMasterFile>>>
      searchMasterFiles({
    required String query,
    required int page,
    required int pageSize,
  }) async {
    try {
      final result = await remoteDatasource.searchMasterFiles(
        query: query,
        page: page,
        pageSize: pageSize,
      );
      return Right(result);
    } catch (e) {
      return Left(
          ServerFailure('Failed to search master files: ${e.toString()}'));
    }
  }
}
