import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:land_asset_valuation/data/datasource/shared_preference.dart';
import 'package:land_asset_valuation/domain/usecases/mr_requests_usecases.dart';
import 'package:land_asset_valuation/data/models/mr_request_model.dart';
import 'package:land_asset_valuation/data/models/paginated_response_mr.dart';

part 'mr_requests_state.dart';

class MrRequestsCubit extends Cubit<MrRequestsState> {
  final AppSharedData appSharedData;
  final GetMrRequestsPaginatedUseCase getMrRequestsPaginatedUseCase;

  MrRequestsCubit({
    required this.appSharedData,
    required this.getMrRequestsPaginatedUseCase,
  }) : super(MrRequestsInitial());

  Future<void> loadMrRequests({
    required int requestTypeId,
    required int pageSize,
    String? pageToken,
  }) async {
    emit(MrRequestsLoading());

    try {
      final result = await getMrRequestsPaginatedUseCase.call(
        requestTypeId: requestTypeId,
        pageSize: pageSize,
        pageToken: pageToken,
      );

      emit(MrRequestsLoaded(result));
    } catch (e) {
      emit(MrRequestsError('Failed to load MR requests: $e'));
    }
  }

  Future<void> refreshMrRequests({
    required int requestTypeId,
    required int pageSize,
  }) async {
    await loadMrRequests(
      requestTypeId: requestTypeId,
      pageSize: pageSize,
      pageToken: null,
    );
  }

  // Load specific request types
  Future<void> loadMassRatingRequests({
    required int pageSize,
    String? pageToken,
  }) async {
    await loadMrRequests(
      requestTypeId: 1, // Mass Rating
      pageSize: pageSize,
      pageToken: pageToken,
    );
  }

  Future<void> loadRatingAssessmentRequests({
    required int pageSize,
    String? pageToken,
  }) async {
    await loadMrRequests(
      requestTypeId: 2, // Rating Assessment (if applicable)
      pageSize: pageSize,
      pageToken: pageToken,
    );
  }

  Future<void> loadRatingBuildingRequests({
    required int pageSize,
    String? pageToken,
  }) async {
    await loadMrRequests(
      requestTypeId: 3, // Rating Building (if applicable)
      pageSize: pageSize,
      pageToken: pageToken,
    );
  }

  Future<void> loadRatingObjectRequests({
    required int pageSize,
    String? pageToken,
  }) async {
    await loadMrRequests(
      requestTypeId: 4, // Rating Object (if applicable)
      pageSize: pageSize,
      pageToken: pageToken,
    );
  }
}
