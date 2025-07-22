import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:land_asset_valuation/application/core/widgets/tableForRA/cubit/ra_requests_state.dart';
import 'package:land_asset_valuation/domain/usecases/get_ra_requests_usecase.dart';
import 'package:logger/logger.dart';

class RaRequestsCubit extends Cubit<RaRequestsState> {
  final GetRaRequestsUseCase getRaRequestsUseCase;
  final Logger _logger = Logger();

  RaRequestsCubit({required this.getRaRequestsUseCase}) : super(RaRequestsInitial());

  Future<void> loadRequests() async {
    emit(RaRequestsLoading());

    final result = await getRaRequestsUseCase();

    result.fold(
      (failure) {
        _logger.e('Failed to load RA requests: $failure');
        emit(const RaRequestsError(message: 'Failed to load rating assessment requests'));
      },
      (response) {
        _logger.d('Successfully loaded ${response.requests.length} RA requests');
        emit(RaRequestsLoaded(requests: response.requests));
      },
    );
  }

  void refresh() {
    loadRequests();
  }
}