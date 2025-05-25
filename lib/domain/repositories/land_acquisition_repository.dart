import '../../data/models/land_acquisition_master_file_model.dart';

abstract class LandAcquisitionRepository {
  Future<List<LandAcquisitionMasterFile>> getAllMasterFiles();
  Future<List<LandAcquisitionMasterFile>> searchMasterFiles(String query);
}
