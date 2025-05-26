import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:land_asset_valuation/data/models/asset_division.dart';
import 'package:land_asset_valuation/domain/usecases/asset_division_usecases.dart';

// States
abstract class AssetDivisionState extends Equatable {
  const AssetDivisionState();

  @override
  List<Object?> get props => [];
}

class AssetDivisionInitial extends AssetDivisionState {}

class AssetDivisionLoading extends AssetDivisionState {}

class AssetDivisionValidating extends AssetDivisionState {}

class AssetDivisionValidated extends AssetDivisionState {
  final AssetDivisionValidation validation;

  const AssetDivisionValidated({required this.validation});

  @override
  List<Object> get props => [validation];
}

class AssetDivisionSuccess extends AssetDivisionState {
  final AssetDivisionResponse response;

  const AssetDivisionSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

class AssetDivisionError extends AssetDivisionState {
  final String message;

  const AssetDivisionError({required this.message});

  @override
  List<Object> get props => [message];
}

// Cubit
class AssetDivisionCubit extends Cubit<AssetDivisionState> {
  final DivideAssetUseCase divideAssetUseCase;
  final ValidateAssetDivisionUseCase validateAssetDivisionUseCase;

  AssetDivisionCubit({
    required this.divideAssetUseCase,
    required this.validateAssetDivisionUseCase,
  }) : super(AssetDivisionInitial());

  Future<void> validateDivision(AssetDivisionRequest request) async {
    emit(AssetDivisionValidating());

    try {
      final validation = await validateAssetDivisionUseCase(request);
      emit(AssetDivisionValidated(validation: validation));
    } catch (e) {
      emit(AssetDivisionError(message: 'Validation failed: ${e.toString()}'));
    }
  }

  Future<void> divideAsset(AssetDivisionRequest request) async {
    emit(AssetDivisionLoading());

    try {
      final response = await divideAssetUseCase(request);
      emit(AssetDivisionSuccess(response: response));
    } catch (e) {
      emit(AssetDivisionError(message: 'Division failed: ${e.toString()}'));
    }
  }

  void reset() {
    emit(AssetDivisionInitial());
  }
}
