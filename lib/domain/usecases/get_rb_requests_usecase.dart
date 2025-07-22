import 'package:dartz/dartz.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/data/models/ra_request_model.dart';
import 'package:land_asset_valuation/domain/repositories/rb_request_repository.dart';

class GetRbRequestsUseCase {
  final RbRequestRepository repository;

  GetRbRequestsUseCase({required this.repository});

  Future<Either<Failure, RaRequestResponse>> call() async {
    return await repository.getRatingBuildingRequests();
  }
}