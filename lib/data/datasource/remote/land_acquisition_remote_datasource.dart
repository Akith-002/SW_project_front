import 'package:dio/dio.dart';
import 'package:land_asset_valuation/data/datasource/remote/api/dio_client.dart';
import 'package:land_asset_valuation/data/models/land_acquisition_master_file_model.dart';
import 'package:land_asset_valuation/data/models/paginated_response.dart';

class LandAcquisitionRemoteDatasource {
  final DioClient dioClient;

  LandAcquisitionRemoteDatasource(this.dioClient);

  Future<PaginatedResponse<LandAcquisitionMasterFile>> getPaginatedMasterFiles({
    required int page,
    required int pageSize,
  }) async {
    final response = await dioClient.get(
      '/LAMasterfile',
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
      },
    );

    // If the API returns zeros for pagination values, use the actual data length
    final data = response.data;
    if (data['totalCount'] == 0) {
      final List<dynamic> masterFiles = data['masterFiles'];
      data['totalCount'] = masterFiles.length;
      data['currentPage'] = page;
      data['pageSize'] = pageSize;
      data['totalPages'] = (masterFiles.length / pageSize).ceil();
      data['hasPrevious'] = page > 1;
      data['hasNext'] = page * pageSize < masterFiles.length;
    }

    return PaginatedResponse.fromJson(
      data,
      (json) => LandAcquisitionMasterFile.fromJson(json),
    );
  }

  Future<List<LandAcquisitionMasterFile>> searchMasterFiles(
      String query) async {
    try {
      final response = await dioClient.post('/LAMasterfile/search', data: {
        'query': query,
      });
      final List<dynamic> data = response.data['masterFiles'];
      return data.map((e) => LandAcquisitionMasterFile.fromJson(e)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // If search endpoint fails, fall back to getting all records and filtering client-side
        final allRecords =
            await getPaginatedMasterFiles(page: 1, pageSize: 100);
        return allRecords.items.where((file) {
          final searchTerm = query.toLowerCase();
          return file.masterFileNo
                  .toString()
                  .toLowerCase()
                  .contains(searchTerm) ||
              file.planType.toLowerCase().contains(searchTerm) ||
              file.planNo.toLowerCase().contains(searchTerm) ||
              file.requestingAuthorityReferenceNo
                  .toLowerCase()
                  .contains(searchTerm) ||
              file.status.toLowerCase().contains(searchTerm);
        }).toList();
      }
      rethrow;
    }
  }
}
