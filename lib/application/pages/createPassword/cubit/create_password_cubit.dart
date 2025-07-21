import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'create_password_state.dart';

class CreatePasswordCubit extends BaseCubit<CreatePasswordState> {
  CreatePasswordCubit() : super(CreatePasswordInitial());

  Future<void> createPassword(String email, String password) async {
    emit(CreatePasswordLoading());
    // TODO: Implement actual password creation logic
    await Future.delayed(const Duration(seconds: 1));
    emit(CreatePasswordSuccess());
  }
}
