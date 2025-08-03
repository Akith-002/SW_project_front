import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:land_asset_valuation/application/core/error/exceptions.dart';
import 'package:land_asset_valuation/data/datasource/remote/api/dio_client.dart';
import 'package:land_asset_valuation/data/models/lm_sales_evidences_model.dart';
import 'package:logger/logger.dart';

/// Remote data source for LM Sales Evidences API operations
/// Handles all HTTP requests related to sales evidence submission
abstract class LmSalesEvidencesRemoteDataSource {
  /// Sends sales evidence data to the backend API
  Future<bool> sendLmSalesEvidences(LmSalesEvidencesModel salesEvidenceData);
}

/// Implementation of LM Sales Evidences remote data source using Dio
class LmSalesEvidencesRemoteDataSourceImpl
    extends LmSalesEvidencesRemoteDataSource {
  final DioClient dioClient;
  final Logger _logger = Logger();

  LmSalesEvidencesRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<bool> sendLmSalesEvidences(
      LmSalesEvidencesModel salesEvidenceData) async {
    try {
      _logger.d('📤 Sending LM Sales Evidences data to API...');
      _logger.d('🔍 Sales Evidence Data: ${salesEvidenceData.toString()}');

      // Convert model to JSON
      final jsonData = salesEvidenceData.toJson();
      _logger.d('🗂️ JSON Data: ${jsonEncode(jsonData)}');

      // Make POST request to the SalesEvidenceLM endpoint
      final response = await dioClient.post(
        '/SalesEvidenceLM',
        data: jsonData,
      );

      _logger.d('📡 API Response Status: ${response.statusCode}');
      _logger.d('📄 API Response Data: ${response.data}');

      // Check if request was successful
      if (response.statusCode == 200 || response.statusCode == 201) {
        _logger.i('✅ LM Sales Evidences data sent successfully');
        return true;
      } else {
        _logger.e(
            '❌ Failed to send LM Sales Evidences data. Status: ${response.statusCode}');
        throw ServerException();
      }
    } on DioException catch (e) {
      _logger
          .e('🚨 DioException occurred while sending LM Sales Evidences data');
      _logger.e('🔍 Error Type: ${e.type}');
      _logger.e('💬 Error Message: ${e.message}');
      _logger.e('📡 Response: ${e.response?.data}');

      // Handle different types of DioException
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw ServerException();
        case DioExceptionType.badResponse:
          throw ServerException();
        case DioExceptionType.cancel:
          throw ServerException();
        case DioExceptionType.connectionError:
          throw ServerException();
        default:
          throw ServerException();
      }
    } catch (e, stackTrace) {
      _logger.e(
          '💥 Unexpected error occurred while sending LM Sales Evidences data');
      _logger.e('🐛 Error: $e');
      _logger.e('📚 Stack trace: $stackTrace');
      throw ServerException();
    }
  }
}
