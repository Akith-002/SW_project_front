import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/pages/LA_Sales_Evidence/cubit/la_sales_evidence_state.dart';
import 'package:land_asset_valuation/data/datasources/shared_preference.dart';

class LaSalesEvidenceCubit extends BaseCubit<BaseState<LaSalesEvidenceState>> {
  final AppSharedData appSharedData;

  LaSalesEvidenceCubit({required this.appSharedData})
      : super(LaSalesEvidenceInitial());
}
