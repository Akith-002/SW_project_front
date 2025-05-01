import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/pages/conditionReport/cubit/condition_report_state.dart';
import 'package:land_asset_valuation/data/datasource/shared_preference.dart';

class ConditionReportCubit extends BaseCubit<BaseState<ConditionReportState>> {
  final AppSharedData appSharedData;

  ConditionReportCubit({required this.appSharedData}) : super(ConditionReportInitial());
}