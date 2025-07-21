import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'verify_otp_state.dart';

class VerifyOtpCubit extends BaseCubit<VerifyOtpState> {
  VerifyOtpCubit() : super(VerifyOtpInitial());

  Future<void> verifyOtp(String email, String otp) async {
    emit(VerifyOtpLoading());
    // TODO: Implement actual OTP verification logic
    await Future.delayed(const Duration(seconds: 1));
    emit(VerifyOtpSuccess());
  }
}
