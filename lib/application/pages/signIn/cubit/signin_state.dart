import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/data/models/auth/login_response.dart';

abstract class SigninState extends BaseState<SigninState> {
  const SigninState();
}

class SigninInitial extends SigninState {}

class SigninLoading extends SigninState {}

class SigninAuthenticated extends SigninState {
  final LoginResponse user;
  const SigninAuthenticated(this.user);
}

class SigninError extends SigninState {
  final String message;
  const SigninError(this.message);
}

class ForgotPasswordEmailSent extends SigninState {
  const ForgotPasswordEmailSent();
}
