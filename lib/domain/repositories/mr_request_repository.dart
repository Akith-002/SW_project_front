import '../../data/models/mr_request_model.dart';
import '../../data/models/paginated_response_mr.dart';

abstract class MrRequestRepository {
  Future<List<MrRequest>> getMrRequests({
    required int requestTypeId,
  });

  // Add this if you want pagination
  Future<PaginatedResponse<MrRequest>> getMrRequestsPaginated({
    required int requestTypeId,
    required int pageSize,
    String? pageToken,
  });
}
