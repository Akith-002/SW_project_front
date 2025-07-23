import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:land_asset_valuation/application/core/error/exceptions.dart';
import 'package:land_asset_valuation/data/datasource/remote/api/dio_client.dart';
import 'package:land_asset_valuation/application/core/configurations/app_config.dart';

abstract class RbRequestsRemoteDataSource {
  Future<List<dynamic>> getRatingBuildingRequests();
}

class RbRequestsRemoteDataSourceImpl implements RbRequestsRemoteDataSource {
  final DioClient dioClient;
  final Logger _logger = Logger();

  RbRequestsRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<dynamic>> getRatingBuildingRequests() async {
    try {
      const String endpoint = '/Requests/by-request-type/3';

      _logger.d('======= RB REQUESTS: MAKING API CALL =======');
      _logger.d('Base URL: ${AppConfig.apiBaseUrl}');
      _logger.d('Endpoint: $endpoint');
      _logger.d('===========================================');

      final response = await dioClient.get(endpoint);

      _logger.d('======= RB REQUESTS: API RESPONSE =======');
      _logger.d('Status Code: ${response.statusCode}');
      _logger.d('Response Data: ${response.data}');
      _logger.d('===========================================');

      if (response.statusCode == 200) {
        if (response.data is List) {
          return response.data;
        } else {
          _logger.e('Unexpected response format: ${response.data.runtimeType}');
          throw ServerException();
        }
      } else {
        _logger.e('Failed to load RB requests. Status code: ${response.statusCode}');
        throw ServerException();
      }
    } on DioException catch (e) {
      _logger.e('======= RB REQUESTS: DIO ERROR =======');
      _logger.e('Error Type: ${e.type}');
      _logger.e('Error Message: ${e.message}');
      _logger.e('Response Status Code: ${e.response?.statusCode}');
      _logger.e('Response Data: ${e.response?.data}');
      _logger.e('===========================================');
      throw DioErrorException();
    } catch (e) {
      _logger.e('======= RB REQUESTS: UNEXPECTED ERROR =======');
      _logger.e('Error: $e');
      _logger.e('===========================================');
      throw ServerException();
    }
  }
}