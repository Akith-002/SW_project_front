import 'package:dartz/dartz.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/data/models/ra_request_model.dart';

abstract class RoRequestRepository {
  Future<Either<Failure, RaRequestResponse>> getRatingObjectRequests();
}