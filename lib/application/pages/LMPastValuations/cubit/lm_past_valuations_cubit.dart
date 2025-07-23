import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/pages/LMPastValuations/cubit/lm_past_valuations_state.dart';
import 'package:land_asset_valuation/data/datasource/shared_preference.dart';

class LmPastValuationsCubit
    extends BaseCubit<BaseState<LmPastValuationsState>> {
  final AppSharedData appSharedData;

  LmPastValuationsCubit({required this.appSharedData})
      : super(LmPastValuationsInitial());
}
