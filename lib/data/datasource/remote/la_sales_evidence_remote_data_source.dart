import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:land_asset_valuation/data/datasource/remote/api/dio_client.dart';
import 'package:land_asset_valuation/data/models/la_sales_evidence_model.dart';
import 'package:logger/logger.dart';

/// Remote data source for LA Sales Evidence API operations
/// Handles all HTTP requests related to sales evidence submission
abstract class LaSalesEvidenceRemoteDataSource {
  /// Sends sales evidence data to the backend API
  Future<bool> sendLaSalesEvidence(LaSalesEvidenceModel salesEvidenceData);
}

/// Implementation of LA Sales Evidence remote data source using Dio
class LaSalesEvidenceRemoteDataSourceImpl
    extends LaSalesEvidenceRemoteDataSource {
  final DioClient dioClient;
  final Logger logger;

  LaSalesEvidenceRemoteDataSourceImpl({
    required this.dioClient,
    required this.logger,
  });

  @override
  Future<bool> sendLaSalesEvidence(
      LaSalesEvidenceModel salesEvidenceData) async {
    try {
      logger.d('📤 Sending LA Sales Evidence data to API...');
      logger.d('🔍 Sales Evidence Data: ${salesEvidenceData.toString()}');

      // Convert model to JSON
      final jsonData = salesEvidenceData.toJson();
      logger.d('🗂️ JSON Data: ${jsonEncode(jsonData)}');

      // Make POST request to the SalesEvidenceLA endpoint
      final response = await dioClient.post(
        '/SalesEvidenceLA',
        data: jsonData,
      );

      logger.d('📡 API Response Status: ${response.statusCode}');
      logger.d('📄 API Response Data: ${response.data}');

      // Check if request was successful
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i('✅ LA Sales Evidence data sent successfully');
        return true;
      } else {
        logger.e(
            '❌ Failed to send LA Sales Evidence data. Status: ${response.statusCode}');
        return false;
      }
    } on DioException catch (e) {
      logger.e('🚨 DioException occurred while sending LA Sales Evidence data');
      logger.e('🔥 Error Type: ${e.type}');
      logger.e('💬 Error Message: ${e.message}');

      // Log specific error details based on type
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          logger.e('⏰ Connection timeout - Check network connectivity');
          break;
        case DioExceptionType.sendTimeout:
          logger.e('📤 Send timeout - Request took too long to send');
          break;
        case DioExceptionType.receiveTimeout:
          logger.e('📥 Receive timeout - Server took too long to respond');
          break;
        case DioExceptionType.badResponse:
          logger.e('📱 Bad response - Status: ${e.response?.statusCode}');
          logger.e('📄 Response data: ${e.response?.data}');
          break;
        case DioExceptionType.cancel:
          logger.e('🚫 Request was cancelled');
          break;
        case DioExceptionType.connectionError:
          logger.e('🔌 Connection error - Check network connectivity');
          break;
        case DioExceptionType.badCertificate:
          logger.e('🔒 Bad certificate - SSL/TLS certificate issue');
          break;
        default:
          logger.e('❓ Unknown error occurred');
      }

      if (e.response != null) {
        logger.e('📊 Response Status Code: ${e.response!.statusCode}');
        logger.e('📋 Response Headers: ${e.response!.headers}');
        logger.e('📃 Response Data: ${e.response!.data}');
      }

      throw Exception('Failed to send LA Sales Evidence data: ${e.message}');
    } catch (e, stackTrace) {
      logger.e(
          '💥 Unexpected error occurred while sending LA Sales Evidence data');
      logger.e('🐛 Error: $e');
      logger.e('📚 Stack trace: $stackTrace');
      throw Exception(
          'Unexpected error occurred while sending LA Sales Evidence data: $e');
    }
  }
}
