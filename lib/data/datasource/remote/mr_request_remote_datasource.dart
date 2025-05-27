import 'package:land_asset_valuation/data/datasource/remote/api/dio_client.dart';
import 'package:land_asset_valuation/data/models/mr_request_model.dart';
abstract class MRRequestRemoteDataSource {
  Future<List<MrRequest>> getRequestsByType(int requestTypeId);
}

class MRRequestRemoteDataSourceImpl implements MRRequestRemoteDataSource {
  final DioClient dioClient;

  MRRequestRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<MrRequest>> getRequestsByType(int requestTypeId) async {
    try {
      final response = await dioClient.get('/Requests/by-request-type/$requestTypeId');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => MrRequest.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load requests');
      }
    } catch (e) {
      throw Exception('Error fetching requests: $e');
    }
  }
}