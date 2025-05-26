
import 'package:land_asset_valuation/domain/repositories/land_acquisition_repository.dart';

import '../../../data/models/land_acquisition_master_file_model.dart';

class SearchMasterFilesUseCase {
  final LandAcquisitionRepository repository;

  SearchMasterFilesUseCase(this.repository);

  Future<List<LandAcquisitionMasterFile>> call(String query) {
    return repository.searchMasterFiles(query);
  }
}
