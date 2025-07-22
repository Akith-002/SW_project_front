import 'package:land_asset_valuation/app/cubit/base_state.dart';

abstract class PastValuationState extends BaseState<PastValuationState> {}

final class PastValuationInitial extends PastValuationState {}

final class PastValuationLoading extends PastValuationState {}

final class PastValuationSubmitSuccess extends PastValuationState {
  final String reportId;
  PastValuationSubmitSuccess(this.reportId);
}

final class PastValuationSubmitFailure extends PastValuationState {
  final String errorMessage;

  PastValuationSubmitFailure(this.errorMessage);
}
