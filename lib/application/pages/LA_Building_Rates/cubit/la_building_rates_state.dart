import 'package:land_asset_valuation/app/cubit/base_state.dart';

abstract class LaBuildingRatesState extends BaseState<LaBuildingRatesState> {}

final class LaBuildingRatesInitial extends LaBuildingRatesState {}

final class LaBuildingRatesLoading extends LaBuildingRatesState {}

final class LaBuildingRatesSubmitSuccess extends LaBuildingRatesState {}

final class LaBuildingRatesSubmitFailure extends LaBuildingRatesState {
  final String errorMessage;
  LaBuildingRatesSubmitFailure(this.errorMessage);
}
