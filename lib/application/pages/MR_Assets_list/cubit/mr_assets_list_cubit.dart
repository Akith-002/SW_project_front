import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/pages/MR_Assets_list/cubit/mr_assets_list_state.dart';
import 'package:land_asset_valuation/data/datasources/shared_preference.dart';

class MrAssetsListCubit extends BaseCubit<BaseState<MrAssetsListState>> {
  final AppSharedData appSharedData;

  MrAssetsListCubit({required this.appSharedData})
      : super(MrAssetsListInitial());
}
