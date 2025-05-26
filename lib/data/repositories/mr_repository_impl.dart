import '../../domain/repositories/mr_request_repository.dart';
import '../models/mr_request_model.dart';
import '../models/paginated_response_mr.dart';
import '../datasource/remote/mr_request_remote_datasource.dart';

class MrRepositoryImpl implements MrRequestRepository {
  final MRRequestRemoteDataSource _remoteDataSource;

  MrRepositoryImpl({required MRRequestRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<List<MrRequest>> getMrRequests({
    required int requestTypeId,
  }) async {
    try {
      List<MrRequest> mrRequests =
          await _remoteDataSource.getRequestsByType(requestTypeId);
      return mrRequests;
    } catch (e) {
      throw Exception('Failed to fetch MR requests: $e');
    }
  }

  @override
  Future<PaginatedResponse<MrRequest>> getMrRequestsPaginated({
    required int requestTypeId,
    required int pageSize,
    String? pageToken,
  }) async {
    try {
      List<MrRequest> allRequests =
          await _remoteDataSource.getRequestsByType(requestTypeId);

      if (allRequests.isEmpty) {
        return PaginatedResponse(items: [], nextPageToken: null);
      }

      // Apply pagination
      int startIndex = pageToken == null ? 0 : int.tryParse(pageToken) ?? 0;
      int endIndex = (startIndex + pageSize).clamp(0, allRequests.length);
      List<MrRequest> paginatedRequests =
          allRequests.sublist(startIndex, endIndex);
      String? nextPageToken =
          endIndex < allRequests.length ? endIndex.toString() : null;

      return PaginatedResponse(
        items: paginatedRequests,
        nextPageToken: nextPageToken,
      );
    } catch (e) {
      throw Exception('Failed to fetch MR requests: $e');
    }
  }
}
