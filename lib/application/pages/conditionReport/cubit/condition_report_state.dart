import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/data/models/master_data_model.dart';

abstract class ConditionReportState extends BaseState<ConditionReportState> {}

final class ConditionReportInitial extends ConditionReportState {}

final class ConditionReportLoading extends ConditionReportState {}

final class ConditionReportSubmitSuccess extends ConditionReportState {}

final class ConditionReportSubmitFailure extends ConditionReportState {
  final String errorMessage;
  ConditionReportSubmitFailure(this.errorMessage);
}

final class MasterDataLoading extends ConditionReportState {}

final class MasterDataLoadSuccess extends ConditionReportState {
  final MasterDataResponse masterData;
  MasterDataLoadSuccess(this.masterData);
}

final class MasterDataLoadFailure extends ConditionReportState {
  final String errorMessage;
  MasterDataLoadFailure(this.errorMessage);
}
