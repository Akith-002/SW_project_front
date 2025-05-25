part of 'i3_master_file_list_cubit.dart';

abstract class I3MasterFileListState {
  const I3MasterFileListState();
}

class I3MasterFileListInitial extends I3MasterFileListState {
  const I3MasterFileListInitial();
}

class I3MasterFileListLoading extends I3MasterFileListState {
  const I3MasterFileListLoading();
}

class I3MasterFileListLoaded extends I3MasterFileListState {
  final PaginatedResponse<LandAcquisitionMasterFile> response;
  const I3MasterFileListLoaded(this.response);
}

class I3MasterFileListSearchResults extends I3MasterFileListState {
  final List<LandAcquisitionMasterFile> results;
  const I3MasterFileListSearchResults(this.results);
}

class I3MasterFileListError extends I3MasterFileListState {
  final String message;
  const I3MasterFileListError(this.message);
}
