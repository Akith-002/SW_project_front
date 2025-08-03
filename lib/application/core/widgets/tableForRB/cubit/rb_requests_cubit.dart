import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:land_asset_valuation/application/core/widgets/tableForRB/cubit/rb_requests_state.dart';
import 'package:land_asset_valuation/domain/usecases/get_rb_requests_usecase.dart';
import 'package:logger/logger.dart';

class RbRequestsCubit extends Cubit<RbRequestsState> {
  final GetRbRequestsUseCase getRbRequestsUseCase;
  final Logger _logger = Logger();

  RbRequestsCubit({required this.getRbRequestsUseCase}) : super(RbRequestsInitial());

  Future<void> loadRequests() async {
    emit(RbRequestsLoading());

    final result = await getRbRequestsUseCase();

    result.fold(
      (failure) {
        _logger.e('Failed to load RB requests: $failure');
        emit(const RbRequestsError(message: 'Failed to load rating building requests'));
      },
      (response) {
        _logger.d('Successfully loaded ${response.requests.length} RB requests');
        emit(RbRequestsLoaded(requests: response.requests));
      },
    );
  }

  void refresh() {
    loadRequests();
  }
}