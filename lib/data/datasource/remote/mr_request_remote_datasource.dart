import 'package:land_asset_valuation/data/datasource/remote/api/dio_client.dart';
import 'package:land_asset_valuation/data/models/mr_request_model.dart';
abstract class MRRequestRemoteDataSource {
  Future<List<MrRequest>> getRequestsByType(int requestTypeId);
  Future<MrRequest> getRequestById(int requestId);
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

  @override
  Future<MrRequest> getRequestById(int requestId) async {
    try {
      // First, we need to get all requests and filter by ID
      // since there's no direct endpoint for getting a single request
      final response = await dioClient.get('/Requests');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final requests = data.map((json) => MrRequest.fromJson(json)).toList();
        final request = requests.firstWhere(
          (r) => r.id == requestId,
          orElse: () => throw Exception('Request with ID $requestId not found'),
        );
        return request;
      } else {
        throw Exception('Failed to load request');
      }
    } catch (e) {
      throw Exception('Error fetching request: $e');
    }
  }
}