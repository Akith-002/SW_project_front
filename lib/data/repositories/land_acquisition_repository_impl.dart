import '../../domain/repositories/land_acquisition_repository.dart';
import '../models/land_acquisition_master_file_model.dart';
import '../datasource/remote/land_acquisition_remote_datasource.dart';

class LandAcquisitionRepositoryImpl implements LandAcquisitionRepository {
  final LandAcquisitionRemoteDatasource remoteDatasource;

  LandAcquisitionRepositoryImpl(this.remoteDatasource);

  @override
  Future<List<LandAcquisitionMasterFile>> getAllMasterFiles() {
    return remoteDatasource.getAllMasterFiles();
  }

  @override
  Future<List<LandAcquisitionMasterFile>> searchMasterFiles(String query) {
    return remoteDatasource.searchMasterFiles(query);
  }
}
