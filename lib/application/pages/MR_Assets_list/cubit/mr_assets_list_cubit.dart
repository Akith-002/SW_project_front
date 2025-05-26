import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/pages/MR_Assets_list/cubit/mr_assets_list_state.dart';
import 'package:land_asset_valuation/data/datasource/shared_preference.dart';
import 'package:land_asset_valuation/domain/usecases/asset_usecases.dart';

class MrAssetsListCubit extends BaseCubit<BaseState<MrAssetsListState>> {
  final AppSharedData appSharedData;
  final GetAssetsUseCase getAssetsUseCase;
  final GetAssetsPaginatedUseCase getAssetsPaginatedUseCase;
  final SearchAssetsUseCase searchAssetsUseCase;

  MrAssetsListCubit({
    required this.appSharedData,
    required this.getAssetsUseCase,
    required this.getAssetsPaginatedUseCase,
    required this.searchAssetsUseCase,
  }) : super(MrAssetsListInitial());

  /// Load assets for a specific request
  Future<void> loadAssets({
    required int requestId,
    required String requestType,
  }) async {
    emit(MrAssetsListLoading());

    try {
      final result = await getAssetsUseCase.call(
        requestId: requestId,
        requestType: requestType,
      );

      result.fold(
        (failure) => emit(MrAssetsListError(message: failure.message)),
        (assets) => emit(MrAssetsListLoaded(assets: assets)),
      );
    } catch (e) {
      emit(MrAssetsListError(message: 'Failed to load assets: $e'));
    }
  }

  /// Load paginated assets
  Future<void> loadAssetsPaginated({
    required int requestId,
    required String requestType,
    required int pageSize,
    String? pageToken,
  }) async {
    emit(MrAssetsListLoading());

    try {
      final result = await getAssetsPaginatedUseCase.call(
        requestId: requestId,
        requestType: requestType,
        pageSize: pageSize,
        pageToken: pageToken,
      );

      result.fold(
        (failure) => emit(MrAssetsListError(message: failure.message)),
        (paginatedResponse) => emit(MrAssetsListLoaded(
          assets: paginatedResponse.items,
          nextPageToken: paginatedResponse.hasNext
              ? (paginatedResponse.currentPage + 1).toString()
              : null,
        )),
      );
    } catch (e) {
      emit(MrAssetsListError(message: 'Failed to load assets: $e'));
    }
  }

  /// Search assets
  Future<void> searchAssets({
    required int requestId,
    required String requestType,
    required String query,
  }) async {
    if (query.trim().isEmpty) {
      // If search query is empty, reload the original assets
      loadAssets(requestId: requestId, requestType: requestType);
      return;
    }

    emit(MrAssetsListSearching());

    try {
      final result = await searchAssetsUseCase.call(
        requestId: requestId,
        requestType: requestType,
        query: query,
      );

      result.fold(
        (failure) => emit(MrAssetsListError(message: failure.message)),
        (assets) => emit(MrAssetsListSearchLoaded(searchResults: assets)),
      );
    } catch (e) {
      emit(MrAssetsListError(message: 'Failed to search assets: $e'));
    }
  }

  /// Load more assets (for pagination)
  Future<void> loadMoreAssets({
    required int requestId,
    required String requestType,
    required int pageSize,
    String? nextPageToken,
  }) async {
    if (nextPageToken == null) return;

    try {
      final result = await getAssetsPaginatedUseCase.call(
        requestId: requestId,
        requestType: requestType,
        pageSize: pageSize,
        pageToken: nextPageToken,
      );

      result.fold(
        (failure) => emit(MrAssetsListError(message: failure.message)),
        (paginatedResponse) {
          // Append new assets to existing ones
          final currentState = state;
          if (currentState is MrAssetsListLoaded) {
            final allAssets = [
              ...currentState.assets,
              ...paginatedResponse.items
            ];
            emit(MrAssetsListLoaded(
              assets: allAssets,
              nextPageToken: paginatedResponse.hasNext
                  ? (paginatedResponse.currentPage + 1).toString()
                  : null,
            ));
          }
        },
      );
    } catch (e) {
      emit(MrAssetsListError(message: 'Failed to load more assets: $e'));
    }
  }
}
