import 'package:land_asset_valuation/data/models/land_acquisition_master_file_model.dart';
import 'package:land_asset_valuation/data/models/paginated_response.dart';
import 'package:land_asset_valuation/domain/repositories/land_acquisition_repository.dart';

class GetPaginatedMasterFilesUseCase {
  final LandAcquisitionRepository repository;

  GetPaginatedMasterFilesUseCase(this.repository);

  Future<PaginatedResponse<LandAcquisitionMasterFile>> call({
    required int page,
    required int pageSize,
  }) {
    return repository.getPaginatedMasterFiles(
      page: page,
      pageSize: pageSize,
    );
  }
}
