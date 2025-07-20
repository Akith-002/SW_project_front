import 'package:land_asset_valuation/domain/repositories/land_acquisition_repository.dart';

import '../../../data/models/land_acquisition_master_file_model.dart';
import '../../../data/models/paginated_response.dart';

class SearchMasterFilesUseCase {
  final LandAcquisitionRepository repository;

  SearchMasterFilesUseCase(this.repository);

  Future<PaginatedResponse<LandAcquisitionMasterFile>> call({
    required String query,
    required int page,
    required int pageSize,
    String? sortBy,
  }) {
    return repository.searchMasterFiles(
      query: query,
      page: page,
      pageSize: pageSize,
      sortBy: sortBy,
    );
  }
}
