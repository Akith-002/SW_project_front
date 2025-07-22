import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:land_asset_valuation/application/core/error/exceptions.dart';
import 'package:land_asset_valuation/data/datasource/remote/api/dio_client.dart';
import 'package:land_asset_valuation/data/models/la_building_rates_model.dart';

abstract class LaBuildingRatesRemoteDataSource {
  Future<bool> sendLaBuildingRates(LaBuildingRatesModel report);
}

class LaBuildingRatesRemoteDataSourceImpl
    implements LaBuildingRatesRemoteDataSource {
  final DioClient dioClient;
  final Logger _logger = Logger();

  LaBuildingRatesRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<bool> sendLaBuildingRates(LaBuildingRatesModel report) async {
    try {
      final String endpoint = '/BuildingRatesLA';

      _logger
          .d('======= LA BUILDING RATES REMOTE DATA SOURCE: API CALL =======');
      _logger.d('Endpoint: $endpoint');
      _logger.d('Report data: ${report.toJson()}');
      _logger.d('===========================================');

      final response = await dioClient.post(
        endpoint,
        data: report.toJson(),
      );

      _logger.d(
          '======= LA BUILDING RATES REMOTE DATA SOURCE: API RESPONSE =======');
      _logger.d('Status Code: ${response.statusCode}');
      _logger.d('Response Data: ${response.data}');
      _logger.d('===========================================');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        _logger.e(
            '======= LA BUILDING RATES REMOTE DATA SOURCE: API ERROR =======');
        _logger.e('Status Code: ${response.statusCode}');
        _logger.e('===========================================');
        throw ServerException();
      }
    } on DioException catch (e) {
      _logger
          .e('======= LA BUILDING RATES REMOTE DATA SOURCE: DIO ERROR =======');
      _logger.e('Dio Error Type: ${e.type}');
      _logger.e('Error Message: ${e.message}');
      if (e.response != null) {
        _logger.e('Response Status Code: ${e.response!.statusCode}');
        _logger.e('Response Data: ${e.response!.data}');
      }
      _logger.e('===========================================');

      // Handle different types of Dio errors
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw DioErrorException();
        case DioExceptionType.badResponse:
          throw ServerException();
        case DioExceptionType.connectionError:
          throw DioErrorException();
        case DioExceptionType.cancel:
          throw DioErrorException();
        default:
          throw ServerException();
      }
    } catch (e) {
      _logger.e(
          '======= LA BUILDING RATES REMOTE DATA SOURCE: UNEXPECTED ERROR =======');
      _logger.e('Error: $e');
      _logger.e('===========================================');
      throw ServerException();
    }
  }
}
