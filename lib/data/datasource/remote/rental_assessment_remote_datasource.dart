import 'package:land_asset_valuation/data/datasource/remote/api/dio_client.dart';
import 'package:land_asset_valuation/data/models/rental_assesment_model.dart';

abstract class RentalAssessmentRemoteDataSource {
  Future<List<RentalAssessment>> getRentalAssessments();
}

class RentalAssessmentRemoteDataSourceImpl implements RentalAssessmentRemoteDataSource {
  final DioClient dioClient;

  RentalAssessmentRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<RentalAssessment>> getRentalAssessments() async {
    try {
      final response = await dioClient.get('/Requests/by-request-type/2');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => RentalAssessment.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load rental assessments');
      }
    } catch (e) {
      throw Exception('Error fetching rental assessments: $e');
    }
  }
}