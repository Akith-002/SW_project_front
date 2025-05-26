import 'package:dartz/dartz.dart';

import '../../application/core/error/failures.dart';
import 'package:land_asset_valuation/domain/repositories/land_miscellaneous_repository.dart';
import '../../../data/models/land_miscellaneous_master_file_model.dart';

class GetAllLmMasterFilesUseCase {
  final LandMiscellaneousRepository repository;

  GetAllLmMasterFilesUseCase(this.repository);

  Future<Either<Failure, List<LandMiscellaneousMasterFile>>> call() async {
    return await repository.getAllMasterFiles();
  }
}
