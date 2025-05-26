import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/pages/RO_Assets_list/cubit/ro_assets_list_state.dart';
import 'package:land_asset_valuation/data/datasources/shared_preference.dart';

class RoAssetsListCubit extends BaseCubit<BaseState<RoAssetsListState>> {
  final AppSharedData appSharedData;

  RoAssetsListCubit({required this.appSharedData})
      : super(RoAssetsListInitial());
}
