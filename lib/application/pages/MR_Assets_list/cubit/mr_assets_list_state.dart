import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/data/models/asset.dart';

abstract class MrAssetsListState extends BaseState<MrAssetsListState> {}

final class MrAssetsListInitial extends MrAssetsListState {}

final class MrAssetsListLoading extends MrAssetsListState {}

final class MrAssetsListLoaded extends MrAssetsListState {
  final List<Asset> assets;
  final String? nextPageToken;

  MrAssetsListLoaded({
    required this.assets,
    this.nextPageToken,
  });
}

final class MrAssetsListError extends MrAssetsListState {
  final String message;

  MrAssetsListError({required this.message});
}

final class MrAssetsListSearching extends MrAssetsListState {}

final class MrAssetsListSearchLoaded extends MrAssetsListState {
  final List<Asset> searchResults;

  MrAssetsListSearchLoaded({required this.searchResults});
}
