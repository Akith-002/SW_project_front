import 'package:dartz/dartz.dart';
import 'package:land_asset_valuation/application/core/error/exceptions.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/data/datasource/remote/ro_requests_remote_data_source.dart';
import 'package:land_asset_valuation/data/models/ra_request_model.dart';
import 'package:land_asset_valuation/domain/repositories/ro_request_repository.dart';

class RoRequestRepositoryImpl implements RoRequestRepository {
  final RoRequestsRemoteDataSource remoteDataSource;

  RoRequestRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, RaRequestResponse>> getRatingObjectRequests() async {
    try {
      final response = await remoteDataSource.getRatingObjectRequests();
      return Right(RaRequestResponse.fromJson(response));
    } on ServerException {
      return const Left(ServerFailure('Failed to load rating object requests'));
    } on DioErrorException {
      return const Left(NetworkFailure('Network error occurred'));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }
}