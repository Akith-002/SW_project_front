import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/pages/LM_Masterfile_list/cubit/lm_masterfile_list_state.dart';
import 'package:land_asset_valuation/data/datasource/shared_preference.dart';

class LmMasterfileListCubit
    extends BaseCubit<BaseState<LM_MasterfileListState>> {
  final AppSharedData appSharedData;

  LmMasterfileListCubit({required this.appSharedData})
      : super(LM_MasterfileListInitial());
}
