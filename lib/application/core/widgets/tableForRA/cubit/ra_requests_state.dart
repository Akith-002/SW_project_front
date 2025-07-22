import 'package:equatable/equatable.dart';
import 'package:land_asset_valuation/data/models/ra_request_model.dart';

abstract class RaRequestsState extends Equatable {
  const RaRequestsState();

  @override
  List<Object?> get props => [];
}

class RaRequestsInitial extends RaRequestsState {}

class RaRequestsLoading extends RaRequestsState {}

class RaRequestsLoaded extends RaRequestsState {
  final List<RaRequestModel> requests;

  const RaRequestsLoaded({required this.requests});

  @override
  List<Object?> get props => [requests];
}

class RaRequestsError extends RaRequestsState {
  final String message;

  const RaRequestsError({required this.message});

  @override
  List<Object?> get props => [message];
}