import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:land_asset_valuation/application/core/widgets/tableForRO/cubit/ro_requests_state.dart';
import 'package:land_asset_valuation/domain/usecases/get_ro_requests_usecase.dart';
import 'package:logger/logger.dart';

class RoRequestsCubit extends Cubit<RoRequestsState> {
  final GetRoRequestsUseCase getRoRequestsUseCase;
  final Logger _logger = Logger();

  RoRequestsCubit({required this.getRoRequestsUseCase}) : super(RoRequestsInitial());

  Future<void> loadRequests() async {
    emit(RoRequestsLoading());

    final result = await getRoRequestsUseCase();

    result.fold(
      (failure) {
        _logger.e('Failed to load RO requests: $failure');
        emit(const RoRequestsError(message: 'Failed to load rating object requests'));
      },
      (response) {
        _logger.d('Successfully loaded ${response.requests.length} RO requests');
        emit(RoRequestsLoaded(requests: response.requests));
      },
    );
  }

  void refresh() {
    loadRequests();
  }
}