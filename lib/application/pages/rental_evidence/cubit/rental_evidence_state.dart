part of 'rental_evidence_cubit.dart';

abstract class RentalEvidenceState extends BaseState<RentalEvidenceState> {}

final class RentalEvidenceInitial extends RentalEvidenceState {}

final class RentalEvidenceLoading extends RentalEvidenceState {}

final class RentalEvidenceSubmitSuccess extends RentalEvidenceState {}

final class RentalEvidenceSubmitFailure extends RentalEvidenceState {
  final String errorMessage;

  RentalEvidenceSubmitFailure(this.errorMessage);
}
