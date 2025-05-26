import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:land_asset_valuation/application/core/error/exceptions.dart';
import 'package:land_asset_valuation/data/datasources/remote/api/dio_client.dart';
import 'package:land_asset_valuation/data/models/condition_report_model.dart';
import 'package:land_asset_valuation/application/core/configurations/app_config.dart';

abstract class ConditionReportRemoteDataSource {
  Future<bool> sendConditionReport(ConditionReportModel report);
}

class ConditionReportRemoteDataSourceImpl
    implements ConditionReportRemoteDataSource {
  final DioClient dioClient;
  final Logger _logger = Logger();

  ConditionReportRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<bool> sendConditionReport(ConditionReportModel report) async {
    try {
      // Get the full API URL for debugging
      final String endpoint = '/ConditionReport/submit';
      final String fullUrl =
          '${AppConfig.apiBaseUrl}${endpoint.startsWith('/') ? endpoint.substring(1) : endpoint}';

      // Debug: Log API call details
      _logger.d('======= REMOTE DATA SOURCE: MAKING API CALL =======');
      _logger.d('Base URL: ${AppConfig.apiBaseUrl}');
      _logger.d('Endpoint: $endpoint');
      _logger.d('FULL URL: $fullUrl');
      _logger.d('Report data: ${report.toJson()}');
      _logger.d('===========================================');

      final response = await dioClient.post(
        endpoint,
        data: report.toJson(),
      );

      // Debug: Log API response details
      _logger.d('======= REMOTE DATA SOURCE: API RESPONSE =======');
      _logger.d('Status Code: ${response.statusCode}');
      _logger.d('Response Data: ${response.data}');
      _logger.d('===========================================');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        _logger.e(
            '======= REMOTE DATA SOURCE: API ERROR - UNEXPECTED STATUS CODE =======');
        _logger.e('Status Code: ${response.statusCode}');
        _logger.e('===========================================');
        throw ServerException();
      }
    } on DioException catch (e) {
      _logger.e('======= REMOTE DATA SOURCE: DIO EXCEPTION =======');
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
      _logger.e('======= REMOTE DATA SOURCE: UNEXPECTED EXCEPTION =======');
      _logger.e('Error: $e');
      _logger.e('===========================================');
      throw ServerException();
    }
  }
}
