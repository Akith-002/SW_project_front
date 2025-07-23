import 'package:dartz/dartz.dart';
import 'package:land_asset_valuation/application/core/error/exceptions.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/data/datasource/remote/rb_requests_remote_data_source.dart';
import 'package:land_asset_valuation/data/models/ra_request_model.dart';
import 'package:land_asset_valuation/domain/repositories/rb_request_repository.dart';

class RbRequestRepositoryImpl implements RbRequestRepository {
  final RbRequestsRemoteDataSource remoteDataSource;

  RbRequestRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, RaRequestResponse>> getRatingBuildingRequests() async {
    try {
      final response = await remoteDataSource.getRatingBuildingRequests();
      return Right(RaRequestResponse.fromJson(response));
    } on ServerException {
      return const Left(ServerFailure('Failed to load rating building requests'));
    } on DioErrorException {
      return const Left(NetworkFailure('Network error occurred'));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }
}