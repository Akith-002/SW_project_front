import 'package:land_asset_valuation/app/cubit/base_state.dart';

abstract class LmRentalEvidencesState
    extends BaseState<LmRentalEvidencesState> {}

final class LmRentalEvidencesInitial extends LmRentalEvidencesState {}

final class LmRentalEvidencesLoading extends LmRentalEvidencesState {}

final class LmRentalEvidencesSubmitSuccess extends LmRentalEvidencesState {
  final String reportId;
  LmRentalEvidencesSubmitSuccess(this.reportId);
}

final class LmRentalEvidencesSubmitFailure extends LmRentalEvidencesState {
  final String errorMessage;

  LmRentalEvidencesSubmitFailure(this.errorMessage);
}
