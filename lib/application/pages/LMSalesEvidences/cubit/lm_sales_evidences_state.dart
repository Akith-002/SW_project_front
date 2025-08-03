import 'package:land_asset_valuation/app/cubit/base_state.dart';

abstract class LmSalesEvidencesState extends BaseState<LmSalesEvidencesState> {}

final class LmSalesEvidencesInitial extends LmSalesEvidencesState {}

final class LmSalesEvidencesLoading extends LmSalesEvidencesState {}

final class LmSalesEvidencesSubmitSuccess extends LmSalesEvidencesState {}

final class LmSalesEvidencesSubmitFailure extends LmSalesEvidencesState {
  final String errorMessage;

  LmSalesEvidencesSubmitFailure(this.errorMessage);
}
