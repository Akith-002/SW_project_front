import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/data/models/asset.dart';

abstract class RaAssetsListState extends BaseState<RaAssetsListState> {}

final class RaAssetsListInitial extends RaAssetsListState {}

final class RaAssetsListLoading extends RaAssetsListState {}

final class RaAssetsListLoaded extends RaAssetsListState {
  final List<Asset> assets;
  final String? nextPageToken;

  RaAssetsListLoaded({required this.assets, this.nextPageToken});
}

final class RaAssetsListError extends RaAssetsListState {
  final String message;

  RaAssetsListError({required this.message});
}

final class RaAssetsListSearching extends RaAssetsListState {}

final class RaAssetsListSearchLoaded extends RaAssetsListState {
  final List<Asset> searchResults;

  RaAssetsListSearchLoaded({required this.searchResults});
}
