import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/data/datasources/shared_preference.dart';

part 'i2_rental_evidence_state.dart';

class I2RentalEvidenceCubit extends BaseCubit<BaseState<I2RentalEvidenceState>> {
  final AppSharedData appSharedData;

  I2RentalEvidenceCubit({required this.appSharedData}) : super(I2RentalEvidenceInitial());
}
