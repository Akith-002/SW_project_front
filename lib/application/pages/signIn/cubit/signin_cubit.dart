import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/pages/signIn/cubit/signin_state.dart';
import 'package:land_asset_valuation/data/datasource/shared_preference.dart';

class SigninCubit extends BaseCubit<BaseState<SigninState>> {
  final AppSharedData appSharedData;

  SigninCubit({required this.appSharedData}) : super(SigninInitial());
}
