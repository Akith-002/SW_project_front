import 'package:land_asset_valuation/data/models/asset_division.dart';

abstract class AssetDivisionRepository {
  Future<AssetDivisionResponse> divideAsset(AssetDivisionRequest request);
  Future<AssetDivisionValidation> validateDivision(
      AssetDivisionRequest request);
}
