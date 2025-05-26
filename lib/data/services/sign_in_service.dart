import 'package:land_asset_valuation/data/models/auth/login_request.dart';
import 'package:land_asset_valuation/data/repositories/auth_repository.dart';

class SignInService {
  final AuthRepository _authRepository;

  SignInService({required AuthRepository authRepository})
      : _authRepository = authRepository;

  Future<bool> login(String username, String password) async {
    final result = await _authRepository.login(
      LoginRequest(username: username, password: password),
    );

    return result.fold(
      (failure) => false,
      (response) => true,
    );
  }
}
