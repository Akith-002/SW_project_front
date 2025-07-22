import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:land_asset_valuation/application/core/configurations/app_config.dart';
import 'package:land_asset_valuation/application/core/widgets/tableForLM/planLM.dart';
import 'package:land_asset_valuation/application/core/configurations/app_config.dart';

class PlanlmRepository {
  static Future<PaginatedResponseLM<Planlm>> getPlans({
    required int pageSize,
    // pageToken is now pageNumber for API consistency
    required int pageNumber,
    String?
        sortBy, // sortBy and sortDescending are not used by the API endpoint
    bool sortDescending = false,
    String? searchQuery, // searchQuery is not used by this specific endpoint
  }) async {
    final uri = Uri.parse(
        '${AppConfig.apiBaseUrl}LandMiscellaneous/paginated?pageNumber=$pageNumber&pageSize=$pageSize');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> records = data['records'];
        final List<Planlm> plans = records
            .map((e) => Planlm.fromJson(e as Map<String, dynamic>))
            .toList();

        return PaginatedResponseLM(
          items: plans,
          totalCount: data['totalCount'],
          pageNumber: data['pageNumber'],
          pageSize: data['pageSize'],
          totalPages: data['totalPages'],
        );
      } else {
        // It's good practice to throw a more specific error or handle different status codes
        throw Exception(
            'Failed to load plans: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      // Catching network errors or json parsing errors
      throw Exception('Failed to load plans: $e');
    }
  }
}

class PaginatedResponseLM<T> {
  final List<T> items;
  // final String? nextPageToken; // Replaced with pagination details from API
  final int totalCount;
  final int pageNumber;
  final int pageSize;
  final int totalPages;

  PaginatedResponseLM({
    required this.items,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
    // this.nextPageToken
  });
}
