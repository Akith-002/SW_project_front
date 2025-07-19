import 'package:dartz/dartz.dart';

import '../../application/core/error/failures.dart';
import '../../data/models/land_miscellaneous_master_file_model.dart';
import '../../data/models/paginated_response.dart';

abstract class LandMiscellaneousRepository {
  Future<Either<Failure, PaginatedResponse<LandMiscellaneousMasterFile>>>
      getPaginatedMasterFiles({
    required int page,
    required int limit,
    String? sortBy,
  });
  Future<Either<Failure, PaginatedResponse<LandMiscellaneousMasterFile>>>
      getAllMasterFiles();
  Future<Either<Failure, PaginatedResponse<LandMiscellaneousMasterFile>>>
      searchMasterFiles({
    required String query,
    required int page,
    required int pageSize,
    String? sortBy,
  });
}
