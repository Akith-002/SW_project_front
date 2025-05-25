import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'map_screen_state.dart';

class MapScreenCubit extends Cubit<MapScreenState> {
  MapScreenCubit() : super(MapScreenInitial());
}
