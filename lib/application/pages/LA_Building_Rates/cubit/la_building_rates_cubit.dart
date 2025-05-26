import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/pages/LA_Building_Rates/cubit/la_building_rates_state.dart';
import 'package:land_asset_valuation/data/datasource/shared_preference.dart';

class LaBuildingRatesCubit extends BaseCubit<BaseState<LaBuildingRatesState>> {
  final AppSharedData appSharedData;

  LaBuildingRatesCubit({required this.appSharedData})
      : super(LaBuildingRatesInitial());
}
