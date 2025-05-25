
import 'package:land_asset_valuation/domain/repositories/land_acquisition_repository.dart';

import '../../../data/models/land_acquisition_master_file_model.dart';

class GetAllMasterFilesUseCase {
  final LandAcquisitionRepository repository;

  GetAllMasterFilesUseCase(this.repository);

  Future<List<LandAcquisitionMasterFile>> call() {
    return repository.getAllMasterFiles();
  }
}
