import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:land_asset_valuation/application/core/error/exceptions.dart';
import 'package:land_asset_valuation/data/datasource/remote/api/dio_client.dart';
import 'package:land_asset_valuation/data/models/la_lot_model.dart';

abstract class LALotRemoteDataSource {
  Future<LALotResponse> saveLot(LALotModel lot);
  Future<List<LALotModel>> getLotsByMasterFileId(int masterFileId);
}

class LALotRemoteDataSourceImpl implements LALotRemoteDataSource {
  final DioClient dioClient;
  final Logger _logger = Logger();

  LALotRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<LALotResponse> saveLot(LALotModel lot) async {
    try {
      final String endpoint = '/LALot';

      // Debug: Log API call details
      _logger.d('======= LA LOT REMOTE DATA SOURCE: MAKING API CALL =======');
      _logger.d('Endpoint: $endpoint');
      _logger.d('Lot data: ${lot.toJson()}');
      _logger.d('===========================================');

      final response = await dioClient.post(
        endpoint,
        data: lot.toJson(),
      );

      // Debug: Log API response details
      _logger.d('======= LA LOT REMOTE DATA SOURCE: API RESPONSE =======');
      _logger.d('Status Code: ${response.statusCode}');
      _logger.d('Response Data: ${response.data}');
      _logger.d('===========================================');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return LALotResponse(
          success: true,
          message: response.data['message'] ?? 'Lot saved successfully',
          data: response.data,
        );
      } else {
        _logger.e(
            '======= LA LOT REMOTE DATA SOURCE: API ERROR - UNEXPECTED STATUS CODE =======');
        _logger.e('Status Code: ${response.statusCode}');
        _logger.e('===========================================');
        throw ServerException();
      }
    } on DioException catch (e) {
      _logger.e('======= LA LOT REMOTE DATA SOURCE: DIO EXCEPTION =======');
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
          .e('======= LA LOT REMOTE DATA SOURCE: UNEXPECTED EXCEPTION =======');
      _logger.e('Error: $e');
      _logger.e('===========================================');
      throw ServerException();
    }
  }

  @override
  Future<List<LALotModel>> getLotsByMasterFileId(int masterFileId) async {
    try {
      final String endpoint = '/LALot/masterfile/$masterFileId';

      // Debug: Log API call details
      _logger.d('======= LA LOT REMOTE DATA SOURCE: GET LOTS API CALL =======');
      _logger.d('Endpoint: $endpoint');
      _logger.d('Master File ID: $masterFileId');
      _logger.d('===========================================');

      final response = await dioClient.get(endpoint);

      // Debug: Log API response details
      _logger.d(
          '======= LA LOT REMOTE DATA SOURCE: GET LOTS API RESPONSE =======');
      _logger.d('Status Code: ${response.statusCode}');
      _logger.d('Response Data: ${response.data}');
      _logger.d('===========================================');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          return data.map((lotJson) => LALotModel.fromJson(lotJson)).toList();
        } else if (data is Map<String, dynamic> && data['data'] is List) {
          final lotsList = data['data'] as List;
          return lotsList
              .map((lotJson) => LALotModel.fromJson(lotJson))
              .toList();
        } else {
          _logger.w('Unexpected response format for get lots');
          return [];
        }
      } else {
        _logger.e(
            '======= LA LOT REMOTE DATA SOURCE: GET LOTS API ERROR - UNEXPECTED STATUS CODE =======');
        _logger.e('Status Code: ${response.statusCode}');
        _logger.e('===========================================');
        throw ServerException();
      }
    } on DioException catch (e) {
      _logger.e(
          '======= LA LOT REMOTE DATA SOURCE: GET LOTS DIO EXCEPTION =======');
      _logger.e('Error type: ${e.type}');
      _logger.e('Error message: ${e.message}');
      _logger.e('Request URL: ${e.requestOptions.uri}');
      _logger.e('Request Method: ${e.requestOptions.method}');
      _logger.e('Response: ${e.response?.statusCode}');
      _logger.e('Response data: ${e.response?.data}');
      _logger.e('===========================================');
      throw DioErrorException();
    } catch (e) {
      _logger.e(
          '======= LA LOT REMOTE DATA SOURCE: GET LOTS UNEXPECTED EXCEPTION =======');
      _logger.e('Error: $e');
      _logger.e('===========================================');
      throw ServerException();
    }
  }
}
