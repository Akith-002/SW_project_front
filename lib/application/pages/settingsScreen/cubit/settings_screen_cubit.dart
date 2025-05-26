import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/pages/settingsScreen/cubit/settings_screen_state.dart';
import 'package:land_asset_valuation/data/datasources/shared_preference.dart';

class SettingsScreenCubit extends BaseCubit<BaseState<BaseState>> {
  final AppSharedData appSharedData;

  SettingsScreenCubit({required this.appSharedData})
      : super(SettingsScreenInitial());
}
