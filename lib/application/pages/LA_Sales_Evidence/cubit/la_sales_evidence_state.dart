import 'package:land_asset_valuation/app/cubit/base_state.dart';

abstract class LaSalesEvidenceState extends BaseState<LaSalesEvidenceState> {}

final class LaSalesEvidenceInitial extends LaSalesEvidenceState {}

final class LaSalesEvidenceLoading extends LaSalesEvidenceState {}

final class LaSalesEvidenceSubmitSuccess extends LaSalesEvidenceState {}

final class LaSalesEvidenceSubmitFailure extends LaSalesEvidenceState {
  final String errorMessage;

  LaSalesEvidenceSubmitFailure(this.errorMessage);
}
