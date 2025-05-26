import 'package:dartz/dartz.dart';

import '../../application/core/error/failures.dart';
import 'package:land_asset_valuation/domain/repositories/land_miscellaneous_repository.dart';
import '../../../data/models/land_miscellaneous_master_file_model.dart';

class SearchLmMasterFilesUseCase {
  final LandMiscellaneousRepository repository;

  SearchLmMasterFilesUseCase(this.repository);

  Future<Either<Failure, List<LandMiscellaneousMasterFile>>> call(
      String query) async {
    return await repository.searchMasterFiles(query);
  }
}
