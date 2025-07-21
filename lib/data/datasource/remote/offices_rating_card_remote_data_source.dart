import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../../application/core/error/exceptions.dart';
import '../../models/offices_rating_card_model.dart';
import '../../models/offices_rating_card_autofill_model.dart';
import 'api/dio_client.dart';

abstract class OfficesRatingCardRemoteDataSource {
  Future<void> saveOfficesRatingCard(OfficesRatingCardModel model);
  Future<OfficesRatingCardAutofillModel> getAutofillData(int assetId);
}

class OfficesRatingCardRemoteDataSourceImpl
    implements OfficesRatingCardRemoteDataSource {
  final DioClient client;
  final Logger logger;

  OfficesRatingCardRemoteDataSourceImpl({
    required this.client,
    required this.logger,
  });
  
  @override
  Future<void> saveOfficesRatingCard(OfficesRatingCardModel model) async {
    try {
      await client.post(
        '/OfficesRatingCard/asset/${model.assetId}',
        data: model.toJson(),
      );
      logger.i(
          'Offices rating card saved successfully for asset ${model.assetId}');
    } on DioException catch (e) {
      logger.e('Error saving offices rating card: ${e.message}');
      throw ServerException();
    } catch (e) {
      logger.e('Unexpected error saving offices rating card: $e');
      throw ServerException();
    }
  }

  @override
  Future<OfficesRatingCardAutofillModel> getAutofillData(int assetId) async {
    try {
      // Use the offices rating card autofill endpoint
      final response =
          await client.get('/OfficesRatingCard/autofill/$assetId');
      logger.i('Autofill data retrieved successfully for asset $assetId');
      return OfficesRatingCardAutofillModel.fromJson(response.data);
    } on DioException catch (e) {
      logger.e('Error getting autofill data: ${e.message}');
      throw ServerException();
    } catch (e) {
      logger.e('Unexpected error getting autofill data: $e');
      throw ServerException();
    }
  }
}