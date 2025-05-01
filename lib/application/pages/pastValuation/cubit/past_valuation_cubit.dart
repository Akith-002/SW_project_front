import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/pages/PastValuation/cubit/past_valuation_state.dart';
import 'package:land_asset_valuation/data/datasource/shared_preference.dart';

class PastValuationCubit extends BaseCubit<BaseState<PastValuationState>> {
  final AppSharedData appSharedData;

  PastValuationCubit({required this.appSharedData}) : super(PastValuationInitial());
}