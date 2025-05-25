import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:land_asset_valuation/data/models/land_acquisition_master_file_model.dart';
import 'package:land_asset_valuation/domain/usecases/get_all_master_files_usecase.dart';
import 'package:land_asset_valuation/domain/usecases/search_master_files_usecase.dart';
import 'package:land_asset_valuation/data/datasource/shared_preference.dart';

part 'i3_master_file_list_state.dart';

class I3MasterFileListCubit extends Cubit<I3MasterFileListState> {
  final AppSharedData appSharedData;
  final GetAllMasterFilesUseCase getAllUseCase;
  final SearchMasterFilesUseCase searchUseCase;

  I3MasterFileListCubit({
    required this.appSharedData,
    required this.getAllUseCase,
    required this.searchUseCase,
  }) : super(I3MasterFileListInitial());

  Future<void> fetchAllMasterFiles() async {
    emit(I3MasterFileListLoading());
    try {
      final files = await getAllUseCase();
      emit(I3MasterFileListSuccess(files));
    } catch (e) {
      emit(I3MasterFileListError('Failed to fetch master files'));
    }
  }

  Future<void> searchMasterFiles(String query) async {
    emit(I3MasterFileListLoading());
    try {
      final files = await searchUseCase(query);
      emit(I3MasterFileListSuccess(files));
    } catch (e) {
      emit(I3MasterFileListError('Search failed'));
    }
  }
}
