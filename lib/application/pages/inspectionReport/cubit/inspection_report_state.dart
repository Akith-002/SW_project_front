import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/data/models/master_data_model.dart';

abstract class InspectionReportState extends BaseState<InspectionReportState> {}

final class InspectionReportInitial extends InspectionReportState {}

final class InspectionReportLoading extends InspectionReportState {}

final class InspectionReportSubmitSuccess extends InspectionReportState {}

final class InspectionReportSubmitFailure extends InspectionReportState {
  final String errorMessage;
  InspectionReportSubmitFailure(this.errorMessage);
}

final class InspectionReportSavedOffline extends InspectionReportState {
  final int pendingCount;

  InspectionReportSavedOffline(this.pendingCount);
}

final class InspectionReportSyncing extends InspectionReportState {
  final int pendingCount;

  InspectionReportSyncing(this.pendingCount);
}

final class InspectionReportSyncCompleted extends InspectionReportState {
  final int syncedCount;

  InspectionReportSyncCompleted(this.syncedCount);
}

final class MasterDataLoading extends InspectionReportState {}

final class MasterDataLoadSuccess extends InspectionReportState {
  final MasterDataResponse masterData;
  MasterDataLoadSuccess(this.masterData);
}

final class MasterDataLoadFailure extends InspectionReportState {
  final String errorMessage;
  MasterDataLoadFailure(this.errorMessage);
}
