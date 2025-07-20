import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:land_asset_valuation/application/core/error/exceptions.dart';
import 'package:land_asset_valuation/data/datasource/remote/api/dio_client.dart';
import 'package:land_asset_valuation/data/models/rental_evidence_model.dart';
import 'package:land_asset_valuation/application/core/configurations/app_config.dart';

abstract class RentalEvidenceRemoteDataSource {
  Future<String> sendRentalEvidence(RentalEvidenceModel report);
}

class RentalEvidenceRemoteDataSourceImpl
    implements RentalEvidenceRemoteDataSource {
  final DioClient dioClient;
  final Logger _logger = Logger();

  RentalEvidenceRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<String> sendRentalEvidence(RentalEvidenceModel report) async {
    try {
      // Get the full API URL for debugging
      final String endpoint = '/RentalEvidenceLA';

      // Debug: Log API call details
      _logger.d('======= REMOTE DATA SOURCE: MAKING API CALL =======');
      _logger.d('Base URL: ${AppConfig.apiBaseUrl}');
      _logger.d('Endpoint: $endpoint');
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
        // Expecting { msg: "success", reportId: "..." }
        final data = response.data;
        if (data != null && data['reportId'] != null) {
          return data['reportId'].toString();
        } else {
          throw ServerException();
        }
      } else {
        _logger.e(
            '======= REMOTE DATA SOURCE: API ERROR - UNEXPECTED STATUS CODE =======');
        _logger.e('Status Code: ${response.statusCode}');
        _logger.e('Response Data: ${response.data}');
        _logger.e('===========================================');
        throw ServerException();
      }
    } on DioException catch (e) {
      _logger.e('======= REMOTE DATA SOURCE: DIO EXCEPTION =======');
      _logger.e('Error Type: ${e.type}');
      _logger.e('Error Message: ${e.message}');
      _logger.e('Response Status Code: ${e.response?.statusCode}');
      _logger.e('Response Data: ${e.response?.data}');
      _logger.e('===========================================');
      throw DioErrorException();
    } catch (e) {
      _logger.e('======= REMOTE DATA SOURCE: UNEXPECTED ERROR =======');
      _logger.e('Error: $e');
      _logger.e('===========================================');
      throw ServerException();
    }
  }
}
