import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:land_asset_valuation/data/datasource/remote/api/dio_client.dart';
import 'package:land_asset_valuation/data/models/land_acquisition_master_file_model.dart';
import 'package:land_asset_valuation/data/models/paginated_response.dart';

class LandAcquisitionRemoteDatasource {
  final DioClient dioClient;

  LandAcquisitionRemoteDatasource(this.dioClient);

  Future<PaginatedResponse<LandAcquisitionMasterFile>> getPaginatedMasterFiles({
    required int page,
    required int pageSize,
    String? sortBy,
  }) async {
    try {
      if (kDebugMode) {
        print('Fetching data - Page: $page, Size: $pageSize, SortBy: $sortBy');
      }

      final Map<String, dynamic> queryParams = {
        'pageNumber': page - 1, // Convert to 0-based for API
        'pageSize': pageSize,
      };

      if (sortBy != null) {
        queryParams['sortBy'] = sortBy;
      }

      final response = await dioClient.get(
        '/LAMasterfile',
        queryParameters: queryParams,
      );

      if (kDebugMode) {
        print('Raw API Response: ${response.data}');
      }

      final data = response.data;
      final List<dynamic> masterFiles = data['masterFiles'] as List<dynamic>;

      // Get pagination metadata from API response
      final totalCount = data['totalCount'] as int;
      final currentPage = data['currentPage'] as int;
      final totalPages = data['totalPages'] as int;
      final hasPrevious = data['hasPrevious'] as bool;
      final hasNext = data['hasNext'] as bool;

      if (kDebugMode) {
        print('Processing API response:');
        print('Records received: ${masterFiles.length}');
        print('Total Count: $totalCount');
        print('Current Page: $currentPage');
        print('Page Size: $pageSize');
        print('Total Pages: $totalPages');
        print('Has Previous: $hasPrevious');
        print('Has Next: $hasNext');
      }

      // Convert records to model objects
      final items = masterFiles
          .map((e) =>
              LandAcquisitionMasterFile.fromJson(e as Map<String, dynamic>))
          .toList();

      return PaginatedResponse(
        items: items,
        totalCount: totalCount,
        currentPage: currentPage,
        pageSize: pageSize,
        totalPages: totalPages,
        hasPrevious: hasPrevious,
        hasNext: hasNext,
      );
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Error fetching paginated master files:');
        print('Error: $e');
        print('Stack trace: $stackTrace');
      }
      rethrow;
    }
  }

  Future<PaginatedResponse<LandAcquisitionMasterFile>> searchMasterFiles({
    required String query,
    required int page,
    required int pageSize,
    String? sortBy,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {
        'page': page,
        'pageSize': pageSize,
      };

      if (sortBy != null) {
        queryParams['sortBy'] = sortBy;
      }

      final response = await dioClient.post(
        '/LAMasterfile/search/paged',
        data: {'query': query},
        queryParameters: queryParams,
      );

      final data = response.data;
      final List<dynamic> masterFiles = data['masterFiles'] as List<dynamic>;
      final totalCount = data['totalCount'] as int;
      final currentPage = data['currentPage'] as int;
      final totalPages = data['totalPages'] as int;
      final hasPrevious = data['hasPrevious'] as bool;
      final hasNext = data['hasNext'] as bool;

      final items = masterFiles
          .map((e) =>
              LandAcquisitionMasterFile.fromJson(e as Map<String, dynamic>))
          .toList();

      return PaginatedResponse(
        items: items,
        totalCount: totalCount,
        currentPage: currentPage,
        pageSize: pageSize,
        totalPages: totalPages,
        hasPrevious: hasPrevious,
        hasNext: hasNext,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // If search endpoint fails, fall back to getting all records and filtering client-side
        final allRecords = await getPaginatedMasterFiles(
            page: 1, pageSize: 100, sortBy: sortBy);
        final filteredItems = allRecords.items.where((file) {
          final searchTerm = query.toLowerCase();
          return file.masterFileNo
                  .toString()
                  .toLowerCase()
                  .contains(searchTerm) ||
              file.planType.toLowerCase().contains(searchTerm) ||
              file.planNo.toLowerCase().contains(searchTerm) ||
              file.requestingAuthorityReferenceNo
                  .toLowerCase()
                  .contains(searchTerm) ||
              file.status.toLowerCase().contains(searchTerm);
        }).toList();

        return PaginatedResponse(
          items: filteredItems,
          totalCount: filteredItems.length,
          currentPage: 1,
          pageSize: filteredItems.length,
          totalPages: 1,
          hasPrevious: false,
          hasNext: false,
        );
      }
      rethrow;
    }
  }
}
