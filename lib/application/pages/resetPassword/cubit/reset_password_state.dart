import 'package:land_asset_valuation/app/cubit/base_state.dart';

abstract class ResetPasswordState extends BaseState<ResetPasswordState> {
  const ResetPasswordState();
}

class ResetPasswordInitial extends ResetPasswordState {}

class ResetPasswordLoading extends ResetPasswordState {}

class ResetPasswordOtpSent extends ResetPasswordState {}

class ResetPasswordOtpVerified extends ResetPasswordState {}

class ResetPasswordSuccess extends ResetPasswordState {}

class ResetPasswordError extends ResetPasswordState {
  final String message;
  const ResetPasswordError(this.message);
}
