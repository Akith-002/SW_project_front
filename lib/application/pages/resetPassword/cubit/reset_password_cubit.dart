import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'reset_password_state.dart';

class ResetPasswordCubit extends BaseCubit<ResetPasswordState> {
  ResetPasswordCubit() : super(ResetPasswordInitial());

  Future<void> requestOtp(String email) async {
    emit(ResetPasswordLoading());
    // TODO: Implement actual OTP request logic
    await Future.delayed(const Duration(seconds: 1));
    emit(ResetPasswordOtpSent());
  }

  Future<void> verifyOtp(String email, String otp) async {
    emit(ResetPasswordLoading());
    // TODO: Implement actual OTP verification logic
    await Future.delayed(const Duration(seconds: 1));
    emit(ResetPasswordOtpVerified());
  }

  Future<void> resetPassword(String email, String newPassword) async {
    emit(ResetPasswordLoading());
    // TODO: Implement actual password reset logic
    await Future.delayed(const Duration(seconds: 1));
    emit(ResetPasswordSuccess());
  }
}
