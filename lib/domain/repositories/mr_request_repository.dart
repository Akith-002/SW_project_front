import '../../data/models/mr_request_model.dart';
import '../../data/repositories/mr_repository_impl.dart'; // For PaginatedResponse

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