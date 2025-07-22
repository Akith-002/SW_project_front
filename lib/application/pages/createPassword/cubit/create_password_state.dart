import 'package:land_asset_valuation/app/cubit/base_state.dart';

abstract class CreatePasswordState extends BaseState<CreatePasswordState> {
  const CreatePasswordState();
}

class CreatePasswordInitial extends CreatePasswordState {}

class CreatePasswordLoading extends CreatePasswordState {}

class CreatePasswordSuccess extends CreatePasswordState {}

class CreatePasswordError extends CreatePasswordState {
  final String message;
  const CreatePasswordError(this.message);
}
