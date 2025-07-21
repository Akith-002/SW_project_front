import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/pages/signIn/cubit/signin_state.dart';
import 'package:land_asset_valuation/data/datasource/shared_preference.dart';
import 'package:land_asset_valuation/data/models/auth/login_request.dart';
import 'package:land_asset_valuation/data/repositories/auth_repository.dart';

class SigninCubit extends BaseCubit<BaseState<SigninState>> {
  final AppSharedData appSharedData;
  final AuthRepository _authRepository;

  SigninCubit({
    required this.appSharedData,
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(SigninInitial());

  Future<void> login(String username, String password) async {
    emit(SigninLoading());

    final result = await _authRepository.login(
      LoginRequest(
        username: username,
        password: password,
      ),
    );

    result.fold(
      (failure) => emit(SigninError(failure.toString())),
      (response) {
        // Store username in appSharedData for profile page
        appSharedData.setData('username', response.username);
        emit(SigninAuthenticated(response));
      },
    );
  }

  Future<void> logout(String username) async {
    emit(SigninLoading());

    final result = await _authRepository.logout(username);

    result.fold(
      (failure) => emit(SigninError(failure.toString())),
      (success) => emit(SigninInitial()),
    );
  }

  Future<void> forgotPassword(String username) async {
    emit(SigninLoading());

    final result = await _authRepository.forgotPassword(username);

    result.fold(
      (failure) => emit(SigninError(failure.toString())),
      (success) => emit(const ForgotPasswordEmailSent()),
    );
  }
}
