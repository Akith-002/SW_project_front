import 'package:land_asset_valuation/data/models/asset_division.dart';
import 'package:land_asset_valuation/domain/repositories/asset_division_repository.dart';

class DivideAssetUseCase {
  final AssetDivisionRepository repository;

  DivideAssetUseCase(this.repository);

  Future<AssetDivisionResponse> call(AssetDivisionRequest request) async {
    // Validate the request before sending
    final validation = await repository.validateDivision(request);

    if (!validation.isValid) {
      throw AssetDivisionException(
          'Division validation failed: ${validation.errors.join(', ')}');
    }

    return await repository.divideAsset(request);
  }
}

class ValidateAssetDivisionUseCase {
  final AssetDivisionRepository repository;

  ValidateAssetDivisionUseCase(this.repository);

  Future<AssetDivisionValidation> call(AssetDivisionRequest request) async {
    return await repository.validateDivision(request);
  }
}

class AssetDivisionException implements Exception {
  final String message;
  AssetDivisionException(this.message);

  @override
  String toString() => 'AssetDivisionException: $message';
}
