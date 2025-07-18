import 'package:dio/dio.dart';
import 'package:land_asset_valuation/application/core/error/exceptions.dart';
import 'package:land_asset_valuation/data/datasource/remote/api/dio_client.dart';
import 'package:land_asset_valuation/data/models/asset_change_request.dart';
import 'package:land_asset_valuation/data/models/asset_change_response.dart';

abstract class AssetChangeRemoteDataSource {
  Future<AssetChangeResponse> submitAssetChange(AssetChangeRequest request);
}

class AssetChangeRemoteDataSourceImpl implements AssetChangeRemoteDataSource {
  final DioClient dioClient;

  AssetChangeRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<AssetChangeResponse> submitAssetChange(
      AssetChangeRequest request) async {
    try {
      final response = await dioClient.post(
        '/AssetNumberChanges',
        data: request.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return AssetChangeResponse.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Failed to submit asset change: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw DioErrorException(message: 'Network connection error');
      } else if (e.response?.statusCode == 400) {
        throw ServerException(message: 'Bad request: ${e.response?.data}');
      } else if (e.response?.statusCode == 401) {
        throw ServerException(message: 'Unauthorized access');
      } else if (e.response?.statusCode == 500) {
        throw ServerException(message: 'Internal server error');
      } else {
        throw ServerException(message: 'Server error: ${e.message}');
      }
    } catch (e) {
      throw ServerException(message: 'Unexpected error: $e');
    }
  }
}
