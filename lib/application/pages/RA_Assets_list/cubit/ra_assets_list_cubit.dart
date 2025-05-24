import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/pages/RA_Assets_list/cubit/ra_assets_list_state.dart';
import 'package:land_asset_valuation/data/datasource/shared_preference.dart';

class RaAssetsListCubit extends BaseCubit<BaseState<RaAssetsListState>> {
  final AppSharedData appSharedData;

  RaAssetsListCubit({required this.appSharedData})
      : super(RaAssetsListInitial());
}
