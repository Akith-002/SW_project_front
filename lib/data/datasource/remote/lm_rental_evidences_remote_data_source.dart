import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:land_asset_valuation/application/core/error/exceptions.dart';
import 'package:land_asset_valuation/data/datasource/remote/api/dio_client.dart';
import 'package:land_asset_valuation/data/models/lm_rental_evidences_model.dart';
import 'package:land_asset_valuation/application/core/configurations/app_config.dart';

abstract class LmRentalEvidencesRemoteDataSource {
  Future<String> sendLmRentalEvidence(LmRentalEvidencesModel report);
}

class LmRentalEvidencesRemoteDataSourceImpl
    implements LmRentalEvidencesRemoteDataSource {
  final DioClient dioClient;
  final Logger _logger = Logger();

  LmRentalEvidencesRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<String> sendLmRentalEvidence(LmRentalEvidencesModel report) async {
    try {
      // Get the full API URL for debugging
      final String endpoint = '/LMRentalEvidence';

      // Debug: Log API call details
      _logger.d(
          '======= LM RENTAL EVIDENCES REMOTE DATA SOURCE: MAKING API CALL =======');
      _logger.d('Full API URL: ${AppConfig.apiBaseUrl}$endpoint');
      _logger.d('Assessment No: ${report.assessmentNo}');
      _logger.d('Owner: ${report.owner}');
      _logger.d('Request payload: ${report.toJson()}');
      _logger.d('===========================================');

      final response = await dioClient.post(
        endpoint,
        data: report.toJson(),
      );

      // Debug: Log API response
      _logger.d(
          '======= LM RENTAL EVIDENCES REMOTE DATA SOURCE: API RESPONSE =======');
      _logger.d('Status Code: ${response.statusCode}');
      _logger.d('Response Data: ${response.data}');
      _logger.d('===========================================');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Extract report ID from response
        final data = response.data;
        if (data is Map<String, dynamic> && data.containsKey('reportId')) {
          final reportId = data['reportId'].toString();
          _logger.d('Extracted Report ID: $reportId');
          return reportId;
        } else {
          // If reportId is not in the expected format, try to extract from string response
          final responseString = data.toString();
          final reportIdMatch =
              RegExp(r'"reportId"\s*:\s*(\d+)').firstMatch(responseString);
          if (reportIdMatch != null) {
            final reportId = reportIdMatch.group(1)!;
            _logger.d('Extracted Report ID from string: $reportId');
            return reportId;
          } else {
            _logger.w('No reportId found in response, using fallback');
            return DateTime.now().millisecondsSinceEpoch.toString();
          }
        }
      } else {
        _logger.e('API call failed with status: ${response.statusCode}');
        throw ServerException();
      }
    } on DioException catch (e) {
      _logger.e(
          '======= LM RENTAL EVIDENCES REMOTE DATA SOURCE: DIO EXCEPTION =======');
      _logger.e('Error Type: ${e.type}');
      _logger.e('Error Message: ${e.message}');
      if (e.response != null) {
        _logger.e('Response Status Code: ${e.response?.statusCode}');
        _logger.e('Response Data: ${e.response?.data}');
      }
      _logger.e('===========================================');
      throw ServerException();
    } catch (e) {
      _logger.e(
          '======= LM RENTAL EVIDENCES REMOTE DATA SOURCE: UNEXPECTED ERROR =======');
      _logger.e('Error: $e');
      _logger.e('===========================================');
      throw ServerException();
    }
  }
}
