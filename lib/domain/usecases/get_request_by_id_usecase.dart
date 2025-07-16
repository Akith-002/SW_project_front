import '../../data/models/mr_request_model.dart';
import '../repositories/mr_request_repository.dart';

class GetRequestByIdUseCase {
  final MrRequestRepository repository;

  GetRequestByIdUseCase({required this.repository});

  Future<MrRequest> call(int requestId) async {
    return await repository.getRequestById(requestId);
  }
}