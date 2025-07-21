import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:land_asset_valuation/application/core/error/exceptions.dart';
import 'package:land_asset_valuation/data/datasource/remote/api/dio_client.dart';
import 'package:land_asset_valuation/data/models/inspection_report_model.dart';

abstract class InspectionReportRemoteDataSource {
  Future<InspectionReportModel> sendInspectionReport(
      InspectionReportModel report);
}

class InspectionReportRemoteDataSourceImpl
    implements InspectionReportRemoteDataSource {
  final DioClient dioClient;
  final Logger _logger = Logger();

  InspectionReportRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<InspectionReportModel> sendInspectionReport(
      InspectionReportModel report) async {
    try {
      final String endpoint = '/InspectionReport';

      // Debug: Log API call details
      _logger.d('======= INSPECTION REPORT: MAKING API CALL =======');
      _logger.d('Endpoint: $endpoint');
      _logger.d('Report data: ${report.toJson()}');
      _logger.d('===========================================');

      final response = await dioClient.post(
        endpoint,
        data: report.toJson(),
      );

      // Debug: Log API response details
      _logger.d('======= INSPECTION REPORT: API RESPONSE =======');
      _logger.d('Status Code: ${response.statusCode}');
      _logger.d('Response Data: ${response.data}');
      _logger.d('===========================================');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return InspectionReportModel.fromJson(response.data);
      } else {
        _logger.e(
            '======= INSPECTION REPORT: API ERROR - UNEXPECTED STATUS CODE =======');
        _logger.e('Status Code: ${response.statusCode}');
        _logger.e('===========================================');
        throw ServerException();
      }
    } on DioException catch (e) {
      _logger.e('======= INSPECTION REPORT: DIO EXCEPTION =======');
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
      _logger.e('======= INSPECTION REPORT: UNEXPECTED EXCEPTION =======');
      _logger.e('Error: $e');
      _logger.e('===========================================');
      throw ServerException();
    }
  }
}
