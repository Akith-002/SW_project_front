import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/data/datasources/shared_preference.dart';

part 'rental_evidence_state.dart';

class RentalEvidenceCubit extends BaseCubit<BaseState<RentalEvidenceState>> {
  final AppSharedData appSharedData;

  RentalEvidenceCubit({required this.appSharedData}) : super(RentalEvidenceInitial());
}
