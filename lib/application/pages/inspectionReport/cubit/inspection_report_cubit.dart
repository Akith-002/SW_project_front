import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/pages/inspectionReport/cubit/inspection_report_state.dart';
import 'package:land_asset_valuation/data/datasource/shared_preference.dart';

class InspectionReportCubit extends BaseCubit<BaseState<InspectionReportState>> {
  final AppSharedData appSharedData;

  InspectionReportCubit({required this.appSharedData})
      : super(InspectionReportInitial());
}
