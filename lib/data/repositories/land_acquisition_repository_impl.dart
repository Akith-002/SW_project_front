import '../../domain/repositories/land_acquisition_repository.dart';
import '../models/land_acquisition_master_file_model.dart';
import '../models/paginated_response.dart';
import '../datasource/remote/land_acquisition_remote_datasource.dart';
import '../datasource/secure_storage.dart';

class LandAcquisitionRepositoryImpl implements LandAcquisitionRepository {
  final LandAcquisitionRemoteDatasource remoteDatasource;
  final SecureStorage secureStorage;

  LandAcquisitionRepositoryImpl(this.remoteDatasource, this.secureStorage);

  Future<int> _getCurrentUserId() async {
    final userIdString = await secureStorage.read('id');
    if (userIdString == null) {
      throw Exception('User not logged in');
    }
    return int.parse(userIdString);
  }

  @override
  Future<PaginatedResponse<LandAcquisitionMasterFile>> getPaginatedMasterFiles({
    required int page,
    required int pageSize,
    String? sortBy,
  }) async {
    final userId = await _getCurrentUserId();
    return remoteDatasource.getPaginatedMasterFiles(
      page: page,
      pageSize: pageSize,
      assignedToUserId: userId,
      sortBy: sortBy,
    );
  }

  @override
  Future<PaginatedResponse<LandAcquisitionMasterFile>> searchMasterFiles({
    required String query,
    required int page,
    required int pageSize,
    String? sortBy,
  }) async {
    final userId = await _getCurrentUserId();
    return remoteDatasource.searchMasterFiles(
      query: query,
      page: page,
      pageSize: pageSize,
      assignedToUserId: userId,
      sortBy: sortBy,
    );
  }
}
