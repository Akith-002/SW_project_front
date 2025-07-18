import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../../application/core/error/exceptions.dart';
import '../../models/domestic_rating_card_model.dart';
import '../../models/domestic_rating_card_autofill_model.dart';
import 'api/dio_client.dart';

abstract class DomesticRatingCardRemoteDataSource {
  Future<void> saveDomesticRatingCard(DomesticRatingCardModel model);
  Future<DomesticRatingCardAutofillModel> getAutofillData(int assetId);
}

class DomesticRatingCardRemoteDataSourceImpl
    implements DomesticRatingCardRemoteDataSource {
  final DioClient client;
  final Logger logger;

  DomesticRatingCardRemoteDataSourceImpl({
    required this.client,
    required this.logger,
  });
  @override
  Future<void> saveDomesticRatingCard(DomesticRatingCardModel model) async {
    try {
      await client.post(
        '/DomesticRatingCard/asset/${model.assetId}',
        data: model.toJson(),
      );
      logger.i(
          'Domestic rating card saved successfully for asset ${model.assetId}');
    } on DioException catch (e) {
      logger.e('Error saving domestic rating card: ${e.message}');
      throw ServerException();
    } catch (e) {
      logger.e('Unexpected error saving domestic rating card: $e');
      throw ServerException();
    }
  }

  @override
  Future<DomesticRatingCardAutofillModel> getAutofillData(int assetId) async {
    try {
      final response =
          await client.get('/DomesticRatingCard/autofill/$assetId');
      logger.i('Autofill data retrieved successfully for asset $assetId');
      return DomesticRatingCardAutofillModel.fromJson(response.data);
    } on DioException catch (e) {
      logger.e('Error getting autofill data: ${e.message}');
      throw ServerException();
    } catch (e) {
      logger.e('Unexpected error getting autofill data: $e');
      throw ServerException();
    }
  }
}
