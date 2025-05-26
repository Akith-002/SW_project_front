import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/pages/LM_Masterfile_list/cubit/lm_masterfile_list_state.dart';
import 'package:land_asset_valuation/data/datasource/shared_preference.dart';
import 'package:land_asset_valuation/domain/usecases/get_all_lm_master_files_usecase.dart';
import 'package:land_asset_valuation/domain/usecases/get_paginated_lm_master_files_usecase.dart';
import 'package:land_asset_valuation/domain/usecases/search_lm_master_files_usecase.dart';

class LmMasterfileListCubit
    extends BaseCubit<BaseState<LM_MasterfileListState>> {
  final AppSharedData appSharedData;
  final GetAllLmMasterFilesUseCase getAllUseCase;
  final GetPaginatedLMMasterFilesUseCase getPaginatedUseCase;
  final SearchLmMasterFilesUseCase searchUseCase;

  LmMasterfileListCubit({
    required this.appSharedData,
    required this.getAllUseCase,
    required this.getPaginatedUseCase,
    required this.searchUseCase,
  }) : super(LM_MasterfileListInitial());

  Future<void> fetchAllMasterFiles() async {
    emit(LM_MasterfileListLoading());
    try {
      final result = await getAllUseCase();
      result.fold(
        (failure) => emit(LM_MasterfileListError(failure.message)),
        (files) => emit(LM_MasterfileListSuccess(files)),
      );
    } catch (e) {
      emit(LM_MasterfileListError('Failed to fetch master files'));
    }
  }

  Future<void> fetchPaginatedMasterFiles(
      {required int page, required int limit}) async {
    emit(LM_MasterfileListLoading());
    try {
      final result = await getPaginatedUseCase(page: page, limit: limit);
      result.fold(
        (failure) => emit(LM_MasterfileListError(failure.message)),
        (paginatedFiles) =>
            emit(LM_MasterfileListPaginatedSuccess(paginatedFiles)),
      );
    } catch (e) {
      emit(LM_MasterfileListError('Failed to fetch paginated master files'));
    }
  }

  Future<void> searchMasterFiles(String query) async {
    emit(LM_MasterfileListLoading());
    try {
      final result = await searchUseCase(query);
      result.fold(
        (failure) => emit(LM_MasterfileListError(failure.message)),
        (files) => emit(LM_MasterfileListSuccess(files)),
      );
    } catch (e) {
      emit(LM_MasterfileListError('Search failed'));
    }
  }
}
