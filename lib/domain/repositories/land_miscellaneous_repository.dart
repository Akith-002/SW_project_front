import 'package:dartz/dartz.dart';

import '../../application/core/error/failures.dart';
import '../../data/models/land_miscellaneous_master_file_model.dart';
import '../../data/models/paginated_response.dart';

abstract class LandMiscellaneousRepository {
  Future<Either<Failure, PaginatedResponse<LandMiscellaneousMasterFile>>>
      getPaginatedMasterFiles({
    required int page,
    required int limit,
  });
  Future<Either<Failure, List<LandMiscellaneousMasterFile>>>
      getAllMasterFiles();
  Future<Either<Failure, List<LandMiscellaneousMasterFile>>> searchMasterFiles(
      String query);
}
