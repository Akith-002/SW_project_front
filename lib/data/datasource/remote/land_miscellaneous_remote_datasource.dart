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
    String? sortBy,
  }) async {
    final Map<String, dynamic> queryParams = {
      'pageNumber': page,
      'pageSize': pageSize,
    };

    if (sortBy != null) {
      queryParams['sortBy'] = sortBy;
    }

    final response = await dioClient.get('/LandMiscellaneous/paginated',
        queryParameters: queryParams);

    return PaginatedResponse.fromJson(
      response.data,
      (json) => LandMiscellaneousMasterFile.fromJson(json),
    );
  }

  Future<PaginatedResponse<LandMiscellaneousMasterFile>> searchMasterFiles({
    required String query,
    required int page,
    required int pageSize,
    String? sortBy,
  }) async {
    final Map<String, dynamic> queryParams = {
      'searchTerm': query,
      'pageNumber': page,
      'pageSize': pageSize,
    };

    if (sortBy != null) {
      queryParams['sortBy'] = sortBy;
    }

    final response = await dioClient.get('/LandMiscellaneous/search',
        queryParameters: queryParams);

    return PaginatedResponse.fromJson(
      response.data,
      (json) => LandMiscellaneousMasterFile.fromJson(json),
    );
  }
}
