import '../repositories/mr_request_repository.dart';
import '../../data/models/mr_request_model.dart';
import '../../data/repositories/mr_repository_impl.dart';

class GetMrRequestsUseCase {
  final MrRequestRepository repository;

  GetMrRequestsUseCase(this.repository);

  Future<List<MrRequest>> call({required int requestTypeId}) async {
    return await repository.getMrRequests(requestTypeId: requestTypeId);
  }
}

class GetMrRequestsPaginatedUseCase {
  final MrRepositoryImpl repository;

  GetMrRequestsPaginatedUseCase(this.repository);

  Future<PaginatedResponse<MrRequest>> call({
    required int requestTypeId,
    required int pageSize,
    String? pageToken,
  }) async {
    return await repository.getMrRequestsPaginated(
      requestTypeId: requestTypeId,
      pageSize: pageSize,
      pageToken: pageToken,
    );
  }
}
