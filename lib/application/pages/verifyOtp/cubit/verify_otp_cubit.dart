import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'verify_otp_state.dart';
import 'package:land_asset_valuation/data/repositories/auth_repository.dart';

class VerifyOtpCubit extends BaseCubit<VerifyOtpState> {
  final AuthRepository authRepository;
  VerifyOtpCubit({required this.authRepository}) : super(VerifyOtpInitial());

  Future<void> verifyOtp(String email, String otp) async {
    emit(VerifyOtpLoading());
    final result = await authRepository.verifyOtp(email, otp);
    result.fold(
      (failure) => emit(VerifyOtpError(failure.toString())),
      (_) => emit(VerifyOtpSuccess()),
    );
  }
}
