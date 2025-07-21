import 'package:land_asset_valuation/app/cubit/base_state.dart';

abstract class RentalEvidenceState extends BaseState<RentalEvidenceState> {}

final class RentalEvidenceInitial extends RentalEvidenceState {}

final class RentalEvidenceLoading extends RentalEvidenceState {}

final class RentalEvidenceSubmitSuccess extends RentalEvidenceState {
  final String reportId;
  RentalEvidenceSubmitSuccess(this.reportId);
}

final class RentalEvidenceSubmitFailure extends RentalEvidenceState {
  final String errorMessage;

  RentalEvidenceSubmitFailure(this.errorMessage);
}
