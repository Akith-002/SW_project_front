import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/pages/dashboard/cubit/dashboard_state.dart';
import 'package:land_asset_valuation/data/datasources/shared_preference.dart';

class DashboardCubit extends BaseCubit<BaseState<DashboardState>> {
  final AppSharedData appSharedData;

  DashboardCubit({required this.appSharedData}) : super(DashboardInitial());
}
