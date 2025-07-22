import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/pages/LA_Building_Rates/cubit/la_building_rates_state.dart';
import 'package:land_asset_valuation/data/datasource/shared_preference.dart';
import 'package:land_asset_valuation/domain/usecases/send_la_building_rates_usecase.dart';
import 'package:land_asset_valuation/data/models/la_building_rates_model.dart';
import 'package:logger/logger.dart';

class LaBuildingRatesCubit extends BaseCubit<BaseState<LaBuildingRatesState>> {
  final AppSharedData appSharedData;
  final SendLaBuildingRatesUseCase sendLaBuildingRatesUseCase;
  final Logger _logger = Logger();

  LaBuildingRatesCubit({
    required this.appSharedData,
    required this.sendLaBuildingRatesUseCase,
  }) : super(LaBuildingRatesInitial());

  Future<void> sendLaBuildingRates(LaBuildingRatesModel report) async {
    emit(LaBuildingRatesLoading());

    _logger.d('======= CUBIT: SENDING LA BUILDING RATES DATA =======');
    _logger.d('Assessment Number: ${report.assessmentNumber}');
    _logger.d('Owner: ${report.owner}');
    _logger.d('Data being prepared for API call...');
    _logger.d('===========================================');

    final result = await sendLaBuildingRatesUseCase(report);

    result.fold(
      (failure) {
        _logger.e('======= CUBIT: SUBMIT FAILED =======');
        _logger.e('Error: ${failure.message}');
        _logger.e('===========================================');

        // Handle specific authentication errors
        if (failure.message.toLowerCase().contains('unauthorized') ||
            failure.message.toLowerCase().contains('401')) {
          emit(LaBuildingRatesSubmitFailure(
              'Authentication failed. Please login again and try.'));
        } else {
          emit(LaBuildingRatesSubmitFailure(failure.message));
        }
      },
      (success) {
        _logger.d('======= CUBIT: SUBMIT SUCCESS =======');
        _logger.d('Successfully sent LA Building Rates data');
        _logger.d('===========================================');
        emit(LaBuildingRatesSubmitSuccess());
      },
    );
  }
}
