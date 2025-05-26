import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/data/models/land_miscellaneous_master_file_model.dart';
import 'package:land_asset_valuation/data/models/paginated_response.dart';

abstract class LM_MasterfileListState
    extends BaseState<LM_MasterfileListState> {}

final class LM_MasterfileListInitial extends LM_MasterfileListState {}

final class LM_MasterfileListLoading extends LM_MasterfileListState {}

final class LM_MasterfileListSuccess extends LM_MasterfileListState {
  final List<LandMiscellaneousMasterFile> masterFiles;

  LM_MasterfileListSuccess(this.masterFiles);
}

final class LM_MasterfileListPaginatedSuccess extends LM_MasterfileListState {
  final PaginatedResponse<LandMiscellaneousMasterFile> paginatedFiles;

  LM_MasterfileListPaginatedSuccess(this.paginatedFiles);
}

final class LM_MasterfileListError extends LM_MasterfileListState {
  final String message;

  LM_MasterfileListError(this.message);
}
