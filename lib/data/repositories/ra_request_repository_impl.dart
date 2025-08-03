import 'package:dartz/dartz.dart';
import 'package:land_asset_valuation/application/core/error/exceptions.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/data/datasource/remote/ra_requests_remote_data_source.dart';
import 'package:land_asset_valuation/data/models/ra_request_model.dart';
import 'package:land_asset_valuation/domain/repositories/ra_request_repository.dart';

class RaRequestRepositoryImpl implements RaRequestRepository {
  final RaRequestsRemoteDataSource remoteDataSource;

  RaRequestRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, RaRequestResponse>> getRatingAssessmentRequests() async {
    try {
      final response = await remoteDataSource.getRatingAssessmentRequests();
      return Right(RaRequestResponse.fromJson(response));
    } on ServerException {
      return const Left(ServerFailure('Failed to load rating assessment requests'));
    } on DioErrorException {
      return const Left(NetworkFailure('Network error occurred'));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }
}