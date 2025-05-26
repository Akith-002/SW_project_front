import 'package:dartz/dartz.dart';

import '../../application/core/error/failures.dart';
import '../../data/models/paginated_response.dart';
import '../../data/models/land_miscellaneous_master_file_model.dart';
import '../repositories/land_miscellaneous_repository.dart';

class GetPaginatedLMMasterFilesUseCase {
  final LandMiscellaneousRepository repository;

  GetPaginatedLMMasterFilesUseCase(this.repository);

  Future<Either<Failure, PaginatedResponse<LandMiscellaneousMasterFile>>> call({
    required int page,
    required int limit,
  }) async {
    return await repository.getPaginatedMasterFiles(
      page: page,
      limit: limit,
    );
  }
}
