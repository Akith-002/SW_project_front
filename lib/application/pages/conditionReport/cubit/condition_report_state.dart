import 'package:land_asset_valuation/app/cubit/base_state.dart';

abstract class ConditionReportState extends BaseState<ConditionReportState> {}

final class ConditionReportInitial extends ConditionReportState {}

final class ConditionReportLoading extends ConditionReportState {}

final class ConditionReportSubmitSuccess extends ConditionReportState {}

final class ConditionReportSubmitFailure extends ConditionReportState {
  final String errorMessage;

  ConditionReportSubmitFailure(this.errorMessage);
}

final class ConditionReportSavedOffline extends ConditionReportState {
  final int pendingCount;

  ConditionReportSavedOffline(this.pendingCount);
}

final class ConditionReportSyncing extends ConditionReportState {
  final int pendingCount;

  ConditionReportSyncing(this.pendingCount);
}

final class ConditionReportSyncCompleted extends ConditionReportState {
  final int syncedCount;

  ConditionReportSyncCompleted(this.syncedCount);
}
