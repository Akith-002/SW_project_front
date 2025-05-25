import 'package:dio/dio.dart';
import 'package:land_asset_valuation/data/datasource/remote/api/dio_client.dart';
import 'package:land_asset_valuation/data/models/land_acquisition_master_file_model.dart';

class LandAcquisitionRemoteDatasource {
  final DioClient dioClient;

  LandAcquisitionRemoteDatasource(this.dioClient);

  Future<List<LandAcquisitionMasterFile>> getAllMasterFiles() async {
    final response = await dioClient.get('/LAMasterfile');
    final List<dynamic> data = response.data['masterFiles'];
    return data.map((e) => LandAcquisitionMasterFile.fromJson(e)).toList();
  }

  Future<List<LandAcquisitionMasterFile>> searchMasterFiles(String query) async {
    final response = await dioClient.post('/api/LAMasterfile/search', data: {
      'query': query,
    });
    final List<dynamic> data = response.data['masterFiles'];
    return data.map((e) => LandAcquisitionMasterFile.fromJson(e)).toList();
  }
}
