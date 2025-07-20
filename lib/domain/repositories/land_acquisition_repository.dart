import '../../data/models/land_acquisition_master_file_model.dart';
import '../../data/models/paginated_response.dart';

abstract class LandAcquisitionRepository {
  Future<PaginatedResponse<LandAcquisitionMasterFile>> getPaginatedMasterFiles({
    required int page,
    required int pageSize,
    String? sortBy,
  });
  Future<PaginatedResponse<LandAcquisitionMasterFile>> searchMasterFiles({
    required String query,
    required int page,
    required int pageSize,
    String? sortBy,
  });
}
