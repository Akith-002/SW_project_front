import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/pages/splash/cubit/splash_state.dart';
import 'package:land_asset_valuation/data/datasources/shared_preference.dart';

class SplashCubit extends BaseCubit<BaseState<SplashState>> {
  final AppSharedData appSharedData;

  SplashCubit({required this.appSharedData}) : super(SplashInitial());
}
