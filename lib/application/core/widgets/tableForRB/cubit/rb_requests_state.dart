import 'package:equatable/equatable.dart';
import 'package:land_asset_valuation/data/models/ra_request_model.dart';

abstract class RbRequestsState extends Equatable {
  const RbRequestsState();

  @override
  List<Object?> get props => [];
}

class RbRequestsInitial extends RbRequestsState {}

class RbRequestsLoading extends RbRequestsState {}

class RbRequestsLoaded extends RbRequestsState {
  final List<RaRequestModel> requests;

  const RbRequestsLoaded({required this.requests});

  @override
  List<Object?> get props => [requests];
}

class RbRequestsError extends RbRequestsState {
  final String message;

  const RbRequestsError({required this.message});

  @override
  List<Object?> get props => [message];
}