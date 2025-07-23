import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/pages/LM_Building_Rates/cubit/lm_building_rates_state.dart';
import 'package:land_asset_valuation/data/datasource/shared_preference.dart';
import 'package:land_asset_valuation/domain/usecases/send_lm_building_rates_usecase.dart';
import 'package:land_asset_valuation/data/models/lm_building_rates_model.dart';
import 'package:logger/logger.dart';

class LmBuildingRatesCubit extends BaseCubit<BaseState<LmBuildingRatesState>> {
  final AppSharedData appSharedData;
  final SendLmBuildingRatesUseCase sendLmBuildingRatesUseCase;
  final Logger _logger = Logger();

  LmBuildingRatesCubit({
    required this.appSharedData,
    required this.sendLmBuildingRatesUseCase,
  }) : super(LmBuildingRatesInitial());

  Future<void> sendLmBuildingRates(LmBuildingRatesModel report) async {
    emit(LmBuildingRatesLoading());

    _logger.d('======= CUBIT: SENDING LM BUILDING RATES DATA =======');
    _logger.d('Assessment Number: ${report.assessmentNumber}');
    _logger.d('Owner: ${report.owner}');
    _logger.d('Data being prepared for API call...');
    _logger.d('===========================================');

    final result = await sendLmBuildingRatesUseCase(report);

    result.fold(
      (failure) {
        _logger.e('======= CUBIT: SUBMIT FAILED =======');
        _logger.e('Error: ${failure.message}');
        _logger.e('===========================================');

        // Handle specific authentication errors
        if (failure.message.toLowerCase().contains('unauthorized') ||
            failure.message.toLowerCase().contains('401')) {
          emit(LmBuildingRatesSubmitFailure(
              'Authentication failed. Please login again and try.'));
        } else {
          emit(LmBuildingRatesSubmitFailure(failure.message));
        }
      },
      (success) {
        _logger.d('======= CUBIT: SUBMIT SUCCESS =======');
        _logger.d('Successfully sent LM Building Rates data');
        _logger.d('===========================================');
        emit(LmBuildingRatesSubmitSuccess());
      },
    );
  }
}
