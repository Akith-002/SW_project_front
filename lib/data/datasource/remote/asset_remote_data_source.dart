import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:land_asset_valuation/application/core/error/exceptions.dart';
import 'package:land_asset_valuation/data/datasource/remote/api/dio_client.dart';
import 'package:land_asset_valuation/data/models/asset_response.dart';
import 'package:land_asset_valuation/application/core/configurations/app_config.dart';

abstract class AssetRemoteDataSource {
  Future<AssetResponse> getAssets({
    required int requestId,
    required String requestType, // 'MR', 'RA', 'RB', 'RO'
    int? page,
    int? pageSize,
  });

  Future<AssetResponse> searchAssets({
    required int requestId,
    required String requestType,
    required String query,
    int? page,
    int? pageSize,
  });
}

class AssetRemoteDataSourceImpl implements AssetRemoteDataSource {
  final DioClient dioClient;
  final Logger _logger = Logger();

  AssetRemoteDataSourceImpl({required this.dioClient});
  @override
  Future<AssetResponse> getAssets({
    required int requestId,
    required String requestType,
    int? page,
    int? pageSize,
  }) async {
    try {
      final String endpoint = '/Assets/by-request/$requestId';

      // Build query parameters
      Map<String, dynamic> queryParams = {
        'requestType': requestType,
      };

      if (page != null) queryParams['page'] = page;
      if (pageSize != null) queryParams['pageSize'] = pageSize;

      // Debug: Log API call details
      _logger.d('======= ASSETS: MAKING API CALL =======');
      _logger.d('Base URL: ${AppConfig.apiBaseUrl}');
      _logger.d('Endpoint: $endpoint');
      _logger.d('Query Parameters: $queryParams');
      _logger.d('===========================================');

      final response = await dioClient.get(
        endpoint,
        queryParameters: queryParams,
      ); // Debug: Log API response details
      _logger.d('======= ASSETS: API RESPONSE =======');
      _logger.d('Status Code: ${response.statusCode}');
      _logger.d('Response Data: ${response.data}');
      _logger.d('===========================================');

      if (response.statusCode == 200) {
        // Check if response.data is a List (direct asset array) or Map (wrapped response)
        if (response.data is List) {
          return AssetResponse.fromList(response.data);
        } else if (response.data is Map<String, dynamic>) {
          return AssetResponse.fromJson(response.data);
        } else {
          _logger.e('Unexpected response format: ${response.data.runtimeType}');
          throw ServerException();
        }
      } else {
        _logger.e('Failed to load assets. Status code: ${response.statusCode}');
        throw ServerException();
      }
    } on DioException catch (e) {
      _logger.e('======= ASSETS: DIO ERROR =======');
      _logger.e('Error Type: ${e.type}');
      _logger.e('Error Message: ${e.message}');
      _logger.e('Response Status Code: ${e.response?.statusCode}');
      _logger.e('Response Data: ${e.response?.data}');
      _logger.e('===========================================');
      throw DioErrorException();
    } catch (e) {
      _logger.e('======= ASSETS: UNEXPECTED ERROR =======');
      _logger.e('Error: $e');
      _logger.e('===========================================');
      throw ServerException();
    }
  }

  @override
  Future<AssetResponse> searchAssets({
    required int requestId,
    required String requestType,
    required String query,
    int? page,
    int? pageSize,
  }) async {
    try {
      final String endpoint = '/Assets/by-request/$requestId/search';

      // Build query parameters
      Map<String, dynamic> queryParams = {
        'requestType': requestType,
        'query': query,
      };

      if (page != null) queryParams['page'] = page;
      if (pageSize != null) queryParams['pageSize'] = pageSize;

      // Debug: Log API call details
      _logger.d('======= ASSETS SEARCH: MAKING API CALL =======');
      _logger.d('Base URL: ${AppConfig.apiBaseUrl}');
      _logger.d('Endpoint: $endpoint');
      _logger.d('Query Parameters: $queryParams');
      _logger.d('===========================================');

      final response = await dioClient.get(
        endpoint,
        queryParameters: queryParams,
      );

      // Debug: Log API response details
      _logger.d('======= ASSETS SEARCH: API RESPONSE =======');
      _logger.d('Status Code: ${response.statusCode}');
      _logger.d('Response Data: ${response.data}');
      _logger.d('===========================================');

      if (response.statusCode == 200) {
        return AssetResponse.fromJson(response.data);
      } else {
        _logger
            .e('Failed to search assets. Status code: ${response.statusCode}');
        throw ServerException();
      }
    } on DioException catch (e) {
      _logger.e('======= ASSETS SEARCH: DIO ERROR =======');
      _logger.e('Error Type: ${e.type}');
      _logger.e('Error Message: ${e.message}');
      _logger.e('Response Status Code: ${e.response?.statusCode}');
      _logger.e('Response Data: ${e.response?.data}');
      _logger.e('===========================================');
      throw DioErrorException();
    } catch (e) {
      _logger.e('======= ASSETS SEARCH: UNEXPECTED ERROR =======');
      _logger.e('Error: $e');
      _logger.e('===========================================');
      throw ServerException();
    }
  }
}
