import 'package:dio/dio.dart';
import 'package:land_asset_valuation/data/datasource/remote/api/dio_client.dart';
import 'package:land_asset_valuation/data/models/master_data_model.dart';

abstract class MasterDataRemoteDataSource {
  Future<MasterDataResponse> fetchMasterData();
}

class MasterDataRemoteDataSourceImpl implements MasterDataRemoteDataSource {
  final DioClient dioClient;

  MasterDataRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<MasterDataResponse> fetchMasterData() async {
    try {
      final response = await dioClient.get('/MasterData');
      return MasterDataResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to fetch master data: ${e.message}');
    }
  }
}
