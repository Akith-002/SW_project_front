import 'package:land_asset_valuation/app/cubit/base_state.dart';

abstract class VerifyOtpState extends BaseState<VerifyOtpState> {
  const VerifyOtpState();
}

class VerifyOtpInitial extends VerifyOtpState {}

class VerifyOtpLoading extends VerifyOtpState {}

class VerifyOtpSuccess extends VerifyOtpState {}

class VerifyOtpError extends VerifyOtpState {
  final String message;
  const VerifyOtpError(this.message);
}
