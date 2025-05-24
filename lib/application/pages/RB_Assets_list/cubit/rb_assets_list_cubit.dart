import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/pages/RB_Assets_list/cubit/rb_assets_list_state.dart';
import 'package:land_asset_valuation/data/datasource/shared_preference.dart';

class RbAssetsListCubit extends BaseCubit<BaseState<RbAssetsListState>> {
  final AppSharedData appSharedData;

  RbAssetsListCubit({required this.appSharedData})
      : super(RbAssetsListInitial());
}
