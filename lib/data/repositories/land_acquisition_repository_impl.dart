import '../../domain/repositories/land_acquisition_repository.dart';
import '../models/land_acquisition_master_file_model.dart';
import '../models/paginated_response.dart';
import '../datasource/remote/land_acquisition_remote_datasource.dart';

class LandAcquisitionRepositoryImpl implements LandAcquisitionRepository {
  final LandAcquisitionRemoteDatasource remoteDatasource;

  LandAcquisitionRepositoryImpl(this.remoteDatasource);

  @override
  Future<PaginatedResponse<LandAcquisitionMasterFile>> getPaginatedMasterFiles({
    required int page,
    required int pageSize,
    String? sortBy,
  }) {
    return remoteDatasource.getPaginatedMasterFiles(
      page: page,
      pageSize: pageSize,
      sortBy: sortBy,
    );
  }

  @override
  Future<PaginatedResponse<LandAcquisitionMasterFile>> searchMasterFiles({
    required String query,
    required int page,
    required int pageSize,
    String? sortBy,
  }) {
    return remoteDatasource.searchMasterFiles(
      query: query,
      page: page,
      pageSize: pageSize,
      sortBy: sortBy,
    );
  }
}
