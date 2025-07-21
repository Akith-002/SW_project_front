import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'reset_password_state.dart';
import 'package:land_asset_valuation/data/repositories/auth_repository.dart';

class ResetPasswordCubit extends BaseCubit<ResetPasswordState> {
  final AuthRepository authRepository;
  ResetPasswordCubit({required this.authRepository})
      : super(ResetPasswordInitial());

  Future<void> requestOtp(String email) async {
    emit(ResetPasswordLoading());
    final result = await authRepository.requestPasswordReset(email);
    result.fold(
      (failure) => emit(ResetPasswordError(failure.toString())),
      (_) => emit(ResetPasswordOtpSent()),
    );
  }

  Future<void> verifyOtp(String email, String otp) async {
    emit(ResetPasswordLoading());
    final result = await authRepository.verifyOtp(email, otp);
    result.fold(
      (failure) => emit(ResetPasswordError(failure.toString())),
      (_) => emit(ResetPasswordOtpVerified()),
    );
  }

  Future<void> resetPassword(
      String email, String otp, String newPassword) async {
    emit(ResetPasswordLoading());
    final result = await authRepository.resetPassword(email, otp, newPassword);
    result.fold(
      (failure) => emit(ResetPasswordError(failure.toString())),
      (_) => emit(ResetPasswordSuccess()),
    );
  }
}
