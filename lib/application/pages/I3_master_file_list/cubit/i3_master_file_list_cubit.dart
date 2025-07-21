import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:land_asset_valuation/data/datasource/shared_preference.dart';
import 'package:land_asset_valuation/data/models/land_acquisition_master_file_model.dart';
import 'package:land_asset_valuation/data/models/paginated_response.dart';
import 'package:land_asset_valuation/domain/usecases/get_paginated_master_files_usecase.dart';
import 'package:land_asset_valuation/domain/usecases/search_master_files_usecase.dart';

part 'i3_master_file_list_state.dart';

class I3MasterFileListCubit extends Cubit<I3MasterFileListState> {
  final AppSharedData appSharedData;
  final GetPaginatedMasterFilesUseCase getPaginatedUseCase;
  final SearchMasterFilesUseCase searchUseCase;

  I3MasterFileListCubit({
    required this.appSharedData,
    required this.getPaginatedUseCase,
    required this.searchUseCase,
  }) : super(const I3MasterFileListInitial());

  Future<void> getPaginatedMasterFiles({
    required int page,
    required int pageSize,
    String? sortBy,
  }) async {
    try {
      emit(const I3MasterFileListLoading());
      final result = await getPaginatedUseCase(
        page: page,
        pageSize: pageSize,
        sortBy: sortBy,
      );
      emit(I3MasterFileListLoaded(result));
    } catch (e) {
      emit(I3MasterFileListError(e.toString()));
    }
  }

  Future<void> searchMasterFiles({
    required String query,
    required int page,
    required int pageSize,
    String? sortBy,
  }) async {
    try {
      emit(const I3MasterFileListLoading());
      final result = await searchUseCase(
        query: query,
        page: page,
        pageSize: pageSize,
        sortBy: sortBy,
      );
      emit(I3MasterFileListSearchResults(result.items));
    } catch (e) {
      emit(I3MasterFileListError(e.toString()));
    }
  }
}
