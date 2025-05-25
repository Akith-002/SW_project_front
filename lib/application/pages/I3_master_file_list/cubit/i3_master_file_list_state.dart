part of 'i3_master_file_list_cubit.dart';

abstract class I3MasterFileListState {}

final class I3MasterFileListInitial extends I3MasterFileListState {}

final class I3MasterFileListLoading extends I3MasterFileListState {}

final class I3MasterFileListSuccess extends I3MasterFileListState {
  final List<LandAcquisitionMasterFile> masterFiles;

  I3MasterFileListSuccess(this.masterFiles);
}

final class I3MasterFileListError extends I3MasterFileListState {
  final String message;

  I3MasterFileListError(this.message);
}
