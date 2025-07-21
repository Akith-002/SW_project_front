import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'create_password_state.dart';
import 'package:land_asset_valuation/data/repositories/auth_repository.dart';

class CreatePasswordCubit extends BaseCubit<CreatePasswordState> {
  final AuthRepository authRepository;
  CreatePasswordCubit({required this.authRepository})
      : super(CreatePasswordInitial());

  Future<void> createPassword(String email, String otp, String password) async {
    emit(CreatePasswordLoading());
    final result = await authRepository.resetPassword(email, otp, password);
    result.fold(
      (failure) => emit(CreatePasswordError(failure.toString())),
      (_) => emit(CreatePasswordSuccess()),
    );
  }
}
