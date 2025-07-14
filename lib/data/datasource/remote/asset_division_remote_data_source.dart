import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:land_asset_valuation/application/core/error/exceptions.dart';
import 'package:land_asset_valuation/data/datasource/remote/api/dio_client.dart';
import 'package:land_asset_valuation/data/models/asset_division.dart';
import 'package:land_asset_valuation/application/core/configurations/app_config.dart';

abstract class AssetDivisionRemoteDataSource {
  Future<AssetDivisionResponse> divideAsset(AssetDivisionRequest request);
  Future<AssetDivisionValidation> validateDivision(
      AssetDivisionRequest request);
}

class AssetDivisionRemoteDataSourceImpl
    implements AssetDivisionRemoteDataSource {
  final DioClient dioClient;
  final Logger _logger = Logger();

  AssetDivisionRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<AssetDivisionResponse> divideAsset(
      AssetDivisionRequest request) async {
    try {
      final String endpoint = '/Asset/divide';
      final String fullUrl =
          '${AppConfig.apiBaseUrl}${endpoint.startsWith('/') ? endpoint.substring(1) : endpoint}';

      // Debug: Log API call details
      _logger.d('======= ASSET DIVISION: MAKING API CALL =======');
      _logger.d('Base URL: ${AppConfig.apiBaseUrl}');
      _logger.d('Endpoint: $endpoint');
      _logger.d('FULL URL: $fullUrl');
      _logger.d('Division request: ${request.toJson()}');
      _logger.d('===========================================');

      final response = await dioClient.post(
        endpoint,
        data: request.toJson(),
      );

      // Debug: Log API response details
      _logger.d('======= ASSET DIVISION: API RESPONSE =======');
      _logger.d('Status Code: ${response.statusCode}');
      _logger.d('Response Data: ${response.data}');
      _logger.d('===========================================');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AssetDivisionResponse.fromJson(response.data);
      } else {
        _logger.e(
            '======= ASSET DIVISION: API ERROR - UNEXPECTED STATUS CODE =======');
        _logger.e('Status Code: ${response.statusCode}');
        _logger.e('===========================================');
        throw ServerException();
      }
    } on DioException catch (e) {
      _logger.e('======= ASSET DIVISION: DIO EXCEPTION =======');
      _logger.e('Error type: ${e.type}');
      _logger.e('Error message: ${e.message}');
      _logger.e('Request URL: ${e.requestOptions.uri}');
      _logger.e('Request Method: ${e.requestOptions.method}');
      _logger.e('Request Headers: ${e.requestOptions.headers}');
      _logger.e('Response: ${e.response?.statusCode}');
      _logger.e('Response data: ${e.response?.data}');
      _logger.e('===========================================');
      throw DioErrorException();
    } catch (e) {
      _logger.e('======= ASSET DIVISION: UNEXPECTED EXCEPTION =======');
      _logger.e('Error: $e');
      _logger.e('===========================================');
      throw ServerException();
    }
  }

  @override
  Future<AssetDivisionValidation> validateDivision(
      AssetDivisionRequest request) async {
    try {
      final String endpoint = '/Asset/validate-division';
      final String fullUrl =
          '${AppConfig.apiBaseUrl}${endpoint.startsWith('/') ? endpoint.substring(1) : endpoint}';

      // Debug: Log API call details
      _logger.d('======= ASSET DIVISION VALIDATION: MAKING API CALL =======');
      _logger.d('Base URL: ${AppConfig.apiBaseUrl}');
      _logger.d('Endpoint: $endpoint');
      _logger.d('FULL URL: $fullUrl');
      _logger.d('Validation request: ${request.toJson()}');
      _logger.d('===========================================');

      final response = await dioClient.post(
        endpoint,
        data: request.toJson(),
      );

      // Debug: Log API response details
      _logger.d('======= ASSET DIVISION VALIDATION: API RESPONSE =======');
      _logger.d('Status Code: ${response.statusCode}');
      _logger.d('Response Data: ${response.data}');
      _logger.d('===========================================');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AssetDivisionValidation.fromJson(response.data);
      } else {
        _logger.e(
            '======= ASSET DIVISION VALIDATION: API ERROR - UNEXPECTED STATUS CODE =======');
        _logger.e('Status Code: ${response.statusCode}');
        _logger.e('===========================================');
        throw ServerException();
      }
    } on DioException catch (e) {
      _logger.e('======= ASSET DIVISION VALIDATION: DIO EXCEPTION =======');
      _logger.e('Error type: ${e.type}');
      _logger.e('Error message: ${e.message}');
      _logger.e('Request URL: ${e.requestOptions.uri}');
      _logger.e('Request Method: ${e.requestOptions.method}');
      _logger.e('Request Headers: ${e.requestOptions.headers}');
      _logger.e('Response: ${e.response?.statusCode}');
      _logger.e('Response data: ${e.response?.data}');
      _logger.e('===========================================');
      throw DioErrorException();
    } catch (e) {
      _logger
          .e('======= ASSET DIVISION VALIDATION: UNEXPECTED EXCEPTION =======');
      _logger.e('Error: $e');
      _logger.e('===========================================');
      throw ServerException();
    }
  }
}
