import 'package:flutter_bloc/flutter_bloc.dart';

import 'base_state.dart';

abstract class BaseCubit<K extends BaseState> extends Cubit<K> {
  BaseCubit(K initialState) : super(initialState);
}