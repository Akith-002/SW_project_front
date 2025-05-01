import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/data/datasource/shared_preference.dart';

part 'i3_master_file_list_state.dart';

class I3MasterFileListCubit
    extends BaseCubit<BaseState<I3MasterFileListState>> {
  final AppSharedData appSharedData;

  I3MasterFileListCubit({required this.appSharedData})
      : super(I3MasterFileListInitial());
}
