import 'package:land_asset_valuation/app/cubit/base_state.dart';

abstract class LmBuildingRatesState extends BaseState<LmBuildingRatesState> {}

final class LmBuildingRatesInitial extends LmBuildingRatesState {}

final class LmBuildingRatesLoading extends LmBuildingRatesState {}

final class LmBuildingRatesSubmitSuccess extends LmBuildingRatesState {}

final class LmBuildingRatesSubmitFailure extends LmBuildingRatesState {
  final String errorMessage;
  LmBuildingRatesSubmitFailure(this.errorMessage);
}
