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
  Future<Either<Failure, List<LandMiscellaneousMasterFile>>>
      getAllMasterFiles() async {
    try {
      final result = await remoteDatasource.getAllMasterFiles();
      return Right(result);
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
  Future<Either<Failure, List<LandMiscellaneousMasterFile>>> searchMasterFiles(
      String query) async {
    try {
      final result = await remoteDatasource.searchMasterFiles(query);
      return Right(result);
    } catch (e) {
      return Left(
          ServerFailure('Failed to search master files: ${e.toString()}'));
    }
  }
}
