import 'package:land_asset_valuation/data/datasource/remote/api/dio_client.dart';
import 'package:land_asset_valuation/data/models/land_miscellaneous_master_file_model.dart';
import 'package:land_asset_valuation/data/models/paginated_response.dart';

class LandMiscellaneousRemoteDatasource {
  final DioClient dioClient;

  LandMiscellaneousRemoteDatasource(this.dioClient);
  Future<List<LandMiscellaneousMasterFile>> getAllMasterFiles() async {
    final response = await dioClient.get('/LandMiscellaneous');
    final List<dynamic> data = response.data['masterFiles'];
    return data.map((e) => LandMiscellaneousMasterFile.fromJson(e)).toList();
  }

  Future<PaginatedResponse<LandMiscellaneousMasterFile>>
      getPaginatedMasterFiles({
    required int page,
    required int pageSize,
  }) async {
    final response =
        await dioClient.get('/LandMiscellaneous/paginated', queryParameters: {
      'pageNumber': page,
      'pageSize': pageSize,
    });

    return PaginatedResponse.fromJson(
      response.data,
      (json) => LandMiscellaneousMasterFile.fromJson(json),
    );
  }

  Future<List<LandMiscellaneousMasterFile>> searchMasterFiles(
      String query) async {
    final response = await dioClient.post('/LandMiscellaneous/search', data: {
      'query': query,
    });
    final List<dynamic> data = response.data['masterFiles'];
    return data.map((e) => LandMiscellaneousMasterFile.fromJson(e)).toList();
  }
}
